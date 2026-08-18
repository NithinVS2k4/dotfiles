#!/usr/bin/env python3
"""
Kitty pixel dashboard v6.

- Uses Kitty's graphics protocol for all visual elements.
- Uses psutil for reliable macOS CPU/RAM readings.
- Uses netstat for per-interface network throughput.
- Uses Cava raw output from BlackHole for a real audio spectrum.
- Writes unexpected exceptions to ~/.cache/kitty-dashboard/error.log
  instead of letting a traceback flash and kill the panel.
"""

import base64
import configparser
import io
import math
import os
import re
import select
import shutil
import signal
import struct
import subprocess
import tempfile
import time
from collections import deque

try:
    import psutil
except ImportError:
    raise SystemExit("psutil is required. Run the installer again.")

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    raise SystemExit("Pillow is required. Run the installer again.")

# Theme -----------------------------------------------------------------------
#
# The dashboard has two layers of customization:
#
#   1. `mode = kitty` makes every component follow Kitty's current palette.
#   2. Any individual component can be overridden in dashboard-theme.conf.
#
# Colors are RGBA tuples. Alpha is deliberately explicit because this panel
# sits over the user's wallpaper/Kitty background.
THEME_FILE = os.path.expanduser("~/.config/kitty/dashboard-theme.conf")

THEME = {
    "background": (30, 30, 46),
    "foreground": (205, 214, 244),
    "cyan": (148, 226, 213),
    "green": (166, 227, 161),
    "blue": (137, 180, 250),
    "red": (243, 139, 168),
    "magenta": (203, 166, 247),
}

BG = (0, 0, 0, 0)
CARD = (30, 30, 46, 22)
CARD_EDGE = (205, 214, 244, 55)
GRID = (205, 214, 244, 38)
TEXT = (205, 214, 244, 255)
MUTED = (166, 173, 200, 205)
TITLE = (148, 226, 213, 255)
CPU_COLOR = (148, 226, 213, 255)
MEM_COLOR = (166, 227, 161, 255)
NET_DOWN = (137, 180, 250, 255)
NET_UP = (166, 227, 161, 255)
AUDIO_COLOR = (203, 166, 247, 255)
CLOCK_FACE = (30, 30, 46, 42)
CLOCK_OUTLINE = (166, 173, 200, 220)
CLOCK_TICK = (205, 214, 244, 235)
CLOCK_HOUR = (205, 214, 244, 255)
CLOCK_MINUTE = (148, 226, 213, 255)
CLOCK_SECOND = (243, 139, 168, 255)
SHADOW = (0, 0, 0, 145)

THEME_DEFAULTS = {
    "title": "auto",
    "text": "auto",
    "muted": "auto",
    "cpu": "auto",
    "memory": "auto",
    "network_download": "auto",
    "network_upload": "auto",
    "audio": "auto",
    "clock_face": "auto",
    "clock_outline": "auto",
    "clock_tick": "auto",
    "clock_hour": "auto",
    "clock_minute": "auto",
    "clock_second": "auto",
    "grid": "auto",
    "card": "auto",
    "card_border": "auto",
}


IMAGE_ID = 19371
RUNNING = True
LOG_PATH = os.path.expanduser("~/.cache/kitty-dashboard/error.log")


def log(msg):
    os.makedirs(os.path.dirname(LOG_PATH), exist_ok=True)
    with open(LOG_PATH, "a", encoding="utf-8") as f:
        f.write(time.strftime("%Y-%m-%d %H:%M:%S ") + str(msg) + "\n")


def _hex_rgb(value):
    value = value.strip()
    if value.startswith("#") and len(value) == 7:
        try:
            return tuple(int(value[i : i + 2], 16) for i in (1, 3, 5))
        except ValueError:
            return None
    m = re.match(r"rgb:([0-9a-fA-F]+)/([0-9a-fA-F]+)/([0-9a-fA-F]+)", value)
    if m:
        vals = []
        for x in m.groups():
            # Kitty can report 1/2/3/4 hex digits per channel.
            n = int(x, 16)
            denom = (16 ** len(x)) - 1
            vals.append(round(255 * n / denom))
        return tuple(vals)
    return None


def _parse_kitty_color_output(text):
    colors = {}
    for line in text.splitlines():
        m = re.match(r"^\s*([A-Za-z0-9_]+)\s+(.+?)\s*$", line)
        if not m:
            continue
        c = _hex_rgb(m.group(2))
        if c:
            colors[m.group(1)] = c
    return colors


def _read_theme_files():
    """Fallback when Kitty remote control is disabled."""
    files = [
        os.path.expanduser("~/.config/kitty/current-theme.conf"),
        os.path.expanduser("~/.config/kitty/kitty.conf"),
    ]
    colors = {}
    for path in files:
        try:
            with open(path, "r", encoding="utf-8") as f:
                for line in f:
                    line = line.split("#", 1)[0].strip()
                    m = re.match(
                        r"^(background|foreground|color(?:[0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-5][0-9]))\s+(\S+)$",
                        line,
                    )
                    if m:
                        c = _hex_rgb(m.group(2))
                        if c:
                            colors[m.group(1)] = c
        except OSError:
            pass
    return colors


def _parse_rgba(value, fallback, default_alpha=255):
    value = str(value).strip()
    if not value or value.lower() == "auto":
        return fallback

    alpha = default_alpha
    if "@" in value:
        value, a = value.rsplit("@", 1)
        try:
            alpha = (
                max(0, min(255, round(float(a) * 255)))
                if float(a) <= 1
                else max(0, min(255, int(float(a))))
            )
        except ValueError:
            alpha = default_alpha

    rgb = _hex_rgb(value)
    if rgb is None:
        return fallback
    return (*rgb, alpha)


def _theme_file_values():
    cfg = configparser.ConfigParser()
    try:
        cfg.read(THEME_FILE, encoding="utf-8")
        if cfg.has_section("colors"):
            return {k: v for k, v in cfg.items("colors")}
    except Exception as e:
        log(f"theme config: {e!r}")
    return {}


def _kitty_colors():
    colors = {}
    try:
        out = subprocess.check_output(
            ["kitten", "@", "get-colors", "--configured"],
            stderr=subprocess.DEVNULL,
            text=True,
            timeout=0.35,
        )
        colors = _parse_kitty_color_output(out)
    except Exception:
        colors = _read_theme_files()
    return colors


def refresh_theme():
    """Resolve the dashboard palette from Kitty + dashboard-theme.conf."""
    global THEME, BG, CARD, CARD_EDGE, GRID, TEXT, MUTED
    global TITLE, CPU_COLOR, MEM_COLOR, NET_DOWN, NET_UP, AUDIO_COLOR
    global CLOCK_FACE, CLOCK_OUTLINE, CLOCK_TICK, CLOCK_HOUR, CLOCK_MINUTE
    global CLOCK_SECOND, SHADOW

    colors = _kitty_colors()

    bg = colors.get("background", THEME["background"])
    fg = colors.get("foreground", THEME["foreground"])
    cyan = colors.get("color14", colors.get("color6", THEME["cyan"]))
    green = colors.get("color10", colors.get("color2", THEME["green"]))
    blue = colors.get("color12", colors.get("color4", THEME["blue"]))
    red = colors.get("color9", colors.get("color1", THEME["red"]))
    magenta = colors.get("color13", colors.get("color5", THEME["magenta"]))

    THEME = {
        "background": bg,
        "foreground": fg,
        "cyan": cyan,
        "green": green,
        "blue": blue,
        "red": red,
        "magenta": magenta,
    }

    auto = {
        "title": (*cyan, 255),
        "text": (*fg, 255),
        "muted": (*fg, 205),
        "cpu": (*cyan, 255),
        "memory": (*green, 255),
        "network_download": (*blue, 255),
        "network_upload": (*green, 255),
        "audio": (*magenta, 255),
        "clock_face": (*bg, 48),
        "clock_outline": (*fg, 220),
        "clock_tick": (*fg, 235),
        "clock_hour": (*fg, 255),
        "clock_minute": (*cyan, 255),
        "clock_second": (*red, 255),
        "grid": (*fg, 38),
        "card": (*bg, 20),
        "card_border": (*fg, 52),
    }

    overrides = _theme_file_values()
    resolved = {}
    for key, fallback in auto.items():
        resolved[key] = _parse_rgba(
            overrides.get(key, THEME_DEFAULTS[key]),
            fallback,
            fallback[3],
        )

    BG = (0, 0, 0, 0)
    CARD = resolved["card"]
    CARD_EDGE = resolved["card_border"]
    GRID = resolved["grid"]
    TEXT = resolved["text"]
    MUTED = resolved["muted"]
    TITLE = resolved["title"]
    CPU_COLOR = resolved["cpu"]
    MEM_COLOR = resolved["memory"]
    NET_DOWN = resolved["network_download"]
    NET_UP = resolved["network_upload"]
    AUDIO_COLOR = resolved["audio"]
    CLOCK_FACE = resolved["clock_face"]
    CLOCK_OUTLINE = resolved["clock_outline"]
    CLOCK_TICK = resolved["clock_tick"]
    CLOCK_HOUR = resolved["clock_hour"]
    CLOCK_MINUTE = resolved["clock_minute"]
    CLOCK_SECOND = resolved["clock_second"]
    SHADOW = (0, 0, 0, 145)


def run(cmd, timeout=2):
    try:
        return subprocess.check_output(
            cmd, stderr=subprocess.DEVNULL, text=True, timeout=timeout
        ).strip()
    except Exception:
        return ""


def term_size():
    s = shutil.get_terminal_size((42, 40))
    return s.columns, s.lines


PIXEL_SIZE = (9, 18)


def pixel_size():
    # Cached: spawning `kitten icat --print-window-size` every render frame
    # wastes CPU. The fallback is stable until Kitty's cell metrics change.
    return PIXEL_SIZE


def refresh_pixel_size():
    global PIXEL_SIZE
    out = run(["kitten", "icat", "--print-window-size"], timeout=0.6)
    m = re.search(r"(\d+)x(\d+)\s+pixels.*?(\d+)x(\d+)\s+cells", out)
    if m:
        pw, ph, cols, rows = map(int, m.groups())
        if cols and rows:
            PIXEL_SIZE = (max(1, pw // cols), max(1, ph // rows))


def cpu_load():
    try:
        return float(psutil.cpu_percent(interval=None))
    except Exception as e:
        log(f"cpu_load: {e!r}")
        return None


def memory_load():
    try:
        return float(psutil.virtual_memory().percent)
    except Exception as e:
        log(f"memory_load: {e!r}")
        return None


NETWORK_IFACES = None


def network_bytes():
    global NETWORK_IFACES
    try:
        counters = psutil.net_io_counters(pernic=True)

        if NETWORK_IFACES is None:
            NETWORK_IFACES = tuple(
                name
                for name in counters
                if not name.startswith(("lo", "utun", "gif", "stf"))
            )

        rx = sum(
            counters[name].bytes_recv for name in NETWORK_IFACES if name in counters
        )
        tx = sum(
            counters[name].bytes_sent for name in NETWORK_IFACES if name in counters
        )
        return rx, tx
    except Exception as e:
        log(f"network_bytes: {e!r}")
        return None


def fmt_rate(v):
    v = float(max(0, v))
    units = ["B/s", "KB/s", "MB/s", "GB/s"]
    i = 0
    while v >= 1000 and i < len(units) - 1:
        v /= 1000
        i += 1
    if i == 0:
        return f"{v:.0f} {units[i]}"
    return f"{v:.1f} {units[i]}"


FONT_CACHE = {}
FONT_INFO = {"regular": None, "bold": None, "size": 11.0}


def _query_kitty_terminal(*queries):
    try:
        out = subprocess.check_output(
            ["kitten", "query_terminal", *queries],
            stderr=subprocess.DEVNULL,
            text=True,
            timeout=0.35,
        )
        result = {}
        for line in out.splitlines():
            if ":" in line:
                k, v = line.split(":", 1)
                result[k.strip()] = v.strip()
        return result
    except Exception:
        return {}


def _font_file_from_name(name):
    if not name:
        return None

    # Fontconfig is normally available on Homebrew-based macOS setups.
    if shutil.which("fc-match"):
        try:
            out = subprocess.check_output(
                ["fc-match", "-f", "%{file}\\n", name],
                stderr=subprocess.DEVNULL,
                text=True,
                timeout=0.4,
            ).strip()
            if out and os.path.isfile(out.splitlines()[0]):
                return out.splitlines()[0]
        except Exception:
            pass

    # macOS Spotlight fallback.
    if shutil.which("mdfind"):
        try:
            query = f'kMDItemFSName == "*{name}*"c || kMDItemFonts == "*{name}*"c'
            out = subprocess.check_output(
                ["mdfind", query],
                stderr=subprocess.DEVNULL,
                text=True,
                timeout=0.6,
            )
            for path in out.splitlines():
                if path.lower().endswith((".ttf", ".otf", ".ttc", ".otc")):
                    return path
        except Exception:
            pass

    return None


def refresh_font():
    global FONT_INFO
    q = _query_kitty_terminal("font_family", "bold_font", "font_size")
    regular = q.get("font_family")
    bold = q.get("bold_font")
    try:
        size = float(q.get("font_size", "11"))
    except ValueError:
        size = 11.0

    # `font_family` is a PostScript name according to Kitty's query API.
    regular_file = _font_file_from_name(regular)
    bold_file = _font_file_from_name(bold) if bold and bold != "auto" else regular_file

    if regular_file:
        FONT_INFO["regular"] = regular_file
    if bold_file:
        FONT_INFO["bold"] = bold_file
    FONT_INFO["size"] = size
    FONT_CACHE.clear()


def font_candidates(bold=False):
    p = FONT_INFO["bold" if bold else "regular"]
    candidates = [p] if p else []
    if bold:
        candidates += [
            "/System/Library/Fonts/SF-Mono-Bold.otf",
            "/System/Library/Fonts/SFNS-Bold.otf",
            "/System/Library/Fonts/Menlo.ttc",
        ]
    else:
        candidates += [
            "/System/Library/Fonts/SF-Mono-Regular.otf",
            "/System/Library/Fonts/Menlo.ttc",
            "/System/Library/Fonts/SFNS.ttf",
        ]
    return [p for p in candidates if p]


def get_font(size, bold=False):
    size = max(8, int(size))
    key = (size, bold, FONT_INFO.get("regular"), FONT_INFO.get("bold"))
    if key in FONT_CACHE:
        return FONT_CACHE[key]

    for p in font_candidates(bold):
        if os.path.exists(p):
            try:
                f = ImageFont.truetype(p, size)
                FONT_CACHE[key] = f
                return f
            except Exception:
                continue

    f = ImageFont.load_default()
    FONT_CACHE[key] = f
    return f


def round_rect(draw, box, radius, fill, outline=None, width=1):
    draw.rounded_rectangle(box, radius=radius, fill=fill, outline=outline, width=width)


def text_center(draw, xy, text, font, fill):
    text = str(text)
    box = draw.textbbox((0, 0), text, font=font)
    w = box[2] - box[0]
    h = box[3] - box[1]
    draw.text((xy[0] - w / 2, xy[1] - h / 2 - box[1]), text, font=font, fill=fill)


def text(draw, xy, value, font, fill, anchor=None, shadow=True):
    """High-contrast text with a tiny wallpaper-safe shadow."""
    value = str(value)
    if shadow:
        sx = xy[0] + max(1, getattr(font, "size", 18) // 16)
        sy = xy[1] + max(1, getattr(font, "size", 18) // 16)
        draw.text((sx, sy), value, font=font, fill=SHADOW, anchor=anchor)
    draw.text(xy, value, font=font, fill=fill, anchor=anchor)


def draw_gauge(draw, cx, cy, r, value, color, label, value_text):
    """
    Deliberately casts all text to str. This fixes the v5 failure mode where
    Pillow could receive a non-string value through a gauge call.
    """
    value_text = str(value_text)
    label = str(label)

    box = (cx - r, cy - r, cx + r, cy + r)

    draw.arc(
        box,
        210,
        330,
        fill=(*THEME["foreground"], 82),
        width=max(3, r // 9),
    )

    if value is not None:
        frac = max(0.0, min(1.0, float(value) / 100.0))
        draw.arc(
            box,
            210,
            210 + 120 * frac,
            fill=color,
            width=max(3, r // 9),
        )

        ang = math.radians(210 + 120 * frac)
        x2 = cx + math.cos(ang) * r * 0.70
        y2 = cy + math.sin(ang) * r * 0.70
        draw.line(
            (cx, cy, x2, y2),
            fill=TEXT,
            width=max(2, r // 18),
        )
        draw.ellipse((cx - 4, cy - 4, cx + 4, cy + 4), fill=color)

    f_value = get_font(max(16, r // 3), True)
    f_label = get_font(max(12, r // 4))

    text_center(draw, (cx, cy + r * 0.38), value_text, f_value, TEXT)
    text_center(draw, (cx, cy + r * 0.68), label, f_label, MUTED)


def draw_chart(draw, box, hist, color, minv=0, maxv=100, fill_alpha=32):
    x0, y0, x1, y1 = map(int, box)
    if x1 - x0 < 10 or y1 - y0 < 10:
        return

    for q in (0.0, 0.5, 1.0):
        y = int(y1 - (y1 - y0) * q)
        draw.line((x0, y, x1, y), fill=GRID, width=1)

    vals = list(hist)
    if len(vals) < 2:
        return

    span = max(1.0, float(maxv - minv))
    pts = []
    for i, v in enumerate(vals):
        xx = x0 + (x1 - x0) * i / max(1, len(vals) - 1)
        yy = y1 - (y1 - y0) * max(0.0, min(1.0, (float(v) - minv) / span))
        pts.append((int(xx), int(yy)))

    # Draw the translucent fill directly on the existing image.
    # Creating a full-screen RGBA overlay for every chart is expensive.
    if fill_alpha:
        fill = tuple(color[:3]) + (fill_alpha,)
        draw.polygon([(x0, y1), *pts, (x1, y1)], fill=fill)

    draw.line(
        pts,
        fill=color,
        width=max(2, int((x1 - x0) / 130)),
        joint="curve",
    )


def draw_network_chart(draw, box, rx_hist, tx_hist):
    allv = list(rx_hist) + list(tx_hist)
    mx = max(allv) if allv else 1.0
    mx = max(float(mx), 1.0)

    draw_chart(draw, box, rx_hist, NET_DOWN, 0, mx, 30)
    draw_chart(draw, box, tx_hist, NET_UP, 0, mx, 30)


def cava_config(path, bars):
    """Use the user's working Cava config, changing only dashboard output."""
    source = os.path.expanduser("~/.config/cava/config")
    with open(source, "r", encoding="utf-8") as f:
        lines = f.read().splitlines()

    section = None
    output = {
        "method": "raw",
        "channels": "mono",
        "raw_target": "/dev/stdout",
        "data_format": "binary",
        "bit_format": "16bit",
    }
    seen_bars = False
    seen = {k: False for k in output}

    for i, line in enumerate(lines):
        st = line.strip()
        if st.startswith("[") and st.endswith("]"):
            section = st[1:-1].strip().lower()
            continue
        if section == "general" and re.match(r"^\s*;?\s*bars\s*=", line):
            lines[i] = f"bars = {bars}"
            seen_bars = True
        elif section == "output":
            for key, value in output.items():
                if re.match(rf"^\s*;?\s*{re.escape(key)}\s*=", line):
                    indent = re.match(r"^\s*", line).group(0)
                    lines[i] = f"{indent}{key} = {value}"
                    seen[key] = True
                    break

    if not seen_bars:
        for i, line in enumerate(lines):
            if line.strip().lower() == "[general]":
                lines.insert(i + 1, f"bars = {bars}")
                break

    missing = [k for k, v in seen.items() if not v]
    if missing:
        idx = next(
            (i for i, l in enumerate(lines) if l.strip().lower() == "[output]"), None
        )
        if idx is None:
            lines += ["", "[output]"]
            idx = len(lines) - 1
        for key in missing:
            lines.insert(idx + 1, f"{key} = {output[key]}")
            idx += 1

    with open(path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")


def find_cava():
    # Kitty's environment may not inherit Homebrew's /opt/homebrew/bin PATH
    # when launched from the GUI. Search both common Homebrew locations.
    candidates = [
        shutil.which("cava"),
        "/opt/homebrew/bin/cava",
        "/usr/local/bin/cava",
    ]
    for candidate in candidates:
        if candidate and os.path.isfile(candidate) and os.access(candidate, os.X_OK):
            return candidate
    return None


def start_cava(bars):
    cava_bin = find_cava()
    if not cava_bin:
        log("Cava not found. PATH=" + os.environ.get("PATH", ""))
        return None, "cava not found"

    fd, path = tempfile.mkstemp(prefix="kitty-dashboard-cava-", suffix=".conf")
    os.close(fd)
    cava_config(path, bars)

    try:
        p = subprocess.Popen(
            [cava_bin, "-p", path],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            bufsize=0,
        )

        # Non-blocking output: never let Cava stall the UI loop.
        import fcntl

        flags = fcntl.fcntl(p.stdout.fileno(), fcntl.F_GETFL)
        fcntl.fcntl(
            p.stdout.fileno(),
            fcntl.F_SETFL,
            flags | os.O_NONBLOCK,
        )

        return (p, path), "starting"
    except Exception as e:
        log(f"start_cava: {e!r}")
        try:
            os.unlink(path)
        except Exception:
            pass
        return None, str(e)


def parse_cava(buf, bars):
    """Parse Cava's 16-bit raw frames. One frame = bars unsigned shorts."""
    frame_bytes = bars * 2
    if not buf:
        return [], b""

    usable = len(buf) - (len(buf) % frame_bytes)
    if usable <= 0:
        return [], buf

    data = buf[:usable]
    remainder = buf[usable:]
    fmt = "<" + ("H" * bars)
    out = []

    for off in range(0, len(data), frame_bytes):
        try:
            vals = struct.unpack_from(fmt, data, off)
            out.append([max(0, min(65530, v)) / 65530.0 for v in vals])
        except struct.error:
            break

    return out, remainder


def draw_audio(draw, box, vals, signal_ok, cava_state):
    x0, y0, x1, y1 = map(int, box)

    if not signal_ok:
        f = get_font(9, True)
        if cava_state == "missing":
            msg = "CAVA NOT FOUND"
        elif cava_state == "dead":
            msg = "BLACKHOLE UNAVAILABLE"
        else:
            msg = "WAITING FOR AUDIO"
        text_center(
            draw,
            ((x0 + x1) // 2, y0 + 24),
            msg,
            f,
            MUTED,
        )
        return

    n = max(1, len(vals))
    width = x1 - x0
    gap = max(2, width // (n * 6))
    bw = max(2, (width - gap * (n - 1)) // n)

    for i, v in enumerate(vals):
        h = int((y1 - y0) * max(0.015, min(1.0, v)))
        xx = x0 + i * (bw + gap)
        yy = y1 - h
        draw.rounded_rectangle(
            (xx, yy, xx + bw, y1),
            radius=max(1, bw // 3),
            fill=AUDIO_COLOR,
        )


def draw_clock(draw, cx, cy, r):
    # The source image is rendered in physical pixels, so x/y radii remain
    # identical and the clock stays genuinely circular even in a narrow pane.
    draw.ellipse(
        (cx - r, cy - r, cx + r, cy + r),
        fill=CLOCK_FACE,
        outline=CLOCK_OUTLINE,
        width=max(2, r // 28),
    )

    for i in range(60):
        a = 2 * math.pi * i / 60.0
        outer = r * 0.91
        inner = r * (0.78 if i % 5 == 0 else 0.86)
        x1 = cx + math.sin(a) * inner
        y1 = cy - math.cos(a) * inner
        x2 = cx + math.sin(a) * outer
        y2 = cy - math.cos(a) * outer
        draw.line(
            (x1, y1, x2, y2),
            fill=CLOCK_TICK if i % 5 == 0 else (*CLOCK_TICK[:3], 115),
            width=max(2, r // 34) if i % 5 else max(3, r // 22),
        )

    now = time.localtime()
    sec = now.tm_sec + (time.time() % 1)
    hands = [
        (
            (now.tm_hour % 12 + now.tm_min / 60) / 12,
            r * 0.49,
            CLOCK_HOUR,
            max(4, r // 13),
        ),
        ((now.tm_min + sec / 60) / 60, r * 0.69, CLOCK_MINUTE, max(3, r // 17)),
        (sec / 60, r * 0.79, CLOCK_SECOND, max(2, r // 25)),
    ]

    for frac, length, color, width in hands:
        a = 2 * math.pi * frac
        draw.line(
            (cx, cy, cx + math.sin(a) * length, cy - math.cos(a) * length),
            fill=color,
            width=width,
        )

    dot = max(4, r // 16)
    draw.ellipse((cx - dot, cy - dot, cx + dot, cy + dot), fill=CLOCK_MINUTE)


def kitty_image(img, cols, rows):
    bio = io.BytesIO()
    img.save(bio, format="PNG", compress_level=1)
    data = base64.b64encode(bio.getvalue())

    # Replace previous dashboard image.
    os.write(
        1,
        f"\x1b_Ga=d,d=I,i={IMAGE_ID},q=2\x1b\\".encode(),
    )

    os.write(1, b"\x1b[H\x1b[2J")

    head = (f"\x1b_Ga=T,f=100,i={IMAGE_ID}," f"c={cols},r={rows},C=1,q=2;").encode()

    os.write(1, head + data + b"\x1b\\")
    os.write(1, b"\x1b[?25l")


def cleanup(*_):
    global RUNNING
    RUNNING = False
    try:
        os.write(1, b"\x1b_Ga=d,d=I,i=19371,q=2\x1b\\")
        os.write(1, b"\x1b[?25h")
    except Exception:
        pass


def render_once(
    cols,
    rows,
    pw,
    ph,
    cpu_hist,
    mem_hist,
    rx_hist,
    tx_hist,
    audio,
    audio_ok,
    cava_state,
):
    # Render above native resolution, then let Kitty scale to the pane.
    # 1.5x is a good quality/CPU compromise for a continuously-updating panel.
    SCALE = 1.5
    W = max(1, int(cols * pw * SCALE))
    H = max(1, int(rows * ph * SCALE))

    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d._image = img

    margin = max(12, int(W * 0.065))

    title_f = get_font(max(14, int(W * 0.040)), True)
    label_f = get_font(max(11, int(W * 0.030)), True)
    small_f = get_font(max(9, int(W * 0.026)))
    clock_f = get_font(max(18, int(W * 0.035)), True)
    speed_f = get_font(max(14, int(W * 0.035)), True)

    # Header
    text_center(d, (W // 2, margin + 8), "SYSTEM", title_f, TITLE)
    d.line(
        (margin, margin + 30, W - margin, margin + 30),
        fill=(*THEME["foreground"], 65),
        width=1,
    )

    # Clock
    clock_cx = W // 2
    clock_cy = margin + int(H * 0.1)
    r = min(int(W * 0.27), int(H * 0.072))
    draw_clock(d, clock_cx, clock_cy, r)

    ts = time.strftime("%H:%M:%S")
    text_center(
        d,
        (W // 2, clock_cy + r + int(H * 0.012)),
        ts,
        clock_f,
        TEXT,
    )

    y = int(clock_cy + r + int(H * 0.028))
    gap = max(10, int(H * 0.014))
    card_h = max(108, int(H * 0.145))

    def card(y0, title):
        round_rect(
            d,
            (margin, y0, W - margin, y0 + card_h),
            max(10, int(W * 0.018)),
            CARD,
            outline=CARD_EDGE,
            width=max(1, int(W / 700)),
        )
        text(
            d,
            (margin + 12, y0 + 10),
            title,
            label_f,
            TITLE,
            shadow=True,
        )

    cpu = cpu_hist[-1] if cpu_hist else None
    mem = mem_hist[-1] if mem_hist else None

    card(y, "CPU")
    draw_gauge(
        d,
        margin + int(W * 0.24),
        y + card_h * 0.57,
        min(44, int(W * 0.18)),
        cpu,
        CPU_COLOR,
        "SYSTEM",
        f"{cpu:.0f}%" if cpu is not None else "—",
    )
    if cpu_hist:
        draw_chart(
            d,
            (margin + W * 0.45, y + 39, W - margin - 12, y + card_h - 16),
            cpu_hist,
            CPU_COLOR,
            0,
            100,
            25,
        )
    y += card_h + gap

    card(y, "MEMORY")
    draw_gauge(
        d,
        margin + int(W * 0.24),
        y + card_h * 0.57,
        min(44, int(W * 0.18)),
        mem,
        MEM_COLOR,
        "USED",
        f"{mem:.0f}%" if mem is not None else "—",
    )
    if mem_hist:
        draw_chart(
            d,
            (margin + W * 0.45, y + 39, W - margin - 12, y + card_h - 16),
            mem_hist,
            MEM_COLOR,
            0,
            100,
            25,
        )
    y += card_h + gap

    # Network
    net_h = max(126, int(H * 0.2))
    round_rect(
        d,
        (margin, y, W - margin, y + net_h),
        13,
        CARD,
        outline=CARD_EDGE,
        width=1,
    )
    text(d, (margin + 12, y + 10), "NETWORK", label_f, TITLE, shadow=True)

    draw_network_chart(
        d,
        (margin + 12, y + 38, W - margin - 12, y + net_h - 56),
        rx_hist,
        tx_hist,
    )

    rx = rx_hist[-1] if rx_hist else 0
    tx = tx_hist[-1] if tx_hist else 0

    text(
        d,
        (margin + 12, y + net_h - 44),
        f"DOWNLOAD  {fmt_rate(rx)}",
        speed_f,
        NET_DOWN,
        shadow=True,
    )

    txt = f"UPLOAD  {fmt_rate(tx)}"
    tb = d.textbbox((0, 0), txt, font=speed_f)
    text(
        d,
        (margin + 12, y + net_h - 24),
        txt,
        speed_f,
        NET_UP,
        shadow=True,
    )

    y += net_h + gap

    # Audio
    ah = max(78, int(H * 0.2))
    round_rect(
        d,
        (margin, y, W - margin, y + ah),
        13,
        CARD,
        outline=CARD_EDGE,
        width=1,
    )
    text(d, (margin + 12, y + 10), "AUDIO", label_f, TITLE, shadow=True)

    draw_audio(
        d,
        (margin + 14, y + 38, W - margin - 14, y + ah - 12),
        audio,
        audio_ok,
        cava_state,
    )

    return img


def main():
    global RUNNING

    signal.signal(signal.SIGINT, cleanup)
    signal.signal(signal.SIGTERM, cleanup)

    # Prime psutil so the first sample is meaningful.
    try:
        psutil.cpu_percent(interval=None)
    except Exception:
        pass

    cpu_hist = deque(maxlen=90)
    mem_hist = deque(maxlen=90)
    rx_hist = deque(maxlen=90)
    tx_hist = deque(maxlen=90)

    last_net = network_bytes()
    last_theme_refresh = 0.0
    last_font_refresh = 0.0
    last_t = time.monotonic()
    last_stats = 0.0
    last_render = 0.0
    refresh_theme()
    refresh_font()
    refresh_pixel_size()

    cava = None
    cava_buf = b""
    audio = [0.0] * 24
    audio_ok = False
    cava_state = "missing" if not find_cava() else "starting"

    c = psutil.cpu_percent(interval=None)
    m = memory_load()
    n = network_bytes()
    last_stats = time.monotonic()

    while RUNNING:
        try:
            if time.monotonic() - last_theme_refresh > 2.0:
                refresh_theme()
                last_theme_refresh = time.monotonic()

            if time.monotonic() - last_font_refresh > 5.0:
                refresh_font()
                last_font_refresh = time.monotonic()

            cols, rows = term_size()
            # Cell dimensions are effectively constant; refresh occasionally.
            if int(time.monotonic()) % 10 == 0:
                refresh_pixel_size()
            pw, ph = pixel_size()

            if cols < 25 or rows < 20:
                time.sleep(0.25)
                continue

            # Start/restart Cava if necessary.
            if cava is None and find_cava():
                cava, state = start_cava(24)
                cava_state = "starting" if cava else "dead"
                if not cava:
                    log(f"Cava failed to start: {state}")

            if cava:
                p, _path = cava
                try:
                    # Drain the pipe completely each frame. If rendering ever
                    # takes longer than Cava's 60 FPS, we intentionally discard
                    # stale frames and keep only the newest one.
                    frames = []
                    while True:
                        ready, _, _ = select.select([p.stdout], [], [], 0)
                        if not ready:
                            break
                        chunk = os.read(p.stdout.fileno(), 16384)
                        if not chunk:
                            break
                        new_frames, cava_buf = parse_cava(cava_buf + chunk, 24)
                        if new_frames:
                            frames.extend(new_frames)

                    if frames:
                        audio = frames[-1]
                        audio_ok = max(audio) > 0.002
                        cava_state = "live"
                    elif p.poll() is not None:
                        cava = None
                        audio_ok = False
                        cava_state = "dead"
                        log("Cava exited")
                except (BlockingIOError, OSError, ValueError):
                    pass

            now = time.monotonic()

            # Telemetry does not need to be sampled at render FPS.
            # 5 Hz is visually smooth and substantially cheaper.
            if now - last_stats >= 0.20:
                elapsed = max(0.1, now - last_stats)
                last_stats = now

                c = cpu_load()
                m = memory_load()
                n = network_bytes()

                if c is not None:
                    cpu_hist.append(c)
                if m is not None:
                    mem_hist.append(m)

                if n and last_net:
                    rx_hist.append(max(0, n[0] - last_net[0]) / elapsed)
                    tx_hist.append(max(0, n[1] - last_net[1]) / elapsed)

                if n:
                    last_net = n

            img = render_once(
                cols,
                rows,
                pw,
                ph,
                cpu_hist,
                mem_hist,
                rx_hist,
                tx_hist,
                audio,
                audio_ok,
                cava_state,
            )

            kitty_image(img, cols, rows)

            # 24 FPS is enough for the sidebar UI. Cava itself runs at 60 FPS;
            # we always display the newest available audio frame, so no stale
            # audio backlog accumulates.
            time.sleep(1.0 / 16.0)

        except Exception as e:
            # Critical change from v5: NEVER let a transient render/type
            # exception kill the dashboard with a one-frame traceback.
            log(f"MAIN LOOP: {e!r}")
            time.sleep(0.25)


if __name__ == "__main__":
    main()

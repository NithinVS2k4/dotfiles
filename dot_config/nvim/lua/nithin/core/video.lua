local function play_video_inline()
  local file = vim.fn.expand("%:p")

  if file == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end

  ---------------------------------------------------------------------------
  -- Neovim window position/size in terminal cells
  ---------------------------------------------------------------------------

  local pos = vim.fn.win_screenpos(0)
  local win_row = pos[1]
  local win_col = pos[2]
  local win_rows = vim.fn.winheight(0)
  local win_cols = vim.fn.winwidth(0)

  ---------------------------------------------------------------------------
  -- Get Kitty OS window bounds in physical pixels
  ---------------------------------------------------------------------------

  local as_get = [[
    osascript -e '
      tell application "System Events"
        tell process "kitty"
          set win to front window
          set {px, py} to position of win
          set {pw, ph} to size of win
          return (px as string) & "," & (py as string) & "," & (pw as string) & "," & (ph as string)
        end tell
      end tell'
  ]]

  local bounds = vim.fn.system(as_get)
  local px, py, pw, ph = bounds:match("(%d+),(%d+),(%d+),(%d+)")

  if not px then
    vim.notify("Could not read Kitty window bounds (Accessibility permission?)", vim.log.levels.ERROR)
    return
  end

  px = tonumber(px)
  py = tonumber(py)
  pw = tonumber(pw)
  ph = tonumber(ph)

  ---------------------------------------------------------------------------
  -- Convert terminal cells to physical pixels
  ---------------------------------------------------------------------------

  local cell_w = pw / vim.o.columns
  local cell_h = ph / vim.o.lines

  local target_x = px + (win_col - 1) * cell_w
  local target_y = py + (win_row - 1) * cell_h
  local target_w = win_cols * cell_w
  local target_h = win_rows * cell_h

  ---------------------------------------------------------------------------
  -- Output resolution
  --
  -- We don't need a giant 1920px frame for a terminal preview.
  -- 960 is substantially cheaper while still looking good in a preview.
  ---------------------------------------------------------------------------

  local max_width = 960

  local render_width = math.floor(math.min(target_w, max_width))

  -- Keep even.
  render_width = render_width - (render_width % 2)

  ---------------------------------------------------------------------------
  -- Preserve the EXACT aspect ratio of the Kitty image.
  --
  -- The whole output frame is this ratio:
  --
  --     ┌──────────────────────┐
  --     │ ███┌────────────┐███ │
  --     │ ███│   VIDEO    │███ │
  --     │ ███│            │███ │
  --     │ ███└────────────┘███ │
  --     └──────────────────────┘
  --
  -- The black bars are part of the video frame, so Kitty itself doesn't
  -- introduce a positional offset.
  ---------------------------------------------------------------------------

  local render_height = math.floor(render_width * target_h / target_w)

  -- Keep even.
  render_height = render_height - (render_height % 2)

  if render_height < 2 then
    render_height = 2
  end

  ---------------------------------------------------------------------------
  -- Fast scale + pad
  --
  -- fast_bilinear is intentionally used here. This is a preview, not
  -- a high-quality export, and it significantly reduces CPU usage.
  ---------------------------------------------------------------------------

  local video_filter = string.format(
    "scale=%d:%d:force_original_aspect_ratio=decrease:force_divisible_by=2:flags=fast_bilinear,"
      .. "pad=%d:%d:(ow-iw)/2:(oh-ih)/2:black",
    render_width,
    render_height,
    render_width,
    render_height
  )

  local title = "mpv-inline-preview"

  ---------------------------------------------------------------------------
  -- Launch mpv
  ---------------------------------------------------------------------------

  vim.fn.jobstart({
    "kitten",
    "@",
    "launch",
    "--type=os-window",
    "--os-window-title=" .. title,

    "mpv",

    -------------------------------------------------------------------------
    -- Kitty graphics output
    -------------------------------------------------------------------------

    "--vo=kitty",

    -------------------------------------------------------------------------
    -- Hardware decode
    -------------------------------------------------------------------------

    "--hwdec=videotoolbox",

    -------------------------------------------------------------------------
    -- IMPORTANT:
    -- The filter creates a frame matching the Kitty window aspect ratio.
    -------------------------------------------------------------------------

    "--vf=" .. video_filter,

    -------------------------------------------------------------------------
    -- Playback
    -------------------------------------------------------------------------

    "--profile=sw-fast",
    "--video-sync=display-vdrop",
    "--interpolation=no",

    -- Don't maintain a large playback cache for this preview.
    "--cache=no",

    -------------------------------------------------------------------------
    -- OSC
    -------------------------------------------------------------------------

    "--osc=yes",

    "--really-quiet",

    file,
  }, {
    detach = true,
  })

  ---------------------------------------------------------------------------
  -- Position Kitty window over the Neovim split
  ---------------------------------------------------------------------------

  vim.defer_fn(function()
    local as_move = string.format(
      [[
        osascript -e '
          tell application "System Events"
            tell process "kitty"
              repeat with w in windows
                if name of w contains "%s" then
                  set position of w to {%d, %d}
                  set size of w to {%d, %d}
                end if
              end repeat
            end tell
          end tell'
      ]],
      title,
      math.floor(target_x),
      math.floor(target_y),
      math.floor(target_w),
      math.floor(target_h)
    )

    vim.fn.system(as_move)
  end, 10)
end

vim.keymap.set("n", "mv", play_video_inline, { desc = "Play video inline over current split (macOS)" })

#!/usr/bin/env python3

import base64
import subprocess
import sys
import tempfile
import zlib

from pdf2image import convert_from_path

LATEX_TEMPLATE = r"""
\documentclass[preview,border=2pt]{standalone}
\usepackage{amsmath}
\usepackage{amssymb}
\begin{document}
$%s$
\end{document}
"""


def kitty_display(png_path):
    with open(png_path, "rb") as f:
        data = f.read()
    encoded = base64.standard_b64encode(data).decode("ascii")
    # Send in chunks of 4096
    chunk_size = 4096
    chunks = [encoded[i : i + chunk_size] for i in range(0, len(encoded), chunk_size)]
    for i, chunk in enumerate(chunks):
        is_last = i == len(chunks) - 1
        m = 0 if is_last else 1
        if i == 0:
            payload = f"\x1b_Ga=T,f=100,m={m};{chunk}\x1b\\"
        else:
            payload = f"\x1b_Gm={m};{chunk}\x1b\\"
        print(payload, end="", flush=True)
    print()


def exec_cmd(cmd, capture_output=True):
    log = subprocess.run(cmd, capture_output=capture_output)
    if log.returncode:
        print('\nAn error occurred when running the command "' + cmd[0] + '"')
        if capture_output:
            print(log.stdout.decode("utf-8"))
            print(log.stderr.decode("utf-8"))
    return log.returncode == 0


def display_tex(latex):
    with tempfile.TemporaryDirectory() as tmpdirname:
        filename = f"{tmpdirname}/out"

        with open(f"{filename}.tex", "w") as f:
            f.write(LATEX_TEMPLATE % latex)

        latex_cmd = [
            "pdflatex",
            "-interaction=nonstopmode",
            f"-output-directory={tmpdirname}",
            f"{filename}.tex",
        ]

        if exec_cmd(latex_cmd):
            try:
                pages = convert_from_path(f"{filename}.pdf", dpi=300, fmt="png")
                if pages:
                    png_path = f"{filename}.png"
                    pages[0].save(png_path, "PNG")
                    kitty_display(png_path)
            except Exception as e:
                print(f"Error converting PDF to PNG: {e}")


if __name__ == "__main__":
    if len(sys.argv) > 1:
        # join all args so you don't need quotes: texview e^x = 1
        latex = " ".join(sys.argv[1:])
        display_tex(latex)
    else:
        # fallback to interactive mode if no args given
        while True:
            str_in = input("Enter LaTeX: ")
            if not str_in:
                break
            print()
            display_tex(str_in)
            print()

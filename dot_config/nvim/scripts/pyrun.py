"""Run a Python file like `python3 file.py`, but when it crashes also show the
local variables (name, type and value) of the frame where the error happened.

Used by <leader>rp in lua/config/keymaps.lua.
"""

import os
import runpy
import sys

MAX_VALUE_LEN = 120


def color(code, text):
    if sys.stderr.isatty() and "NO_COLOR" not in os.environ:
        return f"\033[{code}m{text}\033[0m"
    return text


def short_repr(value):
    try:
        text = repr(value)
    except Exception as e:
        text = f"<repr failed: {e!r}>"
    if len(text) > MAX_VALUE_LEN:
        text = text[: MAX_VALUE_LEN - 3] + "..."
    return text


def print_locals(frame):
    names = [n for n in frame.f_locals if not (n.startswith("__") and n.endswith("__"))]
    # At module level "locals" are all the globals, including imported modules
    # and functions, which is mostly noise
    if frame.f_code.co_name == "<module>":
        names = [n for n in names if not callable(frame.f_locals[n]) and type(frame.f_locals[n]).__name__ != "module"]
    if not names:
        return
    where = frame.f_code.co_name
    print("\n" + color("1;36", f"Variables in {where}() at line {frame.f_lineno}:"), file=sys.stderr)
    width = max(len(n) for n in names)
    for name in names:
        value = frame.f_locals[name]
        print(
            f"  {color('1;33', name.ljust(width))}  {color('32', type(value).__name__)} = {short_repr(value)}",
            file=sys.stderr,
        )


def main():
    if len(sys.argv) < 2:
        sys.exit("usage: pyrun.py file.py [args...]")
    path = os.path.abspath(sys.argv[1])
    sys.argv = sys.argv[1:]
    # Same as `python3 file.py`: the script's own folder comes first for imports
    sys.path[0] = os.path.dirname(path)

    try:
        runpy.run_path(path, run_name="__main__")
    except SystemExit:
        raise
    except BaseException as e:
        # Hide the runpy/pyrun frames so the traceback starts at the user's file
        tb = e.__traceback__
        while tb and tb.tb_frame.f_code.co_filename != path:
            tb = tb.tb_next
        if tb is None:
            tb = e.__traceback__
        e.__traceback__ = tb
        sys.excepthook(type(e), e, tb)  # Python's own (colored) traceback

        if not isinstance(e, KeyboardInterrupt):
            last = tb
            while last.tb_next:
                last = last.tb_next
            print_locals(last.tb_frame)
        sys.exit(1)


if __name__ == "__main__":
    main()

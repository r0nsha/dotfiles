import sys
from enum import Enum
from typing import TextIO


class Color(str, Enum):
    Blue = "\033[0;34m"
    Yellow = "\033[0;33m"
    Green = "\033[0;32m"
    Red = "\033[0;31m"
    Reset = "\033[0m"


def _log_message(
    color_code: Color,
    prefix: str,
    message: str,
    stream: TextIO = sys.stdout,
):
    formatted_message = f"{color_code}{prefix} {message}{Color.Reset}"
    print(formatted_message, file=stream)


def info(msg: str):
    _log_message(Color.Blue, "[ℹ]", msg)


def running(msg: str):
    _log_message(Color.Yellow, ">", msg)


def success(msg: str):
    _log_message(Color.Green, "✓", msg)


def fail(msg: str):
    _log_message(Color.Red, "!", f"\n{msg}", stream=sys.stderr)

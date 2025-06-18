import datetime
import sys
from enum import Enum
from typing import TextIO


class Color(Enum):
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
    exit_on_fail: bool = False,
):
    timestamp = datetime.datetime.now().strftime("%H:%M:%S")
    formatted_message = f"[{timestamp} {color_code}{prefix}{Color.Reset}] {message}"
    print(formatted_message, file=stream)

    if exit_on_fail:
        sys.exit(1)


def info(msg: str):
    _log_message(Color.Blue, "i", msg)


def running(msg: str):
    _log_message(Color.Yellow, "~", msg)


def success(msg: str):
    _log_message(Color.Green, "+", msg)


def fail(msg: str, exit_script: bool = True):
    _log_message(
        Color.Red, "!", f"\n{msg}", stream=sys.stderr, exit_on_fail=exit_script
    )

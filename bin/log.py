import datetime
import sys
from typing import TextIO

COLOR_BLUE = "\033[0;34m"
COLOR_YELLOW = "\033[0;33m"
COLOR_GREEN = "\033[0;32m"
COLOR_RED = "\033[0;31m"
COLOR_RESET = "\033[0m"

PREFIX_INFO = "i"
PREFIX_RUNNING = "~"
PREFIX_SUCCESS = "+"
PREFIX_FAIL = "!"


def _log_message(
    color_code: str,
    prefix: str,
    message: str,
    stream: TextIO = sys.stdout,
    exit_on_fail: bool = False,
):
    timestamp = datetime.datetime.now().strftime("%H:%M:%S")
    formatted_message = f"[{timestamp} {color_code}{prefix}{COLOR_RESET}] {message}"
    print(formatted_message, file=stream)

    if exit_on_fail:
        sys.exit(1)


def info(msg: str):
    _log_message(COLOR_BLUE, PREFIX_INFO, msg)


def running(msg: str):
    _log_message(COLOR_YELLOW, PREFIX_RUNNING, msg)


def success(msg: str):
    _log_message(COLOR_GREEN, PREFIX_SUCCESS, msg)


def fail(msg: str, exit_script: bool = True):
    _log_message(
        COLOR_RED, PREFIX_FAIL, f"\n{msg}", stream=sys.stderr, exit_on_fail=exit_script
    )

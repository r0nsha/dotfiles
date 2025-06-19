import subprocess
import sys
from collections.abc import Iterable
from typing import Any


def clear_screen():
    _ = sys.stdout.write("\033[1J")
    _ = sys.stdout.flush()


def clear_above(count: int = 1):
    _ = sys.stdout.write("\033[F\033[K" * count)
    _ = sys.stdout.flush()


def command(cmd: str, clear: bool = True, **kwargs: Any) -> int:  # pyright: ignore[reportAny, reportExplicitAny]
    try:
        kwargs = {"capture_output": True} | kwargs

        result = subprocess.run(
            cmd,
            shell=True,
            text=True,
            check=True,
            **kwargs,  # pyright: ignore[reportAny]
        )
        output_lines = result.stdout.strip().split("\n")

        if output_lines:
            clear_count = len(output_lines) + 1

            for line in output_lines:
                print(line)
                _ = sys.stdout.write(f"{line}\n")
            _ = sys.stdout.flush()

            if clear:
                clear_above(clear_count)

            return clear_count

        return 0
    except subprocess.CalledProcessError as e:
        msg = f"Command failed with error: {e}\n{e.stderr}"  # pyright: ignore[reportAny]
        raise ValueError(msg)
    except FileNotFoundError:
        raise ValueError(f"Error: Command '{cmd}' not found.")


def commands(cmds: Iterable[str]):
    clear_count = 0
    for cmd in cmds:
        clear_count += command(cmd, clear=False)
    clear_above(clear_count)

import subprocess
import sys
from collections.abc import Iterable
from types import TracebackType

from bin import log
from bin.utils import clear_above


class Run:
    name: str

    def __init__(self, name: str):
        self.name = name

    def __enter__(self):
        try:
            log.running(self.name)
        except Exception as e:
            clear_above()
            log.error(f"`{self.name}` failed: {e}")

    def __exit__(
        self,
        exc_type: type[BaseException] | None,
        exc_val: BaseException | None,
        exc_tb: TracebackType | None,
    ) -> bool:
        clear_above()
        if exc_val is None:
            log.success(self.name)
        else:
            log.error(self.name)
        return False


def command(cmd: str, input: str | None = None, clear: bool = True) -> int:
    try:
        print(f"{cmd}")
        result = subprocess.run(
            cmd, shell=True, capture_output=True, text=True, check=True, input=input
        )
        output_lines = result.stdout.strip().split("\n")

        if output_lines:
            clear_count = len(output_lines) + 1

            for line in output_lines:
                _ = sys.stdout.write(f"{line}\n")
            _ = sys.stdout.flush()

            if clear:
                clear_above(clear_count)

            return clear_count

        return 0
    except subprocess.CalledProcessError as e:
        msg = f"Command failed with error: {e}"
        print(msg, file=sys.stderr)
        print(e.stderr, file=sys.stderr)  # pyright: ignore[reportAny]
        raise ValueError(msg)
    except FileNotFoundError:
        raise ValueError(f"Error: Command '{cmd}' not found.")


def commands(cmds: Iterable[str]):
    clear_count = 0
    for cmd in cmds:
        clear_count += command(cmd, clear=False)
    clear_above(clear_count)

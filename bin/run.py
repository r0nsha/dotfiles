import subprocess
import sys
import traceback
from collections.abc import Iterable
from types import TracebackType

from bin import log


def _clear_line_above():
    _ = sys.stdout.write("\033[F")
    _ = sys.stdout.write("\033[K")


class Run:
    name: str

    def __init__(self, name: str):
        self.name = name

    def __enter__(self):
        try:
            log.running(self.name)
        except Exception as e:
            _clear_line_above()
            log.fail(f"`{self.name}` failed: {e}")
            traceback.print_exc()

    def __exit__(
        self,
        exc_type: type[BaseException] | None,
        exc_val: BaseException | None,
        exc_tb: TracebackType | None,
    ) -> bool:
        _clear_line_above()
        log.success(self.name)
        return False


def command(cmd: str):
    try:
        print(f"{cmd}")
        result = subprocess.run(
            cmd, shell=True, capture_output=True, text=True, check=True
        )
        output_lines = result.stdout.strip().split("\n")

        if output_lines:
            for line in output_lines:
                _ = sys.stdout.write(f"{line}\n")
            _ = sys.stdout.flush()

            for i in range(len(output_lines) + 1):
                _clear_line_above()
            _ = sys.stdout.flush()

    except subprocess.CalledProcessError as e:
        msg = f"Command failed with error: {e}"
        print(msg)
        print(e.stderr)  # pyright: ignore[reportAny]
        raise ValueError(msg)
    except FileNotFoundError:
        raise ValueError(f"Error: Command '{cmd}' not found.")


def commands(cmds: Iterable[str]):
    for cmd in cmds:
        command(cmd)

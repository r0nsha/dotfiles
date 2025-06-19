import sys
import threading
import urllib.request
from collections.abc import Iterable
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from bin.utils import clear_above


def progress_bar(progress: float) -> str:
    len = 10
    rounded = int(progress * len)
    return f"{'█' * rounded}{'░' * (len - rounded)} {int(progress * 100)}%"


class Progress:
    tasks: dict[Path, float]
    lock: threading.Lock
    last_printed: int = 0

    def __init__(self):
        self.tasks = {}
        self.lock = threading.Lock()

    def update(self, filename: Path, progress: float):
        with self.lock:
            self.tasks[filename] = progress
            self.print()

    def print(self):
        incomplete = [
            f"{filename} {progress_bar(progress)}\n"
            for filename, progress in self.tasks.items()
            if progress < 100
        ]

        if self.last_printed > 0:
            clear_above(self.last_printed)

        if incomplete:
            _ = sys.stdout.writelines(incomplete)
            _ = sys.stdout.flush()
            self.last_printed = len(incomplete)
        else:
            self.last_printed = 0


def download(url: str, filename: Path, progress: Progress):
    def reporthook(count: int, block_size: int, totalsize: int):
        nonlocal progress
        if totalsize > -1:
            progress.update(filename, (count * block_size) / totalsize)

    _ = urllib.request.urlretrieve(url, filename, reporthook=reporthook)


def download_all(urls_filenames: Iterable[tuple[str, Path]]):
    progress = Progress()

    with ThreadPoolExecutor() as executor:
        futures = [
            executor.submit(download, url, filename, progress)
            for url, filename in urls_filenames
        ]
        for future in futures:
            future.result()

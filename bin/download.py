import threading
import urllib.request
from collections.abc import Iterable
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path


class Progress:
    lines: dict[Path, float]
    lock: threading.Lock

    def __init__(self):
        self.lines = {}
        self.lock = threading.Lock()

    def update(self, filename: Path, progress: float):
        with self.lock:
            self.lines[filename] = progress
            self.print()

    def print(self):
        to_print = "\t".join(
            [
                f"{filename} : {progress * 100:.2f}%"
                for filename, progress in self.lines.items()
            ]
        )
        print(f"Downloading\t{to_print}", end="\r")


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

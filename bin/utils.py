import sys


def clear_screen():
    _ = sys.stdout.write("\033[1J")
    _ = sys.stdout.flush()


def clear_above(count: int = 1):
    _ = sys.stdout.write("\033[F\033[K" * count)
    _ = sys.stdout.flush()

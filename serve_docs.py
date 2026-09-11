#!/usr/bin/env python3
"""Serve the generated CubeBraid documentation without browser caching."""

import argparse
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path


class NoCacheRequestHandler(SimpleHTTPRequestHandler):
    """HTTP handler that prevents stale local documentation pages."""

    server_version = "CubeBraidDocs/1.0"

    def end_headers(self):
        self.send_header(
            "Cache-Control",
            "no-store, no-cache, must-revalidate, max-age=0",
        )
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        super().end_headers()


class PreviewHTTPServer(ThreadingHTTPServer):
    """Reusable threaded server for local documentation preview."""

    allow_reuse_address = True
    daemon_threads = True


def parse_args():
    default_directory = Path(__file__).resolve().parent / "build" / "html"
    parser = argparse.ArgumentParser(
        description="Serve generated CubeBraid HTML with cache disabled."
    )
    parser.add_argument(
        "--directory",
        type=Path,
        default=default_directory,
        help="HTML directory to serve (default: build/html)",
    )
    parser.add_argument(
        "--host",
        default="localhost",
        help="Interface to bind (default: localhost)",
    )
    parser.add_argument(
        "--port",
        type=int,
        default=8000,
        help="TCP port to bind (default: 8000)",
    )
    return parser.parse_args()


def main():
    args = parse_args()
    directory = args.directory.expanduser().resolve()
    if not directory.is_dir():
        raise SystemExit(f"HTML directory does not exist: {directory}")

    handler = partial(NoCacheRequestHandler, directory=str(directory))
    server = PreviewHTTPServer((args.host, args.port), handler)
    print(f"Serving {directory}")
    print(f"Open http://localhost:{args.port}")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("Stopping documentation server.")
    finally:
        server.server_close()


if __name__ == "__main__":
    main()

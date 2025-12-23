#!/bin/bash
set -e

# Install packages as root.
echo "[ENTRYPOINT] Installing package..."
# Only build if package not installed
if ! python -c "import softgroup" &>/dev/null; then
    echo "[ENTRYPOINT] Building package..."
    python setup.py build_ext develop
else
    echo "[ENTRYPOINT] Package already installed, skipping build."
fi

# drop privileges
exec su devuser -c "$*"
echo "[ENTRYPOINT] Running command: $@"
exec "$@"

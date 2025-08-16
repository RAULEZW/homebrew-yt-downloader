#!/bin/bash

BREW_PREFIX=$(brew --prefix)
CELLAR="$BREW_PREFIX/Cellar/yt-downloader"
LATEST_VERSION=$(ls -1 "$CELLAR" | sort -V | tail -n1)
VENV_DIR="$CELLAR/$LATEST_VERSION/libexec/venv"

if [ ! -d "$VENV_DIR" ]; then
    echo "Python virtual environment not found in $VENV_DIR"
    exit 1
fi

source "$VENV_DIR/bin/activate"
APP_DIR="$CELLAR/$LATEST_VERSION"
cd "$APP_DIR" || exit 1

export FLASK_APP=app.py
export FLASK_ENV=production

PORT="${1:-5050}"
echo "Starting YouTube Downloader at http://localhost:$PORT"
exec flask run --host=0.0.0.0 --port "$PORT"
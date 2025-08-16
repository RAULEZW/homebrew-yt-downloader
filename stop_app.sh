#!/bin/bash
# Stops the running Flask server for yt-downloader
PID=$(ps aux | grep "[f]lask run" | awk '{print $2}')

if [ -z "$PID" ]; then
    echo "No running Flask server found."
else
    echo "Stopping Flask server with PID $PID"
    kill -9 $PID
fi
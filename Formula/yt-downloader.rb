class YtDownloader < Formula
  desc "Local YouTube downloader Flask app"
  homepage "https://github.com/RAULEZW/youtube-downloader"
  url "https://github.com/RAULEZW/youtube-downloader/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "6571120e28784a86d6aea59cbcbd0f9ed9c4290509039063660c97535d00aca9"
  license "MIT"

  depends_on "python@3.11"
  depends_on "ffmpeg"

  def install
    libexec.install Dir["*"]
    py = Formula["python@3.11"].opt_bin/"python3"

    (bin/"yt-downloader").write <<~SH
      #!/bin/bash
      set -euo pipefail
      APP_DIR="#{opt_libexec}"
      VENV_DIR="$APP_DIR/venv"
      PY="#{py}"

      if [ ! -d "$VENV_DIR" ]; then
        "$PY" -m venv "$VENV_DIR"
        "$VENV_DIR/bin/pip" install --upgrade pip
        if [ -f "$APP_DIR/requirements.txt" ]; then
          "$VENV_DIR/bin/pip" install -r "$APP_DIR/requirements.txt"
        else
          "$VENV_DIR/bin/pip" install flask yt-dlp
        fi
      fi

      mkdir -p "$APP_DIR/downloads"
      cd "$APP_DIR"
      export FLASK_APP=app
      export FLASK_ENV=production
      PORT="${1:-5050}"
      exec "$VENV_DIR/bin/python" -m flask run --host 0.0.0.0 --port "$PORT"
    SH
  end

  def post_install
    (var/"log").mkpath
  end

  service do
    run [opt_bin/"yt-downloader"]
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/yt-downloader.log"
    error_log_path var/"log/yt-downloader.log"
  end

  test do
    system "#{bin}/yt-downloader", "5051"
  end
end

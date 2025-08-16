class YtDownloader < Formula
  desc "YouTube downloader with Flask web UI"
  homepage "https://github.com/RAULEZW/youtube-downloader"
  url "https://github.com/RAULEZW/youtube-downloader/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "6571120e28784a86d6aea59cbcbd0f9ed9c4290509039063660c97535d00aca9"
  license "MIT"

  depends_on "python@3.11"
  depends_on "ffmpeg"

  def install
    venv = libexec/"venv"
    system "python3", "-m", "venv", venv
    system "#{venv}/bin/pip", "install", "--upgrade", "pip"
    system "#{venv}/bin/pip", "install", "-r", "requirements.txt"

    bin.install "start_app.sh" => "yt-downloader"
    bin.install "stop_app.sh" => "yt-downloader-stop"

    # Ensure the start script uses this virtualenv
    inreplace bin/"yt-downloader", /^exec "\$VENV_DIR\/bin\/python"/, "exec #{venv}/bin/python"
  end

  test do
    system "#{bin}/yt-downloader", "--help"
  end
end
class YtDownloader < Formula
  desc "Simple YouTube downloader with Flask web UI"
  homepage "https://github.com/RAULEZW/youtube-downloader"
  url "https://github.com/RAULEZW/youtube-downloader/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "3b5d3b3574753253283c0113e465359e3f4c7d524ba6c0b650d5c6a745236784"
  license "MIT"

  depends_on "python@3.11"
  depends_on "ffmpeg"

  def install
    venv = libexec/"venv"
    system "python3", "-m", "venv", venv
    system venv/"bin/pip", "install", "--upgrade", "pip"
    system venv/"bin/pip", "install", "-r", buildpath/"requirements.txt"

    bin.install "start_app.sh" => "yt-downloader"
    bin.install "stop_app.sh" => "yt-downloader-stop"
  end

  test do
    assert_predicate bin/"yt-downloader", :exist?, "yt-downloader script should exist"
    assert_predicate bin/"yt-downloader-stop", :exist?, "yt-downloader-stop script should exist"
  end
end
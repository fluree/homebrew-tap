class Fluree < Formula
  desc "Command-line interface for Fluree DB"
  homepage "https://flur.ee"
  version "4.0.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/fluree/db/releases/download/v4.0.2/fluree-db-cli-aarch64-apple-darwin.tar.xz"
    sha256 "a93536b3156009a26f3d5a10865fecad768fb26fe1b76e4573aaa84fa263ff62"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/db/releases/download/v4.0.2/fluree-db-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c927c0c9f27cb172e28d4fb2e8d136c69afbb4b5c9ca4db90495bc612a79f421"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fluree/db/releases/download/v4.0.2/fluree-db-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "adb5d43ca58eecca485b4c3b9431d9494d20991b53defc7580a6bc6491da3e4c"
    end
  end
  license "BUSL-1.1"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "fluree" if OS.mac? && Hardware::CPU.arm?
    bin.install "fluree" if OS.linux? && Hardware::CPU.arm?
    bin.install "fluree" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

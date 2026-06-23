class Fluree < Formula
  desc "Command-line interface for Fluree DB"
  homepage "https://flur.ee"
  version "4.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/fluree/db/releases/download/v4.1.0/fluree-db-cli-aarch64-apple-darwin.tar.xz"
    sha256 "cb5fedaf526d65815c2d5e6a97a36ffc15e1de8f08831c2426ae707dba48969d"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/db/releases/download/v4.1.0/fluree-db-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eec7685e5341a0b4ffb8bdb3b673796b3678705f156900d911d81395e2bc7272"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fluree/db/releases/download/v4.1.0/fluree-db-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "af708724929508583cb32037aa28ef026ecf906a5b8d53323dc6b9b38427319b"
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

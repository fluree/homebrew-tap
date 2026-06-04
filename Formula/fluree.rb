class Fluree < Formula
  desc "Command-line interface for Fluree DB"
  homepage "https://flur.ee"
  version "4.0.5"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/fluree/db/releases/download/v4.0.5/fluree-db-cli-aarch64-apple-darwin.tar.xz"
    sha256 "7d03b4714b1eba5dc4df139331d084308fe5e348763e48f2bb82d076b4b18911"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/db/releases/download/v4.0.5/fluree-db-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1666b412da92c859d03236389f5fc3df66db340c25147689bb2339267f97902b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fluree/db/releases/download/v4.0.5/fluree-db-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bdfcb0f96ac2c1975ba4b8ec22078daa4ed2d2ac160bfdaf5bc47d2d6c59bc5a"
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

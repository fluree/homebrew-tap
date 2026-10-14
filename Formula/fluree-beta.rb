class FlureeBeta < Formula
  desc "Command-line interface for Fluree DB (including pre-releases)"
  homepage "https://flur.ee"
  version "5.0.0-alpha.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/fluree/db/releases/download/v5.0.0-alpha.1/fluree-db-cli-aarch64-apple-darwin.tar.xz"
    sha256 "acd3b747176848048a62025310c515d5c096f1a45615e56c8d1c21084c9ecb5a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/db/releases/download/v5.0.0-alpha.1/fluree-db-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "56edcb69670287818cde9aec60d565436c45bf362b86e8cb449e4beb7211a0fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fluree/db/releases/download/v5.0.0-alpha.1/fluree-db-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6359e780bf11876242ea85c449833f934514210795a3abb75fb3fa37bd0bdff2"
    end
  end
  license "BUSL-1.1"
  keg_only "it installs the same commands as the stable formula"

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "fluree"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "fluree"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "fluree"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

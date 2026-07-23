class Fluree < Formula
  desc "Command-line interface for Fluree DB"
  homepage "https://flur.ee"
  version "4.1.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/fluree/db/releases/download/v4.1.4/fluree-db-cli-aarch64-apple-darwin.tar.xz"
    sha256 "45367dc19d277778ba0c0c4e486615646ba850bd474ddbc8e37954afad97079a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/db/releases/download/v4.1.4/fluree-db-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4f6b60e459c87ef0c64e949b1f7ccb7279e3cf2a116b322003e3d8a0f8107684"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fluree/db/releases/download/v4.1.4/fluree-db-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e44d8d2977489beeccfb1f9b0e8576539c061bdff6375fba9c11844b7310601f"
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

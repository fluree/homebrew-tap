class Fluree < Formula
  desc "Command-line interface for Fluree DB"
  homepage "https://flur.ee"
  version "4.0.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/fluree/db/releases/download/v4.0.1/fluree-db-cli-aarch64-apple-darwin.tar.xz"
    sha256 "9c4f8b0d799214396221cf31ff68f4143adbfd9021c8f045a9e019d9873b79ce"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/db/releases/download/v4.0.1/fluree-db-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e1b32f4e48fad1adc9ada854b5c3b962111f7b36f0e67fa0c4a4d5d3e24d9287"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fluree/db/releases/download/v4.0.1/fluree-db-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "de486e452443270f15eeb58f037e2f776ba66731d99c0e790c25e66c3abafb88"
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

class Fluree < Formula
  desc "Command-line interface for Fluree DB"
  homepage "https://flur.ee"
  version "4.2.9"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/fluree/db/releases/download/v4.2.9/fluree-db-cli-aarch64-apple-darwin.tar.xz"
    sha256 "76e72d5264485e9b64da7df4238a28204334a2c295fd8edd204ab7e91204cf51"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/db/releases/download/v4.2.9/fluree-db-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cdb5c44bb522c42b9bb4185342276f6bcc64b8302a0604d565fc561432e6658f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fluree/db/releases/download/v4.2.9/fluree-db-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d26e0f69ec27282ed0172d34d6c540334bf95e5f07f3c011924915cdddd22d38"
    end
  end
  license "BUSL-1.1"

  on_macos do
    depends_on macos: :sonoma
  end

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

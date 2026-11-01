class Fluree < Formula
  desc "Command-line interface for Fluree DB"
  homepage "https://flur.ee"
  version "4.2.5"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/fluree/db/releases/download/v4.2.5/fluree-db-cli-aarch64-apple-darwin.tar.xz"
    sha256 "b6959a2e766423cf6974313a8b3315c19a9459b83cf909b978b6a29d71ac2b63"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/db/releases/download/v4.2.5/fluree-db-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0458bccba2cafb145f10015203529b002c07038d0ec3474c9064e63ffe0020c8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fluree/db/releases/download/v4.2.5/fluree-db-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a2b509b05a77949ca61cfc4d2fb70ff82609f8910f3e8cada28574503bf1b699"
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

class Fluree < Formula
  desc "Command-line interface for Fluree DB"
  homepage "https://flur.ee"
  version "4.2.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/fluree/db/releases/download/v4.2.3/fluree-db-cli-aarch64-apple-darwin.tar.xz"
    sha256 "16824314fa81ef6adb3c12c208900c43210b0c8df242b5b3a04890b586d8a812"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/db/releases/download/v4.2.3/fluree-db-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4a6f16ff7f64eeabb2b0df2dc98eedf04317eb0e6892f1501cb1fc42012419c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fluree/db/releases/download/v4.2.3/fluree-db-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a6e1ed6200a59aedd2533e9d73cf4fdce6d1b7d59c8cc5ffec60b8697b9ea4d9"
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

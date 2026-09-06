class Fluree < Formula
  desc "Command-line interface for Fluree DB"
  homepage "https://flur.ee"
  version "4.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/fluree/db/releases/download/v4.2.0/fluree-db-cli-aarch64-apple-darwin.tar.xz"
    sha256 "b330a032162787eb70c1997df92be3797b7955b9afe4aa9e9e0466fb332f3d84"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/db/releases/download/v4.2.0/fluree-db-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "efe4ea071a269bb16509ef0a6d3fd4348ab5b0381d94fefc80460b20536de526"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fluree/db/releases/download/v4.2.0/fluree-db-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a6efbfa34c2d355db4db662c61cfa1d75a74d98ce71e4fa66fa06c3c506b2ba1"
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

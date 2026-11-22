class FlureeBeta < Formula
  desc "Command-line interface for Fluree DB (including pre-releases)"
  homepage "https://flur.ee"
  version "5.0.0-alpha.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/fluree/db/releases/download/v5.0.0-alpha.4/fluree-db-cli-aarch64-apple-darwin.tar.xz"
    sha256 "2a22f441177a6d7e9d60ee8427127fa5c120081054de9bb048394e15ba2d9623"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/db/releases/download/v5.0.0-alpha.4/fluree-db-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3c4c9e2956138d71544e5427d02beb542d03b95cf9692b70ea8ab61b91d40228"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fluree/db/releases/download/v5.0.0-alpha.4/fluree-db-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b88f782e992c321a1bf5e6aaccedaa65274b9df1a91a1ed61f218189380be155"
    end
  end
  license "BUSL-1.1"
  keg_only "it installs the same commands as the stable formula"

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

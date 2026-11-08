class FlureeBeta < Formula
  desc "Command-line interface for Fluree DB (including pre-releases)"
  homepage "https://flur.ee"
  version "5.0.0-alpha.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/fluree/db/releases/download/v5.0.0-alpha.2/fluree-db-cli-aarch64-apple-darwin.tar.xz"
    sha256 "665051298b0d654045c9d0dd6f89aa05886ba9b684f9cea56c059c79f1483291"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/db/releases/download/v5.0.0-alpha.2/fluree-db-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "19674bb723d0bd3b8f1b7503d4f9ddfb93f53b81b04731a5c6f110116cef4ae3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fluree/db/releases/download/v5.0.0-alpha.2/fluree-db-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6534cdff837ab09fd734daf9175e4929b5ab2a3a28e9282046a7b582c204a620"
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

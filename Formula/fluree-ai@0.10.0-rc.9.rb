class FlureeAiAT0100Rc9 < Formula
  keg_only :versioned_formula
  desc "Fluree AI standalone platform"
  homepage "https://flur.ee"
  version "0.10.0-rc.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/fluree-ai-releases/releases/download/v0.10.0-rc.9/fluree-ai-aarch64-apple-darwin.tar.gz"
      sha256 "4927c1db4815d4cc8c587555c099b6b40976f2ef5b44f7a46461d7b1ba9f9322"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/fluree-ai-releases/releases/download/v0.10.0-rc.9/fluree-ai-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dbbf13e551be6586f663c878784c6043fd7ed9249ca79e7eda89f1072bc2a55f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fluree/fluree-ai-releases/releases/download/v0.10.0-rc.9/fluree-ai-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a03dbfc9ae6c72c3e1dd74032554596a37f22c7007cff3d4610fed4b8665ba74"
    end
  end
  license "LicenseRef-Proprietary"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
      bin.install "fluree-ai"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "fluree-ai"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "fluree-ai"
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

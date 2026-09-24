class FlureeAiAT0100Rc3 < Formula
  keg_only :versioned_formula
  desc "Fluree AI standalone platform"
  homepage "https://flur.ee"
  version "0.10.0-rc.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/fluree-ai-releases/releases/download/v0.10.0-rc.3/fluree-ai-aarch64-apple-darwin.tar.gz"
      sha256 "44f8a39c3ae81949235df339237dfce07902acd7da672bcf3f6e240a4f205a6c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/fluree-ai-releases/releases/download/v0.10.0-rc.3/fluree-ai-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d5cedfb586c46ec6c159bd593677700b33a0ae2544573f073b443b7aa868a6bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fluree/fluree-ai-releases/releases/download/v0.10.0-rc.3/fluree-ai-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "db09750a336018b787931bc873a94ba37b015d26aa64055e0b7fd98a7daa0764"
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

class FlureeAiAT0100Rc8 < Formula
  keg_only :versioned_formula
  desc "Fluree AI standalone platform"
  homepage "https://flur.ee"
  version "0.10.0-rc.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/fluree-ai-releases/releases/download/v0.10.0-rc.8/fluree-ai-aarch64-apple-darwin.tar.gz"
      sha256 "36fa17f752352e2be8a0397377a6bac4b0853e8f5ef49a54eae8a7fa2c439ef9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/fluree-ai-releases/releases/download/v0.10.0-rc.8/fluree-ai-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f0c0d9376b2bce1ce90374fa6e55aba8689cfa03a6ff66af9090c1572c540aaf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fluree/fluree-ai-releases/releases/download/v0.10.0-rc.8/fluree-ai-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8173ff9dfd8be4e688804a9c3fecab1130c957edd2871d07038a4d58fde3a024"
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

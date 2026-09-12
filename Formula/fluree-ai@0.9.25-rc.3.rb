class FlureeAiAT0925Rc3 < Formula
  keg_only :versioned_formula
  desc "Fluree AI standalone platform"
  homepage "https://flur.ee"
  version "0.9.25-rc.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/fluree-ai-releases/releases/download/v0.9.25-rc.3/fluree-ai-aarch64-apple-darwin.tar.gz"
      sha256 "6d3ddb88afd7cccde95d62847a79e00191a21fdf42ccd739de3ae3a371d00267"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/fluree-ai-releases/releases/download/v0.9.25-rc.3/fluree-ai-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "62b6803a9401ff49c775bf07bf2114102c20ea0dd5c8e71d456f069ae0342b89"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fluree/fluree-ai-releases/releases/download/v0.9.25-rc.3/fluree-ai-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "627bd47c4feeda0bcd1d1bea0fdd17c13fd0dd95925b7982800175afb93670e7"
    end
  end
  license "LicenseRef-Proprietary"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
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

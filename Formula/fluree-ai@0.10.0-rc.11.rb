class FlureeAiAT0100Rc11 < Formula
  keg_only :versioned_formula
  desc "Fluree AI standalone platform"
  homepage "https://flur.ee"
  version "0.10.0-rc.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/fluree-ai-releases/releases/download/v0.10.0-rc.11/fluree-ai-aarch64-apple-darwin.tar.gz"
      sha256 "f3dbff5317cc4b60126123e6fb9479dd08f57e4653d5fcac7ba0688ec43fc6ed"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fluree/fluree-ai-releases/releases/download/v0.10.0-rc.11/fluree-ai-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b603d2ed34225154da203699647f3f5358c9c1830d183491623f0f8a1f38f1fa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fluree/fluree-ai-releases/releases/download/v0.10.0-rc.11/fluree-ai-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "310de37094d5ae37112a2fcf1e2f36b65e2bf814a0f0d15964e0f93e1818dddd"
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

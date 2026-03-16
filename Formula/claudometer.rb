class Claudometer < Formula
  desc "macOS menu bar app that monitors Claude Pro/Max session and weekly usage"
  homepage "https://github.com/sebasrodriguez/claudometer"
  url "https://github.com/sebasrodriguez/claudometer.git", tag: "v0.1.0"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on :macos => :sonoma

  def install
    cd "ClaudeUsageBar" do
      system "swift", "build", "-c", "release", "--disable-sandbox"

      # Find and install the built binary
      binary = Pathname.glob(".build/**/release/ClaudeUsageBar").first
      binary ||= Pathname.new(".build/release/ClaudeUsageBar")
      bin.install binary => "claudometer"
    end

    # Create .app bundle with symlink to the binary
    app_contents = prefix/"Claudometer.app/Contents"
    (app_contents/"MacOS").mkpath
    ln_sf bin/"claudometer", app_contents/"MacOS/ClaudeUsageBar"
    (app_contents/"Info.plist").write info_plist
  end

  def info_plist
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleExecutable</key>
        <string>ClaudeUsageBar</string>
        <key>CFBundleIdentifier</key>
        <string>com.github.claudometer</string>
        <key>CFBundleName</key>
        <string>Claudometer</string>
        <key>CFBundleVersion</key>
        <string>#{version}</string>
        <key>CFBundleShortVersionString</key>
        <string>#{version}</string>
        <key>LSUIElement</key>
        <true/>
        <key>LSMinimumSystemVersion</key>
        <string>14.0</string>
      </dict>
      </plist>
    XML
  end

  def post_install
    ohai "To launch Claudometer:"
    ohai "  open #{prefix}/Claudometer.app"
    ohai ""
    ohai "To add to Applications:"
    ohai "  ln -sf #{prefix}/Claudometer.app /Applications/Claudometer.app"
  end

  test do
    assert_predicate bin/"claudometer", :exist?
  end
end

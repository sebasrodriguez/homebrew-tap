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
      bin.install ".build/release/ClaudeUsageBar" => "claudometer"
    end

    # Create .app bundle
    app_bundle = prefix/"Claudometer.app/Contents"
    (app_bundle/"MacOS").mkpath
    (app_bundle/"MacOS").install bin/"claudometer" => "ClaudeUsageBar"
    (app_bundle/"Info.plist").write info_plist
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
    # Link the .app bundle to /Applications if the user wants
    ohai "Claudometer.app has been built at:"
    ohai "  #{prefix}/Claudometer.app"
    ohai ""
    ohai "To add to Applications:"
    ohai "  ln -sf #{prefix}/Claudometer.app /Applications/Claudometer.app"
    ohai ""
    ohai "To launch:"
    ohai "  open #{prefix}/Claudometer.app"
  end

  test do
    assert_predicate prefix/"Claudometer.app/Contents/MacOS/ClaudeUsageBar", :exist?
  end
end

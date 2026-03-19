class Tokentap < Formula
  desc "Multi-provider macOS menu bar app that monitors AI session usage (Claude, Codex)"
  homepage "https://github.com/sebasrodriguez/tokentap"
  url "https://github.com/sebasrodriguez/tokentap.git", tag: "v0.2.0"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on :macos => :sonoma

  def install
    cd "TokenTap" do
      system "swift", "build", "-c", "release",
             "--disable-sandbox",
             "--scratch-path", buildpath/"build"
    end

    bin.install buildpath/"build/release/TokenTap" => "tokentap"

    # Create .app bundle
    app_contents = prefix/"TokenTap.app/Contents"
    (app_contents/"MacOS").mkpath
    ln_sf bin/"tokentap", app_contents/"MacOS/TokenTap"
    (app_contents/"Info.plist").write info_plist
  end

  def info_plist
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleExecutable</key>
        <string>TokenTap</string>
        <key>CFBundleIdentifier</key>
        <string>com.github.tokentap</string>
        <key>CFBundleName</key>
        <string>TokenTap</string>
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
    ohai "To launch TokenTap:"
    ohai "  open #{prefix}/TokenTap.app"
    ohai ""
    ohai "To add to Applications:"
    ohai "  ln -sf #{prefix}/TokenTap.app /Applications/TokenTap.app"
  end

  test do
    assert_predicate bin/"tokentap", :exist?
  end
end

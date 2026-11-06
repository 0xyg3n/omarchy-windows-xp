Windows XP theme for Omarchy

Includes the Omarchy theme and generated application color configs, Bliss
wallpaper, Luna application theme, complete Windows XP icon pack, Chicago95
cursors, four XP shell plugins, GTK settings, and the theme-switch hook.
Terminal colors are black (#000000) with silver text (#C0C0C0), like CMD.

Manual installation on a compatible Omarchy installation:
1. Back up any destination files that already exist.
2. Copy the CONTENTS of home/ into your home directory, merging directories.
   The icon/cursor/theme directories contain actual files, not local symlinks.
3. Run: chmod +x ~/.config/omarchy/hooks/theme-set.d/xp-chrome.sh
4. Run: omarchy theme set windows-xp
   The hook configures the XP bar, fonts, GTK icons and cursors.
   shell-config.example.json contains only the XP bar settings for reference;
   merge its bar object if needed rather than replacing personal shell settings.
5. To keep CMD colors regardless of theme, append the matching file in
   terminal-overrides/ to the relevant terminal configuration (merge existing
   color sections rather than adding duplicate sections). Then run:
   omarchy restart terminal
   Foot loads configuration in new windows.

Requires Omarchy's Lua Hyprland config and Quickshell plugin interfaces used
by this theme, and Liberation Sans / your preferred monospace font. GTK 2
applications may require the Murrine theme engine. Application launchers use
the installed defaults; optional menu applications must be installed separately.
No fonts or unrelated application data are bundled.

Export changes: removed local author/username values; made the hook's runtime
UID dynamic; exported only theme-related shell configuration; removed image
text/EXIF metadata; materialized internal icon links; omitted Git history,
caches, backups, accounts, credentials, logs, and unrelated personal settings.
Public upstream credits and supplied licenses are retained in licenses/ and
the asset directories. No new license is granted for third-party artwork.
SHA256SUMS lists every payload file for integrity checking.

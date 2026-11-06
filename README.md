# Windows XP for Omarchy

A complete Windows XP Luna desktop theme bundle for Omarchy: Bliss wallpaper,
XP Start menu and taskbar, desktop icons, Luna application styling, a full icon
pack, classic cursors, and a black Command Prompt style terminal palette.

![Bliss wallpaper](home/.config/omarchy/themes/windows-xp/preview.png)

## Included

- Omarchy theme and application color configurations.
- Four Quickshell plugins: Start menu, Quick Launch, task buttons, and notification area.
- Windows XP icon pack, Chicago95 cursors, and Windows XP Luna application theme.
- GTK 3/4 appearance settings and a theme-switch hook.
- Terminal colors: pure black background, silver text, and the classic CMD palette.
- Setup instructions, upstream credits/licenses, and SHA-256 checksums.

## Installation

Requires an Omarchy version using Lua Hyprland configuration and the Quickshell
plugin interfaces used by this theme. Fonts are not bundled; install Liberation
Sans and a suitable monospace font. GTK 2 applications may need Murrine.
Optional menu applications must be installed separately.

This repository is a complete desktop bundle. Install it manually using the
steps below; its layout is not intended for `omarchy theme install`.

Back up existing files in the corresponding theme, plugin, cursor, icon, and GTK
configuration locations before copying. The GTK files replace appearance
settings, and the theme hook changes the bar layout when switching themes.

```sh
git clone https://github.com/0xyg3n/omarchy-windows-xp.git
cd omarchy-windows-xp
cp -a home/. "$HOME/"
chmod +x "$HOME/.config/omarchy/hooks/theme-set.d/xp-chrome.sh"
omarchy theme set windows-xp
```

The hook sets the XP bar, fonts, icons, cursors, and dark terminal colors.
`shell-config.example.json` contains just the XP bar layout for reference;
merge its `bar` object if needed instead of replacing personal shell settings.

### CMD terminal colors

The theme includes a black background (`#000000`), silver text (`#C0C0C0`), and
the classic 16-color CMD palette for Foot, Alacritty, Kitty, and Ghostty.

To keep those colors across other desktop themes, merge the matching file from
`terminal-overrides/` into your terminal configuration. Avoid duplicate TOML/INI
sections. Then run:

```sh
omarchy restart terminal
```

Foot reads its configuration in new windows. Already-open Foot sessions retain
their in-memory colors; start a new window after installing the theme.

## Downloads and integrity

The complete ZIP is available on the [releases page](https://github.com/0xyg3n/omarchy-windows-xp/releases).
The ZIP and Git source contain the same theme assets. `SHA256SUMS` covers the
exported bundle files; repository documentation is added separately.

```sh
sha256sum -c SHA256SUMS
```

## Privacy

This repository was built from the sanitized theme export, with a new Git
history. It excludes unrelated configuration, credentials, account data, browser
profiles, shell history, caches, backups, logs, and original Git history. Local
usernames and author fields were removed from the custom plugins. Image
text/EXIF metadata was removed and internal asset links were materialized.

See [PRIVACY-CHECK.txt](PRIVACY-CHECK.txt) for the checks and their limits.
Commits use a GitHub no-reply email address.

## Credits and licensing

- [Windows XP icon pack](https://github.com/B00merang-Artwork/Windows-XP).
- [Windows XP Luna application theme](https://github.com/B00merang-Project/Windows-XP).
- [Chicago95 cursors](https://github.com/grassmunk/Chicago95).
- Bliss wallpaper by Charles O'Rear; Windows artwork and marks belong to their respective owners.

Supplied upstream license and credit files are retained under `licenses/` and
within the asset directories. This bundle does not grant a new blanket license
for third-party artwork. See [README.txt](README.txt) for the export notes.

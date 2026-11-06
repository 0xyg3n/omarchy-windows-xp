#!/bin/bash
# Apply / revert Windows XP chrome after omarchy-theme-set.
theme="${1:-}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=/run/user/$(id -u)/bus}"
export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
HIS=$(ls -1t "$XDG_RUNTIME_DIR/hypr" 2>/dev/null | head -1)
export HYPRLAND_INSTANCE_SIGNATURE="${HYPRLAND_INSTANCE_SIGNATURE:-$HIS}"

restore_default_bar() {
  python3 - << 'PY'
import json
from pathlib import Path
user = Path.home() / ".config/omarchy/shell.json"
stock = Path("/usr/share/omarchy/config/omarchy/shell.json")
d = json.loads(user.read_text()) if user.exists() else {"version": 1}
default_bar = json.loads(stock.read_text()).get("bar", {})
d["bar"] = default_bar
user.parent.mkdir(parents=True, exist_ok=True)
user.write_text(json.dumps(d, indent=2) + "\n")
print("restored default bar")
PY
}

disable_xp_plugins() {
  for id in xp.start xp.launch xp.tasks xp.notify; do
    omarchy plugin disable "$id" >/dev/null 2>&1 || true
  done
}

enable_xp_plugins() {
  omarchy plugin enable xp.start >/dev/null 2>&1 || true
  omarchy plugin enable xp.launch --section left --index 1 >/dev/null 2>&1 || true
  omarchy plugin enable xp.tasks --section left --index 2 >/dev/null 2>&1 || true
  omarchy plugin enable xp.notify --section right --index 0 >/dev/null 2>&1 || true
}

if [[ "$theme" == "windows-xp" ]]; then
  gsettings set org.gnome.desktop.interface gtk-theme "Windows XP Luna" || true
  gsettings set org.gnome.desktop.interface icon-theme "Windows XP" || true
  gsettings set org.gnome.desktop.interface cursor-theme "Chicago95_Standard_Cursors" || true
  gsettings set org.gnome.desktop.interface font-name "Liberation Sans 9" || true
  gsettings set org.gnome.desktop.interface document-font-name "Liberation Sans 9" || true
  gsettings set org.gnome.desktop.interface color-scheme "prefer-light" || true
  gsettings set org.gnome.desktop.wm.preferences titlebar-font "Liberation Sans Bold 9" || true
  hyprctl setcursor Chicago95_Standard_Cursors 24 >/dev/null || true
  python3 - << 'PY'
import json
from pathlib import Path
p = Path.home() / ".config/omarchy/shell.json"
d = json.loads(p.read_text()) if p.exists() else {"version": 1}
d.setdefault("bar", {})
d["bar"]["position"] = "bottom"
d["bar"]["transparent"] = True
d["bar"]["layout"] = {
  "left": [{"id": "xp.start"}, {"id": "xp.launch"}, {"id": "xp.tasks"}],
  "center": [],
  "right": [{"id": "xp.notify"}],
}
p.write_text(json.dumps(d, indent=2) + "\n")
PY
  enable_xp_plugins
  mkdir -p "$HOME/Desktop" "$HOME/Documents"
  if [[ -f $HOME/.config/user-dirs.dirs ]]; then
    sed -i 's|^XDG_DESKTOP_DIR=.*|XDG_DESKTOP_DIR="$HOME/Desktop"|' "$HOME/.config/user-dirs.dirs"
  fi
  TERM_SRC="$HOME/.config/omarchy/themes/windows-xp/term-dark"
  TERM_DST="$HOME/.local/state/omarchy/current/theme"
  if [[ -d $TERM_SRC && -d $TERM_DST ]]; then
    cp -f "$TERM_SRC/foot.ini" "$TERM_DST/foot.ini"
    cp -f "$TERM_SRC/alacritty.toml" "$TERM_DST/alacritty.toml"
    cp -f "$TERM_SRC/kitty.conf" "$TERM_DST/kitty.conf"
    cp -f "$TERM_SRC/ghostty.conf" "$TERM_DST/ghostty.conf"
  fi
else
  restore_default_bar
  disable_xp_plugins
  gsettings reset org.gnome.desktop.interface cursor-theme >/dev/null 2>&1 || true
  gsettings reset org.gnome.desktop.interface font-name >/dev/null 2>&1 || true
  gsettings reset org.gnome.desktop.interface document-font-name >/dev/null 2>&1 || true
  gsettings reset org.gnome.desktop.wm.preferences titlebar-font >/dev/null 2>&1 || true
  hyprctl setcursor Adwaita 24 >/dev/null 2>&1 || true
  # Re-apply the current theme's gnome bits in case we overwrote them on XP.
  omarchy-theme-set-gnome >/dev/null 2>&1 || true
fi

import Quickshell
import Quickshell.Io
import QtQuick

Item {
  id: root
  property string themeName: ""
  readonly property bool xp: themeName === "windows-xp"

  FileView {
    path: Quickshell.env("HOME") + "/.local/state/omarchy/current/theme.name"
    watchChanges: true
    printErrors: false
    onLoaded: root.themeName = String(text()).trim()
    onFileChanged: reload()
  }
}

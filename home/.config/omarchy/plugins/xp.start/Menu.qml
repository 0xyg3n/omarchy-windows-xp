import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import qs.Commons
import qs.Ui

Item {
  id: root

  property string omarchyPath: Quickshell.env("OMARCHY_PATH")
  property var shell: null
  property var manifest: null
  property bool opened: false
  property string targetScreen: ""
  property string userName: Quickshell.env("USER") || "User"
  property string home: Quickshell.env("HOME")
  readonly property int barH: Style.bar.sizeHorizontal
  readonly property int menuW: 402
  readonly property int menuH: 492
  ThemeGate { id: gate }

  function open(payloadJson) {
    var payload = ({})
    try { payload = JSON.parse(payloadJson || "{}") } catch (e) { payload = ({}) }
    if (payload.screen)
      root.targetScreen = String(payload.screen)
    else if (Hyprland.focusedMonitor)
      root.targetScreen = String(Hyprland.focusedMonitor.name || "")
    else
      root.targetScreen = ""
    root.opened = true
  }

  function close() { root.opened = false }

  function dismiss() {
    root.opened = false
    if (root.shell && typeof root.shell.hide === "function")
      root.shell.hide((root.manifest && root.manifest.id) || "xp.start")
  }

  function toggle() {
    if (root.opened) root.dismiss()
    else root.open("{}")
  }

  function ping() { return "ok" }

  function launch(cmd) {
    root.dismiss()
    Util.execDetached(cmd)
  }

  function ic(name) { return Qt.resolvedUrl("icons/" + name) }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: panel
      required property var modelData
      screen: modelData
      visible: gate.xp && root.opened && (root.targetScreen === "" || String(modelData.name || "") === root.targetScreen)
      color: "transparent"
      anchors { top: true; bottom: true; left: true; right: true }
      WlrLayershell.namespace: "xp-start-menu"
      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
      exclusionMode: ExclusionMode.Ignore

      onVisibleChanged: if (visible) Qt.callLater(function() { keyCatcher.forceActiveFocus() })

      MouseArea {
        anchors.fill: parent
        onClicked: root.dismiss()
      }

      // Outer Luna frame
      Rectangle {
        id: frame
        width: root.menuW
        height: root.menuH
        x: 0
        y: parent.height - root.barH - height + 1
        radius: 0
        color: "#1951B0"

        Rectangle {
          anchors.fill: parent
          anchors.margins: 2
          color: "#ECE9D8"

          MouseArea { anchors.fill: parent; onClicked: {} }

          Item {
            id: keyCatcher
            anchors.fill: parent
            focus: true
            Keys.onEscapePressed: root.dismiss()
          }

          Column {
            anchors.fill: parent
            spacing: 0

            // Header
            Rectangle {
              width: parent.width
              height: 56
              gradient: Gradient {
                GradientStop { position: 0.0; color: "#2A6AD6" }
                GradientStop { position: 0.45; color: "#245EDC" }
                GradientStop { position: 1.0; color: "#1941A5" }
              }

              Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 8
                spacing: 10

                Rectangle {
                  width: 44
                  height: 44
                  radius: 3
                  // XP user tile uses a windows-colored frame
                  gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "#F25022" }
                    GradientStop { position: 0.33; color: "#7FBA00" }
                    GradientStop { position: 0.66; color: "#00A4EF" }
                    GradientStop { position: 1.0; color: "#FFB900" }
                  }
                  Rectangle {
                    anchors.fill: parent
                    anchors.margins: 3
                    color: "#FFFFFF"
                    Image {
                      anchors.fill: parent
                      source: root.ic("UserAccounts.png")
                      fillMode: Image.PreserveAspectFit
                      smooth: true
                    }
                  }
                }

                Text {
                  text: root.userName
                  color: "white"
                  font.family: "Liberation Sans"
                  font.pixelSize: 18
                  font.bold: true
                  anchors.verticalCenter: parent.verticalCenter
                  style: Text.Raised
                  styleColor: "#0A246A"
                }
              }
            }

            // Orange hairline under header, like Luna
            Rectangle { width: parent.width; height: 2; color: "#F6B93B" }

            Row {
              width: parent.width
              height: parent.height - 56 - 2 - 44

              Rectangle {
                width: 196
                height: parent.height
                color: "#FFFFFF"

                Column {
                  anchors.fill: parent
                  anchors.topMargin: 8
                  anchors.leftMargin: 6
                  anchors.rightMargin: 6
                  spacing: 1

                  StartRow {
                    label: "Internet"
                    sub: "Web Browser"
                    iconSrc: root.ic("InternetExplorer6.png")
                    onActivated: root.launch("omarchy-launch-browser")
                  }
                  StartRow {
                    label: "E-mail"
                    sub: "Default Mail"
                    iconSrc: root.ic("InternetShortcut.png")
                    onActivated: root.launch("xdg-open mailto:")
                  }

                  Item { width: 1; height: 6 }
                  Rectangle { width: parent.width; height: 1; color: "#D6D3CE" }
                  Rectangle { width: parent.width; height: 1; color: "#FFFFFF" }
                  Item { width: 1; height: 6 }

                  StartRow {
                    label: "Command Prompt"
                    iconSrc: root.ic("CommandPrompt.png")
                    onActivated: root.launch("omarchy-launch-terminal")
                  }
                  StartRow {
                    label: "My Files"
                    iconSrc: root.ic("FolderClosed.png")
                    onActivated: root.launch("omarchy-launch-nautilus")
                  }
                  StartRow {
                    label: "Cursor"
                    iconSrc: root.ic("Notepad.png")
                    onActivated: root.launch("uwsm-app -- cursor")
                  }
                  StartRow {
                    label: "Visual Studio Code"
                    iconSrc: root.ic("GenericDocument.png")
                    onActivated: root.launch("uwsm-app -- code")
                  }
                  StartRow {
                    label: "Herdr"
                    iconSrc: root.ic("CommandPrompt.png")
                    onActivated: root.launch("omarchy-launch-terminal-herdr")
                  }

                  Item { width: 1; height: 10 }

                  Rectangle { width: parent.width; height: 1; color: "#D6D3CE" }
                  StartRow {
                    label: "All Programs"
                    bold: true
                    iconSrc: root.ic("Programs.png")
                    trailing: "▸"
                    onActivated: { root.dismiss(); Util.execDetached("omarchy-menu toggle apps") }
                  }
                }
              }

              Rectangle { width: 1; height: parent.height; color: "#9BB3D3" }

              Rectangle {
                width: 201
                height: parent.height
                color: "#D3E5FA"

                Column {
                  anchors.fill: parent
                  anchors.margins: 8
                  spacing: 2

                  StartRow {
                    label: "My Documents"
                    pane: true
                    iconSrc: root.ic("MyDocuments.png")
                    onActivated: root.launch("xdg-open " + root.home)
                  }
                  StartRow {
                    label: "My Pictures"
                    pane: true
                    iconSrc: root.ic("WindowsPictureandFaxViewer.png")
                    onActivated: root.launch("xdg-open " + root.home + "/Pictures")
                  }
                  StartRow {
                    label: "My Computer"
                    pane: true
                    iconSrc: root.ic("MyComputer.png")
                    onActivated: root.launch("omarchy-launch-nautilus")
                  }

                  Item { width: 1; height: 4 }
                  Rectangle { width: parent.width; height: 1; color: "#9BB3D3" }
                  Item { width: 1; height: 4 }

                  StartRow {
                    label: "Control Panel"
                    pane: true
                    iconSrc: root.ic("ControlPanel.png")
                    onActivated: { root.dismiss(); Util.execDetached("omarchy-menu toggle setup") }
                  }
                  StartRow {
                    label: "Help and Support"
                    pane: true
                    iconSrc: root.ic("HelpandSupport.png")
                    onActivated: { root.dismiss(); Util.execDetached("omarchy-menu toggle") }
                  }
                  StartRow {
                    label: "Search"
                    pane: true
                    iconSrc: root.ic("Search.png")
                    onActivated: { root.dismiss(); Util.execDetached("omarchy-menu toggle apps") }
                  }
                  StartRow {
                    label: "Run..."
                    pane: true
                    iconSrc: root.ic("Run.png")
                    onActivated: { root.dismiss(); Util.execDetached("omarchy-menu toggle") }
                  }
                }
              }
            }

            Rectangle {
              width: parent.width
              height: 44
              gradient: Gradient {
                GradientStop { position: 0.0; color: "#2A6AD6" }
                GradientStop { position: 1.0; color: "#163E96" }
              }

              Row {
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                spacing: 18

                StartFooterBtn {
                  label: "Log Off"
                  iconSrc: root.ic("Logout.png")
                  onActivated: root.launch("omarchy-system-logout")
                }
                StartFooterBtn {
                  label: "Turn Off Computer"
                  iconSrc: root.ic("Shutdown.png")
                  onActivated: root.launch("omarchy-system-shutdown")
                }
              }
            }
          }
        }
      }
    }
  }

  component StartRow: Item {
    id: row
    property string label: ""
    property string sub: ""
    property string iconSrc: ""
    property string trailing: ""
    property bool pane: false
    property bool bold: false
    signal activated()
    width: parent.width
    height: sub !== "" ? 42 : 34

    Rectangle {
      anchors.fill: parent
      color: ma.containsMouse ? "#316AC5" : "transparent"
      radius: 0
    }

    Image {
      id: ico
      visible: row.iconSrc !== ""
      source: row.iconSrc
      width: 32
      height: 32
      x: 4
      anchors.verticalCenter: parent.verticalCenter
      fillMode: Image.PreserveAspectFit
      smooth: true
    }

    Column {
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: ico.visible ? ico.right : parent.left
      anchors.leftMargin: 8
      anchors.right: trail.left
      Text {
        text: row.label
        color: ma.containsMouse ? "#FFFFFF" : (row.pane ? "#003399" : "#000000")
        font.family: "Liberation Sans"
        font.pixelSize: row.pane ? 13 : 12
        font.bold: row.bold || row.pane
        elide: Text.ElideRight
        width: parent.width
      }
      Text {
        visible: row.sub !== ""
        text: row.sub
        color: ma.containsMouse ? "#FFFFFF" : "#6D6D6D"
        font.family: "Liberation Sans"
        font.pixelSize: 10
      }
    }

    Text {
      id: trail
      text: row.trailing
      visible: row.trailing !== ""
      color: ma.containsMouse ? "#FFFFFF" : "#000000"
      font.pixelSize: 14
      anchors.verticalCenter: parent.verticalCenter
      anchors.right: parent.right
      anchors.rightMargin: 8
    }

    MouseArea {
      id: ma
      anchors.fill: parent
      hoverEnabled: true
      onClicked: row.activated()
    }
  }

  component StartFooterBtn: Item {
    id: fbtn
    property string label: ""
    property string iconSrc: ""
    signal activated()
    width: inner.implicitWidth + 10
    height: 34
    opacity: ma.containsMouse ? 0.88 : 1

    Row {
      id: inner
      anchors.centerIn: parent
      spacing: 6
      Image {
        source: fbtn.iconSrc
        width: 24
        height: 24
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
      }
      Text {
        text: fbtn.label
        color: "white"
        font.family: "Liberation Sans"
        font.pixelSize: 12
        font.bold: true
        anchors.verticalCenter: parent.verticalCenter
        style: Text.Raised
        styleColor: "#0A246A"
      }
    }
    MouseArea {
      id: ma
      anchors.fill: parent
      hoverEnabled: true
      onClicked: fbtn.activated()
    }
  }
}

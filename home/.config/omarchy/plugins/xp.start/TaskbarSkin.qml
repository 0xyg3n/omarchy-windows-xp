import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.Commons

Item {
  id: root
  property var shell: null
  property var manifest: null
  property string omarchyPath: Quickshell.env("OMARCHY_PATH")
  readonly property int barH: Style.bar.sizeHorizontal

  ThemeGate { id: gate }

  Variants {
    model: Quickshell.screens
    PanelWindow {
      required property var modelData
      screen: modelData
      visible: gate.xp
      color: "transparent"
      implicitHeight: root.barH
      anchors.bottom: true
      anchors.left: true
      anchors.right: true
      WlrLayershell.namespace: "xp-taskbar-skin"
      WlrLayershell.layer: WlrLayer.Bottom
      exclusionMode: ExclusionMode.Ignore

      Image {
        anchors.fill: parent
        source: Qt.resolvedUrl("taskbar.png")
        fillMode: Image.TileHorizontally
        smooth: false
        cache: true
      }
    }
  }

  DesktopIcons {}
}

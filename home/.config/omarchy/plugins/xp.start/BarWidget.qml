import QtQuick
import qs.Ui

BarWidget {
  id: root
  moduleName: "xp.start"
  ThemeGate { id: gate }

  // Native Luna start BMP is 99x33. Bar left section is inset Style.space(8);
  // extend that far left so the green orb sits flush on the screen edge.
  readonly property int btnH: root.barSize
  readonly property int edgePad: 8
  readonly property int btnW: Math.round(99 * btnH / 33)

  visible: gate.xp
  implicitWidth: gate.xp ? btnW : 0
  implicitHeight: gate.xp ? btnH : 0

  function hostScreenName() {
    var p = root.parent
    while (p) {
      if (p.screen && p.screen.name)
        return String(p.screen.name)
      p = p.parent
    }
    return ""
  }

  Item {
    id: startBtn
    // Row assigns x; pull the painted orb into the 8px section margin.
    x: -root.edgePad
    y: 0
    width: parent.width + root.edgePad
    height: parent.height

    Image {
      anchors.fill: parent
      source: mouse.containsPress ? Qt.resolvedUrl("start-pressed.png")
            : (mouse.containsMouse ? Qt.resolvedUrl("start-hover.png")
                                   : Qt.resolvedUrl("start-normal.png"))
      fillMode: Image.Stretch
      smooth: false
      cache: true
    }

    Row {
      anchors.verticalCenter: parent.verticalCenter
      anchors.verticalCenterOffset: mouse.containsPress ? 1 : 0
      anchors.left: parent.left
      anchors.leftMargin: 10
      spacing: 5

      Image {
        source: Qt.resolvedUrl("winlogo.png")
        width: 20
        height: 16
        fillMode: Image.PreserveAspectFit
        smooth: false
        anchors.verticalCenter: parent.verticalCenter
      }

      Text {
        text: "start"
        color: "white"
        font.family: "Liberation Sans"
        font.pixelSize: 13
        font.bold: true
        font.italic: true
        style: Text.Raised
        styleColor: "#145214"
        anchors.verticalCenter: parent.verticalCenter
      }
    }

    MouseArea {
      id: mouse
      anchors.fill: parent
      hoverEnabled: true
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      onClicked: function(ev) {
        if (!root.bar) return
        if (ev.button === Qt.RightButton) {
          root.bar.run("xdg-terminal-exec")
          return
        }
        var screen = root.hostScreenName()
        root.bar.run("omarchy-shell shell toggle xp.start '" + JSON.stringify({ screen: screen }) + "'")
      }
    }
  }
}

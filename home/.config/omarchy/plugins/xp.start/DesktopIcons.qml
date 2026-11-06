import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.Commons

Item {
  id: root

  ListModel {
    id: iconModel
    ListElement { key: "docs"; label: "My Documents"; icon: "desk-docs.png"; cmd: "xdg-open \"$HOME/Documents\"" }
    ListElement { key: "pc"; label: "My Computer"; icon: "desk-computer.png"; cmd: "nautilus computer:///" }
    ListElement { key: "net"; label: "My Network Places"; icon: "desk-network.png"; cmd: "nautilus network:///" }
    ListElement { key: "bin"; label: "Recycle Bin"; icon: "desk-recycle.png"; cmd: "nautilus trash:///" }
    ListElement { key: "ie"; label: "Internet Explorer"; icon: "desk-ie.png"; cmd: "omarchy-launch-browser" }
  }

  property string selected: ""
  ThemeGate { id: gate }

  function launch(cmd) {
    Util.execDetached(cmd)
  }

  Variants {
    model: Quickshell.screens
    PanelWindow {
      required property var modelData
      screen: modelData
      visible: gate.xp
      color: "transparent"
      anchors { top: true; left: true; right: true; bottom: true }
      margins.bottom: Style.bar.sizeHorizontal
      WlrLayershell.namespace: "xp-desktop-icons"
      WlrLayershell.layer: WlrLayer.Background
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
      exclusionMode: ExclusionMode.Ignore

      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: root.selected = ""
      }

      Column {
        x: 18
        y: 14
        spacing: 10

        Repeater {
          model: iconModel

          Item {
            id: cell
            required property string key
            required property string label
            required property string icon
            required property string cmd
            readonly property bool chosen: root.selected === key

            width: 78
            height: 86

            Rectangle {
              id: iconHi
              anchors.top: parent.top
              anchors.horizontalCenter: parent.horizontalCenter
              width: 36
              height: 36
              color: cell.chosen ? "#80245EDC" : "transparent"
              radius: 0
            }

            Image {
              anchors.centerIn: iconHi
              width: 32
              height: 32
              source: Qt.resolvedUrl("icons/" + cell.icon)
              fillMode: Image.PreserveAspectFit
              smooth: false
              cache: true
              asynchronous: true
            }

            Rectangle {
              id: labelHi
              anchors.top: iconHi.bottom
              anchors.topMargin: 3
              anchors.horizontalCenter: parent.horizontalCenter
              width: labelText.implicitWidth + 6
              height: labelText.implicitHeight + 2
              color: cell.chosen ? "#0A246A" : "transparent"
            }

            Text {
              id: labelText
              anchors.centerIn: labelHi
              width: 72
              text: cell.label
              color: "white"
              wrapMode: Text.Wrap
              horizontalAlignment: Text.AlignHCenter
              font.family: "Liberation Sans"
              font.pixelSize: 11
              style: cell.chosen ? Text.Normal : Text.Outline
              styleColor: "#000000"
            }

            MouseArea {
              anchors.fill: parent
              acceptedButtons: Qt.LeftButton | Qt.RightButton
              hoverEnabled: true
              onClicked: function(ev) {
                root.selected = cell.key
                if (ev.button === Qt.RightButton)
                  root.launch(cell.cmd)
              }
              onDoubleClicked: root.launch(cell.cmd)
            }
          }
        }
      }
    }
  }
}

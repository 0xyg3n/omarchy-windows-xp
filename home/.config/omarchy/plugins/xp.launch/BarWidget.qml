import QtQuick
import qs.Ui

BarWidget {
  id: root
  moduleName: "xp.launch"
  ThemeGate { id: gate }

  visible: gate.xp
  implicitWidth: gate.xp ? row.implicitWidth + 6 : 0
  implicitHeight: gate.xp ? root.barSize : 0

  Row {
    id: row
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    spacing: 3

    Item {
      width: 5
      height: Math.max(18, root.barSize - 8)
      anchors.verticalCenter: parent.verticalCenter
      Rectangle { width: 1; height: parent.height; color: "#163E96" }
      Rectangle { x: 2; width: 1; height: parent.height; color: "#9EC1F0" }
    }

    Repeater {
      model: ListModel {
        ListElement { icon: "ql-desktop.png"; cmd: "hyprctl dispatch togglespecialworkspace desktop" }
        ListElement { icon: "ql-ie.png"; cmd: "omarchy-launch-browser" }
        ListElement { icon: "ql-docs.png"; cmd: "xdg-open \"$HOME/Documents\"" }
      }

      Item {
        id: tool
        required property string icon
        required property string cmd
        width: 22
        height: 22
        anchors.verticalCenter: parent.verticalCenter

        Image {
          anchors.centerIn: parent
          width: 16
          height: 16
          source: Qt.resolvedUrl(tool.icon)
          fillMode: Image.PreserveAspectFit
          smooth: false
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          onClicked: {
            if (root.bar)
              root.bar.run(tool.cmd)
          }
        }
      }
    }

    Item {
      width: 5
      height: Math.max(18, root.barSize - 8)
      anchors.verticalCenter: parent.verticalCenter
      Rectangle { width: 1; height: parent.height; color: "#163E96" }
      Rectangle { x: 2; width: 1; height: parent.height; color: "#9EC1F0" }
    }
  }
}

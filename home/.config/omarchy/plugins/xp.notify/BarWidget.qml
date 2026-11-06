import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "xp.notify"
  ThemeGate { id: gate }

  visible: gate.xp
  implicitWidth: gate.xp ? well.implicitWidth : 0
  implicitHeight: gate.xp ? root.barSize : 0

  Item {
    id: well
    anchors.fill: parent
    implicitWidth: inner.implicitWidth + 22
    implicitHeight: root.barSize

    BorderImage {
      anchors.fill: parent
      source: Qt.resolvedUrl("tray.png")
      border.left: 6
      border.right: 4
      border.top: 4
      border.bottom: 4
      horizontalTileMode: BorderImage.Stretch
      verticalTileMode: BorderImage.Stretch
      smooth: false
      cache: true
    }

    // Luna gripper: two columns of bumps on the left of the well
    Column {
      id: grip
      anchors.left: parent.left
      anchors.leftMargin: 4
      anchors.verticalCenter: parent.verticalCenter
      spacing: 2
      Repeater {
        model: 4
        Row {
          spacing: 2
          Rectangle { width: 1; height: 1; color: "#9EE7FF" }
          Rectangle { width: 1; height: 1; color: "#0A4A8A" }
        }
      }
    }

    Row {
      id: inner
      anchors.right: parent.right
      anchors.rightMargin: 8
      anchors.verticalCenter: parent.verticalCenter
      spacing: 3

      Repeater {
        model: SystemTray.items

        Item {
          id: traySlot
          required property var modelData
          readonly property bool show: modelData && modelData.status !== Status.Passive
          visible: show
          width: show ? 16 : 0
          height: 16

          Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: traySlot.modelData ? (traySlot.modelData.icon || "") : ""
            smooth: false
            asynchronous: true
          }

          MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            hoverEnabled: true
            onClicked: function(ev) {
              if (!traySlot.modelData)
                return
              if (ev.button === Qt.RightButton && traySlot.modelData.menu)
                traySlot.modelData.activate()
              else if (ev.button === Qt.MiddleButton)
                traySlot.modelData.secondaryActivate()
              else
                traySlot.modelData.activate()
            }
          }
        }
      }

      Image {
        id: volIcon
        width: 16
        height: 16
        source: Qt.resolvedUrl("Volume.png")
        fillMode: Image.PreserveAspectFit
        smooth: false
        MouseArea {
          anchors.fill: parent
          onClicked: {
            if (root.bar)
              root.bar.run("omarchy-shell shell toggle omarchy.audio")
          }
        }
      }

      Text {
        id: clockLabel
        text: Qt.formatDateTime(clock.date, "HH:mm")
        color: "white"
        font.family: "Liberation Sans"
        font.pixelSize: 11
        font.bold: false
        style: Text.Normal
        anchors.verticalCenter: volIcon.verticalCenter
        leftPadding: 4
        MouseArea {
          anchors.fill: parent
          onClicked: {
            if (root.bar)
              root.bar.run("omarchy-shell shell toggle omarchy.clock")
          }
        }
      }
    }
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }
}

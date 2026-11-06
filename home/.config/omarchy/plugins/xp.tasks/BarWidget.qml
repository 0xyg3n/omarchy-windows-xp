import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "xp.tasks"
  ThemeGate { id: gate }
  visible: gate.xp

  function hostScreenName() {
    var p = root.parent
    while (p) {
      if (p.screen && p.screen.name)
        return String(p.screen.name)
      p = p.parent
    }
    return ""
  }

  function hostMonitor() {
    var name = hostScreenName()
    var mons = Hyprland.monitors.values
    for (var i = 0; i < mons.length; i++) {
      if (mons[i].name === name)
        return mons[i]
    }
    return Hyprland.focusedMonitor
  }

  function appClass(t) {
    if (!t)
      return ""
    if (t.lastIpcObject && t.lastIpcObject["class"])
      return String(t.lastIpcObject["class"])
    if (t.wayland && t.wayland.appId)
      return String(t.wayland.appId)
    return ""
  }

  function showTask(t) {
    if (!t)
      return false
    var mon = hostMonitor()
    if (mon && t.monitor && t.monitor.name && t.monitor.name !== mon.name)
      return false
    var ws = mon ? mon.activeWorkspace : Hyprland.focusedWorkspace
    if (ws && t.workspace && t.workspace.id !== ws.id)
      return false
    if (t.workspace && t.workspace.id < 0)
      return false
    if (t.wayland && t.wayland.parent)
      return false
    return true
  }

  function taskLabel(t) {
    if (!t)
      return ""
    var title = String(t.title || "")
    if (title.length > 0)
      return title
    var cls = appClass(t)
    return cls.length > 0 ? cls : "Window"
  }

  function iconFor(t) {
    var cls = appClass(t)
    if (cls.length === 0)
      return Quickshell.iconPath("application-x-executable", true)
    var themed = Quickshell.iconPath(cls, true)
    if (themed && themed.length > 0)
      return themed
    var shortName = cls.split(".").pop()
    themed = Quickshell.iconPath(shortName, true)
    if (themed && themed.length > 0)
      return themed
    return Quickshell.iconPath("application-x-executable", true)
  }

  function activateTask(t) {
    if (!t)
      return
    if (t.activated && t.wayland) {
      t.wayland.minimized = true
      return
    }
    if (t.wayland) {
      t.wayland.activate()
      return
    }
    if (t.address)
      Hyprland.dispatch("focuswindow address:" + t.address)
  }

  function closeTask(t) {
    if (!t)
      return
    if (t.wayland)
      t.wayland.close()
  }

  readonly property int taskCount: {
    var n = 0
    var tops = Hyprland.toplevels.values
    var _ws = Hyprland.focusedWorkspace
    var _mon = Hyprland.focusedMonitor
    for (var i = 0; i < tops.length; i++) {
      if (showTask(tops[i]))
        n++
    }
    return n
  }

  readonly property int btnW: Math.max(72, Math.min(160, Math.floor(640 / Math.max(1, taskCount))))

  implicitWidth: gate.xp ? Math.max(0, row.implicitWidth + 4) : 0
  implicitHeight: gate.xp ? root.barSize : 0

  Row {
    id: row
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.leftMargin: 2
    spacing: 3

    Repeater {
      model: Hyprland.toplevels

      Rectangle {
        id: chip
        required property var modelData
        readonly property bool onBar: root.showTask(modelData)
        readonly property bool focused: modelData && modelData.activated === true

        visible: onBar
        width: visible ? root.btnW : 0
        height: Math.max(22, root.barSize - 4)
        radius: 0
        color: focused ? "#1B49B3" : "#3C6FBB"

        Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.right: parent.right; height: 1; color: focused ? "#0A246A" : "#9EC1F0" }
        Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: focused ? "#0A246A" : "#9EC1F0" }
        Rectangle { anchors.left: parent.left; anchors.bottom: parent.bottom; anchors.right: parent.right; height: 1; color: focused ? "#7BA7E1" : "#163E96" }
        Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: focused ? "#7BA7E1" : "#163E96" }

        Image {
          id: appIcon
          anchors.left: parent.left
          anchors.leftMargin: 4
          anchors.verticalCenter: parent.verticalCenter
          width: 16
          height: 16
          source: root.iconFor(chip.modelData)
          fillMode: Image.PreserveAspectFit
          smooth: false
          asynchronous: true
        }

        Text {
          anchors.left: appIcon.right
          anchors.leftMargin: 4
          anchors.right: parent.right
          anchors.rightMargin: 5
          anchors.verticalCenter: parent.verticalCenter
          anchors.verticalCenterOffset: focused ? 1 : 0
          text: root.taskLabel(chip.modelData)
          color: "white"
          font.family: "Liberation Sans"
          font.pixelSize: 11
          elide: Text.ElideRight
        }

        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
          onClicked: function(ev) {
            if (ev.button === Qt.MiddleButton || ev.button === Qt.RightButton)
              root.closeTask(chip.modelData)
            else
              root.activateTask(chip.modelData)
          }
        }
      }
    }
  }
}

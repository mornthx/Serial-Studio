import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
  id: root
  spacing: 0
  visible: count > 0

  property int count: 0
  property var titles:[""]
  property string icon: ""
  property string title: ""
  property bool colorfulSwitches: true
  readonly property var widgetColors: Cpp_ThemeManager.colors["widget_colors"]

  signal checkedChanged(var index, var checked)

  Connections {
    target: Cpp_UI_Dashboard

    function onDataReset() {
      hideAll.checked = false
    }
  }

  RowLayout {
    spacing: 4
    visible: root.count > 0

    Image {
      source: root.icon
      sourceSize: Qt.size(18, 18)
      Layout.alignment: Qt.AlignVCenter
    }

    Label {
      text: root.title
      Layout.alignment: Qt.AlignVCenter
      opacity: hideAll.checked ? 0.5 : 1
      font: Cpp_Misc_CommonFonts.customUiFont(10, true)
      color: Cpp_ThemeManager.colors["pane_section_label"]
      Component.onCompleted: font.capitalization = Font.AllUppercase
    }

    Item {
      Layout.fillWidth: true
    }

    RoundButton {
      id: hideAll
      width: 24
      height: 24
      flat: true
      checkable: true
      icon.width: 18
      icon.height: 18
      Layout.rightMargin: -6
      icon.color: "transparent"
      icon.source: !checked ? "qrc:/rcc/icons/dashboard/show-all.svg" :
                              "qrc:/rcc/icons/dashboard/hide-all.svg"
      onCheckedChanged: {
        for (var i = 0; i < root.count; ++i)
          root.checkedChanged(i, !checked)
      }
    }
  }

  Repeater {
    model: hideAll.checked ? 0 : root.count
    delegate: Switch {
      checked: true
      Layout.leftMargin: -6
      Layout.fillWidth: true
      text: root.titles[index]
      Layout.maximumHeight: 24
      onCheckedChanged: root.checkedChanged(index, checked)
      palette.highlight: root.colorfulSwitches ?
                           root.widgetColors[index % root.widgetColors.length] :
                           Cpp_ThemeManager.colors["view_switch"]
    }
  }

  Item {
    height: 8
    visible: !hideAll.checked && count > 0
  }
}

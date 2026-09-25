import QtQuick
import IslandBackend

Item {
    id: root

    property real radius: 20
    property bool hovered: false
    property bool pressed: false
    readonly property real innerRadius: Math.max(0, radius - 1)

    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: root.pressed ? StyleTokens.cardFillActive : (root.hovered ? StyleTokens.moduleHover : StyleTokens.module)
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        radius: root.innerRadius
        color: root.pressed ? StyleTokens.panel : (root.hovered ? StyleTokens.cardFillActive : StyleTokens.module)
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        radius: root.innerRadius
        color: StyleTokens.transparent
        border.width: 1
        border.color: root.hovered ? StyleTokens.inputBorder : StyleTokens.track
    }
}

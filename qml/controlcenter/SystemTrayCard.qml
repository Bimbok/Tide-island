import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import IslandBackend

Item {
    id: root

    readonly property var userConfig: UserConfig
    readonly property var trayItems: SystemTray.items.values
    readonly property int itemCount: trayItems ? trayItems.length : 0
    readonly property bool hasItems: itemCount > 0

    visible: hasItems
    height: hasItems ? 62 : 0

    Behavior on height {
        NumberAnimation {
            duration: 220
            easing.type: Easing.OutCubic
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
        }
    }

    Rectangle {
        id: cardBg
        anchors.fill: parent
        radius: 20
        color: StyleTokens.clearBlack
        clip: true

        MatteSurface {
            anchors.fill: parent
            radius: parent.radius
        }

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            spacing: 12

            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "\uf0c9"
                    color: StyleTokens.textSecondary
                    font.pixelSize: 12
                    font.family: userConfig.iconFontFamily
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Tray"
                    color: StyleTokens.textSecondary
                    font.pixelSize: 12
                    font.family: userConfig.textFontFamily
                    font.weight: Font.DemiBold
                }
            }

            Rectangle {
                width: 1
                height: 18
                anchors.verticalCenter: parent.verticalCenter
                color: StyleTokens.withAlpha(StyleTokens.textSecondary, 0.22)
            }

            Flickable {
                id: trayFlickable
                width: parent.width - 70
                height: 42
                anchors.verticalCenter: parent.verticalCenter
                contentWidth: trayRow.implicitWidth
                contentHeight: height
                boundsBehavior: Flickable.StopAtBounds
                clip: true

                Row {
                    id: trayRow
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    Repeater {
                        model: root.trayItems

                        delegate: Item {
                            id: trayDelegate
                            width: 38
                            height: 38

                            Rectangle {
                                anchors.fill: parent
                                radius: 10
                                color: trayMouse.pressed
                                    ? StyleTokens.cardFillActive
                                    : (trayMouse.containsMouse ? StyleTokens.cardFillHover : StyleTokens.transparent)
                                border.color: modelData.status === 2
                                    ? StyleTokens.accent
                                    : (trayMouse.containsMouse ? StyleTokens.withAlpha(StyleTokens.white, 0.12) : StyleTokens.transparent)
                                border.width: 1

                                Behavior on color {
                                    ColorAnimation { duration: 120 }
                                }

                                Image {
                                    anchors.centerIn: parent
                                    width: 22
                                    height: 22
                                    source: modelData.icon || ""
                                    fillMode: Image.PreserveAspectFit
                                    asynchronous: true
                                    smooth: true
                                    mipmap: true
                                }
                            }

                            MouseArea {
                                id: trayMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                                cursorShape: Qt.PointingHandCursor

                                onClicked: function(mouse) {
                                    if (mouse.button === Qt.LeftButton) {
                                        modelData.activate();
                                    } else if (mouse.button === Qt.RightButton || mouse.button === Qt.MiddleButton) {
                                        modelData.secondaryActivate();
                                    }
                                }

                                onWheel: function(wheel) {
                                    modelData.scroll(wheel.angleDelta.y);
                                }
                            }

                            // Tooltip on hover
                            Rectangle {
                                id: tooltipBox
                                visible: trayMouse.containsMouse && tooltipLabel.text !== ""
                                z: 999
                                anchors.bottom: parent.top
                                anchors.bottomMargin: 6
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: tooltipLabel.implicitWidth + 16
                                height: 22
                                radius: 6
                                color: StyleTokens.prompt
                                border.color: StyleTokens.inputBorder
                                border.width: 1

                                Text {
                                    id: tooltipLabel
                                    anchors.centerIn: parent
                                    text: modelData.tooltipTitle || modelData.title || modelData.id || ""
                                    color: StyleTokens.textPrimaryBright
                                    font.pixelSize: 11
                                    font.family: userConfig.textFontFamily
                                    font.weight: Font.Medium
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

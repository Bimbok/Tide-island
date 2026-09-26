import TideIsland 1.0
import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    color: Theme.cardBgColor
    radius: 16
    border.width: 1
    border.color: Theme.splitLineColor
    implicitHeight: paletteColumn.implicitHeight + 36

    function boolValue(key, fallback) {
        const val = ConfigStore.value(key, fallback);
        return val === undefined || val === null ? fallback : Boolean(val);
    }

    Column {
        id: paletteColumn

        anchors.top: parent.top
        anchors.topMargin: 18
        anchors.left: parent.left
        anchors.leftMargin: 18
        anchors.right: parent.right
        anchors.rightMargin: 18
        spacing: 16

        Item {
            width: parent.width
            height: 49

            Text {
                id: paletteToggleTitle
                text: "Dynamic Color Palette"
                font.family: Theme.textFontFamily
                font.pixelSize: 18
                color: Theme.textColor
                anchors.top: parent.top
                anchors.left: parent.left
            }

            Text {
                text: "Sync island and controls with system theme (Matugen / colors.json)"
                font.family: Theme.textFontFamily
                font.pixelSize: 14
                anchors.top: paletteToggleTitle.bottom
                anchors.topMargin: 5
                anchors.left: paletteToggleTitle.left
                color: Theme.subtleTextColor
            }

            StyledSwitch {
                id: paletteSwitch
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                checked: root.boolValue("colorPaletteEnabled", true)
                onToggled: function(val) {
                    checked = val;
                    ConfigStore.setValue("colorPaletteEnabled", val);
                    ConfigStore.save();
                }
            }
        }

        SplitLine { width: parent.width }

        Item {
            width: parent.width
            height: 49

            Text {
                id: colorsPathTitle
                text: "Colors File Path"
                font.family: Theme.textFontFamily
                font.pixelSize: 18
                color: Theme.textColor
                anchors.top: parent.top
                anchors.left: parent.left
            }

            Text {
                text: "Custom colors.json path (empty for ~/.config/tide-island/colors.json)"
                font.family: Theme.textFontFamily
                font.pixelSize: 14
                anchors.top: colorsPathTitle.bottom
                anchors.topMargin: 5
                anchors.left: colorsPathTitle.left
                color: Theme.subtleTextColor
            }

            ConfigTextField {
                id: colorsPathField
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 260
                height: 36
                placeholderText: "~/.config/tide-island/colors.json"

                Component.onCompleted: {
                    text = String(ConfigStore.value("colorsFilePath", ""))
                }

                onAccepted: commit()
                onEditingFinished: commit()

                function commit() {
                    ConfigStore.setValue("colorsFilePath", text.trim())
                    ConfigStore.save()
                }
            }
        }

        SplitLine { width: parent.width }

        Column {
            id: matugenGuide
            width: parent.width
            spacing: 12

            property bool copiedSnippet: false

            Timer {
                id: matugenCopyResetTimer
                interval: 1500
                repeat: false
                onTriggered: matugenGuide.copiedSnippet = false
            }

            readonly property string matugenSnippet:
"[templates.tide_island]\ninput_path = \"~/.config/matugen/templates/tide-island-colors.json\"\noutput_path = \"~/.config/tide-island/colors.json\""

            Item {
                width: parent.width
                height: 32

                Text {
                    text: "Matugen System Palette Setup"
                    font.family: Theme.textFontFamily
                    font.pixelSize: 18
                    color: Theme.textColor
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 96
                    height: 32
                    radius: 8
                    color: matugenGuide.copiedSnippet
                        ? Theme.buttonColor
                        : (copyMouse.containsMouse ? Theme.mutedButtonHoverColor : Theme.mutedButtonColor)
                    border.width: 1
                    border.color: Theme.splitLineColor

                    Text {
                        anchors.centerIn: parent
                        text: matugenGuide.copiedSnippet ? "Copied!" : "Copy TOML"
                        color: matugenGuide.copiedSnippet ? Theme.buttonTextColor : Theme.mutedButtonTextColor
                        font.family: Theme.textFontFamily
                        font.pixelSize: 13
                        font.weight: Font.DemiBold
                    }

                    MouseArea {
                        id: copyMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (backend.copyToClipboard(matugenGuide.matugenSnippet)) {
                                matugenGuide.copiedSnippet = true;
                                matugenCopyResetTimer.restart();
                            }
                        }
                    }
                }
            }

            Text {
                width: parent.width
                text: "To sync colors automatically with your wallpaper via Matugen, ensure the template is placed in ~/.config/matugen/templates/ and add this block to ~/.config/matugen/config.toml:"
                font.family: Theme.textFontFamily
                font.pixelSize: 14
                color: Theme.subtleTextColor
                wrapMode: Text.WordWrap
            }

            Rectangle {
                width: parent.width
                height: codeText.implicitHeight + 20
                radius: 8
                color: Theme.inputBgColor
                border.width: 1
                border.color: Theme.inputBorderColor

                Text {
                    id: codeText
                    anchors.fill: parent
                    anchors.margins: 10
                    text: matugenGuide.matugenSnippet
                    color: Theme.textColor
                    wrapMode: Text.WrapAnywhere
                    font.family: "monospace"
                    font.pixelSize: 13
                    lineHeight: 1.2
                }
            }

            Text {
                width: parent.width
                text: "• Template file: ~/.config/matugen/templates/tide-island-colors.json\n• Generated colors: ~/.config/tide-island/colors.json\n• Background transparency is independently preserved using the 'Background Transparency' slider in General."
                font.family: Theme.textFontFamily
                font.pixelSize: 13
                color: Theme.subtleTextColor
                wrapMode: Text.WordWrap
                lineHeight: 1.3
            }
        }
    }

    component SplitLine: Rectangle {
        height: 1
        color: Theme.splitLineColor
    }

    component StyledSwitch: Item {
        id: control

        signal toggled(bool checked)

        property bool checked: false

        width: 48
        height: 26

        Rectangle {
            id: track

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width: 40
            height: 24
            radius: 12
            color: control.checked ? Theme.accentColor : Theme.componentBgColor
            border.width: 1
            border.color: control.checked ? Theme.accentColor : Theme.inputBorderColor

            Behavior on color {
                ColorAnimation { duration: 180; easing.type: Easing.InOutQuad }
            }
        }

        Rectangle {
            id: knob

            width: 18
            height: 18
            radius: 9
            x: control.checked ? 22 : 6
            y: 3
            color: Theme.cardBgColor
            border.width: 0

            Behavior on x {
                NumberAnimation { duration: 180; easing.type: Easing.InOutQuad }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                control.toggled(!control.checked);
            }
        }
    }
}

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
import IslandBackend

FocusScope {
    id: root

    signal closeRequested()

    property bool showCondition: false
    property string iconFontFamily: ""
    property string textFontFamily: ""
    property string searchQuery: ""
    property int selectedIndex: 0
    property string deletingId: ""
    property string collapsingId: ""
    property bool imgFullPreview: false
    property int previewSlideDir: 1
    property int totalCount: 0
    property var allEntries: []
    property bool cliphistAvailable: true

    readonly property string helperScriptPath: {
        const candidate = Qt.resolvedUrl("../../scripts/cliphist-helper.sh").toString();
        if (candidate.startsWith("file://")) {
            return decodeURIComponent(candidate.substring(7));
        }
        return "/usr/share/tide-island/scripts/cliphist-helper.sh";
    }

    focus: showCondition
    activeFocusOnTab: true
    anchors.fill: parent
    opacity: showCondition ? 1 : 0

    Behavior on opacity {
        NumberAnimation {
            duration: root.showCondition ? StyleTokens.durationStandard : StyleTokens.durationFast
            easing.type: Easing.InOutQuad
        }
    }

    ListModel {
        id: listModel
    }

    onShowConditionChanged: {
        if (showCondition) {
            imgFullPreview = false;
            searchQuery = "";
            searchInput.text = "";
            selectedIndex = 0;
            refresh();
            grabKeyboardFocus();
        }
    }

    onSearchQueryChanged: {
        rebuildFilteredModel();
    }

    onImgFullPreviewChanged: {
        if (imgFullPreview) {
            previewArea.forceActiveFocus();
        } else {
            searchInput.forceActiveFocus();
        }
    }

    function grabKeyboardFocus() {
        root.focus = true;
        root.forceActiveFocus();
        if (imgFullPreview) {
            previewArea.forceActiveFocus();
        } else {
            searchInput.forceActiveFocus();
        }
    }

    function refresh() {
        listProc.running = false;
        listProc.running = true;
        countProc.running = false;
        countProc.running = true;
    }

    function rebuildFilteredModel() {
        listModel.clear();
        const q = searchQuery.trim().toLowerCase();
        const list = q.length === 0
            ? allEntries
            : allEntries.filter(e => String(e.label).toLowerCase().includes(q));

        for (let i = 0; i < list.length; i++) {
            listModel.append(list[i]);
        }

        if (listModel.count === 0) {
            selectedIndex = -1;
        } else {
            selectedIndex = Math.max(0, Math.min(listModel.count - 1, selectedIndex));
        }
    }

    function copySelected() {
        if (listModel.count === 0 || selectedIndex < 0 || selectedIndex >= listModel.count)
            return;
        const entry = listModel.get(selectedIndex);
        copyEntry(entry);
    }

    function copyEntry(entry) {
        if (!entry || !entry.id)
            return;
        copyProc.command = ["bash", root.helperScriptPath, "copy", String(entry.id)];
        copyProc.running = false;
        copyProc.running = true;
        root.closeRequested();
    }

    function deleteSelected() {
        if (listModel.count === 0 || selectedIndex < 0 || selectedIndex >= listModel.count)
            return;
        const entry = listModel.get(selectedIndex);
        deleteEntry(entry);
    }

    function deleteEntry(entry) {
        if (!entry || !entry.id)
            return;
        root.deletingId = String(entry.id);
        deleteProc.command = ["bash", root.helperScriptPath, "delete", String(entry.id), "true"];
        deleteProc.running = false;
        deleteProc.running = true;
        holdDeleteTimer.entryId = String(entry.id);
        holdDeleteTimer.restart();
    }

    function toggleImagePreview() {
        if (listModel.count === 0 || selectedIndex < 0 || selectedIndex >= listModel.count)
            return;
        const entry = listModel.get(selectedIndex);
        if (!entry || !entry.imagePath)
            return;
        imgFullPreview = !imgFullPreview;
    }

    function findAdjacentImageIndex(direction) {
        if (listModel.count === 0)
            return -1;
        let idx = root.selectedIndex;
        for (let i = 0; i < listModel.count; i++) {
            idx = (idx + direction + listModel.count) % listModel.count;
            const e = listModel.get(idx);
            if (e && e.imagePath)
                return idx;
        }
        return -1;
    }

    function formatImageLabel(raw) {
        if (!raw)
            return "Image";
        const match = String(raw).match(/\[\[ binary data (.+) \]\]/);
        if (match && match[1])
            return match[1];
        return String(raw);
    }

    Timer {
        id: holdDeleteTimer
        property string entryId: ""
        interval: 160
        repeat: false
        onTriggered: {
            root.collapsingId = entryId;
            removeTimer.entryId = entryId;
            removeTimer.restart();
        }
    }

    Timer {
        id: removeTimer
        property string entryId: ""
        interval: 200
        repeat: false
        onTriggered: {
            const currentIdx = root.selectedIndex;
            const savedContentY = listView.contentY;

            let idx = -1;
            for (let i = 0; i < listModel.count; i++) {
                if (listModel.get(i).id === entryId) {
                    idx = i;
                    break;
                }
            }
            if (idx !== -1)
                listModel.remove(idx);

            root.allEntries = root.allEntries.filter(e => e.id !== entryId);
            root.deletingId = "";
            root.collapsingId = "";

            const newLength = listModel.count;
            if (newLength === 0) {
                root.selectedIndex = -1;
                root.imgFullPreview = false;
            } else if (currentIdx >= newLength) {
                root.selectedIndex = newLength - 1;
            } else {
                root.selectedIndex = currentIdx;
            }

            if (root.imgFullPreview && root.selectedIndex !== -1) {
                const e = listModel.get(root.selectedIndex);
                if (!e || !e.imagePath) {
                    const imgIdx = root.findAdjacentImageIndex(root.previewSlideDir);
                    if (imgIdx !== -1) {
                        root.selectedIndex = imgIdx;
                    } else {
                        root.imgFullPreview = false;
                    }
                }
            }

            Qt.callLater(() => {
                const maxY = Math.max(0, listView.contentHeight - listView.height);
                listView.contentY = Math.min(savedContentY, maxY);
                if (root.selectedIndex >= 0)
                    listView.positionViewAtIndex(root.selectedIndex, ListView.Contain);
            });
        }
    }

    Process {
        id: listProc
        command: ["bash", root.helperScriptPath, "list", "200"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                root.cliphistAvailable = true;
                const lines = this.text.split("\n").filter(l => l.length > 0);
                const parsed = [];
                for (let i = 0; i < lines.length; i++) {
                    const line = lines[i];
                    const tabIdx = line.indexOf("\t");
                    if (tabIdx === -1)
                        continue;
                    const id = line.substring(0, tabIdx);
                    const rest = line.substring(tabIdx + 1);
                    const nullIdx = rest.indexOf("\x00");
                    if (nullIdx !== -1) {
                        const label = rest.substring(0, nullIdx);
                        const iconPart = rest.substring(nullIdx + 1);
                        const splitPart = iconPart.split("\x1f");
                        const imgPath = splitPart.length > 1 ? splitPart[1] : "";
                        parsed.push({ id: id, label: label, imagePath: imgPath, isImage: true });
                    } else {
                        const isImg = rest.indexOf("[[ binary data") !== -1;
                        parsed.push({ id: id, label: rest, imagePath: "", isImage: isImg });
                    }
                }
                root.allEntries = parsed;
                root.rebuildFilteredModel();
            }
        }
        onExited: (code) => {
            if (code === 127)
                root.cliphistAvailable = false;
        }
    }

    Process {
        id: countProc
        command: ["bash", root.helperScriptPath, "count"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                const count = parseInt(this.text.trim(), 10);
                root.totalCount = isNaN(count) ? root.allEntries.length : count;
            }
        }
    }

    Process {
        id: copyProc
        running: false
    }

    Process {
        id: deleteProc
        running: false
        onRunningChanged: {
            if (!running) {
                countProc.running = false;
                countProc.running = true;
            }
        }
    }

    Process {
        id: wipeProc
        command: ["bash", root.helperScriptPath, "wipe"]
        running: false
        onRunningChanged: {
            if (!running) {
                root.allEntries = [];
                listModel.clear();
                root.totalCount = 0;
                root.selectedIndex = -1;
                root.imgFullPreview = false;
            }
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10
        clip: true

        // Header
        RowLayout {
            width: parent.width
            height: 28

            // Clipboard Icon + Title
            Row {
                Layout.alignment: Qt.AlignLeft
                spacing: 8

                Item {
                    width: 20
                    height: 20
                    anchors.verticalCenter: parent.verticalCenter

                    Shape {
                        anchors.fill: parent
                        preferredRendererType: Shape.CurveRenderer

                        ShapePath {
                            fillColor: StyleTokens.transparent
                            strokeColor: "#ffffff"
                            strokeWidth: 1.6
                            capStyle: ShapePath.RoundCap
                            joinStyle: ShapePath.RoundJoin

                            // Clipboard board outline
                            PathSvg {
                                path: "M7 4H5a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2h-2"
                            }
                        }

                        ShapePath {
                            fillColor: StyleTokens.transparent
                            strokeColor: "#ffffff"
                            strokeWidth: 1.6
                            capStyle: ShapePath.RoundCap
                            joinStyle: ShapePath.RoundJoin

                            // Clipboard clip on top
                            PathSvg {
                                path: "M7 3a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2H7V3z"
                            }
                        }
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.imgFullPreview ? "Image Preview" : "Clipboard History"
                    color: "#ffffff"
                    font.family: root.textFontFamily
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                }
            }

            Item {
                Layout.fillWidth: true
            }

            // Count badge
            Text {
                text: listModel.count === 0
                    ? "0 items"
                    : (root.selectedIndex >= 0 ? (root.selectedIndex + 1) : 0) + " / " + listModel.count
                        + (root.totalCount > listModel.count ? " (" + root.totalCount + " total)" : "")
                color: StyleTokens.textMuted
                font.family: root.textFontFamily
                font.pixelSize: 11
                Layout.alignment: Qt.AlignVCenter
                visible: !root.imgFullPreview
            }

            // Wipe history button
            Rectangle {
                width: 26
                height: 26
                radius: 7
                color: wipeMouse.containsMouse ? StyleTokens.danger : StyleTokens.module
                opacity: listModel.count > 0 ? (wipeMouse.containsMouse ? 0.9 : 0.6) : 0.2
                Layout.alignment: Qt.AlignVCenter
                visible: !root.imgFullPreview

                Behavior on color { ColorAnimation { duration: 120 } }
                Behavior on opacity { NumberAnimation { duration: 120 } }

                Item {
                    anchors.centerIn: parent
                    width: 14
                    height: 14

                    Shape {
                        anchors.fill: parent
                        preferredRendererType: Shape.CurveRenderer

                        ShapePath {
                            fillColor: StyleTokens.transparent
                            strokeColor: "#ffffff"
                            strokeWidth: 1.4
                            capStyle: ShapePath.RoundCap
                            joinStyle: ShapePath.RoundJoin

                            PathSvg {
                                path: "M2 3.5h10 M5 3.5V2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v1.5 M3 3.5l.8 8.5a1.5 1.5 0 0 0 1.5 1.4h3.4a1.5 1.5 0 0 0 1.5-1.4L11 3.5"
                            }
                        }
                    }
                }

                MouseArea {
                    id: wipeMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    enabled: listModel.count > 0
                    onClicked: {
                        wipeProc.running = false;
                        wipeProc.running = true;
                    }
                }
            }

            // Close button
            Rectangle {
                width: 26
                height: 26
                radius: 7
                color: closeMouse.containsMouse ? StyleTokens.moduleHover : StyleTokens.transparent
                Layout.alignment: Qt.AlignVCenter

                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    color: closeMouse.containsMouse ? "#ffffff" : StyleTokens.textMuted
                    font.pixelSize: 12
                }

                MouseArea {
                    id: closeMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.imgFullPreview) {
                            root.imgFullPreview = false;
                        } else {
                            root.closeRequested();
                        }
                    }
                }
            }
        }

        // Search Input Box
        Rectangle {
            id: searchContainer
            width: parent.width
            height: 32
            radius: 8
            color: StyleTokens.input
            border.color: searchInput.activeFocus ? StyleTokens.accent : StyleTokens.inputBorder
            border.width: 1
            visible: !root.imgFullPreview

            Behavior on border.color { ColorAnimation { duration: 150 } }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 8
                spacing: 8

                // Magnifying glass icon
                Item {
                    width: 14
                    height: 14
                    Layout.alignment: Qt.AlignVCenter

                    Shape {
                        anchors.fill: parent
                        preferredRendererType: Shape.CurveRenderer

                        ShapePath {
                            fillColor: StyleTokens.transparent
                            strokeColor: StyleTokens.textMuted
                            strokeWidth: 1.5
                            capStyle: ShapePath.RoundCap
                            joinStyle: ShapePath.RoundJoin

                            PathSvg {
                                path: "M6 10.5a4.5 4.5 0 1 0 0-9 4.5 4.5 0 0 0 0 9z M9.5 9.5l3.5 3.5"
                            }
                        }
                    }
                }

                TextInput {
                    id: searchInput
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    verticalAlignment: TextInput.AlignVCenter
                    color: StyleTokens.textPrimary
                    font.family: root.textFontFamily
                    font.pixelSize: 12
                    clip: true
                    selectByMouse: true
                    selectedTextColor: "#ffffff"
                    selectionColor: StyleTokens.accent

                    onTextChanged: {
                        root.searchQuery = text;
                    }

                    Text {
                        text: "Search clipboard..."
                        color: StyleTokens.textDim
                        font: searchInput.font
                        visible: searchInput.text.length === 0
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Down) {
                            if (listModel.count > 0) {
                                root.selectedIndex = (root.selectedIndex + 1) % listModel.count;
                                listView.positionViewAtIndex(root.selectedIndex, ListView.Contain);
                            }
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Up) {
                            if (listModel.count > 0) {
                                root.selectedIndex = root.selectedIndex <= 0
                                    ? listModel.count - 1
                                    : root.selectedIndex - 1;
                                listView.positionViewAtIndex(root.selectedIndex, ListView.Contain);
                            }
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            root.copySelected();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Escape) {
                            event.accepted = true;
                            root.closeRequested();
                        } else if (event.key === Qt.Key_Delete) {
                            root.deleteSelected();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Tab) {
                            root.toggleImagePreview();
                            event.accepted = true;
                        }
                    }
                }

                // Clear text button
                Rectangle {
                    width: 18
                    height: 18
                    radius: 9
                    color: clearQueryMouse.containsMouse ? StyleTokens.moduleHover : StyleTokens.transparent
                    visible: searchInput.text.length > 0
                    Layout.alignment: Qt.AlignVCenter

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: StyleTokens.textMuted
                        font.pixelSize: 10
                    }

                    MouseArea {
                        id: clearQueryMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            searchInput.text = "";
                            searchInput.forceActiveFocus();
                        }
                    }
                }
            }
        }

        // Main Content Area: List View or Full Image Preview
        Item {
            width: parent.width
            height: parent.height - (root.imgFullPreview ? 38 : 78)
            clip: true

            // Full Image Preview Mode
            FocusScope {
                id: previewArea
                anchors.fill: parent
                visible: root.imgFullPreview
                focus: root.imgFullPreview

                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Down || event.key === Qt.Key_Right) {
                        const next = root.findAdjacentImageIndex(1);
                        if (next !== -1) {
                            root.previewSlideDir = 1;
                            root.selectedIndex = next;
                        }
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Up || event.key === Qt.Key_Left) {
                        const prev = root.findAdjacentImageIndex(-1);
                        if (prev !== -1) {
                            root.previewSlideDir = -1;
                            root.selectedIndex = prev;
                        }
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        root.copySelected();
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Delete) {
                        root.deleteSelected();
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Escape || event.key === Qt.Key_Tab) {
                        root.imgFullPreview = false;
                        event.accepted = true;
                    }
                }

                readonly property var currentEntry: {
                    if (root.selectedIndex >= 0 && root.selectedIndex < listModel.count)
                        return listModel.get(root.selectedIndex);
                    return null;
                }

                readonly property string currentImgPath: currentEntry && currentEntry.imagePath
                    ? currentEntry.imagePath
                    : ""

                Column {
                    anchors.fill: parent
                    spacing: 8

                    // Image container
                    Rectangle {
                        width: parent.width
                        height: parent.height - 36
                        radius: 12
                        color: StyleTokens.module
                        clip: true

                        Image {
                            id: fullPreviewImg
                            anchors.centerIn: parent
                            width: parent.width - 20
                            height: parent.height - 20
                            fillMode: Image.PreserveAspectFit
                            asynchronous: true
                            cache: false
                            source: previewArea.currentImgPath !== ""
                                ? ("file://" + previewArea.currentImgPath)
                                : ""

                            property real slideY: 0
                            transform: Translate { y: fullPreviewImg.slideY }

                            onSourceChanged: {
                                slideY = root.previewSlideDir * 20;
                                slideAnim.restart();
                            }

                            NumberAnimation {
                                id: slideAnim
                                target: fullPreviewImg
                                property: "slideY"
                                to: 0
                                duration: 180
                                easing.type: Easing.OutCubic
                            }
                        }

                        // Image info badge
                        Rectangle {
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.margins: 10
                            height: 22
                            width: previewInfoText.implicitWidth + 16
                            radius: 6
                            color: "#aa121214"

                            Text {
                                id: previewInfoText
                                anchors.centerIn: parent
                                text: previewArea.currentEntry
                                    ? root.formatImageLabel(previewArea.currentEntry.label)
                                    : ""
                                color: "#ffffff"
                                font.family: root.textFontFamily
                                font.pixelSize: 10
                            }
                        }
                    }

                    // Navigation bar & shortcuts hint
                    RowLayout {
                        width: parent.width
                        height: 24

                        Text {
                            text: "[Enter] Copy   [Del] Delete   [↑/↓] Navigate   [Tab/Esc] Back"
                            color: StyleTokens.textMuted
                            font.family: root.textFontFamily
                            font.pixelSize: 11
                            Layout.alignment: Qt.AlignLeft
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Rectangle {
                            height: 24
                            width: 72
                            radius: 6
                            color: StyleTokens.accent
                            opacity: copyBtnMouse.containsMouse ? 0.9 : 1

                            Text {
                                anchors.centerIn: parent
                                text: "Copy"
                                color: "#ffffff"
                                font.family: root.textFontFamily
                                font.pixelSize: 11
                                font.weight: Font.DemiBold
                            }

                            MouseArea {
                                id: copyBtnMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.copySelected()
                            }
                        }
                    }
                }
            }

            // Normal List View Mode
            ListView {
                id: listView
                anchors.fill: parent
                clip: true
                model: listModel
                currentIndex: root.selectedIndex
                highlightFollowsCurrentItem: false
                visible: !root.imgFullPreview && listModel.count > 0
                spacing: 5
                boundsBehavior: Flickable.StopAtBounds

                ScrollBar.vertical: ScrollBar {
                    id: vbar
                    active: true
                    width: 4
                    policy: listView.contentHeight > listView.height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
                    contentItem: Rectangle {
                        implicitWidth: 4
                        radius: 2
                        color: StyleTokens.textMuted
                        opacity: 0.4
                    }
                }

                delegate: Rectangle {
                    id: rowDelegate
                    required property int index
                    required property var model

                    width: listView.width - (vbar.visible ? 8 : 0)
                    height: model.id === root.collapsingId
                        ? 0
                        : (model.imagePath !== "" ? 56 : 38)
                    radius: 8
                    clip: true
                    opacity: model.id === root.collapsingId ? 0 : 1
                    scale: model.id === root.collapsingId ? 0.8 : 1

                    color: {
                        if (model.id === root.deletingId)
                            return StyleTokens.danger;
                        if (index === root.selectedIndex)
                            return StyleTokens.cardFillHover;
                        if (rowMouse.containsMouse)
                            return StyleTokens.moduleHover;
                        return StyleTokens.module;
                    }

                    border.color: index === root.selectedIndex
                        ? StyleTokens.accent
                        : StyleTokens.transparent
                    border.width: 1

                    Behavior on height { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
                    Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                    Behavior on color { ColorAnimation { duration: 100 } }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 8
                        spacing: 10

                        // Icon or Image Thumbnail
                        Item {
                            width: model.imagePath !== "" ? 48 : 18
                            height: model.imagePath !== "" ? 38 : 18
                            Layout.alignment: Qt.AlignVCenter

                            // Image thumbnail
                            Rectangle {
                                anchors.fill: parent
                                radius: 5
                                color: "#1a1a1c"
                                clip: true
                                visible: model.imagePath !== ""

                                Image {
                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectFit
                                    source: model.imagePath ? ("file://" + model.imagePath) : ""
                                    asynchronous: true
                                    cache: false
                                    sourceSize: Qt.size(96, 76)
                                }
                            }

                            // Text icon for text items
                            Item {
                                anchors.fill: parent
                                visible: model.imagePath === ""

                                Shape {
                                    anchors.fill: parent
                                    preferredRendererType: Shape.CurveRenderer

                                    ShapePath {
                                        fillColor: StyleTokens.transparent
                                        strokeColor: StyleTokens.textMuted
                                        strokeWidth: 1.4
                                        capStyle: ShapePath.RoundCap
                                        joinStyle: ShapePath.RoundJoin

                                        PathSvg {
                                            path: "M3 2h8l4 4v10a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V3a1 1 0 0 1 1-1z M11 2v4h4 M5 9h6 M5 12h6"
                                        }
                                    }
                                }
                            }
                        }

                        // Label content
                        Column {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            spacing: 2

                            Text {
                                width: parent.width
                                text: model.imagePath !== ""
                                    ? root.formatImageLabel(model.label)
                                    : model.label
                                color: StyleTokens.textPrimary
                                font.family: root.textFontFamily
                                font.pixelSize: 11
                                elide: Text.ElideRight
                                maximumLineCount: model.imagePath !== "" ? 1 : 2
                                wrapMode: model.imagePath !== "" ? Text.NoWrap : Text.WrapAnywhere
                            }

                            Text {
                                visible: model.imagePath !== ""
                                text: "Image [Press Tab to full preview]"
                                color: StyleTokens.accent
                                font.family: root.textFontFamily
                                font.pixelSize: 9
                                font.weight: Font.DemiBold
                            }
                        }

                        // Actions (Copy / Delete)
                        Row {
                            Layout.alignment: Qt.AlignVCenter
                            spacing: 4
                            opacity: (rowMouse.containsMouse || index === root.selectedIndex) ? 1 : 0

                            Behavior on opacity { NumberAnimation { duration: 100 } }

                            // Copy button
                            Rectangle {
                                width: 24
                                height: 24
                                radius: 6
                                color: copyActionMouse.containsMouse ? StyleTokens.accent : StyleTokens.module

                                Item {
                                    anchors.centerIn: parent
                                    width: 12
                                    height: 12

                                    Shape {
                                        anchors.fill: parent
                                        preferredRendererType: Shape.CurveRenderer

                                        ShapePath {
                                            fillColor: StyleTokens.transparent
                                            strokeColor: "#ffffff"
                                            strokeWidth: 1.3
                                            capStyle: ShapePath.RoundCap
                                            joinStyle: ShapePath.RoundJoin

                                            PathSvg {
                                                path: "M4 1.5h5a1 1 0 0 1 1 1V8 M2 4.5h5a1 1 0 0 1 1 1V11a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V5.5a1 1 0 0 1 1-1z"
                                            }
                                        }
                                    }
                                }

                                MouseArea {
                                    id: copyActionMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        root.copyEntry(rowDelegate.model);
                                    }
                                }
                            }

                            // Delete button
                            Rectangle {
                                width: 24
                                height: 24
                                radius: 6
                                color: deleteActionMouse.containsMouse ? StyleTokens.danger : StyleTokens.module

                                Item {
                                    anchors.centerIn: parent
                                    width: 12
                                    height: 12

                                    Shape {
                                        anchors.fill: parent
                                        preferredRendererType: Shape.CurveRenderer

                                        ShapePath {
                                            fillColor: StyleTokens.transparent
                                            strokeColor: "#ffffff"
                                            strokeWidth: 1.3
                                            capStyle: ShapePath.RoundCap
                                            joinStyle: ShapePath.RoundJoin

                                            PathSvg {
                                                path: "M1.5 2.5h9 M4 2.5V1.5h4v1 M2.5 2.5l.6 7.5a1 1 0 0 0 1 .9h3.8a1 1 0 0 0 1-.9l.6-7.5"
                                            }
                                        }
                                    }
                                }

                                MouseArea {
                                    id: deleteActionMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        root.deleteEntry(rowDelegate.model);
                                    }
                                }
                            }
                        }
                    }

                    MouseArea {
                        id: rowMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        cursorShape: Qt.PointingHandCursor

                        onClicked: (mouse) => {
                            root.selectedIndex = rowDelegate.index;
                            if (mouse.button === Qt.RightButton) {
                                root.deleteEntry(rowDelegate.model);
                            } else {
                                root.copyEntry(rowDelegate.model);
                            }
                        }
                    }
                }
            }

            // Empty or Not Found State
            Item {
                anchors.fill: parent
                visible: !root.imgFullPreview && listModel.count === 0

                Column {
                    anchors.centerIn: parent
                    spacing: 8

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: !root.cliphistAvailable
                            ? "cliphist or wl-clipboard not found"
                            : (root.searchQuery !== "" ? "No clips match your search" : "Clipboard is empty")
                        color: StyleTokens.textSecondary
                        font.family: root.textFontFamily
                        font.pixelSize: 13
                        font.weight: Font.DemiBold
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: !root.cliphistAvailable
                            ? "Install cliphist and wl-clipboard to enable clipboard history"
                            : (root.searchQuery !== "" ? "Try a different search keyword" : "Items you copy will automatically appear here")
                        color: StyleTokens.textMuted
                        font.family: root.textFontFamily
                        font.pixelSize: 11
                    }
                }
            }
        }
    }
}

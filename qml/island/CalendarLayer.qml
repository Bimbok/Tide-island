pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import IslandBackend

FocusScope {
    id: root

    signal closeRequested()

    property bool showCondition: false
    property string iconFontFamily: ""
    property string textFontFamily: ""
    property string heroFontFamily: ""

    // Current navigation state
    property int viewYear: new Date().getFullYear()
    property int viewMonth: new Date().getMonth()
    property int selectedYear: new Date().getFullYear()
    property int selectedMonth: new Date().getMonth()
    property int selectedDay: new Date().getDate()

    // Fixed today references
    readonly property var todayDate: new Date()
    readonly property int todayYear: todayDate.getFullYear()
    readonly property int todayMonth: todayDate.getMonth()
    readonly property int todayDay: todayDate.getDate()

    readonly property var monthNames: [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]

    readonly property var monthNamesShort: [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ]

    readonly property var dayNames: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]

    readonly property var weekdayNamesFull: [
        "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
    ]

    readonly property bool isViewingCurrentMonth: viewYear === todayYear && viewMonth === todayMonth

    focus: root.showCondition
    activeFocusOnTab: true
    anchors.fill: parent
    clip: true

    opacity: root.showCondition ? 1 : 0
    Behavior on opacity {
        NumberAnimation {
            duration: StyleTokens.durationStandard
            easing.type: Easing.InOutQuad
        }
    }

    Keys.onEscapePressed: function(event) {
        root.closeRequested();
        event.accepted = true;
    }

    Keys.onLeftPressed: function(event) {
        root.prevMonth();
        event.accepted = true;
    }

    Keys.onRightPressed: function(event) {
        root.nextMonth();
        event.accepted = true;
    }

    Keys.onHomePressed: function(event) {
        root.goToToday();
        event.accepted = true;
    }

    onShowConditionChanged: {
        if (root.showCondition) {
            root.forceActiveFocus();
            root.goToToday();
        }
    }

    function daysInMonth(y, m) {
        return new Date(y, m + 1, 0).getDate();
    }

    function daysInPrevMonth(y, m) {
        return new Date(y, m, 0).getDate();
    }

    // Monday-based first day of week: 0 = Monday, ..., 6 = Sunday
    function firstDayOfWeek(y, m) {
        const day = new Date(y, m, 1).getDay();
        return (day + 6) % 7;
    }

    function prevMonth() {
        if (viewMonth === 0) {
            viewMonth = 11;
            viewYear -= 1;
        } else {
            viewMonth -= 1;
        }
    }

    function nextMonth() {
        if (viewMonth === 11) {
            viewMonth = 0;
            viewYear += 1;
        } else {
            viewMonth += 1;
        }
    }

    function goToToday() {
        viewYear = todayYear;
        viewMonth = todayMonth;
        selectedYear = todayYear;
        selectedMonth = todayMonth;
        selectedDay = todayDay;
    }

    function selectDate(y, m, d) {
        const target = new Date(y, m, d);
        selectedYear = target.getFullYear();
        selectedMonth = target.getMonth();
        selectedDay = target.getDate();
        viewYear = selectedYear;
        viewMonth = selectedMonth;
    }

    function formatSelectedDateFull() {
        const d = new Date(selectedYear, selectedMonth, selectedDay);
        const dayName = weekdayNamesFull[d.getDay()];
        const monthName = monthNamesShort[selectedMonth];
        return dayName + ", " + selectedDay + " " + monthName + " " + selectedYear;
    }

    function getRelativeDescription() {
        const sel = new Date(selectedYear, selectedMonth, selectedDay);
        const tod = new Date(todayYear, todayMonth, todayDay);
        const diffMs = sel.getTime() - tod.getTime();
        const diffDays = Math.round(diffMs / 86400000);

        if (diffDays === 0) return "Today";
        if (diffDays === 1) return "Tomorrow";
        if (diffDays === -1) return "Yesterday";
        if (diffDays > 1) return "In " + diffDays + " days";
        return Math.abs(diffDays) + " days ago";
    }

    function getWeekNumber(y, m, d) {
        const target = new Date(Date.UTC(y, m, d));
        target.setUTCDate(target.getUTCDate() + 4 - (target.getUTCDay() || 7));
        const yearStart = new Date(Date.UTC(target.getUTCFullYear(), 0, 1));
        return Math.ceil((((target.getTime() - yearStart.getTime()) / 86400000) + 1) / 7);
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 8

        // ──────────────────────────────────────────
        // 1. TOP HEADER BAR
        // ──────────────────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 28
            spacing: 8

            // Calendar Vector Icon
            Shape {
                Layout.preferredWidth: 15
                Layout.preferredHeight: 15
                preferredRendererType: Shape.CurveRenderer
                Layout.alignment: Qt.AlignVCenter

                ShapePath {
                    fillColor: StyleTokens.transparent
                    strokeColor: StyleTokens.accent
                    strokeWidth: 1.4
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.RoundJoin

                    PathSvg {
                        path: "M3 4a1.5 1.5 0 0 1 1.5-1.5h6A1.5 1.5 0 0 1 12 4v8a1.5 1.5 0 0 1-1.5 1.5h-6A1.5 1.5 0 0 1 3 12V4zm0 2.5h9M5 1.5v2M10 1.5v2"
                    }
                }
            }

            // Month & Year Label
            Text {
                text: root.monthNames[root.viewMonth] + " " + root.viewYear
                color: StyleTokens.textPrimaryBright
                font.family: root.textFontFamily
                font.pixelSize: 15
                font.weight: Font.Bold
                font.letterSpacing: -0.2
                Layout.alignment: Qt.AlignVCenter
            }

            Item { Layout.fillWidth: true }

            // "Today" Button
            Rectangle {
                Layout.preferredHeight: 22
                Layout.preferredWidth: todayLabel.implicitWidth + 16
                radius: 11
                color: todayMouse.containsMouse
                    ? StyleTokens.moduleHover
                    : (root.isViewingCurrentMonth ? "#1c2230" : StyleTokens.module)
                border.width: 1
                border.color: root.isViewingCurrentMonth ? "#2e4873" : StyleTokens.transparent

                Behavior on color { ColorAnimation { duration: 100 } }

                Text {
                    id: todayLabel
                    anchors.centerIn: parent
                    text: "Today"
                    color: root.isViewingCurrentMonth ? StyleTokens.accent : StyleTokens.textSecondary
                    font.family: root.textFontFamily
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                }

                MouseArea {
                    id: todayMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.goToToday()
                }
            }

            // Previous Month Button
            Item {
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
                Layout.alignment: Qt.AlignVCenter

                Shape {
                    anchors.centerIn: parent
                    width: 14
                    height: 14
                    scale: prevMouse.pressed ? 0.85 : (prevMouse.containsMouse ? 1.08 : 1.0)
                    preferredRendererType: Shape.CurveRenderer
                    Behavior on scale { NumberAnimation { duration: 100 } }

                    ShapePath {
                        fillColor: StyleTokens.transparent
                        strokeColor: prevMouse.containsMouse ? StyleTokens.textPrimaryBright : StyleTokens.textDim
                        strokeWidth: 1.5
                        capStyle: ShapePath.RoundCap
                        joinStyle: ShapePath.RoundJoin

                        PathSvg {
                            path: "M9 3L4 7.5L9 12"
                        }
                    }
                }

                MouseArea {
                    id: prevMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.prevMonth()
                }
            }

            // Next Month Button
            Item {
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
                Layout.alignment: Qt.AlignVCenter

                Shape {
                    anchors.centerIn: parent
                    width: 14
                    height: 14
                    scale: nextMouse.pressed ? 0.85 : (nextMouse.containsMouse ? 1.08 : 1.0)
                    preferredRendererType: Shape.CurveRenderer
                    Behavior on scale { NumberAnimation { duration: 100 } }

                    ShapePath {
                        fillColor: StyleTokens.transparent
                        strokeColor: nextMouse.containsMouse ? StyleTokens.textPrimaryBright : StyleTokens.textDim
                        strokeWidth: 1.5
                        capStyle: ShapePath.RoundCap
                        joinStyle: ShapePath.RoundJoin

                        PathSvg {
                            path: "M5 3L10 7.5L5 12"
                        }
                    }
                }

                MouseArea {
                    id: nextMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.nextMonth()
                }
            }
        }

        // Divider
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: "#22252e"
        }

        // ──────────────────────────────────────────
        // 2. DAY NAMES HEADER (Mo, Tu, We, Th, Fr, Sa, Su)
        // ──────────────────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 18
            spacing: 4

            Repeater {
                model: root.dayNames

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height

                    Text {
                        anchors.centerIn: parent
                        text: String(modelData)
                        color: (index >= 5) ? StyleTokens.accentSoft : StyleTokens.textMuted
                        font.family: root.textFontFamily
                        font.pixelSize: 11
                        font.weight: Font.DemiBold
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }

        // ──────────────────────────────────────────
        // 3. 42-CELL DAYS GRID (6 rows x 7 cols)
        // ──────────────────────────────────────────
        Grid {
            id: daysGrid
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 7
            columnSpacing: 4
            rowSpacing: 3

            readonly property real cellWidth: (width - 6 * columnSpacing) / 7
            readonly property real cellHeight: (height - 5 * rowSpacing) / 6
            readonly property int firstDay: root.firstDayOfWeek(root.viewYear, root.viewMonth)
            readonly property int daysInCur: root.daysInMonth(root.viewYear, root.viewMonth)
            readonly property int daysInPrev: root.daysInPrevMonth(root.viewYear, root.viewMonth)

            Repeater {
                model: 42

                Rectangle {
                    id: cellRect
                    width: daysGrid.cellWidth
                    height: daysGrid.cellHeight
                    radius: 7

                    // Cell date resolution
                    readonly property int cellIndex: index
                    readonly property bool isPrevMonth: cellIndex < daysGrid.firstDay
                    readonly property bool isNextMonth: cellIndex >= daysGrid.firstDay + daysGrid.daysInCur
                    readonly property bool isCurMonth: !isPrevMonth && !isNextMonth

                    readonly property int cellDay: {
                        if (isPrevMonth) {
                            return daysGrid.daysInPrev - daysGrid.firstDay + cellIndex + 1;
                        } else if (isCurMonth) {
                            return cellIndex - daysGrid.firstDay + 1;
                        } else {
                            return cellIndex - (daysGrid.firstDay + daysGrid.daysInCur) + 1;
                        }
                    }

                    readonly property int cellMonth: {
                        if (isPrevMonth) return (root.viewMonth === 0 ? 11 : root.viewMonth - 1);
                        if (isNextMonth) return (root.viewMonth === 11 ? 0 : root.viewMonth + 1);
                        return root.viewMonth;
                    }

                    readonly property int cellYear: {
                        if (isPrevMonth && root.viewMonth === 0) return root.viewYear - 1;
                        if (isNextMonth && root.viewMonth === 11) return root.viewYear + 1;
                        return root.viewYear;
                    }

                    readonly property bool isToday: cellYear === root.todayYear
                        && cellMonth === root.todayMonth
                        && cellDay === root.todayDay

                    readonly property bool isSelected: cellYear === root.selectedYear
                        && cellMonth === root.selectedMonth
                        && cellDay === root.selectedDay

                    // Styling
                    color: isToday
                        ? StyleTokens.accent
                        : (isSelected
                            ? "#1e2433"
                            : (cellMouse.containsMouse ? "#1c1f28" : StyleTokens.transparent))

                    border.width: (isSelected && !isToday) ? 1 : 0
                    border.color: (isSelected && !isToday) ? StyleTokens.accent : StyleTokens.transparent

                    Behavior on color { ColorAnimation { duration: 100 } }

                    Text {
                        anchors.centerIn: parent
                        text: String(cellRect.cellDay)
                        font.family: root.textFontFamily
                        font.pixelSize: 12
                        font.weight: (cellRect.isToday || cellRect.isSelected) ? Font.Bold : Font.Normal
                        color: {
                            if (cellRect.isToday) return "#ffffff";
                            if (cellRect.isSelected) return StyleTokens.accent;
                            if (cellRect.isCurMonth) return StyleTokens.textPrimaryBright;
                            return "#424552"; // Dimmed for other months
                        }
                    }

                    MouseArea {
                        id: cellMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.selectDate(cellRect.cellYear, cellRect.cellMonth, cellRect.cellDay);
                        }
                    }
                }
            }
        }

        // ──────────────────────────────────────────
        // 4. FOOTER DETAILS STRIP
        // ──────────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            radius: 8
            color: "#161820"
            border.width: 1
            border.color: "#21242e"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 8

                // Selected date readable string
                Text {
                    text: root.formatSelectedDateFull()
                    color: StyleTokens.textPrimaryBright
                    font.family: root.textFontFamily
                    font.pixelSize: 11
                    font.weight: Font.Medium
                    Layout.alignment: Qt.AlignVCenter
                }

                Item { Layout.fillWidth: true }

                // Relative day badge (e.g. "Today", "In 3 days")
                Rectangle {
                    Layout.preferredHeight: 18
                    Layout.preferredWidth: relativeText.implicitWidth + 12
                    radius: 9
                    color: root.getRelativeDescription() === "Today" ? "#192842" : "#1e2129"
                    border.width: 1
                    border.color: root.getRelativeDescription() === "Today" ? "#2b4570" : "#282c37"

                    Text {
                        id: relativeText
                        anchors.centerIn: parent
                        text: root.getRelativeDescription()
                        color: root.getRelativeDescription() === "Today" ? StyleTokens.accent : StyleTokens.textSecondary
                        font.family: root.textFontFamily
                        font.pixelSize: 10
                        font.weight: Font.DemiBold
                    }
                }

                // Week Number badge
                Rectangle {
                    Layout.preferredHeight: 18
                    Layout.preferredWidth: weekText.implicitWidth + 10
                    radius: 4
                    color: "#181a22"

                    Text {
                        id: weekText
                        anchors.centerIn: parent
                        text: "W" + root.getWeekNumber(root.selectedYear, root.selectedMonth, root.selectedDay)
                        color: StyleTokens.textMuted
                        font.family: root.textFontFamily
                        font.pixelSize: 10
                        font.weight: Font.DemiBold
                    }
                }
            }
        }
    }
}

/*
    SPDX-FileCopyrightText: 2016 David Edmundsson <davidedmundson@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
    Cyberpunk neon edit: time in #00ffcc with glow, date in soft cyan
*/

import QtQuick 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as Plasma5Support

ColumnLayout {
    readonly property bool softwareRendering: GraphicsInfo.api === GraphicsInfo.Software

    Item {
        id: timeWrapper
        Layout.alignment: Qt.AlignHCenter
        implicitWidth: timeLabel.implicitWidth + 30
        implicitHeight: timeLabel.implicitHeight + 30

        PlasmaComponents3.Label {
            id: timeLabel
            anchors.centerIn: parent
            text: Qt.formatTime(timeSource.data["Local"]["DateTime"])
            style: softwareRendering ? Text.Outline : Text.Normal
            styleColor: softwareRendering ? Kirigami.Theme.backgroundColor : "transparent"
            font.pointSize: 52
            color: "#00ffcc"
        }

        DropShadow {
            anchors.fill: timeLabel
            source: timeLabel
            visible: !softwareRendering
            horizontalOffset: 0
            verticalOffset: 0
            radius: 12
            samples: 24
            spread: 0.35
            color: "#00ffcc"
            opacity: 0.55
        }
    }

    PlasmaComponents3.Label {
        text: Qt.formatDate(timeSource.data["Local"]["DateTime"], Qt.DefaultLocaleLongDate)
        style: softwareRendering ? Text.Outline : Text.Normal
        styleColor: softwareRendering ? Kirigami.Theme.backgroundColor : "transparent"
        font.pointSize: 22
        color: "#9fe8dc"
        Layout.alignment: Qt.AlignHCenter
    }

    Plasma5Support.DataSource {
        id: timeSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 1000
    }
}

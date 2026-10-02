/*
    SPDX-FileCopyrightText: 2016 David Edmundson <davidedmundson@kde.org>
    SPDX-FileCopyrightText: 2022 Aleix Pol Gonzalez <aleixpol@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami as Kirigami

PlasmaComponents.ToolButton {
    id: root

    property int currentIndex: keyboard.currentLayout
    onCurrentIndexChanged: keyboard.currentLayout = currentIndex

    text: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Keyboard Layout: %1", keyboard.layouts[currentIndex].longName)
    visible: keyboard.layouts.length > 1
    leftPadding: Kirigami.Units.smallSpacing
    rightPadding: Kirigami.Units.smallSpacing

    // Explicit neon footer style (real greeter runs as 'sddm' — LIGHT global theme)
    contentItem: Text {
        text: root.text
        font: root.font
        color: (root.hovered || root.down || root.checked) ? "#00ffcc" : "#00aaff"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    background: Rectangle {
        radius: 3
        color: root.checked ? "#132038" : (root.hovered ? "#101a2e" : "transparent")
        border.width: 1
        border.color: (root.hovered || root.checked) ? "#003344" : "transparent"
    }

    checkable: true
    checked: menu.opened
    onToggled: {
        if (checked) {
            menu.popup(root, 0, 0)
        } else {
            menu.dismiss()
        }
    }

    signal keyboardLayoutChanged()

    PlasmaComponents.Menu {
        id: menu
        Kirigami.Theme.colorSet: Kirigami.Theme.Window
        Kirigami.Theme.inherit: false

        onAboutToShow: {
            if (instantiator.model === null) {
                let layouts = keyboard.layouts;
                layouts.sort((a, b) => a.longName.localeCompare(b.longName));
                instantiator.model = layouts;
            }
        }

        Instantiator {
            id: instantiator
            model: null
            onObjectAdded: menu.insertItem(index, object)
            onObjectRemoved: menu.removeItem(object)
            delegate: PlasmaComponents.MenuItem {
                text: modelData.longName
                onTriggered: {
                    keyboard.currentLayout = keyboard.layouts.indexOf(modelData)
                    root.keyboardLayoutChanged()
                }
            }
        }
    }
}

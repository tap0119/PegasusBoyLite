import QtQuick 2.15
import QtMultimedia 5.9

import "Components/Settings"

FocusScope {

    property alias currentIndex: menuRoot.currentIndex
    property alias menuListView: menuRoot.listView


    Item {

        id: menuRoot
        property alias currentIndex: menuListView.currentIndex
        property alias listView: menuListView

        ListView {
            id: menuListView

            focus: menuRoot.focus

            model: menuOptions
            delegate: menuListDelegate

            interactive: false
            clip: true
            currentIndex: root.currentmenuIndex

        }


        Component {
            id: menuListDelegate

            Rectangle {
                id: menuTextRect
                color: ListView.isCurrentItem ? themeData.colorTheme[theme].background : themeData.colorTheme[theme].background

                }
        }
    }

}

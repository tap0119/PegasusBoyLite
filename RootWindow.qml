import QtQuick 2.15
import SortFilterProxyModel 0.2
import QtMultimedia 5.9

import "Logger.js" as Logger

Item {
    id: rootWindow

	SoundEffect {
		id: forSound;
		source: 'assets/sound/forward.wav';
		volume: .25;
	}


    Keys.onPressed: {
        if (api.keys.isNextPage(event)) {
            event.accepted = true
            if(menuLoader.item.currentIndex < 3 && themeSettings.soundsmenu){
	    	forSound.play();
	    }
            menuItem.menuListView.incrementCurrentIndex()
            Logger.info("Menu Index: " + menuLoader.item.currentIndex)
            return
        }

        if (api.keys.isPrevPage(event)) {
            event.accepted = true
            if(menuLoader.item.currentIndex > 0 && (themeSettings.soundsmenu)){
	     	forSound.play();
	    }
            menuItem.menuListView.decrementCurrentIndex()
            Logger.info("Menu Index: " + menuLoader.item.currentIndex)
	    return
        }
    }

    Rectangle {
        id: background
        width: parent.width
        height: parent.height
        color: themeData.colorTheme[theme].background
    }

    property alias menuItem: menuLoader.item
    Loader {
        id: menuLoader
        focus: false
        width: parent.width
        height: parent.height * 0.1
        sourceComponent: menuComponent
	y: themeSettings.menuadjust      
	asynchronous: true
    }

    Component {
        id: menuComponent
        Menu {
            id: menu
            focus: menuLoader.focus
            currentIndex: themeSettings["menuIndex_main"]
        }
    }

    Loader {
        id: subHeaderLoader
        focus: false

    }

    property alias contentItem: contentLoader.item
    Loader {
        id: contentLoader
        focus: true
        sourceComponent: collectionsMenu
        asynchronous: true
        anchors {
            top: menuLoader.bottom
            bottomMargin: (themeSettings.gamesListCounter || themeSettings.showClock || themeSettings.showBattery) ? themeSettings.footerfontsize + 5 + (parent.height * 0.03) : parent.height * 0.03 
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
    }

    Component {
        id: collectionsMenu

        Item {

            anchors.fill: parent.fill

            Loader {
                id: collectionsMenuModelLoader
                sourceComponent: collectionsMenuProxyModel
                active: true

                onStatusChanged: {
                    if (collectionsMenuModelLoader.status == Loader.Ready) {
                        Logger.info("RootWindow:collectionsMenuModelLoader:LoaderReady")
                        gamesListMenuLoader.active = true
                    }
                }
            }

            Component {
                id: collectionsMenuProxyModel

                SortFilterProxyModel {

                    sourceModel: themeData.collectionsListModel
                    delayed: false
                    sorters: [
                        RoleSorter {
                            roleName: "sortBy"
                        }
                    ]

                    Component.onCompleted: {
                        Logger.info("collections proxy model: " + sourceModel.count)
                        //gamesListMenuLoader.active = true
                    }
                }
            }

            Loader {
                id: gamesListMenuLoader
                anchors.fill: parent
                focus: contentLoader.focus
                active: false
                sourceComponent: gamesListMenu
            }

            Component {
                id:gamesListMenu

                GamesListMenu {
                    focus: gamesListMenuLoader.focus
                    subMenuEnable: true
                    subMenuModel: collectionsMenuModelLoader.item
                    //gamesListModel: themeData.collectionsListModel.get(collectionsMenuListView.currentIndex).games
                    gamesListModel: currentCollection.games
                    menuName: rootWindow.state

                    Component.onCompleted: {
                        Logger.info("RootWindow:collectionsMenu:onCompleted");
                    }
                }
            }

        }
    }


    Component {
        id: favoritesMenu

        GamesListMenu {
            focus: contentLoader.focus
            subMenuEnable: false
            gamesListModel: api.allGames
            filterOnlyFavorites: true
            menuName: rootWindow.state
        }
    }

    property int size
    property bool showall

    Component {
        id: settingsMenu

        SettingsMenu {
            focus: contentLoader.focus

            Component.onCompleted:{
                size = themeSettings.menusize
                showall = themeSettings.collectionAllGames
            }

            Component.onDestruction:{
                //themeSettings.collectionAllGames != showall
                if(themeSettings.menusize != size){
                    menuLoader.active = !menuLoader.active
                    menuLoader.active = !menuLoader.active
                }
            }
        }
        
    }

    Component {
        id: lastPlayedMenu

        GamesListMenu {
            focus: contentLoader.focus
            subMenuEnable: false
            gamesListModel: api.allGames
            filterByDate: true
            menuName: rootWindow.state
        }
    }


    states: [
        State {
            name: "games"
            when: menuItem.currentIndex == 0
            changes: [
                PropertyChanges {
                    target: contentLoader
                    sourceComponent: collectionsMenu
                }
            ]
        },
        State {
            name: "favorites"
            when: menuItem.currentIndex == 1
            changes: [
                PropertyChanges {
                    target: contentLoader
                    sourceComponent: favoritesMenu
                }
            ]
        },
        State {
            name: "lastplayed"
            when: menuItem.currentIndex == 2
            changes: [
                PropertyChanges {
                    target: contentLoader
                    sourceComponent: lastPlayedMenu
                }
            ]
        },
        State {
            name: "settings"
            when: menuItem.currentIndex == 3
            PropertyChanges {
                target: contentLoader
                sourceComponent: settingsMenu
            }
        }
    ]

    onStateChanged: {
        Logger.info("rootWindow:stateChanged:state:" + state);
        if (menuItem !== null) {
            themeSettings["menuIndex_main"] = menuItem.currentIndex;
        }
    }

    Component.onCompleted: {
        Logger.info("rootWindow:onCompleted");
        if (menuItem !== null) {
            menuItem.currentIndex = themeSettings["menuIndex_main"];
        }
    }
}

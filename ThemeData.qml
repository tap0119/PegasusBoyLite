import QtQuick 2.15
import SortFilterProxyModel 0.2

import "Logger.js" as Logger

Item {

    // Add an All to the main collections model
    // Dynamically create a ListModel to keep compatability
    property alias collectionsListModel: collectionsListModel

    
    ListModel {
        id: collectionsListModel 

        Component.onCompleted: {
            const collections = api.collections
            const allCollection = {
                name: "All",
                shortName: "All",
                games: api.allGames
            }

            const favCollection = {
                name: "Favorites",
                shortName: "♥ Fav",
                games: api.allGames
            }

            const recentCollection = {
                name: "Recent",
                shortName: "Recent",
                games: api.allGames
            }

            collectionsListModel.append(favCollection)

            if(themeSettings.lastPlayedDays > 0) {
                collectionsListModel.append(recentCollection)
            }

            if (themeSettings.collectionAllGames) {
                collectionsListModel.append(allCollection)
            }

            for (var i=0; i < collections.count; ++i) {
                collectionsListModel.append(collections.get(i))
            }
        }
    }

    property var allGamesModel: {
        return api.allGames;
    }


    property var colorTheme: {
        "Green": {
            background: "#1c0118",
            primary: "#6bd425",
            secondary: "#618b25",
            light: "#618b25",
            dark: "#370926",
        },
        "Amber": {
            background: "#141514",
            primary: "#E0B700",
            secondary: "#A38500",
            light: "#A38500",
            dark: "#7A6400",
        },
        "Blue": {
            background: "#000814",
            primary: "#007AF5",
            secondary: "#007AF5",
            light: "#00478F",
            dark: "#073b4c",
        },
        "Purple": {
            background: "#0b0410",
            primary: "#9d5ed4",
            secondary: "#7f33c1",
            light: "#6f2da8",
            dark: "#401a61",
        },
        "Vampire": {
            background: "#242631",
            primary: "#a576ce",
            secondary: "#a576ce",
            light: "#7c52a0",
            dark: "#242631",
        },
         "White": {
            background: "#000000",
            primary: "#e9ecef",
            secondary: "#e9ecef",
            light: "#6c757d",
            dark: "#000000",
        },
        "Pink": {
            background: "#14010C",
            primary: "#CC125A",
            secondary: "#CC125A",
            light: "#EB1E6D",
            dark: "#280118",
        }
    }

    property var languageNames: {
        "en": "English"
    }

    // Language shortcodes https://www.science.co.il/language/Codes.php
    property var text: {
        "en": {
            "menu_collections": "Games",
            "menu_favorites": "Favorites",
            "menu_lastplayed": "Last Played",
            "menu_settings": "Settings"
        }
    }

    property var font: {
        "HackRegular": ""
    }

}

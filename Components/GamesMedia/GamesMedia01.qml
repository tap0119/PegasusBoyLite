import QtQuick 2.15
import QtGraphicalEffects 1.12

import "../Settings"

Item {

    required property var currentGame
    required property bool imagetype
    required property bool imagebigview

    property int marginoffset: (themeSettings.gamesListCounter || themeSettings.showClock || themeSettings.showBattery) ? themeSettings.footerfontsize + 5 : 0

    property var primary: (themeSettings.primaryAsset == "Title Screen") ? currentGame.assets.titlescreen : currentGame.assets.boxFront 
    property var secondary: (themeSettings.primaryAsset == "Title Screen") ? currentGame.assets.boxFront : currentGame.assets.titlescreen


    Image {
        id: gamesMediaScreenshot

        width: (imagebigview) ? parent.width/1.05: root.width / 2.1;
        height: (imagebigview) ? (parent.height +marginoffset)/2: root.height;
        x:(imagebigview) ? 0: parent.width - ((root.width*.98) * .5);
        y:(imagebigview) ? parent.height/2 + 5 + (marginoffset/2) : -70;

        asynchronous: true
        fillMode: Image.PreserveAspectFit
        sourceSize {
            width: width
            height: height
        }

        source: currentGame.assets.screenshot || ""
    }


    Image {
        id: gamesMediaTitle
        width: (imagebigview) ? parent.width/1.05: root.width / 2.1;
        height: (imagebigview) ? (parent.height +marginoffset)/2: root.height;
        x:(imagebigview) ? 0: parent.width - (root.width * .98);
        y:(imagebigview) ? 0: -70;

        asynchronous: true
        fillMode: Image.PreserveAspectFit
        sourceSize {
            width: width
            height: height
        }
       		 source: (imagetype) ? primary || secondary: secondary|| ""
    }



    Text {
        text: currentGame.title;
	color: themeData.colorTheme[theme].primary;
        opacity: (imagebigview) ? 0 : 1;
	width: root.width / 2.1
        x: parent.width - ((root.width*.98) * .5)
	y: parent.height - 25 + marginoffset
	font.bold: true
	//wrapMode:Text.WordWrap

	fontSizeMode: Text.HorizontalFit
 	font.pointSize: themeSettings.footerfontsize + 5
        font.family: "HackRegular"
    }




}
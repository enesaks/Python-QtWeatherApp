import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
    width: 800
    height: 300
    visible: true
    title: qsTr("Weather Condition")

    minimumWidth: 800
    maximumWidth: 800

    minimumHeight: 300
    maximumHeight: 300

    Rectangle {
        anchors.fill: parent
        color: "#F0F0F0"
    }

    WeatherLine {}
}

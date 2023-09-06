import QtQuick
import QtQuick.Controls

Item {
    property int day: 1
    property string iconstr: "none"
    property string daystr: "none"
    property string descriptionstr: "none"
    property string degreestr: "none"
    property string degreeminstr: "none"
    property string degreemaxstr: "none"
    property string humiditystr: "none"
    property string citystr: "Bolu"
    property var days: ["Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi", "Pazar"]

    //TODO TASARIMI YAP
    width: parent.width
    height: parent.height
    property alias searchBar: searchBar

    anchors.centerIn: parent

    Column {
        id: mainColumnId
        width: parent.width
        height: parent.height
        spacing: 20
        anchors.centerIn: parent
        anchors.top: parent
        anchors.topMargin: 10
        anchors.verticalCenterOffset: 0
        anchors.horizontalCenterOffset: 0

        TextField {
            id: searchBar
            placeholderText: "Şehir Giriniz..."

            background: Rectangle {
                width: parent.width
                height: parent.height
                color: "black"
                radius: 6
            }

            width: parent.width - 400
            height: 30

            anchors.horizontalCenter: parent.horizontalCenter

            Keys.onPressed: {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    btn.clicked()
                    searchBar.text = ""
                }
            }
        }

        Rectangle {
            // Weather Parth
            id: rectWeather
            width: parent.width
            height: 150
            color: "#F0F0F0"

            Row {
                spacing: 30
                anchors.centerIn: parent

                Image {
                    id: iconImage
                    source: iconstr
                    width: 100
                    height: 100
                    anchors.verticalCenter: parent.verticalCenter
                }

                Column {
                    spacing: 5
                    id: textColumId

                    Text {
                        id: txtCity
                        text: citystr
                        color: "black"
                        font.bold: true
                        font.pixelSize: 24
                    }

                    Text {
                        id: txtDay
                        text: daystr
                        color: "black"
                        font.bold: true
                        font.pixelSize: 20
                    }

                    Text {
                        id: txtDescription
                        text: descriptionstr
                        color: "black"
                        font.italic: true
                        font.pixelSize: 18
                    }

                    Row {
                        spacing: 15

                        Text {
                            id: txtDegree
                            text: degreestr
                            color: "black"
                            font.pixelSize: 18
                        }

                        Text {
                            id: txtDegreeMin
                            text: degreeminstr
                            color: "black"
                            font.pixelSize: 18
                        }

                        Text {
                            id: txtDegreeMax
                            text: degreemaxstr
                            color: "black"
                            font.pixelSize: 18
                        }
                    }

                    Text {
                        id: txtHumidity
                        text: humiditystr
                        color: "black"
                        font.pixelSize: 18
                    }
                }
            }
        }

        Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter

            ComboBox {
                id: daySelector
                width: 100
                height: 30
                model: days
                onCurrentIndexChanged: {
                    day = (currentIndex + 2) % 7
                }

                background: Rectangle {
                    color: "black"
                    radius: 5
                }
                Text {
                    text: control.currentText
                    font.pixelSize: 14
                    color: "black"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    leftPadding: 10
                    rightPadding: 10
                }
                indicator: Canvas {
                    id: canvas
                    width: 12
                    height: 8
                    contextType: "2d"
                    property var ctx: canvas.getContext("2d")
                }
            }

            Timer {
                id: timer
                interval: 1
                repeat: false

                onTriggered: {
                    btn.clicked()
                }
            }

            Button {
                id: btn
                text: "Seç"
                width: 100
                height: 30
                font.pixelSize: 14

                background: Rectangle {
                    color: "#007BFF"
                    radius: 5
                }
                Text {
                    text: control.text
                    font.pixelSize: 14
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.fill: parent
                }

                Component.onCompleted: {
                    timer.start()
                }
                onClicked: {
                    var searchText = searchBar.text

                    if (searchText !== "") {
                        citystr = searchText
                        console.log(searchText)
                    }
                    weatherDay.pull_api(citystr)
                    weatherDay.day_weather(day)
                    dayMain = day
                }
            }
        }
    }

    Connections {
        target: weatherDay

        function onDayName(day) {
            daystr = day
        }
        function onIcon(icon) {
            iconstr = icon
        }
        function onDescription(description) {
            descriptionstr = description
        }
        function onDegree(degree) {
            degreestr = "Derece: " + degree + "°C"
        }
        function onMinDegree(min) {
            degreeminstr = "Min Derece : " + min + "°C"
        }
        function onMaxDegree(max) {
            degreemaxstr = "Max Derece : " + max + "°C"
        }
        function onHumidity(humidity) {
            humiditystr = "Nem : %" + humidity
        }
        function onCity(city) {
            citystr = "Şehir" + city
        }
    }
}

# This Python file uses the following encoding: utf-8
import sys
import http.client
import json
from pathlib import Path


from PySide6.QtCore import QObject, Signal, Slot
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine


class WeatherReturn(QObject):
    def __init__(self):
        QObject.__init__(self)

    weather = {}
    weather_result = []
    day_weather_list = {}

    # Qml'e gönderilecek değişkenler...
    date = Signal(str, arguments="date")
    dayName = Signal(str, arguments="dayName")
    icon = Signal(str, arguments="icon")
    description = Signal(str, arguments="description".upper)
    degree = Signal(str, arguments="degree")
    minDegree = Signal(str, arguments="min")
    maxDegree = Signal(str, arguments="max")
    humidity = Signal(str, arguments="humidity")
    city = Signal(str, arguments="city")

    @Slot(str, result=str)
    def pull_api(self, city):  # Hava Durumu Verisini Çekiyo...
        conn = http.client.HTTPSConnection("api.collectapi.com")
        headers = {  # api authorization işlemini yapıyo.
            "content-type": "application/json",
            "authorization": "apikey 3iyagddq0py7h4qmDMkQiU:51aJu9h0IGgV8ZjLAP8aJo",
        }

        self.city = city

        conn.request(
            "GET",
            f"/weather/getWeather?data.lang=tr&data.city={city}",
            headers=headers,
        )

        res = conn.getresponse()
        data = res.read()

        # Json dosyasını anlamlı bir dictinary'e çeviriyo.
        self.weather = json.loads(data.decode("utf-8"))

        self.weather_result = self.weather["result"]

    @Slot(int, result=int)
    def day_weather(self, day):  # Gün gün veri veriyo...

        self.day = day
        self.day_weather_list = self.weather_result[self.day-1]

        print("Date:", self.day_weather_list["date"])
        print("Day Name:", self.day_weather_list["day"])

        self.date.emit(self.day_weather_list["date"])
        self.dayName.emit(self.day_weather_list["day"])
        self.icon.emit(self.day_weather_list["icon"])
        self.description.emit(self.day_weather_list["description"])
        self.degree.emit(self.day_weather_list["degree"])
        self.minDegree.emit(self.day_weather_list["min"])
        self.maxDegree.emit(self.day_weather_list["max"])
        self.humidity.emit(self.day_weather_list["humidity"])


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    qml_file = Path(__file__).resolve().parent / "main.qml"
    engine.load(qml_file)

    # Veri Gönderme Kısmı
    weather_day_api = WeatherReturn()
    engine.rootContext().setContextProperty("weatherDay", weather_day_api)

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())

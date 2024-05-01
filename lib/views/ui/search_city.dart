import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/utils/api_string.dart';

class SearchCity extends StatefulWidget {
  const SearchCity({super.key});

  @override
  State<SearchCity> createState() => _SearchCityState();
}

class _SearchCityState extends State<SearchCity> {
  final cityNameCon = TextEditingController();
  final WeatherFactory _wf = WeatherFactory(OpenWeather_Api_Key);

  Weather? _weather;

  Future<void> getData(String name) async {
    try {
      _wf.currentWeatherByCityName(name).then(
        (value) {
          setState(() {
            _weather = value;
            print(value);
            cityNameCon.clear();
          });
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                width: 310,
                height: 55,
                child: TextField(
                  controller: cityNameCon,
                  decoration: InputDecoration(
                      suffixIcon: InkWell(
                          onTap: () {
                            getData(cityNameCon.text.toString());
                          },
                          child: Icon(Icons.search)),
                      hintText: "Search City Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              _cityName(),
              SizedBox(
                height: 30,
              ),
              _weatherIcon(),
              SizedBox(
                height: 30,
              ),
              _currentTem(),
              SizedBox(
                height: 30,
              ),
              _extraInfo(),
            ],
          ),
        ),
      )),
    );
  }

  Widget _cityName() {
    if (_weather == null || _weather!.date == null) {
      return Container();
    } else {
      DateTime now = _weather!.date!;

      return SizedBox(
        height: 110,
        child: Column(
          children: [
            Text(
              _weather?.areaName ?? "",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              DateFormat("h:mm a").format(now).toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  DateFormat("EEEE").format(now),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  "  ${DateFormat(DateFormat.YEAR_MONTH_DAY).format(now).toString()}",
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            )
          ],
        ),
      );
    }
  }

  Widget _currentTem() {
    if (_weather == null || _weather!.temperature == null) {
      return Container();
    } else {
      return Text(
        "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
        style: TextStyle(
            fontSize: 90, color: Colors.black, fontWeight: FontWeight.w500),
      );
    }
    //   }
  }

  Widget _weatherIcon() {
    if (_weather == null ||
        _weather!.weatherIcon == null ||
        _weather!.weatherDescription == null) {
      return Container();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 0.20,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"),
                    scale: 1.0)),
          ),
          Text(
            _weather?.weatherDescription ?? "",
            style: const TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          )
        ],
      );
    }
  }

  Widget _extraInfo() {
    if (_weather == null ||
        _weather!.tempMax == null ||
        _weather!.tempMin == null ||
        _weather!.windSpeed == null ||
        _weather!.humidity == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Center(
            child: Container(
          child: Text(
            "☝️☝️☝️ Inter the City Name ☝️☝️☝️\n To Show About Weather Information ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        )),
      );
    } else {
      return Container(
        height: MediaQuery.sizeOf(context).height * 0.15,
        width: MediaQuery.sizeOf(context).width * 0.80,
        decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                Text(
                  "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                Text(
                  "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                )
              ],
            )
          ],
        ),
      );
    }
  }
}

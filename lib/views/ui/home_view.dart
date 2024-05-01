import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/utils/api_string.dart';
import 'package:weather_app/views/ui/search_city.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController nameCon = TextEditingController();
  final WeatherFactory _wf = WeatherFactory(OpenWeather_Api_Key);

  Weather? _weather;

  Future currentLocationweather() async {
    await _wf
        .currentWeatherByLocation(24.860966, 66.990501)
        .then((value) => setState(() {
              _weather = value;
            }));
  }

  @override
  void initState() {
    super.initState();
    currentLocationweather();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(left: 70),
              child: Center(
                  child: Text(
                "Weather App",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              )),
            ),
            backgroundColor: Colors.white12,
            elevation: 0,
            actions: [
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchCity()));
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.black,
                      )))
            ],
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Current Location",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
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

  Widget _extraInfo() {
    if (_weather == null ||
        _weather!.tempMax == null ||
        _weather!.tempMin == null ||
        _weather!.windSpeed == null ||
        _weather!.humidity == null) {
      return Center(
        child: CircularProgressIndicator(),
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

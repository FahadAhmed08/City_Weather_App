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
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 25,
              ),
              SizedBox(
                height: 25,
              ),
              _cityName(),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(DateFormat("h:mm a").format(now).toString()),
                SizedBox(
                  width: 8,
                ),
                Text(
                  DateFormat("EEEE").format(now).toString(),
                ),
              ],
            ),
            Text(
              DateFormat(DateFormat.YEAR_MONTH_DAY).format(now).toString(),
            ),
          ],
        ),
      );
    }
  }
}

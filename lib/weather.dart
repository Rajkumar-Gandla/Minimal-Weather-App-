import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weatherapp/models.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  final WeatherFactory _weatherFactory = WeatherFactory(WEATHER_API);
  Weather? _weather;
  String? _location;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        backgroundColor: Color.fromARGB(255, 85, 189, 170), // Premium color
      ),
      backgroundColor: Color.fromARGB(255, 83, 159, 169), // Premium color
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                focusColor: Colors.amber,
                filled: true,
                fillColor: const Color.fromARGB(255, 183, 217, 204),
                hintText: "Enter the city name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: Color(0xFF2C3E50)), // Premium color
                ),
              ),
              onSubmitted: (value) {
                setState(() {
                  _location = value;
                  _weatherFactory
                      .currentWeatherByCityName(_location!)
                      .then((value) {
                    setState(() {
                      _weather = value;
                    });
                  });
                });
              },
            ),
          ),
          SizedBox(
            height: 50,
          ),
          bodyui(),
        ],
      ),
    );
  }

  Widget bodyui() {
    if (_weather == null) {
      return Container(
        child: Center(child: Text("Welcome...")),
      );
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        //mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _locator(),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.05,
          ),
          _datetime(),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.05,
          ),
          _weathericon(),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.05,
          ),
          _currenttemp(),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.05,
          ),
          _maxmin(),
        ],
      ),
    );
  }

  Widget _locator() {
    return Text(
      _weather?.areaName ?? "",
      style:
          TextStyle(color: const Color.fromARGB(255, 63, 60, 64), fontSize: 30),
    );
  }

  Widget _datetime() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: TextStyle(
              color: const Color.fromARGB(255, 18, 18, 18), fontSize: 30),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEE").format(now),
              style: TextStyle(
                  color: const Color.fromARGB(255, 6, 6, 6), fontSize: 20),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              DateFormat("d.m.y").format(now),
              style: TextStyle(
                  color: const Color.fromARGB(255, 3, 3, 3), fontSize: 20),
            ),
          ],
        )
      ],
    );
  }

  Widget _weathericon() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.width * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
              ),
            ),
          ),
        ),
        Text(_weather?.weatherDescription ?? "",
            style: TextStyle(
                color: const Color.fromARGB(255, 73, 72, 72), fontSize: 20)),
      ],
    );
  }

  Widget _currenttemp() {
    return Text("${_weather?.temperature?.celsius?.toStringAsFixed(2)} °C",
        style: TextStyle(
            color: const Color.fromARGB(255, 11, 0, 0), fontSize: 30));
  }

  Widget _maxmin() {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 103, 157, 153),
            borderRadius: BorderRadius.circular(50)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(2)} °C",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  Text(
                    "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(2)}  °C",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Humidity : ${_weather?.humidity} %",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  Text(
                    "Wind : ${_weather?.windSpeed} m/s",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

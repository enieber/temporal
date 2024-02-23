import 'package:flutter/material.dart';
import 'package:temporal/models/weather_model.dart';
import 'package:temporal/services/log.dart';
import 'package:temporal/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

String getWeatherAnimation(String? mainCondition) {
  if (mainCondition == null) return 'assets/sunny.json'; // default to sunny

  switch (mainCondition.toLowerCase()) {
    case 'clouds':
    case 'mist':
    case 'smoke':
    case 'haze':
    case 'dust':
    case 'fog':
      return 'assets/cloud.json';
    case 'rain':
    case 'drizzle':
    case 'shower rain':
      return 'assets/rain.json';
    case 'thunderstorm':
      return 'assets/thunder.json';
    case 'clear':
      return 'assets/sunny.json';
    default:
      return 'assets/sunny.json';
  }
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('dd6d187f22bda5057596bf1591bde140');
  final log = logger;

  Weather? _weather;

  _fetchWeather() async {
    try {
      String cityName = await _weatherService.getCurrentCity();
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      debugPrint('city: $e');
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    if (_weather == null) {
      return Scaffold(body: Center(child: Lottie.asset('assets/loading.json')));
    }

    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(_weather?.cityName ?? "Loading city",
          style: TextStyle(
            fontSize: 35.0,
            fontWeight: FontWeight.w500,
          )),
      Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
      Text('${_weather?.temperature.round()}ºC',
          style: TextStyle(fontSize: 24.0)),
    ])));
  }
}

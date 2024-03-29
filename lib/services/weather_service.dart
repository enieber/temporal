import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:temporal/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:temporal/services/log.dart';

class WeatherService {
  static const BASE_URL = "http://api.openweathermap.org";
  final String apiKey;
  final log = logger;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(Uri.parse(
        '$BASE_URL/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Fail to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final longitude = position.longitude;
    final latitude = position.latitude;
    final places = await placemarkFromCoordinates(latitude, longitude);
    String? city = places[0].subAdministrativeArea;

    return city ?? "";
  }
}

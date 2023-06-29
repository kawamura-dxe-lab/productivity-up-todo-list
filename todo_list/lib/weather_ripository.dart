import 'package:dio/dio.dart';

Future<List<WeatherData>> fetchWeatherDataList() async {
  final weatherDataList = <WeatherData>[];

  // APIのURL
  const url =
      'https://api.open-meteo.com/v1/forecast?latitude=35.6785&longitude=139.6823&daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=Asia%2FTokyo';
  final response = await Dio().get<Map<dynamic, dynamic>>(url);
  // print(response);

  if (response.statusCode == 200) {
    if (response.data != null) {
      final data = response.data;

      final dailyData = data!['daily'];

      // WeatherDataオブジェクトに変換してリストに追加
      for (int i = 0; i < dailyData['time'].length; i++) {
        final timeString = dailyData['time'][i] as String;
        final weatherCode = dailyData['weathercode'][i] as int;
        final maxTemperature = dailyData['temperature_2m_max'][i] as double;
        final minTemperature = dailyData['temperature_2m_min'][i] as double;

        final time = DateTime.parse(timeString);
        final weatherData =
            WeatherData(time, weatherCode, maxTemperature, minTemperature);
        weatherDataList.add(weatherData);
      }
      // print(weatherDataList);
    } else {
      throw Exception('Data is not exist');
    }
  } else {
    throw Exception('Failed to load sentence');
  }

  return weatherDataList;
}

class WeatherData {
  final DateTime time;
  final int weatherCode;
  final double maxTemperature;
  final double minTemperature;

  WeatherData(
      this.time, this.weatherCode, this.maxTemperature, this.minTemperature);

  @override
  String toString() {
    return 'WeatherData(time: $time, weatherCode: $weatherCode, maxTemperature: $maxTemperature, minTemperature: $minTemperature)';
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

Future getData() async {
  String city = "Bikaner";
  String api = "your_api_key";
  try {
    final result = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$api'),
    );
    final data = jsonDecode(result.body);
    if (data['cod'] != '200') {
      throw 'Opps Something went wrong';
    } else {
      double temp = data['list'][0]['main']['temp'];
      String pressure = data['list'][0]['main']['pressure'].toString();
      String humidity = data['list'][0]['main']['humidity'].toString();
      String wind = data['list'][0]['wind']['speed'].toString();
      String weather = data['list'][0]['weather'][0]['main'];
      return [temp, weather,pressure,humidity,wind,data['list']];
    }
  } catch (e) {
    throw e.toString();
  }
}

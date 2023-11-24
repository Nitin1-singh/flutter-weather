import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_component.dart';
import 'package:weather_app/api/get_data.dart';
import 'package:weather_app/hourly_component.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0.0;
  String weather = "";
  String humidity = "";
  String windSpeed = "";
  String pressure = "";
  var hourlyForecast = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
                setState(() {});
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.hasData) {
            temp = snapshot.data[0];
            weather = snapshot.data[1];
            pressure = snapshot.data[2];
            humidity = snapshot.data[3];
            windSpeed = snapshot.data[4];
            hourlyForecast = snapshot.data[5];
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              //Main Card
              SizedBox(
                width: double.infinity,
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: [
                              Text(
                                "${(temp-273.15).toStringAsFixed(2).toString()} °C",
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              weather == "Rain" || weather == "Clouds"
                                  ? const Icon(
                                      Icons.cloud,
                                      size: 64,
                                    )
                                  : const Icon(
                                      Icons.sunny,
                                      size: 64,
                                    ),
                              Text(
                                weather,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              //weather card
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Weather Forecast",
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold))),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return HourlyForecastItem(
                        time: DateFormat.j().format(DateTime.parse(hourlyForecast[index + 1]['dt_txt'])).toString(),
                        temp: (hourlyForecast[index + 1]['main']['temp']-273.15).toStringAsFixed(2).toString(),
                        icon: hourlyForecast[index + 1]['weather'][0]['main'].toString() == 'Clouds' ||
                              hourlyForecast[index + 1]['weather'][0]['main'].toString() == "Rain"
                              ? Icons.cloud
                              : Icons.sunny,
                      );
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Additional Information",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInformation(
                      icon: (Icons.water_drop),
                      label: "Humidity",
                      temp: humidity),
                  AdditionalInformation(
                      icon: (Icons.air),
                      label: "Wind Speed",
                      temp: windSpeed),
                  AdditionalInformation(
                      icon: (Icons.beach_access),
                      label: "Pressure",
                      temp: pressure),
                ],
              )
            ]),
          );
        },
      ),
    );
  }
}

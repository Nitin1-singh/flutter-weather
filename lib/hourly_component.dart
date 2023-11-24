import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final String temp;
  final IconData icon;
  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.temp,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: 100,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
               const SizedBox(
                height: 5,
              ),
              Icon(icon),
              const SizedBox(
                height: 5,
              ),
              Text('$temp °C'),
            ],
          ),
        ),
      ),
    );
  }
}

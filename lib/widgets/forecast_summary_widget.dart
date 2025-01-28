import 'package:flutter/material.dart';
import 'package:weatherapp/scripts/forecast.dart' as forecast;

class ForecastSummaryWidget extends StatelessWidget {
  const ForecastSummaryWidget({
    super.key,
    required forecast.Forecast currentForecast,
  }) : _forecast = currentForecast;

  final forecast.Forecast _forecast;

  @override
  Widget build(BuildContext context) {
    // TODO: update this widget to look better
    // Use flutter documentation to help you
    // Try add spacing and a border around the outside
    // Update the text as well, so the name, forecast, and temperature have different formatting
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0), // Uniform radius
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                _forecast.name ?? "",
                style: TextStyle(fontWeight: FontWeight.bold),
                ),
              Text(
                _forecast.shortForecast,
                style: TextStyle(fontStyle: FontStyle.italic),
                ),
              Text(
                "${_forecast.temperature}${_forecast.temperatureUnit}"
                )
            ],
          ),
        ),
      ),
    );
  }
}

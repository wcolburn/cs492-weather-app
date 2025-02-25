import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/forecast_provider.dart';
import 'package:weatherapp/providers/dark_mode_provider.dart';

import 'package:weatherapp/widgets/location/location_widget.dart';
import 'package:weatherapp/widgets/forecast/forecast_summary/forecast_summaries_widget.dart';
import 'package:weatherapp/widgets/forecast/forecast_widget/forecast_widget.dart';

class ForecastTabWidget extends StatelessWidget {
  const ForecastTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var forecastProvider = Provider.of<ForecastProvider>(context);
    var darkModeProvider = Provider.of<DarkModeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            LocationWidget(),
            ForecastWidget(),
            Switch(
                value: darkModeProvider.isDarkMode,
                onChanged: (bool value) {
                  if (value == true) {
                    darkModeProvider.setDarkMode();
                  } else {
                    darkModeProvider.setLightMode();
                  }
            }),
            ForecastSummariesWidget(forecasts: forecastProvider.forecastsDaily),
            ForecastSummariesWidget(
                forecasts: forecastProvider.filteredForecastsHourly)
          ],
        ),
      ),
    );
  }
}

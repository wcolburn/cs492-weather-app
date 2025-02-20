import 'package:flutter/material.dart';
import 'package:weatherapp/scripts/forecast.dart' as forecast;
import 'package:weatherapp/widgets/forecast_tab/forecast_summary_widget.dart';


class ForecastSummariesWidget extends StatelessWidget {
  const ForecastSummariesWidget({
    super.key,
    required List<forecast.Forecast> forecasts,
    required Function setActiveForecast,
  }) : _forecasts = forecasts, _setActiveForecast = setActiveForecast;

  final List<forecast.Forecast> _forecasts;
  final Function _setActiveForecast;
  
  List<OnTapSummaryWidget> getForecastWidgets(){
    List<OnTapSummaryWidget> widgets = [];

    for (int i = 0; i < _forecasts.length; i++){
      widgets.add(OnTapSummaryWidget(forecasts: _forecasts, i: i, setActiveForecast: _setActiveForecast));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: getForecastWidgets()));
  }
}

class OnTapSummaryWidget extends StatelessWidget {
  const OnTapSummaryWidget({
    super.key,
    required List<forecast.Forecast> forecasts,
    required this.i,
    required Function setActiveForecast
  }) : _forecasts = forecasts, _setActiveForecast = setActiveForecast;

  final List<forecast.Forecast> _forecasts;
  final int i;
  final Function _setActiveForecast;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {_setActiveForecast(i);}, child: ForecastSummaryWidget(currentForecast: _forecasts[i]));
  }
}
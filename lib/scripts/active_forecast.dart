import 'package:weatherapp/scripts/forecast.dart' as forecast;
import 'package:weatherapp/scripts/location.dart' as location;

class ActiveForecast {

  ActiveForecast();

  List<forecast.Forecast> _forecastsHourly = [];
  List<forecast.Forecast> _filteredForecastsHourly= [];
  List<forecast.Forecast> _forecasts = [];
  List<forecast.Forecast> _dailyForecasts = [];

  

}
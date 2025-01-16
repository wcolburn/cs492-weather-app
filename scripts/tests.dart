import './forecast.dart' as forecast;

Future<void> main() async {
  // testing with Bend, OR coordinates
  double lat = 44.05;
  double lon = -121.31;
  // TODO: Seach for latitutes and longitudes of 5 cities in the US on the internet
  // Create a for loop that will generate forecasts arrays for each city

  List<List<double>> coords = [
    [44.05, -121.31],
    [40.71, -74.006],
    [41.878, -87.629],
    [25.7617, -80.1918],
    [35.0844, -106.65]
  ];

  // TODO: create forecasts and forecastsHourly both of type List<forecast.Forecast>
  for (List<double> coord in coords) {
    List<forecast.Forecast> forecasts = await forecast.getForecastFromPoints(coord[0], coord[1]);
    List<forecast.Forecast> forecastsHourly = await forecast.getForecastHourlyFromPoints(coord[0], coord[1]);
    print("Oh");
  }
}
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Forecast{
  final String? name;
  final bool isDaytime;
  final int temperature;
  final String temperatureUnit;
  final String windSpeed;
  final String windDirection;
  final String shortForecast;
  final String detailedForecast;
  final int? precipitationProbability;
  final int? humidity;
  final num? dewpoint;

  Forecast({
    required this.name,
    required this.isDaytime,
    required this.temperature,
    required this.temperatureUnit,
    required this.windSpeed,
    required this.windDirection,
    required this.shortForecast,
    required this.detailedForecast,
    required this.precipitationProbability,
    required this.humidity,
    required this.dewpoint,
  });

  factory Forecast.fromJson(Map<String, dynamic> json){
    return Forecast(
      name: json["name"].length > 0? json["name"] : null,
      isDaytime: json["isDaytime"],
      temperature: json["temperature"],
      temperatureUnit: json["temperatureUnit"],
      windSpeed: json["windSpeed"],
      windDirection: json["windDirection"],
      shortForecast: json["shortForecast"],
      detailedForecast: json["detailedForecast"],
      precipitationProbability: json["probabilityOfPrecipitation"]["value"],
      humidity: json["relativeHumidity"] != null ? json["relativeHumidity"]["value"] : null,
      dewpoint: json["dewpoint"]?["value"],
    );
  }

  // TODO: Finish the toString() function, printing every value
  @override
  String toString(){
    return "name: ${name ?? "None"}\n" // TODO: if this is null, print "None"
      "isDaytime: ${isDaytime ? "Yes" : "No"}\n"
      "temperature: ${temperature}\n"
      "temperatureUnit: ${temperatureUnit}\n"
      "windSpeed: ${windSpeed}\n"
      "windDirection: ${windDirection}\n"
      "shortForecast: ${shortForecast}\n"
      "detailedForecast: ${detailedForecast}\n"
      "preciptationProbability: ${precipitationProbability}\n"
      "humidity: ${humidity ?? "None"}"
      "dewpoint: ${dewpoint ?? "None"}";
  }
}

Future<List<Forecast>> getForecastFromPoints(double lat, double lon) async{
  // TODO: Update this function to return a list of forecasts
  // make a request to the weather api using the latitude and longitude and decode the json data
  String pointsUrl = "https://api.weather.gov/points/${lat},${lon}";
  Map<String, dynamic> pointsJson = await getRequestJson(pointsUrl);

  // pull the forecast URL from the response json
  String forecastUrl = pointsJson["properties"]["forecast"];

  // make a request to the forecastJson url and decode the json data
  Map<String, dynamic> forecastJson = await getRequestJson(forecastUrl);

  return processForecasts(forecastJson["properties"]["periods"]);
}

Future<List<Forecast>> getForecastHourlyFromPoints(double lat, double lon) async{
  // TODO: Update this function to return a list of forecasts
  // make a request to the weather api using the latitude and longitude and decode the json data
  String pointsUrl = "https://api.weather.gov/points/${lat},${lon}";
  Map<String, dynamic> pointsJson = await getRequestJson(pointsUrl);

  // pull the forecastHourly URL from the response json
  String forecastHourlyUrl = pointsJson["properties"]["forecastHourly"];

  // make a request to the forecastHourlyJson url and decode the json data
  Map<String, dynamic> forecastHourlyJson = await getRequestJson(forecastHourlyUrl);

  return processForecasts(forecastHourlyJson["properties"]["periods"]);
}

List<Forecast> processForecasts(List<dynamic> forecasts){
  // TODO: Change this function to return a List of Forecast Objects
  List<Forecast> forecastObjs = <Forecast>[];
  for (dynamic forecast in forecasts){
    Forecast forecastObj = Forecast.fromJson(forecast);
    forecastObjs.add(forecastObj);
  }
  return forecastObjs;
}

void processForecast(Map<String, dynamic> forecast){
  String forecastName = forecast["name"];
  bool isDaytime = forecast["isDaytime"];
  int temperature = forecast["temperature"];
  String tempUnit = forecast["temperatureUnit"];
  String windSpeed = forecast["windSpeed"];
  String windDirection = forecast["windDirection"];
  String shortForecast = forecast["shortForecast"];
  String detailedForecast = forecast["detailedForecast"];
  int? preciptationProb = forecast["probabilityOfPrecipitation"]["value"] ?? null;
  int? humidity = forecast["relativeHumidity"] != null ? forecast["relativeHumidity"]["value"] : null;
  num? dewpoint = forecast["dewpoint"]?["value"];

  Forecast forecastObj = Forecast(
    name: forecastName, 
    isDaytime: isDaytime, 
    temperature: temperature, 
    temperatureUnit: tempUnit, 
    windSpeed: windSpeed, 
    windDirection: windDirection, 
    shortForecast: shortForecast, 
    detailedForecast: detailedForecast, 
    precipitationProbability: preciptationProb, 
    humidity: humidity, 
    dewpoint: dewpoint);

  print(forecastObj);

  return;
}


Future<Map<String, dynamic>> getRequestJson(String url) async{
  http.Response r = await http.get(Uri.parse(url));
  return convert.jsonDecode(r.body);
}
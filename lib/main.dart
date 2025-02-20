import 'package:flutter/material.dart';

import 'package:weatherapp/scripts/location.dart' as location;
import 'package:weatherapp/scripts/forecast.dart' as forecast;
import 'package:weatherapp/scripts/time.dart' as time;
import 'package:weatherapp/widgets/forecast_tab/forecast_tab_widget.dart';
import 'package:weatherapp/widgets/location_tab/location_tab_widget.dart';
import 'package:weatherapp/scripts/active_forecast.dart';

// TODO: With a partner, refactor the entire codebase (not just main.dart, every file)
// You should be looking for opportunities to make the code better
// Examples include (but are not limited to): Abstraction, Code Structure, Naming Conventions, Code Optimization, Redundant Code Removal, File names/directories
// You should be working with a partner. One person should be making changes to the code and the other should be documenting those changes in documentation/refactor.txt

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String title = 'CS492 Weather App';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WeatherForecastsHomePage(title: title),
    );
  }
}

class WeatherForecastsHomePage extends StatefulWidget {
  const WeatherForecastsHomePage({super.key, required this.title});

  final String title;

  @override
  State<WeatherForecastsHomePage> createState() => _WeatherForecastsHomePageState();
}

class _WeatherForecastsHomePageState extends State<WeatherForecastsHomePage> {

  // List<forecast.Forecast> _forecastsHourly = [];
  // List<forecast.Forecast> _filteredForecastsHourly= [];
  // List<forecast.Forecast> _forecasts = [];
  // List<forecast.Forecast> _dailyForecasts = [];
  ActiveForecast _activeForecast = ActiveForecast();
  location.Location? _location;

  @override
  void initState() {
    super.initState();
    if (_location == null){
      setInitialLocation();
    }
  }

  void setInitialLocation() async {
    setLocation(await location.getLocationFromGps());
  }

  void setActiveForecast(int i){
    setState(() {
      _filteredForecastsHourly = getHourlyForecastsForDay(i);
      _activeForecast = _dailyForecasts[i];
    });
  }

  void setActiveHourlyForecast(int i){
    setState(() {
      _activeForecast = _filteredForecastsHourly[i];
    });
  }

  void setDailyForecasts(){
    List<forecast.Forecast> dailyForecasts = [];
    for (int i = 0; i < _forecasts.length-1; i+=2){
      dailyForecasts.add(forecast.getForecastDaily(_forecasts[i], _forecasts[i+1]));
      
    }
    setState(() {
      _dailyForecasts = dailyForecasts;
    });
  }

  List<forecast.Forecast> getHourlyForecastsForDay(int dayIndex){
    return _forecastsHourly.where((f)=>time.equalDates(f.startTime, _dailyForecasts[dayIndex].startTime)).toList();
  }

  void setLocation(location.Location? currentLocation) async {
    if (currentLocation == null){
      setState(() {
        _location = null;
      });
    }
    else {
      List<forecast.Forecast> currentHourlyForecasts = await forecast.getForecastHourlyFromPoints(currentLocation.latitude, currentLocation.longitude);
      List<forecast.Forecast> currentForecasts = await forecast.getForecastFromPoints(currentLocation.latitude, currentLocation.longitude);
      setState((){
        _location = currentLocation;
        _forecastsHourly = currentHourlyForecasts;
        _forecasts = currentForecasts;
        setDailyForecasts();
        _filteredForecastsHourly = getHourlyForecastsForDay(0);
        _activeForecast = _forecastsHourly[0];
      });
      }

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.sunny_snowing)),
              Tab(icon: Icon(Icons.edit_location_alt))
            ]
          )
        ),
        body:TabBarView(
          children: [ForecastTabWidget(
            activeLocation: _location, 
            activeForecast: _activeForecast,
            dailyForecasts: _dailyForecasts,
            filteredForecastsHourly: _filteredForecastsHourly,
            setActiveForecast: setActiveForecast,
            setActiveHourlyForecast: setActiveHourlyForecast),
          LocationTabWidget(setLocation: setLocation, activeLocation: _location)]
        ),
      ),
    );
  }
}
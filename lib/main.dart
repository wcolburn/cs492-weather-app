import 'package:flutter/material.dart';

import 'package:weatherapp/scripts/location.dart' as location;
import 'package:weatherapp/scripts/forecast.dart' as forecast;
import 'package:weatherapp/widgets/forecast_summaries_widget.dart';
import 'package:weatherapp/widgets/forecast_widget.dart';
import 'package:weatherapp/widgets/location_widget.dart';

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<forecast.Forecast> _forecastsHourly = [];
  // TODO create a new variable for _forecasts
  List<forecast.Forecast> _forecasts = [];
  forecast.Forecast? _activeForecast;
  location.Location? _location;

  @override
  void initState() {
    super.initState();
    setLocation();

  }

  Future<List<forecast.Forecast>> getHourlyForecasts(location.Location currentLocation) async {
    return forecast.getForecastHourlyFromPoints(currentLocation.latitude, currentLocation.longitude);
  }

  // TODO: create a new function getForecasts that returns forecast.getForecastFromPoints
  Future<List<forecast.Forecast>> getForecasts(location.Location currentLocation) async {
    return forecast.getForecastFromPoints(currentLocation.latitude, currentLocation.longitude);
  }

  void setActiveHourlyForecast(int i){
    setState(() {
      _activeForecast = _forecastsHourly[i];
    });
  }

  // create a new function: setActiveHourlyForecast that updates _activeForecast with _forecasts[i]
  void setActiveForecast(int i){
    setState(() {
      _activeForecast = _forecasts[i];
    });
  }



  void setLocation() async {
    if (_location == null){
      location.Location currentLocation = await location.getLocationFromGps();

      List<forecast.Forecast> currentHourlyForecasts = await getHourlyForecasts(currentLocation);
      List<forecast.Forecast> currentForecasts = await getForecasts(currentLocation);

      setState(() {
        _location = currentLocation;
        _activeForecast = currentHourlyForecasts[0];
        _forecastsHourly = currentHourlyForecasts;
        _forecasts = currentForecasts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
          child: Column(
            children: [
              LocationWidget(location: _location),
              _activeForecast != null ? ForecastWidget(forecast: _activeForecast!) : Text(""),
              // TODO add a new ForecastSummariesWidget for the daily forecasts
              _forecasts.isNotEmpty ? ForecastSummariesWidget(forecasts: _forecasts, setActiveForecast: setActiveForecast) : Text(""),
              _forecastsHourly.isNotEmpty ? ForecastSummariesWidget(forecasts: _forecastsHourly.where((forecast) => 
          forecast.startTime?.substring(1,11) == _activeForecast?.startTime?.substring(1,11)).toList(), setActiveForecast: setActiveHourlyForecast) : Text(""),
            ],
          ),
        ),
      ),
    );
  }

}

// TODO: This will require some research
// When a forecast is set from the daily forecasts (_forecasts), 
// filter the hourly forecasts to only include forecasts with the same startDate (not including time) as the activeForecast


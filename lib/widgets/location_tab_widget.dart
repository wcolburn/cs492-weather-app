import 'package:flutter/material.dart';
import 'package:weatherapp/scripts/location.dart' as location;
import 'package:weatherapp/scripts/location_database.dart' as location_database;

// TODO: Use the new location.database.dart logic to get the locations
// update the addLocations function to only add a single location instead of the entire list of _saved locations
// add delete buttons to the weather widgets
// use those to delete
// you will need to add a delete function to the location_database.dart class
class LocationTabWidget extends StatefulWidget {
  const LocationTabWidget({
    super.key,
    required Function setLocation,
    required location.Location? activeLocation
  }) : _setLocation = setLocation, _location = activeLocation;

  final Function _setLocation;
  final location.Location? _location;

  @override
  State<LocationTabWidget> createState() => _LocationTabWidgetState();
}

class _LocationTabWidgetState extends State<LocationTabWidget> {

  late location_database.LocationDatabase _db;

  List<location.Location> _savedLocations = [];



  void _setLocationFromAddress(String city, String state, String zip) async {
    // set location to null temporarily while it finds a new location
    widget._setLocation(null);
    location.Location currentLocation = await location.getLocationFromAddress(city, state, zip) as location.Location;
    widget._setLocation(currentLocation);
    _addLocation(currentLocation);
  }

  void _setLocationFromGps() async {
    // set location to null temporarily while it finds a new location
    widget._setLocation(null);
    location.Location currentLocation = await location.getLocationFromGps();
    widget._setLocation(currentLocation);
  }

  
  // void _addLocation(location.Location location) async{
  //   setState(() {
  //     _savedLocations.add(location);
  //   });

  //   await ls.writeLocations(_savedLocations);
    
  // }

  void _addLocation(location.Location location) async {
    setState(() {
      _savedLocations.add(location);
    });
    _db.insertLocation(location);
  }

  void _deleteLocation(location.Location location) async {
    setState(() {
      _savedLocations.remove(location);
    });
    _db.deleteLocation(location);
  }

  @override
  void initState() {
    // Get initial locations
    super.initState();
    _loadLocations();
  }

  void _loadLocations() async {
    _db = await location_database.LocationDatabase.open();
    List<location.Location> locations = await _db.getLocations();
    setState(() {
      _savedLocations = locations;
    });
  }

  // void _loadLocations() async {
  //   List<location.Location> locations = await ls.readLocations();
  //   setState(() {
  //     _savedLocations = locations;
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LocationDisplayWidget(activeLocation: widget._location),
        LoctionInputWidget(setLocation: _setLocationFromAddress), // pass in _addLocation
        ElevatedButton(onPressed: ()=>{_setLocationFromGps()},child: const Text("Get From GPS")),
        SavedLocationsWidget(locations: _savedLocations, setLocation: widget._setLocation, deleteLocation: _deleteLocation,)
      ],
    );
  }
}

class SavedLocationsWidget extends StatelessWidget {
  const SavedLocationsWidget({
    super.key,
    required List<location.Location> locations,
    required Function setLocation,
    required Function deleteLocation,
  }) : _locations = locations, _setLocation = setLocation, _deleteLocation = deleteLocation;

  final List<location.Location> _locations;
  final Function _setLocation;
  final Function _deleteLocation;

  @override
  Widget build(BuildContext context) {
    return Column(children: _locations.map((loc)=>SavedLocationWidget(loc: loc, setLocation: _setLocation, deleteLocation: _deleteLocation,)).toList(),);
  }
}

class SavedLocationWidget extends StatelessWidget {
  const SavedLocationWidget({
    super.key,
    required location.Location loc,
    required Function setLocation,
    required Function deleteLocation,
  }) : _loc = loc, _setLocation = setLocation, _deleteLocation = deleteLocation;

  final location.Location _loc;
  final Function _setLocation;
  final Function _deleteLocation;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(onTap: () {_setLocation(_loc);}, child: Text("${_loc.city}, ${_loc.state} ${_loc.zip}")),
        FloatingActionButton(onPressed: () {_deleteLocation(_loc);}, child: Text("Delete"))
      ],
    );
  }
  
}

class LocationDisplayWidget extends StatelessWidget {
  const LocationDisplayWidget({
    super.key,
    required location.Location? activeLocation
  }) : _location = activeLocation;

  final location.Location? _location;

  @override
  Widget build(BuildContext context) {
    return Text(_location != null ? "${_location.city}, ${_location.state} ${_location.zip}" : "No Location Set");
  }
}

class LoctionInputWidget extends StatefulWidget {
  const LoctionInputWidget({
    super.key,
    required Function setLocation,
  }) : _setLocation = setLocation;

  final Function _setLocation;

  @override
  State<LoctionInputWidget> createState() => _LoctionInputWidgetState();
}

class _LoctionInputWidgetState extends State<LoctionInputWidget> {

  // values
  late String _city;
  late String _state;
  late String _zip;
  
  @override
  void initState() {
    super.initState();
    _city = "";
    _state = "";
    _zip = "";

  }

  // update functions
  void _updateCity(String value){
    _city = value;
  }

  void _updateState(String value){
    _state = value;
  }

  void _updateZip(String value){
    _zip = value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              LocationTextWidget(width: 100, text: "city", updateText: _updateCity),
              LocationTextWidget(width: 75, text: "state", updateText: _updateState),
              LocationTextWidget(width: 100, text: "zip", updateText: _updateZip),
            ],
          ),
          ElevatedButton(onPressed: () {widget._setLocation(_city, _state, _zip);}, child: Text("Get From Address"))
        ],
      ),
    );
  }
}

class LocationTextWidget extends StatefulWidget {
  const LocationTextWidget({
    super.key,
    required double width,
    required String text,
    required Function updateText
  }): _width = width, _text = text, _updateText = updateText;

  final double _width;
  final String _text;
  final Function _updateText;

  @override
  State<LocationTextWidget> createState() => _LocationTextWidgetState();
}

class _LocationTextWidgetState extends State<LocationTextWidget> {

  // controllers
  late TextEditingController _controller;

  // initialize Controllers
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget._width,
      child: TextField(
        controller: _controller,
        onChanged: (value) => {widget._updateText(value)},
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: widget._text
      )),
    );
  }
}
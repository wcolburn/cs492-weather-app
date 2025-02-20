import 'package:flutter/material.dart';
import 'package:weatherapp/scripts/location.dart' as location;
import 'package:weatherapp/widgets/location_tab/saved_location_widget.dart';

class SavedLocationsWidget extends StatelessWidget {
  const SavedLocationsWidget(
      {super.key,
      required List<location.Location> locations,
      required Function setLocation,
      required Function deleteLocation,
      required bool editMode})
      : _locations = locations,
        _setLocation = setLocation,
        _deleteLocation = deleteLocation,
        _editMode = editMode;

  final List<location.Location> _locations;
  final Function _setLocation;
  final Function _deleteLocation;
  final bool _editMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _locations
          .map((loc) => SavedLocationWidget(loc: loc, setLocation: _setLocation, delete: _deleteLocation, editMode: _editMode)).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:weatherapp/scripts/location.dart' as location;

class SavedLocationWidget extends StatelessWidget {
  const SavedLocationWidget(
      {super.key,
      required location.Location loc,
      required Function delete,
      required Function setLocation,
      required bool editMode})
      : _loc = loc,
        _del = delete,
        _setLocation = setLocation,
        _editMode = editMode;

  final location.Location _loc;
  final Function _setLocation;
  final Function _del;
  final bool _editMode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _setLocation(_loc);
        },
        child: Container(
          margin: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: _editMode ? Colors.red : Colors.black, width: 2)),
          child: _editMode ? SavedLocationEditWidgetBody(delete: _del, loc: _loc) : SavedLocationWidgetBody(loc: _loc),
        ));
  }
}

class SavedLocationWidgetBody extends StatelessWidget {
  const SavedLocationWidgetBody({
    super.key,
    required location.Location loc,
  }) : _loc = loc;

  final location.Location _loc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
          width: 250,
          child: Text("${_loc.city}, ${_loc.state} ${_loc.zip}")),
    );
  }
}

class SavedLocationEditWidgetBody extends StatelessWidget {
  const SavedLocationEditWidgetBody({
    super.key,
    required location.Location loc,
    required Function delete,
  }) : _loc = loc, _delete = delete;

  final location.Location _loc;
  final Function _delete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(width: 250, child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${_loc.city}, ${_loc.state} ${_loc.zip}"),
          GestureDetector(
            onTap: (){_delete(_loc);}, 
            child: Icon(Icons.delete, color: Colors.red))
        ],
      )),
    );
  }
}
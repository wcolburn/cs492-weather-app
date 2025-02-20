import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              LocationTextWidget(
                  width: 100, text: "city", updateText: (value) => _city = value),
              LocationTextWidget(
                  width: 75, text: "state", updateText: (value) => _state = value),
              LocationTextWidget(
                  width: 100, text: "zip", updateText: (value) => _zip = value),
            ],
          ),
          ElevatedButton(
              onPressed: () {
                widget._setLocation(_city, _state, _zip);
              },
              child: Text("Get From Address"))
        ],
      ),
    );
  }
}

class LocationTextWidget extends StatefulWidget {
  const LocationTextWidget(
      {super.key,
      required double width,
      required String text,
      required Function updateText})
      : _width = width,
        _text = text,
        _updateText = updateText;

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
              border: OutlineInputBorder(), labelText: widget._text)),
    );
  }
}

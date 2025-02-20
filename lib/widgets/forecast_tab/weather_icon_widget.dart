import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class WeatherIconWidget extends StatelessWidget {
  const WeatherIconWidget({
    super.key,
    required String iconPath,
    required double height,
    required double width,
  }) : _iconPath = iconPath, _height = height, _width = width;

  final String _iconPath;
  final double _height;
  final double _width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SvgPicture.asset(_iconPath, height: _height, width: _width),
    );
  }
}
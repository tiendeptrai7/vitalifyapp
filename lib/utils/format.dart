import 'package:flutter/cupertino.dart';

BorderRadius borderRadius(
    double topLeft, double topRight, double bottomRight, double bottomLeft) {
  return BorderRadius.only(
    topLeft: Radius.circular(topLeft),
    topRight: Radius.circular(topRight),
    bottomRight: Radius.circular(bottomRight),
    bottomLeft: Radius.circular(bottomLeft),
  );
}
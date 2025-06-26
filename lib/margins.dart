import 'package:flutter/cupertino.dart';

EdgeInsets quizMargins(Size size) {
  return EdgeInsets.only(
    left: size.width / 16,
    right: size.width / 20,
  );
}

EdgeInsets activitiesMargins(Size size) {
  return EdgeInsets.only(
    left: size.width / 20,
    right: size.width / 20,
    top: size.height / 10,
  );
}
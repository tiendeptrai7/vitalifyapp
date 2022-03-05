import 'package:flutter/material.dart';

import '../app_colors.dart';


class KTextStyle {
  static const headerTextStyle = TextStyle(
      color: AppColors.whiteShade, fontSize: 28, fontWeight: FontWeight.w700);

  static const textFieldHeading =
      TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500);

  static const textFieldHintStyle = TextStyle(
      color: AppColors.hintText, fontSize: 14, fontWeight: FontWeight.w500);

  static const authButtonTextStyle = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.whiteShade);
}
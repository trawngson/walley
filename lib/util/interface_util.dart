import 'package:flutter/material.dart';

class InterfaceUtil {
  /// Returns the appropriate left and right padding based on the screen's dimensions
  /// If on a phone, the padding length will be less than e.g. on a computer.
  static double getResponsivePaddingLength(BuildContext context,
      {double offset = 0}) {
    return MediaQuery.of(context).size.width * 0.15 + offset;
  }

  static EdgeInsets getResponsivePadding(BuildContext context,
      {double offset = 0}) {
    return EdgeInsets.only(
      left: getResponsivePaddingLength(context, offset: offset),
      right: getResponsivePaddingLength(context, offset: offset),
    );
  }
}

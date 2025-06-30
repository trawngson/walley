import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GlobalVariable {
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();

  static final image = SvgPicture.asset(
    'assets/transparent_logo.svg',
    semanticsLabel: 'Transparent Logo',
  );
  static final textLogo = SvgPicture.asset(
    'assets/text_logo.svg',
    semanticsLabel: 'Text Logo',
  );
}

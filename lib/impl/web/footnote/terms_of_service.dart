import 'package:flutter/material.dart';
import 'package:walley/util/interface_util.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Padding(
        padding: InterfaceUtil.getResponsivePadding(context),
      ) as PreferredSizeWidget,
    );
  }
}

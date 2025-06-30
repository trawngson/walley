import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:walley/util/interface_util.dart';

class WebAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WebAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: InterfaceUtil.getResponsivePadding(context),
      child: AppBar(
        forceMaterialTransparency: true,
        leading: SvgPicture.asset(
          'assets/text_logo.svg',
          semanticsLabel: 'Text Logo',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => {},
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(
                    color: Theme.of(context).hintColor.withAlpha(90),
                  ),
                ),
              ),
            ),
            child: const Text(
              "Log in",
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:walley/gobal.dart';

class WebRoot extends StatelessWidget {
  const WebRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: SvgPicture.asset(
            'assets/text_logo.svg',
            semanticsLabel: 'Text Logo',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: ElevatedButton(
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
                "Sign in",
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Financial management",
              textScaler: TextScaler.linear(3),
            ),
            Text(
              "at ease.",
              textScaler: TextScaler.linear(3),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

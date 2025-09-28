import 'package:flutter/material.dart';

class UiKit {
  static BoxDecoration gradientCard(ColorScheme scheme, Color a, Color b) =>
      BoxDecoration(
        gradient: LinearGradient(
          colors: [a.withOpacity(.85), b.withOpacity(.70)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: a.withOpacity(.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      );

  static InputDecoration roundedInput(BuildContext context, String label,
      {Widget? prefixIcon, String? hint,}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      prefixIcon: prefixIcon,
    );
  }
}

import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Vietnamese Dong currency formatting utilities
final NumberFormat _vndNumberFormat = NumberFormat.currency(
  locale: 'vi_VN',
  symbol: '₫',
  decimalDigits: 0,
);

String formatCurrencyVND(num amount, {bool symbolAtEnd = true}) {
  final raw = _vndNumberFormat.format(amount);
  if (!symbolAtEnd) return raw; // default returns symbol first
  final sym = _vndNumberFormat.currencySymbol; // ₫
  if (raw.startsWith(sym)) {
    return '${raw.substring(sym.length).trim()} $sym';
  }
  return raw;
}

String formatCurrencyVNDNullable(num? amount, {bool symbolAtEnd = true}) =>
    amount == null ? '-' : formatCurrencyVND(amount, symbolAtEnd: symbolAtEnd);

/// Responsive text for large VND amounts that adapts to width & height to avoid overflow.
class ResponsiveVndAmount extends StatelessWidget {
  final num amount;
  final bool negative;
  final TextStyle? style;
  final bool symbolAtEnd;
  const ResponsiveVndAmount(
    this.amount, {
    super.key,
    this.negative = false,
    this.style,
    this.symbolAtEnd = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth.isFinite ? constraints.maxWidth : 400;
        final maxH = constraints.maxHeight.isFinite ? constraints.maxHeight : 120;
        // Derive a font size capped by height & width.
        double fsFromWidth = maxW / 9; // heuristic: 9 chars typical
        double fsFromHeight = maxH * .38; // keep within card
        double fontSize = math.max(24, math.min(48, math.min(fsFromWidth, fsFromHeight)));
        final base = style ?? Theme.of(context).textTheme.displaySmall;
        return FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            (negative ? '-' : '') + formatCurrencyVND(amount, symbolAtEnd: symbolAtEnd),
            style: base?.copyWith(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                  height: 1.05,
                ) ??
                TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                  height: 1.05,
                ),
          ),
        );
      },
    );
  }
}

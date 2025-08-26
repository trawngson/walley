import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:walley/util/currency_util.dart';
import 'package:walley/util/user_util.dart';
import 'package:walley/impl/ui/home/impl/balance_widget.dart' show summaryCardHeight, amountSectionHeight;

class TotalSpentWidget extends StatefulWidget {
  const TotalSpentWidget({super.key});
  @override
  State<TotalSpentWidget> createState() => _TotalSpentWidgetState();
}

class _TotalSpentWidgetState extends State<TotalSpentWidget> {
  int _today = 0;
  List<int> _recent = List.filled(
      7, 0); // mock distribution until real history aggregator is used
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final today = await UserUtil.fetchTotalSpent();
    final rnd = math.Random(today + DateTime.now().millisecondsSinceEpoch ~/ 60000);
    // Base ensures some scale for visual even if today is 0
    final base = today <= 0 ? 5000 : today;
    // Generate raw list with spread and gentle trend
    List<int> list = List.generate(7, (i) {
      final trend = 1 - (6 - i) * 0.05; // slight upward toward today (index 6 after reverse)
      final mult = (0.55 + rnd.nextDouble() * 0.9) * trend; // 0.55..1.45 * trend
      return (base * mult).round().clamp(0, 1 << 31);
    });
    // If all equal (rare), inject variation
    final maxVal = list.reduce(math.max);
    final minVal = list.reduce(math.min);
    if (maxVal == minVal) {
      for (int i = 0; i < list.length; i++) {
        list[i] = (base * (0.6 + i * 0.07)).round();
      }
    }
    // Shuffle slight noise so bars differ
    for (int i = 0; i < list.length; i++) {
      list[i] = (list[i] * (0.9 + rnd.nextDouble() * 0.25)).round();
    }
    if (!mounted) return;
    setState(() {
      _today = today;
      _recent = list; // no reverse so most recent at end naturally
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final h = summaryCardHeight(context);
    final hideCaption = MediaQuery.of(context).size.width < 600;
    return SizedBox(
      height: h,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              scheme.primary.withOpacity(.85),
              scheme.primaryContainer.withOpacity(.70),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withOpacity(.25),
              blurRadius: 24,
              offset: const Offset(0, 8),
            )
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: _loading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(scheme.onPrimary),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.trending_down_rounded, color: scheme.onPrimary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Today\'s Spending',
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: scheme.onPrimary.withOpacity(.9),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Refresh',
                        onPressed: _load,
                        icon: Icon(Icons.refresh_rounded, color: scheme.onPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: amountSectionHeight,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: ResponsiveVndAmount(
                          _today,
                          negative: true,
                          symbolAtEnd: true,
                          style: TextStyle(
                            color: scheme.onPrimary,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!hideCaption) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Spending pulse across recent days. Aim for smoother, intentional distribution rather than spikes.',
                      style: TextStyle(
                        fontFamily: 'Hedvig',
                        fontSize: 13,
                        height: 1.25,
                        color: scheme.onPrimary.withOpacity(.85),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 6),
                  Expanded(
                    child: RepaintBoundary(
                      child: LayoutBuilder(
                        builder: (context, c) {
                          final maxBar = (_recent.fold<int>(0, (p, e) => e > p ? e : p)).toDouble().clamp(1, double.infinity);
                          final totalGap = 6 * (_recent.length - 1);
                          final barWidth = ((c.maxWidth - totalGap) / _recent.length).clamp(6, 40).toDouble();
                          final usableHeight = c.maxHeight - 18; // reserve for labels
                          return Align(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                for (int i = 0; i < _recent.length; i++) ...[
                                  _SpentBar(
                                    value: _recent[i].toDouble(),
                                    max: maxBar.toDouble(),
                                    label: 'D${i + 1}',
                                    color: scheme.onPrimary,
                                    highlight: i == _recent.length - 1,
                                    width: barWidth,
                                    maxVisualHeight: usableHeight,
                                  ),
                                  if (i != _recent.length - 1) const SizedBox(width: 6),
                                ]
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _SpentBar extends StatelessWidget {
  final double value;
  final double max;
  final String label;
  final Color color;
  final bool highlight;
  final double width;
  final double? maxVisualHeight; // allow dynamic height
  const _SpentBar({
    required this.value,
    required this.max,
    required this.label,
    required this.color,
    required this.highlight,
    required this.width,
    this.maxVisualHeight,
  });
  @override
  Widget build(BuildContext context) {
    final pct = (value / max).clamp(0, 1);
    final available = (maxVisualHeight ?? 70).clamp(20, 400);
    final barHeight = math.max(6, available * pct + (highlight ? 6 : 0));
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutCubic,
            height: barHeight.clamp(6, available).toDouble(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(highlight ? .95 : .55),
                  color.withOpacity(.25),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              boxShadow: [
                if (highlight)
                  BoxShadow(
                    color: color.withOpacity(.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'Hedvig',
              color: color.withOpacity(.9),
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:walley/util/user_util.dart';

class FinancialTrackerWidget extends StatefulWidget {
  const FinancialTrackerWidget({super.key});

  @override
  State<FinancialTrackerWidget> createState() => _FinancialTrackerWidgetState();
}

class _FinancialTrackerWidgetState extends State<FinancialTrackerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  Map<String, dynamic>? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final d = await UserUtil.aggregateSpending();
    if (mounted) {
      setState(() {
        _data = d;
        _loading = false;
      });
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.secondary.withOpacity(0.85),
            scheme.secondaryContainer.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: scheme.secondary.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: _loading
          ? SizedBox(
              height: 140,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(scheme.onSecondary),
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Spending Overview',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _intervalLabel(_data!['interval']),
                      style: TextStyle(
                        fontFamily: 'Hedvig',
                        fontSize: 12,
                        color: scheme.onSecondary.withOpacity(0.85),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Refresh',
                      icon: Icon(Icons.refresh_rounded,
                          color: scheme.onSecondary,),
                      onPressed: _load,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Visualizing your recent spending pattern',
                  style: TextStyle(
                    fontFamily: 'Hedvig',
                    fontSize: 13,
                    color: scheme.onSecondary.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 140,
                  child: AnimatedBuilder(
                    animation: _fade,
                    builder: (context, _) => _buildChart(context),
                  ),
                ),
              ],
            ),
    );
  }

  String _intervalLabel(String interval) {
    switch (interval) {
      case 'daily':
        return 'Last 7 Days';
      case 'weekly':
        return 'Last 8 Weeks';
      default:
        return 'Last 12 Months';
    }
  }

  Widget _buildChart(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final buckets = _data!['buckets'] as List;
    final maxVal = _data!['max'] as double;

    if (buckets.isEmpty) {
      return Center(
        child: Text(
          'No spending data yet',
          style: TextStyle(
            fontFamily: 'Hedvig',
            fontSize: 13,
            color: scheme.onSecondary,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth =
            min(42.0, constraints.maxWidth / (buckets.length * 1.6));
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (int i = 0; i < buckets.length; i++) ...[
              _Bar(
                label: buckets[i]['label'] as String,
                value: (buckets[i]['value'] as double),
                max: maxVal,
                color: scheme.onSecondary,
                animationValue: _fade.value,
                width: barWidth,
              ),
              if (i != buckets.length - 1) const SizedBox(width: 6),
            ],
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final double value;
  final double max;
  final Color color;
  final double animationValue;
  final double width;
  const _Bar(
      {required this.label,
      required this.value,
      required this.max,
      required this.color,
      required this.animationValue,
      required this.width,});

  @override
  Widget build(BuildContext context) {
    final pct = (value / max).clamp(0, 1);
    final h = 100 * pct * animationValue;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            height: h <= 4 ? 4 : h,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color.withOpacity(0.15),
              gradient: LinearGradient(
                colors: [color.withOpacity(0.9), color.withOpacity(0.4)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Hedvig',
              fontSize: 11,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

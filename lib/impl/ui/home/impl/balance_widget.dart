import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:walley/util/user_util.dart';
import 'package:walley/util/currency_util.dart';
import 'package:walley/impl/ui/root/walley_navigation_scope.dart';

// Replace fixed height constant with responsive helper
// Unified responsive height for summary cards
double summaryCardHeight(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  if (w < 480) return 200;
  if (w < 700) return 220;
  if (w < 1024) return 240;
  return 260; // desktop
}
const double amountSectionHeight = 64; // shared amount display height

class BalanceWidget extends StatefulWidget {
  const BalanceWidget({super.key});
  @override
  State<BalanceWidget> createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;
  int _balance = 0;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _sub = UserUtil.usersStream().listen((doc) {
      final data = doc.data();
      if (!mounted) return;
      setState(() => _balance = (data?['balance'] ?? 0) as int);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _controller.dispose();
    super.dispose();
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
              scheme.tertiary.withOpacity(.85),
              scheme.tertiaryContainer.withOpacity(.70),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: scheme.tertiary.withOpacity(.25),
              blurRadius: 26,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBuilder(
                        animation: _pulse,
                        builder: (_, __) => Transform.scale(
                          scale: 1 + _pulse.value * .04,
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(colors: [
                                scheme.onTertiary.withOpacity(.25),
                                scheme.onTertiary.withOpacity(0),
                              ]),
                            ),
                            child: Icon(
                              Icons.account_balance_wallet_rounded,
                              color: scheme.onTertiary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          'Available Balance',
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: scheme.onTertiary.withOpacity(.9),
                          ),
                        ),
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
                          _balance,
                          symbolAtEnd: true,
                          style: TextStyle(
                            color: scheme.onTertiary,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!hideCaption) ...[
                    const SizedBox(height: 12),
                    Text(
                      _balance >= 0
                          ? 'Great! You are net positive. Keep allocating surplus intentionally.'
                          : 'You are negative. Focus on halting leakage and stabilising outflows.',
                      style: TextStyle(
                        fontFamily: 'Hedvig',
                        fontSize: 13,
                        height: 1.25,
                        color: scheme.onTertiary.withOpacity(.85),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const Spacer(),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          final scope = WalleyNavigationScope.of(context);
                          scope?.selectTab(1);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: scheme.onTertiary,
                          foregroundColor: scheme.tertiary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        label: const Text('Add Entry'),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: scheme.onTertiary),
                          foregroundColor: scheme.onTertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('Export'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 22),
            // Sparkline area
            SizedBox(
              width: 120,
              height: double.infinity,
              child: Center(
                child: RepaintBoundary(
                  child: SizedBox(
                    height: h - 48, // account for padding top/bottom
                    child: _BalanceSparkline(
                      balance: _balance,
                      color: scheme.onTertiary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceSparkline extends StatefulWidget {
  final int balance;
  final Color color;
  const _BalanceSparkline({required this.balance, required this.color});
  @override
  State<_BalanceSparkline> createState() => _BalanceSparklineState();
}

class _BalanceSparklineState extends State<_BalanceSparkline>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late List<double> points;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();
    points = List.generate(
        14, (i) => sin(i / 2) * .4 + .6 + Random().nextDouble() * .15);
  }

  @override
  void didUpdateWidget(covariant _BalanceSparkline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.balance != widget.balance) {
      _c.forward(from: 0);
      points = List.generate(
          14, (i) => sin(i / 2) * .4 + .6 + Random().nextDouble() * .15);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => CustomPaint(
        painter: _SparkPainter(
            points: points, progress: _c.value, color: widget.color),
      ),
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }
}

class _SparkPainter extends CustomPainter {
  final List<double> points;
  final double progress;
  final Color color;
  _SparkPainter(
      {required this.points, required this.progress, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final double topPad = 8;
    final double height = size.height - topPad * 2;
    for (int i = 0; i < points.length; i++) {
      final pct = i / (points.length - 1);
      final x = pct * size.width;
      final y = topPad + (height - points[i] * height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final visibility = progress.clamp(0, 1);
    final paint = Paint()
      ..color = color.withOpacity(.85 * visibility)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
    // Fill with animated fade
    final fillPath = Path.from(path)
      ..lineTo(path.getBounds().right, size.height)
      ..lineTo(path.getBounds().left, size.height)
      ..close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withOpacity(.35 * visibility),
          color.withOpacity(0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _SparkPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.points != points;
}

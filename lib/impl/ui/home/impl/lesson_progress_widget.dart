import 'dart:math';
import 'package:flutter/material.dart';
import 'package:walley/util/user_util.dart';
import 'package:walley/impl/ui/lessons/lessons_page.dart';
import 'package:walley/impl/ui/root/walley_navigation_scope.dart';

class LessonProgressWidget extends StatefulWidget {
  const LessonProgressWidget({super.key});

  @override
  State<LessonProgressWidget> createState() => _LessonProgressWidgetState();
}

class _LessonProgressWidgetState extends State<LessonProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return StreamBuilder<int>(
      stream: UserUtil.lessonProgressStream(),
      builder: (context, snap) {
        final lesson = (snap.data ?? 1).clamp(1, 9999);
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                scheme.primary.withOpacity(0.85),
                scheme.primaryContainer.withOpacity(0.75),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withOpacity(0.25),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _pulse,
                builder: (context, _) => Transform.scale(
                  scale: 1 + _pulse.value * 0.05,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              scheme.onPrimary.withOpacity(0.2),
                              scheme.onPrimary.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: scheme.onPrimary.withOpacity(0.15),
                        child: Text(
                          '#$lesson',
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: scheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Current Lesson',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: scheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'You are on lesson $lesson. Keep the streak alive!',
                      style: TextStyle(
                        fontFamily: 'Hedvig',
                        fontSize: 13,
                        color: scheme.onPrimary.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: scheme.onPrimary,
                            foregroundColor: scheme.primary,
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            final scope = WalleyNavigationScope.of(context);
                            if (scope != null) {
                              scope.selectTab(2); // Lessons tab
                            } else if (context.mounted) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const LessonsPage(),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Continue Lesson'),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: scheme.onPrimary),
                            foregroundColor: scheme.onPrimary,
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            final snack = SnackBar(
                              content: Text(
                                'Lesson $lesson: Consider what you already know about investments and debts, which sort of plans can you craft for your future investments?',
                              ),
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(snack);
                            }
                          },
                          child: const Text('Hints'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _ProgressArc(lesson: lesson),
            ],
          ),
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

class _ProgressArc extends StatelessWidget {
  final int lesson;
  const _ProgressArc({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final double progress = (lesson % 10) / 10.0; // cyclic preview
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress == 0 ? 1 : progress,
            strokeWidth: 6,
            backgroundColor: scheme.onPrimary.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation(scheme.onPrimary),
          ),
          Text(
            '${(progress * 100).round()}%',
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: scheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

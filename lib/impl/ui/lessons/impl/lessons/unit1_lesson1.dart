import 'package:flutter/material.dart';
import 'package:walley/util/user_util.dart';

class Unit1Lesson1 extends StatelessWidget {
  const Unit1Lesson1({super.key});
  static const int lessonNumber = 1;

  @override
  Widget build(BuildContext context) {
    return _ScaffoldLesson(
      title: 'UNIT 1 · LESSON 1',
      headline: 'Flagship Concepts',
      color: Colors.redAccent,
      lessonNumber: lessonNumber,
      children: const [
        _Paragraph(
            'Welcome! This first lesson establishes the mental models you will reuse everywhere: cash flow, margin, and intentional allocation.'),
        _BulletList([
          'Money = resource that buys time & optionality',
          'Cash Flow = recurring pattern, not isolated events',
          'Surplus must be deliberately directed (Save, Invest, Build)',
          'Small consistent habits beat irregular intensity',
        ]),
        _TipCard('Reflect',
            'List three money decisions from last week. Would Future-You vote to repeat them?')
      ],
    );
  }
}

// Re-usable lesson scaffold (mirrors design of other Unit lessons)
class _ScaffoldLesson extends StatelessWidget {
  final String title;
  final String headline;
  final Color color;
  final int lessonNumber;
  final List<Widget> children;
  const _ScaffoldLesson(
      {required this.title,
      required this.headline,
      required this.color,
      required this.lessonNumber,
      required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 900;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: color.withOpacity(0.1),
                  pinned: true,
                  automaticallyImplyLeading: true,
                  title: Text(headline,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600)),
                  actions: [
                    IconButton(
                      tooltip: 'Mark Complete',
                      onPressed: () async {
                        await UserUtil.updateLessonProgressIfCurrent(
                            lessonNumber);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Progress updated')),
                          );
                        }
                      },
                      icon: const Icon(Icons.check_circle_outline),
                    )
                  ],
                ),
                SliverToBoxAdapter(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    padding: EdgeInsets.symmetric(
                      horizontal: wide ? 80 : 20,
                      vertical: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w600,
                                color: color.withOpacity(0.7))),
                        const SizedBox(height: 8),
                        Text(headline,
                            style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                                color: color)),
                        const SizedBox(height: 24),
                        ...children,
                        const SizedBox(height: 40),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await UserUtil.updateLessonProgressIfCurrent(
                                  lessonNumber);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Lesson marked as complete.')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                            ),
                            icon: const Icon(Icons.check_rounded),
                            label: const Text('Mark as complete'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;
  const _Paragraph(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Hedvig',
            fontSize: 17,
            height: 1.35,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
          ),
        ),
      );
}

class _BulletList extends StatelessWidget {
  final List<String> items;
  const _BulletList(this.items);
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final line in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 7, right: 10),
                    decoration:
                        BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  Expanded(
                    child: Text(
                      line,
                      style: TextStyle(
                          fontSize: 15,
                          height: 1.35,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.9)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String title;
  final String body;
  const _TipCard(this.title, this.body);
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            scheme.primary.withOpacity(0.12),
            scheme.primary.withOpacity(0.05)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: scheme.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: .8,
                  color: scheme.primary)),
          const SizedBox(height: 6),
          Text(
            body,
            style: TextStyle(
                fontSize: 14.5,
                height: 1.4,
                color: scheme.onSurface.withOpacity(0.85)),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:walley/util/user_util.dart';

class Unit1Lesson2 extends StatelessWidget {
  const Unit1Lesson2({super.key});
  static const int lessonNumber = 2;

  @override
  Widget build(BuildContext context) => _ScaffoldLesson(
        title: 'UNIT 1 · LESSON 2',
        headline: 'Money Flow Basics',
        color: Colors.orangeAccent,
        lessonNumber: lessonNumber,
        children: const [
          _Paragraph(
              'Cash flow is the metabolic system of your financial life. Before you optimize, you must observe: where does money predictably enter, how does it intentionally exit, and which leaks silently siphon momentum? In this lesson we build a living map— not a static spreadsheet— so that every unit of currency gets a clear job. Think in streams, not isolated puddles: salary, freelance bursts, refunds, interest credits— they each possess volatility, timing, and reliability scores. On the outflow side separate structural (rent, insurance, minimum debt service) from variable (food variation, social, micro–impulses). Finally layer aspirational allocations: future self investments, skill upskilling, and optionality reserves. Your first objective is not perfection; it is measurement density. The more days captured consecutively, the sharper your pattern recognition and the calmer your decision frame.'),
          _InlineChart(
              description:
                  '30‑Day Rolling Net Flow (green positive / red negative).'),
          _BulletList([
            'Log DAILY net remainder (income minus outflow) → form a volatility band',
            'Tag each discretionary purchase with an emotion trigger word',
            'Introduce a 12h delay buffer for digital impulse buys',
            'Redirect surplus immediately to a named goal envelope',
          ]),
          _TipCard('Momentum Hint',
              'Automation beats heroic willpower. If you have to “decide” each transfer, friction will erode consistency. Script rules once, then supervise.')
        ],
      );
}

// Shared scaffold & components (duplicated here for isolation; could be factored if desired)
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
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth > 900;
            return CustomScrollView(slivers: [
              SliverAppBar(
                backgroundColor: color.withOpacity(.08),
                pinned: true,
                automaticallyImplyLeading: true,
                title: Text(headline,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600)),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.check_circle_outline),
                    tooltip: 'Mark Complete',
                    onPressed: () async {
                      await UserUtil.updateLessonProgressIfCurrent(
                          lessonNumber);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Progress updated')));
                      }
                    },
                  )
                ],
              ),
              SliverToBoxAdapter(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding: EdgeInsets.symmetric(
                      horizontal: wide ? 80 : 20, vertical: 30),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w600,
                                color: color.withOpacity(.65))),
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
                                        content: Text(
                                            'Lesson marked as complete.')));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18))),
                            icon: const Icon(Icons.check_rounded),
                            label: const Text('Mark as complete'),
                          ),
                        )
                      ]),
                ),
              )
            ]);
          }),
        ),
      );
}

class _Paragraph extends StatelessWidget {
  final String text;
  const _Paragraph(this.text);
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Text(text,
          style: TextStyle(
              fontFamily: 'Hedvig',
              fontSize: 17,
              height: 1.38,
              color:
                  Theme.of(context).colorScheme.onSurface.withOpacity(.86))));
}

class _BulletList extends StatelessWidget {
  final List<String> items;
  const _BulletList(this.items);
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                          decoration: BoxDecoration(
                              color: color, shape: BoxShape.circle)),
                      Expanded(
                          child: Text(line,
                              style: TextStyle(
                                  fontSize: 15,
                                  height: 1.34,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(.9))))
                    ]))
        ]));
  }
}

class _TipCard extends StatelessWidget {
  final String title;
  final String body;
  const _TipCard(this.title, this.body);
  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    return Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(colors: [
              s.primary.withOpacity(.12),
              s.primary.withOpacity(.05)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            border: Border.all(color: s.primary.withOpacity(.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: .8,
                  color: s.primary)),
          const SizedBox(height: 6),
          Text(body,
              style: TextStyle(
                  fontSize: 14.5,
                  height: 1.42,
                  color: s.onSurface.withOpacity(.85)))
        ]));
  }
}

class _InlineChart extends StatelessWidget {
  final String description;
  const _InlineChart({required this.description});
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
        margin: const EdgeInsets.only(bottom: 26),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: c.secondaryContainer.withOpacity(.35)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
              height: 90,
              child: LayoutBuilder(builder: (ctx, box) {
                return Row(
                    children: List.generate(30, (i) {
                  final h = (i / 29);
                  return Expanded(
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedContainer(
                              duration: const Duration(milliseconds: 600),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 1.5),
                              height: 20 + h * 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                gradient: LinearGradient(colors: [
                                  c.primary.withOpacity(.85 - h * .4),
                                  c.primary.withOpacity(.35)
                                ]),
                              ))));
                }));
              })),
          const SizedBox(height: 10),
          Text(description,
              style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: c.onSecondaryContainer.withOpacity(.75)))
        ]));
  }
}

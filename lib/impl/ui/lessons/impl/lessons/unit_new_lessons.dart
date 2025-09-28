import 'package:flutter/material.dart';
import 'package:walley/util/user_util.dart';

class Unit1Lesson3 extends StatelessWidget {
  const Unit1Lesson3({super.key});
  static const int lessonNumber = 3; // global progression index

  @override
  Widget build(BuildContext context) {
    return const _ScaffoldLesson(
      title: 'UNIT 1 · LESSON 3',
      headline: 'Budget Building Blocks',
      color: Colors.teal,
      lessonNumber: lessonNumber,
      children: [
        _Paragraph(
            'A solid budget is the backbone of every financial plan. Today you will learn how to structure a simple, realistic budget that you can actually stick to.',),
        _BulletList([
          'List your reliable income streams',
          'Categorize expenses (Needs / Wants / Growth)',
          'Set spending limits with a margin of safety',
          'Review weekly; adjust monthly',
        ]),
        _TipCard('Pro Tip',
            'Automate saving by moving money to a goal account the moment income arrives.',),
      ],
    );
  }
}

class Unit1Lesson4 extends StatelessWidget {
  const Unit1Lesson4({super.key});
  static const int lessonNumber = 4;
  @override
  Widget build(BuildContext context) => const _ScaffoldLesson(
        title: 'UNIT 1 · LESSON 4',
        headline: 'Smart Saving Systems',
        color: Colors.indigo,
        lessonNumber: lessonNumber,
        children: [
          _Paragraph(
              'Saving is less about discipline and more about design. Create environmental defaults that make the right action effortless.',),
          _BulletList([
            'Separate accounts for goals',
            'Name accounts to increase emotional attachment',
            'Automate transfers aligned with income frequency',
            'Escalate savings % after every raise',
          ]),
          _TipCard('Experiment',
              'Try a 24‑hour rule before non‑essential purchases to reduce impulse leakage.',),
        ],
      );
}

class Unit1Lesson5 extends StatelessWidget {
  const Unit1Lesson5({super.key});
  static const int lessonNumber = 5;
  @override
  Widget build(BuildContext context) => const _ScaffoldLesson(
        title: 'UNIT 1 · LESSON 5',
        headline: 'Debt Dynamics',
        color: Colors.deepOrange,
        lessonNumber: lessonNumber,
        children: [
          _Paragraph(
              'Not all debt is equal. Understand cost, flexibility, and risk to prioritize repayment strategically.',),
          _BulletList([
            'Track APR & remaining balance',
            'Snowball vs Avalanche methods',
            'Refinancing triggers',
            'Avoid lifestyle debt expansion',
          ]),
          _TipCard('Decision Lens',
              'Ask: Will this debt increase future earning capacity or only satisfy present consumption?',),
        ],
      );
}

class Unit1Lesson6 extends StatelessWidget {
  const Unit1Lesson6({super.key});
  static const int lessonNumber = 6;
  @override
  Widget build(BuildContext context) => const _ScaffoldLesson(
        title: 'UNIT 1 · LESSON 6',
        headline: 'Emergency Resilience',
        color: Colors.purple,
        lessonNumber: lessonNumber,
        children: [
          _Paragraph(
              'Liquidity shields you from turning small setbacks into expensive debt spirals.',),
          _BulletList([
            'Target: 3–6 months essential outflow',
            'Start micro: first goal = 1 week buffer',
            'Store in high‑yield accessible accounts',
            'Rebuild immediately after use',
          ]),
          _TipCard('Motivation Hack',
              'Rename the fund after the emotion it protects (e.g. “Calm Fund”).',),
        ],
      );
}

class Unit1Lesson7 extends StatelessWidget {
  const Unit1Lesson7({super.key});
  static const int lessonNumber = 7;
  @override
  Widget build(BuildContext context) => const _ScaffoldLesson(
        title: 'UNIT 1 · LESSON 7',
        headline: 'Foundations Review',
        color: Colors.blueGrey,
        lessonNumber: lessonNumber,
        children: [
          _Paragraph(
              'You have assembled core personal finance primitives. Today: consolidate into an executable routine.',),
          _BulletList([
            'Weekly 10‑min money review',
            'Monthly category re‑allocation',
            'Quarterly net‑worth snapshot',
            'Annual strategic goal reset',
          ]),
          _TipCard('Sustainability',
              'Consistency > intensity. Favor simple dashboards you will maintain.',),
        ],
      );
}

// UNIT 2 Lessons (8..12)
class Unit2Lesson1 extends StatelessWidget {
  const Unit2Lesson1({super.key});
  static const int lessonNumber = 8;
  @override
  Widget build(BuildContext context) => const _ScaffoldLesson(
        title: 'UNIT 2 · LESSON 1',
        headline: 'Introduction to Investing',
        color: Colors.green,
        lessonNumber: lessonNumber,
        children: [
          _Paragraph(
              'Compounding is a time amplification engine. Start early, stay allocated.',),
          _BulletList([
            'Risk vs Volatility',
            'Inflation as invisible tax',
            'Time horizon determines allocation',
            'Diversification reduces single‑point failure',
          ]),
          _TipCard('Mindset',
              'Volatility is a feature. Focus on process, not short‑term price noise.',),
        ],
      );
}

class Unit2Lesson2 extends StatelessWidget {
  const Unit2Lesson2({super.key});
  static const int lessonNumber = 9;
  @override
  Widget build(BuildContext context) => const _ScaffoldLesson(
        title: 'UNIT 2 · LESSON 2',
        headline: 'Asset Classes Overview',
        color: Colors.cyan,
        lessonNumber: lessonNumber,
        children: [
          _Paragraph(
              'Each asset class encodes a trade‑off between growth, stability, and liquidity.',),
          _BulletList([
            'Equities: growth engine',
            'Bonds: income & dampener',
            'Real Estate: inflation hedge + leverage',
            'Cash: optionality reserve',
          ]),
          _TipCard('Allocation Rule',
              'Increase diversification with uncorrelated cash flows, not just ticker count.',),
        ],
      );
}

class Unit2Lesson3 extends StatelessWidget {
  const Unit2Lesson3({super.key});
  static const int lessonNumber = 10;
  @override
  Widget build(BuildContext context) => const _ScaffoldLesson(
        title: 'UNIT 2 · LESSON 3',
        headline: 'Indexing & Fees',
        color: Colors.deepPurpleAccent,
        lessonNumber: lessonNumber,
        children: [
          _Paragraph(
              'Costs compound against you. Passive, low‑fee indexing often outperforms over long horizons.',),
          _BulletList([
            'Expense ratios drag returns',
            'Turnover creates tax friction',
            'Benchmark selection risk',
            'Simplicity reduces behavioral errors',
          ]),
          _TipCard('Action',
              'Compare fees annually & migrate if materially cheaper for same exposure.',),
        ],
      );
}

class Unit2Lesson4 extends StatelessWidget {
  const Unit2Lesson4({super.key});
  static const int lessonNumber = 11;
  @override
  Widget build(BuildContext context) => const _ScaffoldLesson(
        title: 'UNIT 2 · LESSON 4',
        headline: 'Risk Management',
        color: Colors.redAccent,
        lessonNumber: lessonNumber,
        children: [
          _Paragraph(
              'Survival is the prerequisite to compounding. Guard the downside.',),
          _BulletList([
            'Position sizing logic',
            'Emergency + opportunity cash tiers',
            'Diversification vs Diworsification',
            'Rebalancing cadence',
          ]),
          _TipCard('Checklist',
              'Review allocation drift quarterly; rebalance inside tax‑advantaged accounts when possible.',),
        ],
      );
}

class Unit2Lesson5 extends StatelessWidget {
  const Unit2Lesson5({super.key});
  static const int lessonNumber = 12;
  @override
  Widget build(BuildContext context) => const _ScaffoldLesson(
        title: 'UNIT 2 · LESSON 5',
        headline: 'Long-Term Strategy Review',
        color: Colors.brown,
        lessonNumber: lessonNumber,
        children: [
          _Paragraph(
              'Strategy drift happens subtly. Periodic reflection keeps alignment with life goals.',),
          _BulletList([
            'Annual return attribution',
            'Goal vs portfolio mismatch review',
            'Tax efficiency audit',
            'Behavioral error diary',
          ]),
          _TipCard('Continuity',
              'Document your Investment Policy Statement (IPS) & revisit yearly.',),
        ],
      );
}

// ===== Shared Lesson Layout Components =====
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
      required this.children,});

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
                          fontSize: 20, fontWeight: FontWeight.w600,),),
                  actions: [
                    IconButton(
                      tooltip: 'Mark Complete',
                      onPressed: () async {
                        await UserUtil.updateLessonProgressIfCurrent(
                            lessonNumber,);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Progress updated')),
                          );
                        }
                      },
                      icon: const Icon(Icons.check_circle_outline),
                    ),
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
                                color: color.withOpacity(0.7),),),
                        const SizedBox(height: 8),
                        Text(headline,
                            style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                                color: color,),),
                        const SizedBox(height: 24),
                        ...children,
                        const SizedBox(height: 40),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await UserUtil.updateLessonProgressIfCurrent(
                                  lessonNumber,);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Lesson marked as complete.'),),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 16,),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),),
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
                              .withOpacity(0.9),),
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
            scheme.primary.withOpacity(0.05),
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
                  color: scheme.primary,),),
          const SizedBox(height: 6),
          Text(
            body,
            style: TextStyle(
                fontSize: 14.5,
                height: 1.4,
                color: scheme.onSurface.withOpacity(0.85),),
          ),
        ],
      ),
    );
  }
}

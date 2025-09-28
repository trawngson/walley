import 'package:flutter/material.dart';
import 'package:walley/impl/ui/abstract_walley_page.dart';
import 'package:walley/impl/ui/lessons/impl/lessons/unit1_lesson2.dart';
import 'package:walley/impl/ui/lessons/impl/lessons/unit1_lesson1.dart';
import 'package:walley/impl/ui/lessons/impl/lessons/unit_new_lessons.dart';
import 'package:walley/util/user_util.dart';
import 'package:walley/impl/ui/shared/section_header.dart';

class LessonsPage extends StatelessWidget implements AbstractWalleyPage {
  const LessonsPage({super.key});

  static final _lessons = [
    (1, 'Flagship Concepts', const Unit1Lesson1()),
    (2, 'Money Flow Basics', const Unit1Lesson2()),
    (3, 'Budget Building Blocks', const Unit1Lesson3()),
    (4, 'Smart Saving Systems', const Unit1Lesson4()),
    (5, 'Debt Dynamics', const Unit1Lesson5()),
    (6, 'Emergency Resilience', const Unit1Lesson6()),
    (7, 'Foundations Review', const Unit1Lesson7()),
    (8, 'Intro to Investing', const Unit2Lesson1()),
    (9, 'Asset Classes Overview', const Unit2Lesson2()),
    (10, 'Indexing & Fees', const Unit2Lesson3()),
    (11, 'Risk Management', const Unit2Lesson4()),
    (12, 'Strategy Review', const Unit2Lesson5()),
  ];

  @override
  String getName() => 'Lessons';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<int>(
        stream: UserUtil.lessonProgressStream(),
        builder: (context, snapshot) {
          final progress = snapshot.data ?? 1; // next required lesson number
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SectionHeader(icon: Icons.flag_rounded, title: 'Lessons'),
              const SizedBox(height: 12),
              _unitHeader('UNIT 1', 'Foundations', Icons.flag_rounded,
                  Colors.redAccent,),
              const SizedBox(height: 10),
              ..._buildLessonButtons(context, progress, 1, 7),
              const SizedBox(height: 30),
              _unitHeader('UNIT 2', 'Investing', Icons.trending_up_rounded,
                  Colors.green,),
              const SizedBox(height: 10),
              ..._buildLessonButtons(context, progress, 8, 12),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _unitHeader(String unit, String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(unit,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: color.withOpacity(0.8),),),
              Text(title,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: color.darken(),
                      height: 1,),),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: color.darken(0.2)),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Icon(icon, color: color.darken()),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLessonButtons(
      BuildContext context, int progress, int start, int end,) {
    final list = <Widget>[];
    int visualOffset = 0;
    for (final (number, title, destination)
        in _lessons.where((l) => l.$1 >= start && l.$1 <= end)) {
      final unlocked = number <= progress;
      visualOffset = (visualOffset + 15) % 50;
      list.add(_LessonButtonAdaptive(
        number: number,
        title: title,
        destination: destination,
        unlocked: unlocked,
        offset: visualOffset.toDouble(),
      ),);
    }
    return list;
  }
}

class _LessonButtonAdaptive extends StatelessWidget {
  final int number;
  final String title;
  final Widget destination;
  final bool unlocked;
  final double offset;
  const _LessonButtonAdaptive(
      {required this.number,
      required this.title,
      required this.destination,
      required this.unlocked,
      required this.offset,});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg =
        unlocked ? scheme.primary.withOpacity(0.15) : scheme.surfaceContainerHighest;
    final fg = unlocked ? scheme.primary : scheme.outline;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: 1,
      child: Container(
        margin: EdgeInsets.only(bottom: 10, left: offset),
        child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: unlocked
                ? () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => destination),
                    )
                : null,
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: bg,
                border: Border.all(color: fg.withOpacity(0.4), width: 1),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: fg.withOpacity(0.15),
                    child: Text('$number',
                        style:
                            TextStyle(color: fg, fontWeight: FontWeight.w600),),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: fg,
                      ),
                    ),
                  ),
                  if (unlocked)
                    Icon(Icons.lock_open_rounded, color: fg)
                  else
                    Icon(Icons.lock_rounded, color: fg.withOpacity(0.6)),
                ],
              ),
            ),),
      ),
    );
  }
}

extension _ColorDarken on Color {
  Color darken([double amount = .1]) {
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}

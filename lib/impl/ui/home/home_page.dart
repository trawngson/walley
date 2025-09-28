import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:walley/impl/ui/abstract_walley_page.dart';
import 'package:walley/impl/ui/home/impl/balance_widget.dart';
import 'package:walley/impl/ui/home/impl/total_spent_widget.dart';
import 'package:walley/util/time_util.dart';
import 'package:walley/util/user_util.dart';
import 'impl/lesson_progress_widget.dart';
import 'impl/financial_tracker_widget.dart';

class HomePage extends StatefulWidget implements AbstractWalleyPage {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  @override
  String getName() => "Walley";
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalLayout = width > 1100; // wide screens show cards side by side
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              TimeUtil.ofFormat("EEEE, LLLL d"),
              style: const TextStyle(
                fontFamily: "SF Pro Display",
                fontSize: 23,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          FutureBuilder(
            future: UserUtil.readFromStream(
              'name',
            ),
            builder: (_, AsyncSnapshot data) => Align(
              alignment: Alignment.topLeft,
              child: Text(
                data.connectionState == ConnectionState.done
                    ? "${data.data}'s Wallet" // New data
                    : "", // Old (cached) data
                style: TextStyle(
                  fontFamily: "SF Pro Display",
                  fontSize: 19,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Responsive financial summary cards
          if (horizontalLayout)
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: BalanceWidget()),
                SizedBox(width: 15),
                Expanded(child: TotalSpentWidget()),
              ],
            )
          else
            const Column(
              children: [
                BalanceWidget(),
                SizedBox(height: 15),
                TotalSpentWidget(),
              ],
            ),
          const SizedBox(height: 25),
          // Quick actions
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  // Navigate to entry/log tab
                  DefaultTabController.maybeOf(context);
                  // open via nav scope if available
                },
                icon: const Icon(Iconsax.add),
                label: const Text('New Entry'),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.ios_share_rounded),
                label: const Text('Share'),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.settings_backup_restore_rounded),
                label: const Text('Backup'),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Row(
            children: [
              /*Expanded(
                child: ElevatedButton(
                  onPressed: () => {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.add),
                      SizedBox(width: 10),
                      Text(
                        "Deposit",
                        style: TextStyle(
                          fontFamily: "SF Pro Display",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.minus),
                      SizedBox(width: 10),
                      Text(
                        "Expend",
                        style: TextStyle(
                          fontFamily: "SF Pro Display",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),*/
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              const SizedBox(
                width: 2,
              ),
              const Column(
                children: [
                  SizedBox(
                    height: 1,
                  ),
                  Icon(
                    Iconsax.bookmark,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(
                width: 8,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Lesson Progress",
                  style: TextStyle(
                    fontFamily: "SF Pro Display",
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Icon(
                Icons.ios_share,
                size: 15,
                color: Theme.of(context).hintColor.withAlpha(120),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const LessonProgressWidget(),
          const SizedBox(height: 20),
          const _FinancialTrackerHeader(),
          const SizedBox(
            height: 15,
          ),
          const FinancialTrackerWidget(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _FinancialTrackerHeader extends StatelessWidget {
  const _FinancialTrackerHeader();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 2),
        const Padding(
          padding: EdgeInsets.only(bottom: 1),
          child: Icon(Iconsax.note_1, size: 20),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            "Your Financial Tracker",
            style: TextStyle(
              fontFamily: "SF Pro Display",
              fontSize: 23,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Icon(
          Icons.ios_share,
          size: 15,
          color: Theme.of(context).hintColor.withAlpha(120),
        ),
      ],
    );
  }
}

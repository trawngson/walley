import 'package:flutter/material.dart';
import 'package:walley/impl/ui/log/impl/deposit_tab.dart';
import 'package:walley/impl/ui/log/impl/expend_tab.dart';

class QuickEntrySheet extends StatelessWidget {
  final DateTime initialDateTime;
  const QuickEntrySheet({super.key, required this.initialDateTime});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.96,
      minChildSize: 0.6,
      expand: false,
      builder: (context, controller) => DefaultTabController(
        length: 2,
        child: Material(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 12),
              const TabBar(tabs: [Tab(text: 'Expend'), Tab(text: 'Deposit')]),
              const Divider(height: 1),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      controller: controller,
                      child: ExpendTab(selectedDateTime: initialDateTime),
                    ),
                    SingleChildScrollView(
                      controller: controller,
                      child: DepositTab(selectedDateTime: initialDateTime),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

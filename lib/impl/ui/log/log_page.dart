import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walley/util/user_defaults_util.dart';
import 'package:walley/util/user_util.dart';
import 'package:walley/util/currency_util.dart';
import 'package:iconsax/iconsax.dart';
import 'package:walley/impl/ui/abstract_walley_page.dart';
import 'package:walley/impl/ui/log/impl/deposit_tab.dart';
import 'package:walley/impl/ui/log/impl/expend_tab.dart';

class LogPage extends StatefulWidget implements AbstractWalleyPage {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();

  @override
  String getName() => "Log";
}

class _LogPageState extends State<LogPage> with TickerProviderStateMixin {
  DateTime _entryDateTime = DateTime.now();
  bool get _isCompact => MediaQuery.of(context).size.width < 900;

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final initialDate =
        DateTime(_entryDateTime.year, _entryDateTime.month, _entryDateTime.day);
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
      initialDate: initialDate,
    );
    if (pickedDate == null) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_entryDateTime),
    );
    if (pickedTime == null) return;
    setState(() {
      _entryDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _showQuickAddSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: false,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Quick Add',
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          if (_isCompact) {
                            DefaultTabController.of(context).animateTo(0);
                          }
                        },
                        icon: const Icon(Iconsax.minus),
                        label: const Text('Expend'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          if (_isCompact) {
                            DefaultTabController.of(context).animateTo(1);
                          }
                        },
                        icon: const Icon(Iconsax.add),
                        label: const Text('Deposit'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Tip: Use the clock button to backdate entries.',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildTabs() {
    return const TabBar(
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: [
        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Iconsax.minus),
              SizedBox(width: 8),
              Text('Expend'),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Iconsax.add),
              SizedBox(width: 8),
              Text('Deposit'),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCompact) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: _showQuickAddSheet,
            shape: const CircleBorder(),
            child: const Icon(Iconsax.scanner),
          ),
          appBar: AppBar(
            title: const Text('Log'),
            actions: [
              IconButton(
                tooltip: 'Change date/time',
                onPressed: _pickDateTime,
                icon: const Icon(Icons.access_time_rounded),
              ),
            ],
            bottom: _buildTabs(),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: _QuoteMaybe(),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(height: 220, child: _RecentSpending()),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ExpendTab(selectedDateTime: _entryDateTime),
                    DepositTab(selectedDateTime: _entryDateTime),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Wide layout: show both tabs side-by-side with a sticky header
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log'),
        actions: [
          Tooltip(
            message: 'Pick date & time for entries',
            child: TextButton.icon(
              onPressed: _pickDateTime,
              style: TextButton.styleFrom(shape: const StadiumBorder()),
              icon: const Icon(Icons.access_time_rounded),
              label: Text(
                '${_entryDateTime.year}-${_entryDateTime.month.toString().padLeft(2, '0')}-${_entryDateTime.day.toString().padLeft(2, '0')} · '
                '${_entryDateTime.hour.toString().padLeft(2, '0')}:${_entryDateTime.minute.toString().padLeft(2, '0')}',
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showQuickAddSheet,
        icon: const Icon(Iconsax.scanner),
        label: const Text('Quick Add'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _FinanceQuoteCard(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withOpacity(0.2),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    ExpendTab(selectedDateTime: _entryDateTime),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withOpacity(0.2),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DepositTab(
                                  selectedDateTime: _entryDateTime,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _RecentSpending(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FinanceQuoteCard extends StatefulWidget {
  @override
  State<_FinanceQuoteCard> createState() => _FinanceQuoteCardState();
}

class _QuoteMaybe extends StatefulWidget {
  @override
  State<_QuoteMaybe> createState() => _QuoteMaybeState();
}

class _QuoteMaybeState extends State<_QuoteMaybe> {
  bool? _show;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final show =
        await UserDefaultsUtil.getBool('show_tips', defaultValue: true);
    if (!mounted) return;
    setState(() => _show = show);
  }

  @override
  Widget build(BuildContext context) {
    if (_show == false) return const SizedBox.shrink();
    return _FinanceQuoteCard();
  }
}

class _FinanceQuoteCardState extends State<_FinanceQuoteCard> {
  static const List<Map<String, String>> _quotes = [
    {
      'q':
          'Do not save what is left after spending; spend what is left after saving.',
      'a': 'Warren Buffett',
    },
    {
      'q':
          "It's not your salary that makes you rich, it's your spending habits.",
      'a': 'Charles A. Jaffe',
    },
    {
      'q': 'Beware of little expenses; a small leak will sink a great ship.',
      'a': 'Benjamin Franklin',
    },
    {
      'q':
          'A budget is telling your money where to go instead of wondering where it went.',
      'a': 'Dave Ramsey',
    },
    {
      'q':
          'The individual investor should act consistently as an investor and not as a speculator.',
      'a': 'Ben Graham',
    },
  ];

  late int _index;
  late int _seed; // to refresh image URL

  @override
  void initState() {
    super.initState();
    final rnd = Random();
    _index = rnd.nextInt(_quotes.length);
    _seed = rnd.nextInt(1 << 31);
  }

  void _refresh() {
    setState(() {
      final rnd = Random();
      _index = rnd.nextInt(_quotes.length);
      _seed = rnd.nextInt(1 << 31);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final quote = _quotes[_index];
    final url =
        'https://source.unsplash.com/1200x600/?finance,money,investment&sig=$_seed';

    return Container(
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: scheme.secondary.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.network(
              url,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.2),
              colorBlendMode: BlendMode.darken,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: scheme.secondaryContainer.withOpacity(0.3),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      scheme.secondary.withOpacity(0.85),
                      scheme.secondaryContainer.withOpacity(0.75),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          // Dark gradient overlay for readability
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.45),
                    Colors.black.withOpacity(0.15),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
            ),
          ),
          // Foreground content with no overlaps
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isTight = constraints.maxWidth < 340;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: scheme.secondary.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.lightbulb_rounded,
                                    size: 16,
                                    color: scheme.onSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Finance Tip',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: scheme.onSecondary,
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            tooltip: 'New tip',
                            onPressed: _refresh,
                            icon: Icon(
                              Icons.refresh_rounded,
                              color: scheme.onSecondary,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              // keep some space from the right to avoid tightness
                              maxWidth:
                                  constraints.maxWidth * (isTight ? 0.9 : 0.8),
                            ),
                            child: Text(
                              '“${quote['q']}”',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '— ${quote['a']}',
                        style: TextStyle(
                          fontFamily: 'Hedvig',
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentSpending extends StatefulWidget {
  @override
  State<_RecentSpending> createState() => _RecentSpendingState();
}

class _RecentSpendingState extends State<_RecentSpending>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  Map<String, dynamic>? _chartData;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _loadChart();
  }

  Future<void> _loadChart() async {
    final d = await UserUtil.aggregateSpending();
    if (!mounted) return;
    setState(() => _chartData = d);
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSecondary,
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Refresh',
                icon: Icon(Icons.refresh_rounded, color: scheme.onSecondary),
                onPressed: _loadChart,
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: _chartData == null
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(scheme.onSecondary),
                    ),
                  )
                : AnimatedBuilder(
                    animation: _fade,
                    builder: (context, _) => _MiniChart(
                      data: _chartData!,
                      color: scheme.onSecondary,
                      t: _fade.value,
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: StreamBuilder(
              stream: UserUtil.usersStream(),
              builder: (context, snapshot) {
                final data = snapshot.data?.data();
                final history =
                    (data?['spendingHistory'] as Map<String, dynamic>?) ?? {};
                final entries = history.entries.toList();
                entries.sort((a, b) => b.key.compareTo(a.key));
                final items = entries.take(5).toList();

                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      'No recent transactions',
                      style: TextStyle(color: scheme.onSecondary),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final k = items[i].key;
                    final v = items[i].value as Map<String, dynamic>;
                    final dt = DateTime.tryParse(k);
                    final amount =
                        int.tryParse(v['amount']?.toString() ?? '0') ?? 0;
                    final isNegative = amount < 0;
                    final color = isNegative
                        ? Colors.redAccent
                        : Theme.of(context).colorScheme.tertiary;
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 300 + i * 70),
                      tween: Tween(begin: 0, end: 1),
                      curve: Curves.easeOutCubic,
                      builder: (context, t, child) {
                        return Opacity(
                          opacity: t,
                          child: Transform.translate(
                            offset: Offset(0, 12 * (1 - t)),
                            child: child,
                          ),
                        );
                      },
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: color.withOpacity(0.15),
                          child: Icon(
                            isNegative
                                ? Icons.remove_rounded
                                : Icons.add_rounded,
                            color: color,
                          ),
                        ),
                        title: Text(
                          v['category']?.toString() ?? 'Uncategorized',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            color: scheme.onSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          dt == null
                              ? ''
                              : DateFormat('EEE, MMM d • jm').format(dt),
                          style: TextStyle(
                            color: scheme.onSecondary.withOpacity(0.9),
                            fontFamily: 'Hedvig',
                            fontSize: 12,
                          ),
                        ),
                        trailing: Text(
                          formatCurrencyVND(amount.abs()),
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniChart extends StatelessWidget {
  final Map<String, dynamic> data;
  final Color color;
  final double t;
  const _MiniChart({required this.data, required this.color, required this.t});

  @override
  Widget build(BuildContext context) {
    final buckets = (data['buckets'] as List).cast<Map<String, Object>>();
    final maxVal = (data['max'] as double);
    if (buckets.isEmpty) return const SizedBox();
    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth =
            (constraints.maxWidth / (buckets.length * 1.8)).clamp(6.0, 28.0);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (int i = 0; i < buckets.length; i++) ...[
              _MiniBar(
                value: (buckets[i]['value'] as double),
                max: maxVal,
                color: color,
                width: barWidth,
                t: t,
              ),
              if (i != buckets.length - 1) const SizedBox(width: 6),
            ],
          ],
        );
      },
    );
  }
}

class _MiniBar extends StatelessWidget {
  final double value;
  final double max;
  final Color color;
  final double width;
  final double t; // 0-1 fade/slide factor
  const _MiniBar({
    required this.value,
    required this.max,
    required this.color,
    required this.width,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (value / max).clamp(0, 1);
    final h = (pct * 70.0) * t; // within 80 height minus padding
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      height: h < 4 ? 4 : h,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.9), color.withOpacity(0.4)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      margin: const EdgeInsets.only(top: 8),
    );
  }
}

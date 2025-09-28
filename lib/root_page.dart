import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:walley/impl/ui/abstract_walley_page.dart';
import 'package:walley/impl/ui/root/walley_navigation_bar.dart';
import 'package:walley/impl/ui/user/user_page.dart';
import 'package:walley/impl/ui/home/home_page.dart';
import 'package:walley/impl/ui/log/log_page.dart';
import 'package:walley/impl/ui/lessons/lessons_page.dart';
import 'package:walley/impl/ui/root/walley_navigation_scope.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _index = 0;
  bool _railExtended = false; // default collapsed

  void _onTabChange(int newIndex) {
    setState(() => _index = newIndex);
  }

  AbstractWalleyPage _currentPage() {
    if (_index == 1) return const LogPage();
    if (_index == 2) return const LessonsPage();
    return const HomePage();
  }

  bool get _isCompact => MediaQuery.of(context).size.width < 900;

  @override
  Widget build(BuildContext context) {
    return WalleyNavigationScope(
      selectTab: _onTabChange,
      child: Scaffold(
        endDrawer: _ChangelogDrawer(),
        bottomNavigationBar: _isCompact
            ? WalleyNavigationBar(
                _index,
                onTabChange: _onTabChange,
              )
            : null,
        body: Row(
          children: [
            if (!_isCompact) _buildRail(context),
            Expanded(
              child: _currentPage() as Widget,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRail(BuildContext context) {
    final double width = _railExtended ? 260 : 80;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header with logo + collapse toggle
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _railExtended ? 16 : 8,
                vertical: 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _railExtended
                          ? SvgPicture.asset(
                              'assets/text_logo.svg',
                              key: const ValueKey('logo-full'),
                              height: 48,
                              semanticsLabel: 'Walley',
                            )
                          : Icon(
                              Icons.wallet_rounded,
                              key: const ValueKey('logo-icon'),
                              size: 32,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                    ),
                  ),
                  IconButton(
                    tooltip: _railExtended ? 'Collapse' : 'Expand',
                    onPressed: () =>
                        setState(() => _railExtended = !_railExtended),
                    icon: AnimatedRotation(
                      duration: const Duration(milliseconds: 250),
                      turns: _railExtended ? 0 : 0.5,
                      child: const Icon(Icons.chevron_left_rounded),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: NavigationRail(
                extended: _railExtended,
                selectedIndex: _index,
                onDestinationSelected: (i) => _onTabChange(i),
                backgroundColor: Colors.transparent,
                indicatorColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.12),
                destinations: WalleyNavigationBar.railDestinations(),
              ),
            ),
            const Divider(height: 1),
            _profileTile(context),
          ],
        ),
      ),
    );
  }

  Widget _profileTile(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const UserPage()),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _railExtended ? 16 : 12,
          vertical: 14,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage:
                  const AssetImage('assets/placeholder_avatar.jpg'),
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            if (_railExtended) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Profile',
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChangelogDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              leading: Icon(Icons.new_releases_rounded, color: cs.primary),
              title: const Text('What’s new'),
              subtitle: const Text('Latest improvements and tips'),
            ),
            const Divider(),
            const ListTile(
              title: Text('• Responsive Log with quick add'),
              subtitle: Text('Add entries with backdating and recent activity'),
            ),
            const ListTile(
              title: Text('• Spending charts'),
              subtitle: Text('Visualize daily/weekly/monthly distribution'),
            ),
            const ListTile(
              title: Text('• Enhanced Home'),
              subtitle: Text('Balance sparkline, progress pulse, tidy cards'),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.close_rounded),
              label: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

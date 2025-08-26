import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:walley/impl/ui/home/home_page.dart';
import 'package:walley/impl/ui/lessons/lessons_page.dart';
import 'package:walley/impl/ui/log/log_page.dart';
import 'package:walley/impl/ui/abstract_walley_page.dart';

//ignore: must_be_immutable
class WalleyNavigationBar extends StatelessWidget {
  var _currentIndex = 0;
  Function onTabChange;

  WalleyNavigationBar(
    this._currentIndex, {
    super.key,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return navigationBar();
  }

  NavigationBar navigationBar() => NavigationBar(
        height: 60,
        selectedIndex: _currentIndex,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (newIndex) => onTabTapped(newIndex),
        destinations: const [
          NavigationDestination(icon: Icon(Iconsax.wallet_1), label: "Home"),
          NavigationDestination(icon: Icon(Iconsax.add), label: "Entry"),
          NavigationDestination(
            icon: Icon(Iconsax.book_square),
            label: "Lessons",
          ),
        ],
      );

  void onTabTapped(int index) {
    _currentIndex = index;
    onTabChange(index);
  }

  AbstractWalleyPage getScreen() => _currentIndex == 1
      ? const LogPage()
      : _currentIndex == 2
          ? const LessonsPage()
          : const HomePage();

  bool isHomeScreen() => _currentIndex == 0;
  bool isLogScreen() => _currentIndex == 1;
  bool isLessonsScreen() => _currentIndex == 2;

  static List<NavigationRailDestination> railDestinations() => const [
        NavigationRailDestination(
          icon: Icon(Iconsax.wallet_1),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Iconsax.add),
          label: Text('Entry'),
        ),
        NavigationRailDestination(
          icon: Icon(Iconsax.book_square),
          label: Text('Lessons'),
        ),
      ];
}

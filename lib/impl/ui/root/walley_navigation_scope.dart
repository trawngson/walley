import 'package:flutter/widgets.dart';

class WalleyNavigationScope extends InheritedWidget {
  final void Function(int index) selectTab;
  const WalleyNavigationScope(
      {super.key, required this.selectTab, required super.child});
  static WalleyNavigationScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<WalleyNavigationScope>();
  @override
  bool updateShouldNotify(covariant WalleyNavigationScope oldWidget) =>
      selectTab != oldWidget.selectTab;
}

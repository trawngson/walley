import 'package:flutter/material.dart';
import 'package:walley/impl/finance/spending_category.dart';

class SpendingCategorySelectorItem {
  final SpendingCategory spendingCategory;
  bool isSelected;
  SpendingCategorySelectorItem({required this.spendingCategory})
      : isSelected = false;

  AnimatedContainer render() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInQuad,
      decoration: BoxDecoration(
        color: isSelected
            ? spendingCategory.color.withAlpha(150)
            : spendingCategory.color.withAlpha(40),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_iconFor(spendingCategory), size: 16),
            const SizedBox(width: 6),
            Text(spendingCategory.name),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(SpendingCategory c) {
    switch (c) {
      case SpendingCategory.Food:
        return Icons.fastfood_rounded;
      case SpendingCategory.Transportation:
        return Icons.directions_bus_rounded;
      case SpendingCategory.Entertainment:
        return Icons.videogame_asset_rounded;
      case SpendingCategory.Shopping:
        return Icons.shopping_bag_rounded;
      case SpendingCategory.Health:
        return Icons.health_and_safety_rounded;
      case SpendingCategory.Education:
        return Icons.school_rounded;
      case SpendingCategory.Other:
        return Icons.category_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }
}

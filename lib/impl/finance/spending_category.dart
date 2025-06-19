import 'package:flutter/material.dart';

enum SpendingCategory {
  Food,
  Transportation,
  Entertainment,
  Shopping,
  Health,
  Education,
  Other,
  Uncategorized
}

extension SpendingCategoryExtension on SpendingCategory {
  Color get color {
    switch (this) {
      case SpendingCategory.Food:
        return const Color(0xff6c946f);
      case SpendingCategory.Transportation:
        return const Color(0xffe17d7d);
      case SpendingCategory.Entertainment:
        return const Color(0xff5063C6);
      case SpendingCategory.Shopping:
        return const Color(0xff603610);
      case SpendingCategory.Health:
        return const Color(0xff99C1A9);
      case SpendingCategory.Education:
        return const Color(0xffCEC0F0);
      case SpendingCategory.Other:
        return const Color(0xffDF3E3E);
      default:
        return const Color(0xffB1DFC4);
    }
  }
}

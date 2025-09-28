import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:form_validator/form_validator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:walley/impl/finance/spending_category.dart';
import 'package:walley/impl/finance/spending_category_selector_item.dart';
import 'package:walley/impl/ui/log/impl/log_animation.dart';
// removed unused time_util import
import 'package:walley/util/user_util.dart';

class ExpendTab extends StatefulWidget {
  final DateTime selectedDateTime;
  const ExpendTab({
    super.key,
    required this.selectedDateTime,
  });

  @override
  State<ExpendTab> createState() => _ExpendTabState();
}

class _ExpendTabState extends State<ExpendTab> {
  final _moneyFieldController = TextEditingController();
  final _notesFieldController = TextEditingController();

  final spendingCategories = [
    SpendingCategorySelectorItem(
      spendingCategory: SpendingCategory.Education,
    ),
    SpendingCategorySelectorItem(
      spendingCategory: SpendingCategory.Entertainment,
    ),
    SpendingCategorySelectorItem(
      spendingCategory: SpendingCategory.Food,
    ),
    SpendingCategorySelectorItem(
      spendingCategory: SpendingCategory.Health,
    ),
    SpendingCategorySelectorItem(
      spendingCategory: SpendingCategory.Shopping,
    ),
    SpendingCategorySelectorItem(
      spendingCategory: SpendingCategory.Transportation,
    ),
    SpendingCategorySelectorItem(
      spendingCategory: SpendingCategory.Other,
    ),
  ];

  final GlobalKey<FormState> form = GlobalKey<FormState>();
  CurrencyTextInputFormatter vndTextFieldFormatter =
      CurrencyTextInputFormatter.currency(
    locale: "vi",
    symbol: '₫',
    enableNegative: false,
  );

  int? tryParsingMoneyValueFromRawText() => _moneyFieldController.text.isEmpty
      ? null
      : int.tryParse(
          _moneyFieldController.text
              .substring(
                0,
                _moneyFieldController.text.length - 2,
              ) // Remove the d suffix
              .replaceAll(
                ".",
                "",
              ), // Remove digit seperator
        );

  String? moneyFieldErrorText;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "New expenditure at ${DateFormat('jm').format(widget.selectedDateTime)}",
              style: const TextStyle(
                fontFamily: "SF Pro Display",
                fontSize: 23,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              DateFormat('EEEE, LLLL d').format(widget.selectedDateTime),
              style: TextStyle(
                fontFamily: "SF Pro Display",
                fontSize: 19,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Amount",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Focus(
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                int? parsedValue = tryParsingMoneyValueFromRawText();
                if (parsedValue != null && parsedValue < 1000) {
                  _moneyFieldController.value = TextEditingValue(
                    text: (vndTextFieldFormatter.format.format(
                      parsedValue * 1000,
                    )),
                  );
                }
                setState(
                  () => {},
                ); // Rebuild widget to update _moneyFieldController.text
              }
            },
            child: Form(
              key: form,
              child: FutureBuilder(
                future: UserUtil.readFromStream("balance"),
                builder: (_, AsyncSnapshot snapshot) {
                  int? parsedValue = tryParsingMoneyValueFromRawText();
                  bool error =
                      snapshot.connectionState == ConnectionState.done &&
                          parsedValue != null &&
                          parsedValue > snapshot.data;

                  moneyFieldErrorText = error
                      ? "This amount exceeds your budget by ${vndTextFieldFormatter.format.format(parsedValue - snapshot.data)}"
                      : null;

                  return TextFormField(
                    controller: _moneyFieldController,
                    validator: ValidationBuilder().required().build(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorText: moneyFieldErrorText,
                      hintText: "Enter an amount...",
                      prefixIcon: const Icon(Iconsax.money_remove5),
                    ),
                    onTapOutside: (_) {
                      int? parsedValue = tryParsingMoneyValueFromRawText();
                      if (parsedValue != null && parsedValue < 1000) {
                        _moneyFieldController.value = TextEditingValue(
                          text: (vndTextFieldFormatter.format.format(
                            parsedValue * 1000,
                          )),
                        );
                      }
                      setState(
                        () => {},
                      ); // Rebuild widget to update _moneyFieldController.text
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      vndTextFieldFormatter,
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Category",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 30,
            child: ListView.separated(
              itemCount: 7,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  for (var item in spendingCategories) {
                    item.isSelected = false;
                  } // disable every other item
                  spendingCategories[index].isSelected = true;
                  setState(() => {});
                },
                child: spendingCategories[index].render(),
              ),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(
                width: 7,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Notes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextField(
            controller: _notesFieldController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              hintText: "...",
              prefixIcon: const Icon(Iconsax.note_text5),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: (form.currentState != null &&
                      moneyFieldErrorText == null &&
                      form.currentState!.validate() &&
                      context.mounted)
                  ? (() async {
                      showDialog(
                        useSafeArea: false,
                        context: context,
                        barrierColor: Colors.transparent,
                        builder: (_) {
                          String category = spendingCategories
                              .firstWhere(
                                (item) => item.isSelected,
                                orElse: () => SpendingCategorySelectorItem(
                                  spendingCategory:
                                      SpendingCategory.Uncategorized,
                                ),
                              )
                              .spendingCategory
                              .name;

                          return LogAnimation(
                            type: 'expend',
                            timestamp: widget.selectedDateTime,
                            category: category,
                            notes: _notesFieldController.text,
                            moneyAmount: -tryParsingMoneyValueFromRawText()!,
                          );
                        },
                      );
                    })
                  : null, // grey out button if fields not entered correctly
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color: Theme.of(context).hintColor.withAlpha(90),
                    ),
                  ),
                ),
              ),
              child: const Text("Submit entry"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _moneyFieldController.dispose();
    _notesFieldController.dispose();
    super.dispose();
  }
}

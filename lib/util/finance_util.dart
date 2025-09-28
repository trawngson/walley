import 'package:intl/intl.dart';

class FinanceUtil {
  static final vnd = NumberFormat.decimalPattern('vi_VN');
  static String percent(double value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)}%';
  }
}

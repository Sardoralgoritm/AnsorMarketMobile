import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _formatter = NumberFormat('#,###', 'uz_UZ');

  static String format(double amount, {String symbol = 'UZS'}) {
    return '${_formatter.format(amount)} $symbol';
  }

  static String formatCompact(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M UZS';
    }
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K UZS';
    }
    return format(amount);
  }
}

import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';

String formatCurrency(
  double value, {
  bool useCommas = false,
  int decimalPlaces = 2,
}) {
  return toCurrencyString(
    value.toString(),
    thousandSeparator:
        useCommas
            ? ThousandSeparator
                .Comma // 1,234,567.89
            : ThousandSeparator.Period, // 1.234.567,89
    mantissaLength: decimalPlaces,
  );
}

double parseCurrency(String input) {
  final format = NumberFormat.currency(
    locale: 'es_CO',
    symbol: '',
    decimalDigits: 2,
  );
  try {
    return format.parse(input).toDouble();
  } catch (e) {
    return 0.0;
  }
}

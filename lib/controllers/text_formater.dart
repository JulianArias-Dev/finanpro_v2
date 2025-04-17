import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

String formatCurrency(double value, {
  bool useCommas = true,
  int decimalPlaces = 2,
}) {
  return toCurrencyString(
    value.toString(),
    thousandSeparator: useCommas
        ? ThousandSeparator.Comma   // 1,234,567.89
        : ThousandSeparator.Period,  // 1.234.567,89
    mantissaLength: decimalPlaces,
  );
}

double parseCurrency(String input) {
  final clean = input.replaceAll(',', '').trim();
  return double.tryParse(clean) ?? 0;
}

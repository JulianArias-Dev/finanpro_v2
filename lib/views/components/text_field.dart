import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

Widget buildTextField(
  String label,
  TextEditingController controller, {
  bool isNumeric = false,
  bool isMoney = false,
  bool readOnly = false,
  String? hintText,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: TextFormField(
      controller: controller,
      keyboardType:
          isNumeric
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
      inputFormatters:
          isMoney
              ? [
                CurrencyTextInputFormatter(
                  NumberFormat.currency(
                    locale: 'es_CO', // o 'en_US' para inglés
                    symbol: '', // símbolo que prefieras
                    decimalDigits: 2,
                  ),
                ),
              ]
              : null,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
    ),
  );
}

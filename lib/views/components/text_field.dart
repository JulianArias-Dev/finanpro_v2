import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

Widget buildTextField(
  String label,
  TextEditingController controller, {
  bool isNumeric = false,
  bool isMoney = false,
  bool readOnly = false, // Permitir campos solo de lectura
  String? hintText,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      inputFormatters:
          isMoney
              ? [
                MoneyInputFormatter(
                  thousandSeparator: ThousandSeparator.Comma,
                  mantissaLength: 2,
                ),
              ]
              : null,
      readOnly: readOnly, // Se mantiene la opción de solo lectura
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
    ),
  );
}

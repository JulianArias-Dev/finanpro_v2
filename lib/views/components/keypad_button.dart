import 'package:flutter/material.dart';

Widget buildKeypadButton(String value, void Function(String) onKeyPressed) {
  return GestureDetector(
    onTap: () => onKeyPressed(value),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: 10,
      height: 10,
      margin: EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      child:
          value == "backspace"
              ? const Icon(Icons.backspace, size: 30, color: Colors.white)
              : value == "fingerprint"
              ? const Icon(Icons.fingerprint, size: 30, color: Colors.white)
              : Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
    ),
  );
}

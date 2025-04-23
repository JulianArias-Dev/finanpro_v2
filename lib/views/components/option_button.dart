import 'package:flutter/material.dart';

Widget buildOptionButton(String title, BuildContext context, Widget? page) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    child: ElevatedButton(
      onPressed:
          page != null
              ? () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              )
              : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Color.fromARGB(255, 111, 183, 31),
            width: 3,
          ),
        ),
        minimumSize: const Size(130, 95),
      ),
      child: SizedBox(
        width: 95, // Set a fixed width to wrap text
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    ),
  );
}

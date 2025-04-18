import 'package:flutter/material.dart';

Widget buildImage(BuildContext context, String imageUrl, double height) {
  return Column(
    children: [
      const SizedBox(height: 10),
      Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * height,
        ),
        child: Image.asset(imageUrl, fit: BoxFit.contain),
      ),
      const SizedBox(height: 20),
    ],
  );
}

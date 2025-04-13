import 'package:flutter/material.dart';

class SeriesVariablesScreen extends StatefulWidget {
  const SeriesVariablesScreen({super.key});

  @override
  _SeriesVariablesScreen createState() => _SeriesVariablesScreen();
}

class _SeriesVariablesScreen extends State<SeriesVariablesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FinanPro",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        backgroundColor: Color.fromARGB(255, 111, 183, 31),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Series de Variables",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Aquí puedes calcular el valor futuro o presente de una serie de variables.",
                style: TextStyle(fontSize: 16),
              ),
              // Add your input fields and logic here
            ],
          ),
        ),
      ),
    );
  }
}

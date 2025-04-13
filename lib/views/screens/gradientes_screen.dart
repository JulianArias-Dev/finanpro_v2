import 'package:flutter/material.dart';

class GradientesScreen extends StatefulWidget {
  const GradientesScreen({super.key});

  @override
  _GradientesScreen createState() => _GradientesScreen();
}

class _GradientesScreen extends State<GradientesScreen> {
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
                "Gradientes",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Los gradientes son una forma de representar visualmente la variación de un valor a lo largo del tiempo. En el contexto financiero, los gradientes se utilizan para mostrar cómo cambian los flujos de efectivo a lo largo de un período.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

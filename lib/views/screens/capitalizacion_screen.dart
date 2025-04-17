import 'package:flutter/material.dart';

class CapitalizacionScreen extends StatefulWidget {
  const CapitalizacionScreen({super.key});

  @override
  _CapitalizacionScreen createState() => _CapitalizacionScreen();
}

class _CapitalizacionScreen extends State<CapitalizacionScreen> {
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
                "Capitalización",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "La capitalización es el proceso mediante el cual los intereses generados por un capital inicial se suman al capital original, formando un nuevo capital que a su vez generará más intereses en el futuro.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

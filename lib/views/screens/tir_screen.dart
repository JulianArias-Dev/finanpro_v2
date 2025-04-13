import 'package:flutter/material.dart';

class TirScreen extends StatefulWidget {
  const TirScreen({super.key});

  @override
  _TirScreen createState() => _TirScreen();
}

class _TirScreen extends State<TirScreen> {
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
                "Tasa Interna de Retorno (TIR)",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "La Tasa Interna de Retorno (TIR) es una métrica utilizada en finanzas para evaluar la rentabilidad de una inversión o proyecto. Representa la tasa de descuento que hace que el valor presente neto (VPN) de los flujos de efectivo futuros sea igual a cero.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

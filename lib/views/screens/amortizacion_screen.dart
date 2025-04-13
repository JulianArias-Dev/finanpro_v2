import 'package:flutter/material.dart';

class AmortizacionScreen extends StatefulWidget {
  const AmortizacionScreen({super.key});

  @override
  _AmortizacionScreen createState() => _AmortizacionScreen();
}

class _AmortizacionScreen extends State<AmortizacionScreen> {
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
                "Amortización",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Es el proceso de pagar una deuda a través de pagos regulares y programados. En cada pago se abona una parte del capital y otra parte de los intereses generados.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

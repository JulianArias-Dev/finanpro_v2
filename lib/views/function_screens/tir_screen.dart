import 'package:finanpro_v2/controllers/text_formater.dart';
import 'package:finanpro_v2/views/components/my_image.dart';
import 'package:finanpro_v2/views/components/text_field.dart';
import 'package:finanpro_v2/controllers/tir_controller.dart';
import 'package:flutter/material.dart';

class TirScreen extends StatefulWidget {
  const TirScreen({super.key});

  @override
  _TirScreen createState() => _TirScreen();
}

class _TirScreen extends State<TirScreen> {
  TirController controller = TirController();
  TextEditingController inversionController = TextEditingController();
  List<TextEditingController> flujoControllers = [TextEditingController()];
  String reusltado = '';

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
                "La TIR es una métrica utilizada para evaluar la rentabilidad de una inversión. Representa la tasa de descuento que hace que el VPN sea igual a cero.",
                style: TextStyle(fontSize: 16),
              ),
              buildImage(context, 'assets/formulas/TIR.png', 0.25),
              buildTextField(
                'Inversión Inicial (\$)',
                inversionController,
                isNumeric: true,
                isMoney: true,
              ),
              const SizedBox(height: 10),
              const Text(
                "Flujos de efectivo:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Column(
                children: List.generate(flujoControllers.length, (index) {
                  return buildTextField(
                    'Flujo ${index + 1} (\$)',
                    flujoControllers[index],
                    isNumeric: true,
                    isMoney: true,
                  );
                }),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        flujoControllers.add(TextEditingController());
                      });
                    },
                    child: const Text("Agregar flujo"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        flujoControllers.removeAt(flujoControllers.length - 1);
                      });
                    },
                    child: const Text("Eliminar flujo"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  try {
                    List<double> flujos = [];
                    flujos.add(parseCurrency(inversionController.text));
                    flujos.addAll(
                      flujoControllers
                          .map((c) => parseCurrency(c.text))
                          .toList(),
                    );

                    double tir = controller.calcularTIR(flujos);
                    setState(() {
                      reusltado = 'La TIR es: \$${formatCurrency(tir)}%';
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 55),
                  backgroundColor: const Color.fromARGB(255, 111, 183, 31),
                  foregroundColor: Colors.white, // Text color
                ),
                child: Text("Calcular TIR"),
              ),
              Text(
                reusltado,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

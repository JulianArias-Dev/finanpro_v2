import 'package:finanpro_v2/controllers/anualidades_controller.dart';
import 'package:finanpro_v2/controllers/text_formater.dart';
import 'package:finanpro_v2/views/components/my_image.dart';
import 'package:flutter/material.dart';
import '../components/text_field.dart';

class AnualidadesScreen extends StatefulWidget {
  const AnualidadesScreen({super.key});

  @override
  _AnualidadesScreenState createState() => _AnualidadesScreenState();
}

class _AnualidadesScreenState extends State<AnualidadesScreen> {
  AnualidadesController controller = AnualidadesController();
  TextEditingController capitalController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController periodController = TextEditingController();
  TextEditingController resultController = TextEditingController();
  bool isPresentValue = false;
  bool isFutureValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                "Anualidades",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Las anualidades son pagos periódicos iguales que no necesariamente tienen que ser anuales como lo indica su nombre; un ejemplo de este tipo de pagos son las pensiones, seguros, deudas pactadas con abonos iguales, etc.",
                style: TextStyle(fontSize: 16),
              ),
              buildImage(context, 'assets/formulas/Anualidades.png', 0.3),
              Row(
                children: [
                  Checkbox(
                    value: isPresentValue,
                    onChanged: (bool? value) {
                      setState(() {
                        isPresentValue = value!;
                        isFutureValue = !isPresentValue;
                      });
                    },
                  ),
                  const Text("Valor Actual"),
                  const SizedBox(width: 15),
                  Checkbox(
                    value: isFutureValue,
                    onChanged: (bool? value) {
                      setState(() {
                        isFutureValue = value!;
                        isPresentValue = !isFutureValue;
                      });
                    },
                  ),
                  const Text("Valor Final"),
                ],
              ),
              buildTextField(
                "Capital (\$)",
                capitalController,
                isNumeric: true,
                isMoney: true,
              ),
              buildTextField(
                "Tasa de anualidad (%)",
                rateController,
                isNumeric: true,
              ),
              buildTextField(
                "Periodos de Capitalizacion",
                periodController,
                isNumeric: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  double capital = parseCurrency(capitalController.text);
                  double i = parseCurrency(rateController.text);
                  int n = parseCurrency(periodController.text).toInt();
                  try {
                    if (isFutureValue) {
                      resultController.text = formatCurrency(
                        controller.calcularValorFinal(capital, i / 100, n),
                      );
                    } else if (isPresentValue) {
                      resultController.text = formatCurrency(
                        controller.calcularValorActual(capital, i / 100, n),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Debe escoger una opción para calcular.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
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
                child: const Text("Calcular", style: TextStyle(fontSize: 20)),
              ),
              buildTextField(
                "Valor Final/Actual (\$)",
                resultController,
                isNumeric: true,
                isMoney: true,
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

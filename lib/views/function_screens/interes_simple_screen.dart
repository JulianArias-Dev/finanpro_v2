import 'package:finanpro_v2/controllers/interes_simple_controller.dart';
import 'package:finanpro_v2/models/tiempo.dart';
import 'package:finanpro_v2/controllers/text_formater.dart';
import 'package:finanpro_v2/views/components/my_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import '../components/text_field.dart';

class InteresSimpleScreen extends StatelessWidget {
  const InteresSimpleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    InteresSimpleController logicController = InteresSimpleController();
    TextEditingController capitalController = TextEditingController();
    TextEditingController rateController = TextEditingController();
    TextEditingController yearController = TextEditingController();
    TextEditingController monthController = TextEditingController();
    TextEditingController dayController = TextEditingController();
    TextEditingController interesController = TextEditingController();

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
                "Interés Simple",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "El interés simple se genera sobre un capital inicial con una tasa fija sobre el saldo original de la inversión o préstamo.",
                style: TextStyle(fontSize: 16),
              ),
              buildImage(context, 'assets/formulas/InteresSimple.png', 0.20),
              buildTextField(
                "Capital (\$)",
                capitalController,
                isNumeric: true,
                isMoney: true,
              ),
              buildTextField(
                "Tasa de interés (%)",
                rateController,
                isNumeric: true,
              ),
              const SizedBox(height: 5),
              const Text('Tiempo'),
              Row(
                children: [
                  Expanded(
                    child: buildTextField(
                      "Años",
                      yearController,
                      isNumeric: true,
                    ),
                  ),
                  Expanded(
                    child: buildTextField(
                      "Meses",
                      monthController,
                      isNumeric: true,
                    ),
                  ),
                  Expanded(
                    child: buildTextField(
                      "Días",
                      dayController,
                      isNumeric: true,
                    ),
                  ),
                ],
              ),
              buildTextField(
                "Interés total (\$)",
                interesController,
                isNumeric: true,
                isMoney: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  double capital = parseCurrency(capitalController.text);
                  double rate = parseCurrency(rateController.text);
                  double generated = parseCurrency(interesController.text);

                  int year =
                      int.tryParse(toNumericString(yearController.text)) ?? 0;
                  int month =
                      int.tryParse(toNumericString(monthController.text)) ?? 0;
                  int day =
                      int.tryParse(toNumericString(dayController.text)) ?? 0;
                  Tiempo duree = Tiempo(year, month, day);

                  try {
                    if (capital == 0) {
                      capitalController.text = formatCurrency(
                        logicController.calcularCapitalSimple(
                          rate / 100,
                          generated,
                          duree,
                        ),
                      );
                    } else if (rate == 0) {
                      double newrate =
                          logicController.calcularTasaInteresSimple(
                            capital,
                            generated,
                            duree,
                          ) *
                          100;
                      rateController.text = newrate.toStringAsFixed(2);
                    } else if (duree.isEmpty()) {
                      duree = logicController.calcularTiempoInteresSimple(
                        capital,
                        rate / 100,
                        generated,
                      );
                      yearController.text = duree.years.toString();
                      monthController.text = duree.months.toString();
                      dayController.text = duree.days.toString();
                    } else if (generated == 0) {
                      interesController.text = formatCurrency(
                        logicController.calculerInteretSimple(
                          capital,
                          rate / 100,
                          duree,
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
            ],
          ),
        ),
      ),
    );
  }
}

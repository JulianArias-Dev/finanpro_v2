import 'package:finanpro_v2/controllers/interes_simple_controller.dart';
import 'package:finanpro_v2/models/tiempo.dart';
import 'package:flutter/material.dart';
import 'components/text_field.dart';

class InterestScreen extends StatelessWidget {
  const InterestScreen({super.key});

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
              const SizedBox(height: 20),
              buildTextField("Capital (\$)", capitalController),
              buildTextField("Tasa de interés (%)", rateController),
              const SizedBox(height: 5),
              const Text('Tiempo'),
              Row(
                children: [
                  Expanded(child: buildTextField("Años", yearController)),
                  Expanded(child: buildTextField("Meses", monthController)),
                  Expanded(child: buildTextField("Días", dayController)),
                ],
              ),
              buildTextField("Interés total (\$)", interesController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  double capital = double.tryParse(capitalController.text) ?? 0;
                  double rate = double.tryParse(rateController.text) ?? 0;
                  int year = int.tryParse(yearController.text) ?? 0;
                  int month = int.tryParse(monthController.text) ?? 0;
                  int day = int.tryParse(dayController.text) ?? 0;
                  Tiempo duree = Tiempo(year, month, day);
                  double generated =
                      double.tryParse(interesController.text) ?? 0;
                  try {
                    if (capital == 0) {
                      capitalController.text = logicController
                          .calcularCapitalSimple(rate / 100, generated, duree)
                          .toStringAsFixed(2);
                    } else if (rate == 0) {
                      rateController.text = (logicController
                                  .calcularTasaInteresSimple(
                                    capital,
                                    generated,
                                    duree,
                                  ) *
                              100)
                          .toStringAsFixed(2);
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
                      interesController.text = logicController
                          .calculerInteretSimple(capital, rate / 100, duree)
                          .toStringAsFixed(2);
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

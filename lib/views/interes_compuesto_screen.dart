import 'package:finanpro_v2/controllers/interes_compuesto_controller.dart';
import 'package:flutter/material.dart';
import 'components/text_field.dart';
import '../models/tiempo.dart';

class InteresCompuestoScreen extends StatefulWidget {
  const InteresCompuestoScreen({super.key});

  @override
  _InteresCompuestoScreen createState() => _InteresCompuestoScreen();
}

class _InteresCompuestoScreen extends State<InteresCompuestoScreen> {
  InteresCompuestoController logicController = InteresCompuestoController();
  TextEditingController capitalController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController interesController = TextEditingController();
  bool isMonthly = false;
  bool isAnnual = false;

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
                "Interés Compuesto",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Es aquel que se va sumando al capital inicial y sobre el que se van generando nuevos intereses. El dinero, en este caso, tiene un efecto multiplicador porque los intereses producen nuevos intereses.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text('Capitalización:'),
              Row(
                children: [
                  Checkbox(
                    value: isMonthly,
                    onChanged: (bool? value) {
                      setState(() {
                        isMonthly = value!;
                        isAnnual = !isMonthly;
                      });
                    },
                  ),
                  const Text("Mensual"),
                  const SizedBox(width: 15),
                  Checkbox(
                    value: isAnnual,
                    onChanged: (bool? value) {
                      setState(() {
                        isAnnual = value!;
                        isMonthly = !isAnnual;
                      });
                    },
                  ),
                  const Text("Anual"),
                ],
              ),
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
              buildTextField("Valor final (\$)", interesController),
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
                  String type =
                      isAnnual
                          ? 'annual'
                          : isMonthly
                          ? 'monthly'
                          : '';
                  try {
                    if (type.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Debe escoger una opción para calcular.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    if (capital == 0) {
                      capitalController.text = logicController
                          .calcularCapitalCompuesto(
                            rate / 100,
                            generated,
                            duree,
                            type,
                          )
                          .toStringAsFixed(2);
                    } else if (rate == 0) {
                      rateController.text = (logicController
                                  .calcularTasaInteresCompuesto(
                                    capital,
                                    generated,
                                    duree,
                                    type,
                                  ) *
                              100)
                          .toStringAsFixed(2);
                    } else if (duree.isEmpty()) {
                      duree = logicController.calcularTiempoInteresCompuesto(
                        capital,
                        rate / 100,
                        generated,
                        type,
                      );
                      yearController.text = duree.years.toString();
                      monthController.text = duree.months.toString();
                      dayController.text = duree.days.toString();
                    } else if (generated == 0) {
                      interesController.text = logicController
                          .calcularInteresCompuesto(
                            capital,
                            rate / 100,
                            duree,
                            type,
                          )
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

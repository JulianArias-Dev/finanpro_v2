import 'package:finanpro_v2/controllers/interes_compuesto_controller.dart';
import 'package:finanpro_v2/controllers/text_formater.dart';
import 'package:finanpro_v2/views/components/my_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import '../components/text_field.dart';
import '../../models/tiempo.dart';

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
  bool _isLoading = false;

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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                  buildImage(
                    context,
                    'assets/formulas/InteresCompuesto.png',
                    0.3,
                  ),
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
                  buildTextField(
                    "Capital (\$)",
                    capitalController,
                    isMoney: true,
                    isNumeric: true,
                  ),
                  buildTextField(
                    "Tasa de interés (%)",
                    rateController,
                    isNumeric: true,
                  ),
                  const SizedBox(height: 5),
                  const Text('Tiempo'),
                  const SizedBox(height: 5),
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
                    "Valor final (\$)",
                    interesController,
                    isMoney: true,
                    isNumeric: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      calcularResultados();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(80, 55),
                      backgroundColor: const Color.fromARGB(255, 111, 183, 31),
                      foregroundColor: Colors.white, // Text color
                    ),
                    child: const Text(
                      "Calcular",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  void calcularResultados() async {
    FocusScope.of(context).unfocus(); // Oculta el teclado

    double capital = parseCurrency(capitalController.text);
    double rate = parseCurrency(rateController.text);
    double generated = parseCurrency(interesController.text);

    int year = int.tryParse(toNumericString(yearController.text)) ?? 0;
    int month = int.tryParse(toNumericString(monthController.text)) ?? 0;
    int day = int.tryParse(toNumericString(dayController.text)) ?? 0;
    Tiempo duree = Tiempo(year, month, day);

    String type =
        isAnnual
            ? 'annual'
            : isMonthly
            ? 'monthly'
            : '';
    try {
      if (capital != 0 && rate != 0 && generated != 0 && !duree.isEmpty()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se ha identificado una variable desconocida para calcular. '
              'Asegúrese de dejar un campo vacío o en cero.',
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2)); // Simula espera
      if (type.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debe escoger una opción para calcular.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (capital == 0) {
        capitalController.text = formatCurrency(
          logicController.calcularCapitalCompuesto(
            rate / 100,
            generated,
            duree,
            type,
          ),
        );
      } else if (rate == 0) {
        rateController.text = formatCurrency(
          logicController.calcularTasaInteresCompuesto(
                capital,
                generated,
                duree,
                type,
              ) *
              100,
        );
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
        interesController.text = formatCurrency(
          logicController.calcularInteresCompuesto(
            capital,
            rate / 100,
            duree,
            type,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

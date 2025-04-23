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
                    "Anualidades",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Las anualidades son pagos periódicos iguales...",
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
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      await Future.delayed(
                        const Duration(seconds: 2),
                      ); // Simula espera

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
                      } finally {
                        setState(() => _isLoading = false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(80, 55),
                      backgroundColor: const Color.fromARGB(255, 111, 183, 31),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Calcular",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
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

          // Overlay: Capa encima cuando se está cargando
          if (_isLoading)
            Container(
              color: Color.fromARGB(
                120,
                0,
                0,
                0,
              ), // Color de fondo semitransparente
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:finanpro_v2/controllers/series_controller.dart';
import 'package:finanpro_v2/controllers/text_formater.dart';
import 'package:finanpro_v2/views/components/text_field.dart';
import 'package:flutter/material.dart';

class SeriesVariablesScreen extends StatefulWidget {
  const SeriesVariablesScreen({super.key});

  @override
  _SeriesVariablesScreen createState() => _SeriesVariablesScreen();
}

class _SeriesVariablesScreen extends State<SeriesVariablesScreen> {
  SeriesVariablesController controller = SeriesVariablesController();
  TextEditingController pagosController = TextEditingController();
  TextEditingController variacionController = TextEditingController();
  TextEditingController periodoController = TextEditingController();
  TextEditingController tasaController = TextEditingController();
  TextEditingController vpController = TextEditingController();
  TextEditingController vfController = TextEditingController();

  String tipoGradiente = 'Lineal';

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
                "Series de Variables",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Aquí puedes calcular el valor futuro o presente de una serie de variables.",
                style: TextStyle(fontSize: 16),
              ),

              /// Combobox para tipo de gradiente
              DropdownButtonFormField<String>(
                value: tipoGradiente,
                decoration: const InputDecoration(
                  labelText: "Tipo de Serie",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Lineal', child: Text('Lineal')),
                  DropdownMenuItem(
                    value: 'Geométrico',
                    child: Text('Geométrico'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    tipoGradiente = value!;
                    variacionController.clear();
                  });
                },
              ),
              const SizedBox(height: 20),

              buildTextField(
                "Serie de pagos Uniformes (A)",
                pagosController,
                isNumeric: true,
                isMoney: true,
              ),
              // Campo que cambia dinámicamente
              buildTextField(
                tipoGradiente == 'Lineal' ? "Variación (G)" : "Variación (G%)",
                variacionController,
                isNumeric: true,
                isMoney: tipoGradiente == 'Lineal' ? true : false,
              ),
              buildTextField(
                "Periodos (n)",
                periodoController,
                isNumeric: true,
              ),
              buildTextField(
                "Tasa de interés (%)",
                tasaController,
                isNumeric: true,
              ),
              const SizedBox(height: 5),
              buildTextField(
                "Valor Presente (VP)",
                vpController,
                isNumeric: true,
                isMoney: true,
                readOnly: true,
              ),
              buildTextField(
                "Valor Futuro (VF)",
                vfController,
                isNumeric: true,
                isMoney: true,
                readOnly: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Lógica para calcular el gradiente
                  double pagos = parseCurrency(pagosController.text);
                  double variacion = parseCurrency(variacionController.text);
                  variacion =
                      tipoGradiente == 'Lineal' ? variacion : (variacion / 100);
                  int periodo = parseCurrency(periodoController.text).toInt();
                  double tasa = parseCurrency(tasaController.text);

                  try {
                    Map<String, double> resultado = {};

                    /// Calculo de VP y VF
                    if (tipoGradiente == 'Lineal') {
                      resultado = controller.serieLineal(
                        g: variacion,
                        A: pagos,
                        n: periodo,
                        i: tasa / 100,
                      );
                    } else {
                      resultado = controller.serieGeometrica(
                        g: variacion,
                        A: pagos,
                        n: periodo,
                        i: tasa / 100,
                      );
                    }

                    // Actualizar los campos de texto con los resultados
                    vpController.clear();
                    vfController.clear();
                    vpController.text = formatCurrency(resultado["vp"]!);
                    vfController.text = formatCurrency(resultado["vf"]!);
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
                child: const Text("Calcular"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

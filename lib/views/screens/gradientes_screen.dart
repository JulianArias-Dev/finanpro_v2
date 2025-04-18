import 'package:finanpro_v2/controllers/gradientes_controller.dart';
import 'package:finanpro_v2/controllers/text_formater.dart';
import 'package:flutter/material.dart';
import 'package:finanpro_v2/views/components/text_field.dart';

class GradientesScreen extends StatefulWidget {
  const GradientesScreen({super.key});

  @override
  _GradientesScreen createState() => _GradientesScreen();
}

class _GradientesScreen extends State<GradientesScreen> {
  GradientesController controller = GradientesController();
  TextEditingController pagosController = TextEditingController();
  TextEditingController variacionController = TextEditingController();
  TextEditingController periodoController = TextEditingController();
  TextEditingController tasaController = TextEditingController();
  TextEditingController vpController = TextEditingController();
  TextEditingController vfController = TextEditingController();

  Map<String, String> tipos = {
    'Aritmético': 'GradienteAritmetico',
    'Geométrico Creciente': 'GradGeoCreciente',
    'Geométrico Decreciente': 'GradGeoDecreciente',
  };
  String tipoGradiente = 'Aritmético';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FinanPro",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        backgroundColor: const Color.fromARGB(255, 111, 183, 31),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Gradientes",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Los gradientes son una forma de representar visualmente la variación de un valor a lo largo del tiempo. En el contexto financiero, los gradientes se utilizan para mostrar cómo cambian los flujos de efectivo a lo largo de un período.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(context).size.height *
                      0.3, // 30% de alto pantalla
                ),
                child: Image.asset(
                  'assets/formulas/${tipos[tipoGradiente]}.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

              /// Combobox para tipo de gradiente
              DropdownButtonFormField<String>(
                value: tipoGradiente,
                decoration: const InputDecoration(
                  labelText: "Tipo de gradiente",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Aritmético',
                    child: Text('Aritmético'),
                  ),
                  DropdownMenuItem(
                    value: 'Geométrico Creciente',
                    child: Text('Geométrico Creciente'),
                  ),
                  DropdownMenuItem(
                    value: 'Geométrico Decreciente',
                    child: Text('Geométrico Decreciente'),
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
                tipoGradiente == 'Aritmético'
                    ? "Variación (G)"
                    : "Variación (G%)",
                variacionController,
                isNumeric: true,
                isMoney: tipoGradiente == 'Aritmético' ? true : false,
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
                readOnly: false,
              ),
              buildTextField(
                "Valor Futuro (VF)",
                vfController,
                isNumeric: true,
                isMoney: true,
                readOnly: false,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Lógica para calcular el gradiente
                  double pagos = parseCurrency(pagosController.text);
                  double variacion = parseCurrency(variacionController.text);
                  variacion =
                      tipoGradiente == 'Aritmético'
                          ? variacion
                          : (variacion / 100);
                  int periodo = int.tryParse(periodoController.text) ?? 0;
                  double tasa = double.tryParse(tasaController.text) ?? 0;

                  try {
                    Map<String, double> resultado = {};

                    /// Calculo de VP y VF
                    if (tipoGradiente == 'Aritmético') {
                      resultado = controller.aritmetica(
                        g: variacion,
                        A: pagos,
                        n: periodo,
                        i: tasa / 100,
                      );
                    } else {
                      if (variacion > 0) {
                        resultado = controller.geoCreciente(
                          g: variacion,
                          A: pagos,
                          n: periodo,
                          i: tasa / 100,
                        );
                      } else {
                        resultado = controller.geoDecreciente(
                          g: variacion,
                          A: pagos,
                          n: periodo,
                          i: tasa / 100,
                        );
                      }
                    }
                    // Asignar los resultados a los controladores de texto
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

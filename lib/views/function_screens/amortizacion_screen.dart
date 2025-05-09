import 'package:finanpro_v2/controllers/amortizacion_controller.dart';
import 'package:finanpro_v2/controllers/text_formater.dart';
import 'package:finanpro_v2/views/components/text_field.dart';
import 'package:finanpro_v2/views/components/my_image.dart';
import 'package:flutter/material.dart';

class AmortizacionScreen extends StatefulWidget {
  const AmortizacionScreen({super.key});

  @override
  _AmortizacionScreen createState() => _AmortizacionScreen();
}

class _AmortizacionScreen extends State<AmortizacionScreen> {
  AmortizacionController logicController = AmortizacionController();
  TextEditingController capitalCcontroller = TextEditingController();
  TextEditingController periodosController = TextEditingController();
  TextEditingController tasaInteresController = TextEditingController();
  String detailtxt = '';
  Map<String, String> tipos = {
    'Francesa': 'AmFrancesa',
    'Alemana': 'AmAlemana',
    'Americana': 'AmAmericana',
  };
  String tipoAmortizacion = 'Francesa';
  bool _isLoading = false;
  List<Map<String, dynamic>> tablaAmortizacion = [];

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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                  buildImage(
                    context,
                    'assets/formulas/${tipos[tipoAmortizacion]}.png',
                    0.35,
                  ),
                  DropdownButtonFormField<String>(
                    value: tipoAmortizacion,
                    decoration: const InputDecoration(
                      labelText: "Tipo de Amortización",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Francesa',
                        child: Text('Francesa'),
                      ),
                      DropdownMenuItem(
                        value: 'Alemana',
                        child: Text('Alemana'),
                      ),
                      DropdownMenuItem(
                        value: 'Americana',
                        child: Text('Americana'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        detailtxt = '';
                        tipoAmortizacion = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  buildTextField(
                    'Capital Inicial (\$)',
                    capitalCcontroller,
                    isNumeric: true,
                    isMoney: true,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          'Tasa de Interés (%)',
                          tasaInteresController,
                          isNumeric: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: buildTextField(
                          'Número de Periodos',
                          periodosController,
                          isNumeric: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      calcularResultados();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(80, 55),
                      backgroundColor: const Color.fromARGB(255, 111, 183, 31),
                      foregroundColor: Colors.white, // Text color
                    ),
                    child: const Text("Calcular"),
                  ),
                  const SizedBox(height: 20),
                  if (tablaAmortizacion.isNotEmpty)
                    const Text(
                      "Deslize hacia la izquierda para ver la tabla...",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Periodo")),
                        DataColumn(label: Text("Cuota")),
                        DataColumn(label: Text("Pago de Interés")),
                        DataColumn(label: Text("Abono al Capital")),
                        DataColumn(label: Text("Capital Restante")),
                      ],
                      rows:
                          tablaAmortizacion.asMap().entries.map((entry) {
                            final index = entry.key + 1;
                            final data = entry.value;

                            return DataRow(
                              cells: [
                                DataCell(Text(index.toString())),
                                DataCell(Text(formatCurrency(data['cuota']))),
                                DataCell(
                                  Text(formatCurrency(data['abono interes'])),
                                ),
                                DataCell(
                                  Text(formatCurrency(data['abono capital'])),
                                ),
                                DataCell(Text(formatCurrency(data['capital']))),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
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
            ),
          ),
        ],
      ),
    );
  }

  void calcularResultados() async {
    FocusScope.of(context).unfocus();
    try {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2)); // Simula espera
      double capital = parseCurrency(capitalCcontroller.text);
      double tasaInteres = double.parse(tasaInteresController.text) / 100;
      int periodos = int.parse(periodosController.text);

      setState(() {
        tablaAmortizacion = []; // Limpia
        switch (tipoAmortizacion) {
          case 'Francesa':
            tablaAmortizacion = logicController.francesa(
              capital,
              tasaInteres,
              periodos,
            );
            break;

          case 'Americana':
            tablaAmortizacion = logicController.americana(
              capital,
              tasaInteres,
              periodos,
            );
            break;

          case 'Alemana':
            tablaAmortizacion = logicController.alemana(
              capital,
              tasaInteres,
              periodos,
            );
            break;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

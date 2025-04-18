import 'package:finanpro_v2/controllers/amortizacion_controller.dart';
import 'package:finanpro_v2/controllers/text_formater.dart';
import 'package:finanpro_v2/views/components/text_field.dart';
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
  TextEditingController cuotaController = TextEditingController();
  String detailtxt = '';
  Map<String, String> tipos = {
    'Francesa': 'AmFrancesa',
    'Alemana': 'AmAlemana',
    'Americana': 'AmAmericana',
  };
  String tipoAmortizacion = 'Francesa';
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
      body: SingleChildScrollView(
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
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(context).size.height *
                      0.3, // 30% de alto pantalla
                ),
                child: Image.asset(
                  'assets/formulas/${tipos[tipoAmortizacion]}.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: tipoAmortizacion,
                decoration: const InputDecoration(
                  labelText: "Tipo de Amortización",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Francesa', child: Text('Francesa')),
                  DropdownMenuItem(value: 'Alemana', child: Text('Alemana')),
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
              const SizedBox(height: 5),
              tipoAmortizacion == 'Francesa' || tipoAmortizacion == 'Americana'
                  ? buildTextField(
                    'Cuotas Fijas',
                    cuotaController,
                    isNumeric: true,
                    isMoney: true,
                  )
                  : Container(),
              Text(
                detailtxt,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  double capital = parseCurrency(capitalCcontroller.text);
                  double tasaInteres =
                      double.parse(tasaInteresController.text) / 100;
                  int periodos = int.parse(periodosController.text);

                  setState(() {
                    switch (tipoAmortizacion) {
                      case 'Francesa':
                        double cuota = logicController.francesa(
                          capital,
                          tasaInteres,
                          periodos,
                        );
                        cuotaController.text = formatCurrency(cuota);
                        detailtxt =
                            'Usted pagará \$${formatCurrency(cuota)} durante $periodos meses.';
                        tablaAmortizacion = []; // Limpia
                        break;

                      case 'Americana':
                        double cuotaInteres = logicController.americana(
                          capital,
                          tasaInteres,
                          periodos,
                        );
                        cuotaController.text = formatCurrency(cuotaInteres);
                        detailtxt =
                            'Usted pagará \$${formatCurrency(cuotaInteres)} de interés, durante ${periodos - 1} meses.\n El último mes pagará el capital + intereses \$${formatCurrency(capital + cuotaInteres)}.';
                        tablaAmortizacion = []; // Limpia
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
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 55),
                  backgroundColor: const Color.fromARGB(255, 111, 183, 31),
                  foregroundColor: Colors.white, // Text color
                ),
                child: const Text("Calcular"),
              ),
              const SizedBox(height: 20),
              tipoAmortizacion == 'Alemana'
                  ? const Text(
                    "Deslize hacia la izquierda para ver la tabla...",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                  : Container(),
              const SizedBox(height: 10),
              if (tablaAmortizacion.isNotEmpty)
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
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:math';
import 'package:finanpro_v2/controllers/PrestamoController.dart';
import 'package:flutter/material.dart';

class SolicitarPrestamoScreen extends StatefulWidget {
  const SolicitarPrestamoScreen({super.key});

  @override
  _SolicitarPrestamoScreenState createState() =>
      _SolicitarPrestamoScreenState();
}

class _SolicitarPrestamoScreenState extends State<SolicitarPrestamoScreen> {
  TextEditingController capitalController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController periodController = TextEditingController();
  TextEditingController cuotaController = TextEditingController();
  bool _isLoading = false;

  final double fixedInterestRate = 0.12; // 12% fijo
  List<Map<String, num>> _payments = [];

  final List<String> calculationTypes = [
    'Interés Simple',
    'Interés Compuesto',
    'Amortización',
    'Gradiente',
    'Anualidades',
  ];

  String selectedCalculationType = 'Amortización';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Solicitar Préstamo",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        backgroundColor: const Color.fromARGB(255, 111, 183, 31),
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
                    "Simulación de Préstamo",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Este cálculo te muestra cómo se distribuyen tus pagos mensuales en capital e intereses.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Tasa de interés fija: ${fixedInterestRate * 100}%",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),

                  /// Campo: Selección de tipo de cálculo
                  DropdownButtonFormField<String>(
                    value: selectedCalculationType,
                    items:
                        calculationTypes
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCalculationType = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Tipo de Cálculo",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    "Monto del Préstamo (\$)",
                    capitalController,
                    isNumeric: true,
                    isMoney: true,
                  ),
                  const SizedBox(height: 15),

                  _buildTextField(
                    "Tasa de Interés (%)",
                    rateController,
                    isNumeric: true,
                  ),
                  const SizedBox(height: 15),

                  _buildTextField(
                    "Períodos (meses)",
                    periodController,
                    isNumeric: true,
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      calcularResultados();
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
                  const SizedBox(height: 15),

                  _buildTextField(
                    "Cuota Mensual",
                    cuotaController,
                    isNumeric: true,
                    isMoney: true,
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),

                  if (_payments.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Distribución de pagos:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildPaymentDistributionTable(),
                      ],
                    ),
                  const SizedBox(height: 20),

                  if (!_isLoading)
                    ElevatedButton(
                      onPressed: () async {
                        double capital =
                            double.tryParse(capitalController.text) ?? 0;
                        double tasa = double.tryParse(rateController.text) ?? 0;
                        int periodos = int.tryParse(periodController.text) ?? 0;
                        double cuota =
                            double.tryParse(cuotaController.text) ?? 0;

                        final prestamoController = PrestamoController();
                        await prestamoController.registrarPrestamo(
                          uid: "1",
                          monto: capital,
                          tasa: tasa,
                          periodos: periodos,
                          cuotaMensual: cuota,
                        );
                        try {
                          final result =
                              await prestamoController.obtenerPrestamos();

                          // Imprimir el resultado en la consola
                          if (result.isNotEmpty) {
                            print("Préstamos encontrados:");
                            for (var prestamo in result) {
                              print("Monto: ${prestamo['monto']}");
                              print("Tasa: ${prestamo['tasa']}");
                              print("Periodos: ${prestamo['periodos']}");
                              print(
                                "Cuota mensual: ${prestamo['cuota_mensual']}",
                              );
                              print("Fecha: ${prestamo['fecha']}");
                              print("---");
                            }
                          } else {
                            print("No hay préstamos para este cliente.");
                          }
                        } catch (e) {
                          print("Error al obtener los préstamos: $e");
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Préstamo solicitado exitosamente."),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(80, 55),
                        backgroundColor: const Color.fromARGB(
                          255,
                          111,
                          183,
                          31,
                        ),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Solicitar Préstamo",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: const Color.fromARGB(120, 0, 0, 0),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumeric = false,
    bool isMoney = false,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType:
          isNumeric
              ? const TextInputType.numberWithOptions(decimal: true)
              : null,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixText: isMoney ? '\$' : null,
        border: const OutlineInputBorder(),
      ),
    );
  }

  void calcularResultados() async {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    double capital = double.tryParse(capitalController.text) ?? 0;
    double tasa = (double.tryParse(rateController.text) ?? 0) / 100;
    int periodos = int.tryParse(periodController.text) ?? 0;

    try {
      double cuota = 0;
      List<Map<String, num>> pagos = [];

      switch (selectedCalculationType) {
        case 'Interés Simple':
          cuota = capital * tasa * periodos;
          cuotaController.text = formatCurrency(capital + cuota);
          pagos = [
            {'period': 1, 'interest': cuota, 'principal': capital},
          ];
          break;

        case 'Interés Compuesto':
          double montoFinal = capital * pow(1 + tasa, periodos);
          cuotaController.text = formatCurrency(montoFinal);
          pagos = [
            {
              'period': periodos,
              'interest': montoFinal - capital,
              'principal': capital,
            },
          ];
          break;

        case 'Amortización':
          cuota = _calcularCuota(capital, tasa, periodos);
          cuotaController.text = formatCurrency(cuota);
          pagos = _generarTablaAmortizacion(capital, tasa, periodos, cuota);
          break;

        case 'Gradiente':
          double g = 100; // incremento fijo simulado
          for (int i = 1; i <= periodos; i++) {
            cuota += capital + g * (i - 1);
          }
          cuotaController.text = formatCurrency(cuota);
          pagos = List.generate(periodos, (i) {
            return {
              'period': i + 1,
              'interest': 0,
              'principal': capital + 100 * i,
            };
          });
          break;

        case 'Anualidades':
          cuota =
              capital *
              (tasa * pow(1 + tasa, periodos)) /
              (pow(1 + tasa, periodos) - 1);
          cuotaController.text = formatCurrency(cuota);
          pagos = List.generate(periodos, (i) {
            double interes = capital * tasa;
            double abono = cuota - interes;
            capital -= abono;
            return {'period': i + 1, 'interest': interes, 'principal': abono};
          });
          break;

        default:
          cuotaController.text = "N/A";
          pagos = [];
      }

      setState(() {
        _payments = pagos;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  double _calcularCuota(double capital, double tasa, int periodos) {
    return (capital * tasa) / (1 - pow(1 + tasa, -periodos));
  }

  void _showPaymentDistribution(double capital, double tasa, int periodos) {
    final cuota = _calcularCuota(capital, tasa, periodos);
    final payments = List.generate(periodos, (index) {
      double interestPayment = capital * tasa;
      double principalPayment = cuota - interestPayment;
      capital -= principalPayment;
      return {
        'period': index + 1,
        'interest': interestPayment,
        'principal': principalPayment,
      };
    });

    setState(() {
      _payments = payments;
    });
  }

  Widget _buildPaymentDistributionTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text("Período")),
          DataColumn(label: Text("Intereses (\$)")),
          DataColumn(label: Text("Capital (\$)")),
        ],
        rows:
            _payments.map((payment) {
              return DataRow(
                cells: [
                  DataCell(Text(payment['period'].toString())),
                  DataCell(
                    Text(payment['interest']?.toStringAsFixed(2) ?? '0.00'),
                  ),
                  DataCell(
                    Text(payment['principal']?.toStringAsFixed(2) ?? '0.00'),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }
}

List<Map<String, num>> _generarTablaAmortizacion(
  double capital,
  double tasa,
  int periodos,
  double cuota,
) {
  return List.generate(periodos, (index) {
    double interes = capital * tasa;
    double abono = cuota - interes;
    capital -= abono;
    return {'period': index + 1, 'interest': interes, 'principal': abono};
  });
}

String formatCurrency(double value) {
  return "\$${value.toStringAsFixed(2)}";
}

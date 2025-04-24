import 'dart:math';
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

  // Tasa de interés fija informativa
  final double fixedInterestRate = 0.12; // 12% fijo
  List<Map<String, num>> _payments =
      []; // Cambié a num para permitir tanto int como double

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

                  // Tasa de interés fija informativa
                  Text(
                    "Tasa de interés fija: ${fixedInterestRate * 100}%",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),

                  // Campo de Capital
                  _buildTextField(
                    "Monto del Préstamo (\$)",
                    capitalController,
                    isNumeric: true,
                    isMoney: true,
                  ),
                  const SizedBox(height: 15),

                  // Campo de Tasa de Interés
                  _buildTextField(
                    "Tasa de Interés (%)",
                    rateController,
                    isNumeric: true,
                  ),
                  const SizedBox(height: 15),

                  // Campo de Periodos
                  _buildTextField(
                    "Períodos (meses)",
                    periodController,
                    isNumeric: true,
                  ),
                  const SizedBox(height: 20),

                  // Botón Calcular
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

                  // Campo de Resultado de Cuota
                  _buildTextField(
                    "Cuota Mensual",
                    cuotaController,
                    isNumeric: true,
                    isMoney: true,
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),

                  // Mostrar la tabla de pagos si ya se calculó
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

                  // Botón para solicitar el préstamo
                  if (!_isLoading)
                    ElevatedButton(
                      onPressed: () {
                        // Aquí puedes agregar la lógica para solicitar el préstamo
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

          // Overlay: Capa encima cuando se está cargando
          if (_isLoading)
            Container(
              color: const Color.fromARGB(
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

  // Método para construir campos de texto
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
          isNumeric ? TextInputType.numberWithOptions(decimal: true) : null,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixText: isMoney ? '\$' : null,
        border: const OutlineInputBorder(),
      ),
    );
  }

  // Método para calcular resultados
  void calcularResultados() async {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // Simula espera

    double capital = double.tryParse(capitalController.text) ?? 0;
    double tasa = double.tryParse(rateController.text) ?? 0;
    int periodos = int.tryParse(periodController.text) ?? 0;

    try {
      // Cálculo de cuota mensual
      double cuotaMensual = _calcularCuota(capital, tasa / 100, periodos);
      cuotaController.text = formatCurrency(cuotaMensual);

      // Mostrar la distribución de pagos
      _showPaymentDistribution(capital, tasa / 100, periodos);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Función para calcular la cuota mensual
  double _calcularCuota(double capital, double tasa, int periodos) {
    double cuota =
        (capital * tasa) /
        (1 - pow(1 + tasa, -periodos).toDouble()); // Exponentiation corrected
    return cuota;
  }

  // Función para mostrar la distribución de pagos
  void _showPaymentDistribution(double capital, double tasa, int periodos) {
    // Aquí se calcula cómo se distribuye entre capital e intereses a lo largo de los pagos
    final payments = List.generate(periodos, (index) {
      double interestPayment = capital * tasa; // Pago de intereses
      double principalPayment =
          _calcularCuota(capital, tasa, periodos) -
          interestPayment; // Pago del capital
      capital -= principalPayment; // Reducir el capital restante

      return {
        'period': index + 1,
        'interest': interestPayment,
        'principal': principalPayment,
      };
    });

    setState(() {
      // Almacenar la distribución de pagos para la gráfica
      _payments = payments;
    });
  }

  // Construcción de la tabla de distribución de pagos
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

String formatCurrency(double value) {
  // Función para formatear como moneda
  return "\$${value.toStringAsFixed(2)}"; // Ahora con el signo de dólar
}

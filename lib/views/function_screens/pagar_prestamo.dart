import 'package:finanpro_v2/controllers/PrestamoController.dart';
import 'package:flutter/material.dart';

class PagarPrestamoScreen extends StatefulWidget {
  const PagarPrestamoScreen({super.key});

  @override
  _PagarPrestamoScreenState createState() => _PagarPrestamoScreenState();
}

class _PagarPrestamoScreenState extends State<PagarPrestamoScreen> {
  final PrestamoController _prestamoController = PrestamoController();
  List<Map<String, dynamic>> _prestamos = [];
  TextEditingController _pagoController = TextEditingController();
  int? _prestamoSeleccionado;

  // Cargar los préstamos cuando la pantalla se carga
  @override
  void initState() {
    super.initState();
    _cargarPrestamos();
  }

  // Cargar los préstamos
  Future<void> _cargarPrestamos() async {
    try {
      final prestamos =
          await _prestamoController
              .obtenerPrestamos(); // Usa el UID del cliente
      setState(() {
        _prestamos = prestamos;
      });
    } catch (e) {
      print("Error al cargar préstamos: $e");
    }
  }

  // Realizar el pago
  Future<void> _realizarPago() async {
    if (_prestamoSeleccionado == null) {
      return;
    }

    final pago = double.tryParse(_pagoController.text);
    if (pago == null || pago <= 0) {
      // Validación de pago
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingresa un monto válido')),
      );
      return;
    }

    try {
      await _prestamoController.pagarPrestamo(_prestamoSeleccionado!, pago);
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Pago realizado con éxito')));
      // Recargar los préstamos
      _cargarPrestamos();
    } catch (e) {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagar Préstamo'),
        backgroundColor: Colors.green,
      ),
      body:
          _prestamos.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  DropdownButton<int>(
                    value: _prestamoSeleccionado,
                    hint: Text("Selecciona un préstamo"),
                    onChanged: (int? valor) {
                      setState(() {
                        _prestamoSeleccionado = valor;
                      });
                    },
                    items:
                        _prestamos.map((prestamo) {
                          return DropdownMenuItem<int>(
                            value: prestamo['id'],
                            child: Text('Préstamo: \$${prestamo['monto']}'),
                          );
                        }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _pagoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Monto a Pagar',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _realizarPago,
                    child: Text('Pagar'),
                  ),
                ],
              ),
    );
  }
}

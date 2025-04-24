import 'package:finanpro_v2/controllers/PrestamoController.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importa la librería intl

class PrestamosVigentesScreen extends StatefulWidget {
  const PrestamosVigentesScreen({super.key});

  @override
  _PrestamosVigentesScreenState createState() =>
      _PrestamosVigentesScreenState();
}

class _PrestamosVigentesScreenState extends State<PrestamosVigentesScreen> {
  final PrestamoController _prestamoController = PrestamoController();
  List<Map<String, dynamic>> _prestamos = [];

  // Cargar préstamos cuando la pantalla se cargue
  @override
  void initState() {
    super.initState();
    _cargarPrestamos();
  }

  // Método para cargar los préstamos
  Future<void> _cargarPrestamos() async {
    try {
      final prestamos =
          await _prestamoController
              .obtenerPrestamos(); // Cambia esto con el uid del usuario
      setState(() {
        _prestamos = prestamos;
      });
    } catch (e) {
      print("Error al cargar préstamos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Préstamos Vigentes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green, // Color verde en la AppBar
      ),
      body:
          _prestamos.isEmpty
              ? Center(
                child: CircularProgressIndicator(),
              ) // Muestra un loader mientras se cargan los préstamos
              : ListView.builder(
                itemCount: _prestamos.length,
                itemBuilder: (context, index) {
                  final prestamo = _prestamos[index];

                  // Formatear la fecha a un formato legible
                  final fecha = DateTime.parse(prestamo['fecha']);
                  final fechaFormateada = DateFormat(
                    'dd/MM/yyyy',
                  ).format(fecha); // Formato 'día/mes/año'

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text('Monto: \$${prestamo['monto']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tasa: ${prestamo['tasa']}%'),
                          Text('Periodos: ${prestamo['periodos']} meses'),
                          Text('Cuota mensual: \$${prestamo['cuota_mensual']}'),
                          Text(
                            'Fecha: $fechaFormateada',
                          ), // Mostrar la fecha formateada
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
    );
  }
}

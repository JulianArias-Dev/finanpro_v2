import 'package:finanpro_v2/controllers/databasehelper.dart';

class PrestamoController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> registrarPrestamo({
    required String uid, // UID del cliente
    required double monto,
    required double tasa,
    required int periodos,
    required double cuotaMensual,
  }) async {
    // 1. Buscar al cliente por UID

    final db = await _dbHelper.database;
    await db.insert('clientes', {'uid': "1", 'saldo': 0.0});

    final clienteQuery = await db.query(
      'clientes',
      where: 'uid = ?',
      whereArgs: [uid],
    );
    if (clienteQuery.isEmpty) {
      throw Exception("Usuario no encontrado en la base de datos");
    }

    await _dbHelper.insertPrestamo(monto, tasa, periodos, cuotaMensual);
  }

  Future<List<Map<String, dynamic>>> obtenerPrestamos() async {
    final db = await _dbHelper.database;

    // Buscar al cliente por uid
    final clienteQuery = await db.query('clientes', where: 'uid = 1');

    if (clienteQuery.isEmpty) {
      throw Exception("Usuario no encontrado en la base de datos");
    }

    // Obtener los préstamos asociados al cliente
    final prestamosQuery = await db.query('prestamos', where: 'cliente_id = 1');

    return prestamosQuery; // Retorna la lista de préstamos
  }

  // Método para realizar el pago de un préstamo
  Future<void> pagarPrestamo(int prestamoId, double pago) async {
    final db = await _dbHelper.database;

    // Obtener los detalles del préstamo
    final prestamoQuery = await db.query(
      'prestamos',
      where: 'id = ?',
      whereArgs: [prestamoId],
    );

    if (prestamoQuery.isEmpty) {
      throw Exception("Préstamo no encontrado");
    }

    final prestamo = prestamoQuery.first;
    double montoPendiente =
        (prestamo['monto'] as num)
            .toDouble(); // Aseguramos que monto sea un double

    // Verificar que el pago no exceda el monto pendiente
    if (pago > montoPendiente) {
      throw Exception("El pago no puede ser mayor al monto pendiente");
    }

    // Actualizar el préstamo con el nuevo saldo pendiente
    double nuevoMontoPendiente = montoPendiente - pago;
    await db.update(
      'prestamos',
      {'monto': nuevoMontoPendiente},
      where: 'id = ?',
      whereArgs: [prestamoId],
    );
  }
}

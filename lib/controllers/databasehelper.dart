import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _dbName = 'prestamos.db';
  static const String _defaultUid =
      '1'; // UID predefinido para el único usuario

  // Creamos el Singleton de la base de datos
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  // Inicializar la base de datos
  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''  
          CREATE TABLE clientes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            uid TEXT,
            saldo REAL
          )
        ''');

        await db.execute('''
          CREATE TABLE prestamos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cliente_id INTEGER,
            monto REAL,
            tasa REAL,
            periodos INTEGER,
            cuota_mensual REAL,
            fecha TEXT,
            FOREIGN KEY(cliente_id) REFERENCES clientes(id)
          )
        ''');

        // Insertar el cliente por defecto
        await db.insert('clientes', {'uid': _defaultUid, 'saldo': 0.0});
      },
    );
  }

  // Obtener el cliente por defecto (solo hay un cliente con uid 'usuario_1')
  Future<Map<String, dynamic>?> getCliente() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'clientes',
      where: 'uid = ?',
      whereArgs: [_defaultUid],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Insertar un préstamo para el cliente por defecto
  Future<int> insertPrestamo(
    double monto,
    double tasa,
    int periodos,
    double cuotaMensual,
  ) async {
    final db = await database;

    // Obtener el cliente (suponiendo que siempre será el usuario por defecto)
    final cliente = await getCliente();
    if (cliente == null) {
      throw Exception("Cliente no encontrado");
    }

    //final clienteId = cliente['id']; // Obtener el ID del cliente por defecto

    final prestamo = {
      'cliente_id': "1",
      'monto': monto,
      'tasa': tasa,
      'periodos': periodos,
      'cuota_mensual': cuotaMensual,
      'fecha': DateTime.now().toIso8601String(),
    };

    return await db.insert('prestamos', prestamo);
  }

  // Actualizar el saldo del cliente por defecto
  Future<void> actualizarSaldo(double saldo) async {
    final db = await database;

    // Obtener el cliente (suponiendo que siempre será el usuario por defecto)
    final cliente = await getCliente();
    if (cliente == null) {
      throw Exception("Cliente no encontrado");
    }

    final clienteId = cliente['id'];

    await db.update(
      'clientes',
      {'saldo': saldo},
      where: 'id = ?',
      whereArgs: [clienteId],
    );
  }
}

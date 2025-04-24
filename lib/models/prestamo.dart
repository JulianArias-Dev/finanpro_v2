class Prestamo {
  String id;
  String usuarioId;
  double monto;
  double restante;
  DateTime fecha;
  bool pagado;

  Prestamo({
    required this.id,
    required this.usuarioId,
    required this.monto,
    required this.restante,
    required this.fecha,
    this.pagado = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'monto': monto,
      'restante': restante,
      'fecha': fecha.toIso8601String(),
      'pagado': pagado,
    };
  }

  factory Prestamo.fromMap(Map<String, dynamic> map) {
    return Prestamo(
      id: map['id'],
      usuarioId: map['usuarioId'],
      monto: map['monto'],
      restante: map['restante'],
      fecha: DateTime.parse(map['fecha']),
      pagado: map['pagado'],
    );
  }
}

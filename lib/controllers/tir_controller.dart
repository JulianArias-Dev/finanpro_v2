import 'dart:math';
import 'package:finanpro_v2/controllers/validations.dart';

class TirController {
  TirController();

  double calcularTIR(
    List<double> flujos, {
    double estimacionInicial = 0.05,
    double tolerancia = 1e-2,
    int maxIteraciones = 1200,
  }) {
    // Validar Argumentos
    validarMayorQueCero(estimacionInicial, 'Estimación inicial');
    validarMayorIgualCero(tolerancia, 'Tolerancia');
    validarMayorQueCero(maxIteraciones, 'Máximo de iteraciones');
    if (flujos.isEmpty) {
      throw ArgumentError('La lista de flujos no debe estar vacía.');
    }
    for (int i = 0; i < flujos.length; i++) {
      validarMayorIgualCero(flujos[i], 'Flujo de caja en posición $i');
    }

    double tir = estimacionInicial;

    for (int i = 0; i < maxIteraciones; i++) {
      double f = 0.0;
      double df = 0.0;

      for (int t = 0; t < flujos.length; t++) {
        f += flujos[t] / pow(1 + tir, t);
        df += -t * flujos[t] / pow(1 + tir, t + 1);
      }

      double nuevaTir = tir - f / df;

      if ((nuevaTir - tir).abs() < tolerancia) {
        return nuevaTir;
      }

      tir = nuevaTir;
    }

    throw Exception(
      'No se encontró la TIR después de $maxIteraciones iteraciones',
    );
  }
}

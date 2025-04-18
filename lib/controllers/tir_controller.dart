import 'dart:math';

class TirController {
  TirController();

  double calcularTIR(
    List<double> flujos, {
    double estimacionInicial = 0.1,
    double tolerancia = 1e-6,
    int maxIteraciones = 1000,
  }) {
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

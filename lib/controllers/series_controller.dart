import 'dart:math';

class SeriesVariablesController {
  SeriesVariablesController();

  Map<String, double> serieLineal({
    double A = 0,
    double g = 0,
    int n = 0,
    double i = 0,
  }) {
    if (g == 0 || A <= 0 || n <= 0 || i <= 0) {
      throw ArgumentError(
        "Todos los argumentos deben ser mayores que cero, y la variacion debe ser diferente de cero.",
      );
    }
    // A: Valor Anualidad
    // g: Tasa de crecimiento (puede ser positiva o negativa)
    // n: Número de períodos
    // i: Tasa de interés (puede ser positiva o negativa)
    double vp = 0.0;
    double vf = 0.0;

    // Valor Presente (VP)
    vp =
        (A * ((pow(1 + i, n) - 1) / (i * pow(1 + i, n))) +
            g * ((pow(1 + i, n) - 1 - n * i) / (pow(i, 2) * pow(1 + i, n))));

    // Valor Futuro (VF)
    vf =
        (A * (((pow(1 + i, n) - 1) / i)) +
            (g / i) * ((pow(1 + i, n) - 1 - n * i) / i));

    vp = double.parse(vp.toStringAsFixed(0));
    vf = double.parse(vf.toStringAsFixed(0));
    return {'vp': vp, 'vf': vf};
  }

  Map<String, double> serieGeometrica({
    double A = 0,
    double g = 0,
    int n = 0,
    double i = 0,
  }) {
    if (g == 0 || A <= 0 || n <= 0 || i <= 0) {
      throw ArgumentError(
        "Todos los argumentos deben ser mayores que cero, y la variacion debe ser diferente de cero.",
      );
    }
    // A: Valor Anualidad
    // g: Tasa de crecimiento (puede ser positiva o negativa)
    // n: Número de períodos
    // i: Tasa de interés (puede ser positiva o negativa)

    double vp = 0.0;
    double vf = 0.0;

    if (g == i) {
      vp = A * n / (1 + i);
      vf = (A / (1 + i)) * n * pow(1 + i, n);
    } else {
      vp = (A / (i - g)) * (1 - pow((1 + g) / (1 + i), n));
      vf = (A / (i - g)) * (pow(1 + i, n) - pow(1 + g, n));
    }

    vp = double.parse(vp.toStringAsFixed(0));
    vf = double.parse(vf.toStringAsFixed(0));
    return {'vp': vp, 'vf': vf};
  }
}

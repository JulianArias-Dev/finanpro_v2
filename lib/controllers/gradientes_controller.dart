import 'dart:math';

class GradientesController {
  GradientesController();

  Map<String, double> aritmetica({
    double g = 0,
    double A = 0,
    int n = 0,
    double i = 0,
  }) {
    if (g == 0 || A <= 0 || n <= 0 || i <= 0) {
      throw ArgumentError(
        "Todos los argumentos deben ser mayores que cero, y la variacion debe ser diferente de cero.",
      );
    }
    double vp =
        (A * (1 - pow(1 / (1 + i), n)) / i) +
        (g / i) * ((1 - pow(1 / (1 + i), n)) / i - n / pow(1 + i, n));

    double vf =
        (A * (pow(1 + i, n) - 1) / i) + (g / i) * ((pow(1 + i, n) - 1) / i - n);

    vp = double.parse(vp.toStringAsFixed(0));
    vf = double.parse(vf.toStringAsFixed(0));
    return {"vp": vp, "vf": vf};
  }

  Map<String, double> geoCreciente({
    double g = 0,
    double A = 0,
    int n = 0,
    double i = 0,
  }) {
    if (g <= 0 || A <= 0 || n <= 0 || i <= 0) {
      throw ArgumentError("Todos los argumentos deben ser mayores que cero.");
    }
    double vp = 0;
    if (i != g) {
      // Valor Presente (VP)
      vp = (A * ((pow(1 + g, n) - pow(1 + i, n)) / ((g - i) * pow(1 + i, n))));
    } else {
      // Caso especial: i == g
      vp = (n * A) / (1 + i);
    }
    // Valor Futuro (VF)
    double vf = (A * ((pow(1 + g, n) - pow(1 + i, n)) / (g - i)));
    vp = double.parse(vp.toStringAsFixed(0));
    vf = double.parse(vf.toStringAsFixed(0));
    return {"vp": vp, "vf": vf};
  }

  Map<String, double> geoDecreciente({
    double g = 0,
    double A = 0,
    int n = 0,
    double i = 0,
  }) {
    if (g >= 0 || A <= 0 || n <= 0 || i <= 0) {
      throw ArgumentError(
        "Todos los argumentos deben ser mayores que cero, y la variacion debe ser menor que cero.",
      );
    }
    double vp = 0;
    if (i != g) {
      // Valor Presente (VP)
      vp = (A * ((pow(1 + i, n) - pow(1 - g, n)) / ((i + g) * pow(1 + i, n))));
      // Valor Futuro (VF)
    } else {
      // Caso especial: i == g
      vp = A / (1 + i);
      return {"vp": vp};
    }
    double vf = (A * ((pow(1 + i, n) - pow(1 - g, n)) / (i + g)));
    vp = double.parse(vp.toStringAsFixed(0));
    vf = double.parse(vf.toStringAsFixed(0));
    return {"vp": vp, "vf": vf};
  }
}

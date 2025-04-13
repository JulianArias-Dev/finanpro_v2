import 'dart:math';

class GradientesController {
  GradientesController();

  Map<String, double> aritmetica(double g, double A, double n, double i) {
    double vp =
        (A * (1 - pow(1 / (1 + i), n)) / i) +
        (g / i) * ((1 - pow(1 / (1 + i), n)) / i - n / pow(1 + i, n));

    double vf =
        (A * (pow(1 + i, n) - 1) / i) + (g / i) * ((pow(1 + i, n) - 1) / i - n);

    vp = double.parse(vp.toStringAsFixed(0));
    vf = double.parse(vf.toStringAsFixed(0));
    return {"vp": vp, "vf": vf};
  }

  Map<String, double> geoCreciente(double g, double A, double n, double i) {
    if (i != g) {
      // Valor Presente (VP)
      double vp =
          (A * ((pow(1 + g, n) - pow(1 + i, n)) / ((g - i) * pow(1 + i, n))));
      // Valor Futuro (VF)
      double vf = (A * ((pow(1 + g, n) - pow(1 + i, n)) / (g - i)));

      vp = double.parse(vp.toStringAsFixed(0));
      vf = double.parse(vf.toStringAsFixed(0));
      return {"vp": vp, "vf": vf};
    } else {
      // Caso especial: i == g
      double vp = (n * A) / (1 + i);
      vp = double.parse(vp.toStringAsFixed(0));
      return {"vp": vp};
    }
  }

  Map<String, double> geoDecreciente(double g, double A, double n, double i) {
    if (i != g) {
      // Valor Presente (VP)
      double vp =
          (A * ((pow(1 + i, n) - pow(1 - g, n)) / ((i + g) * pow(1 + i, n))));
      // Valor Futuro (VF)
      double vf = (A * ((pow(1 + i, n) - pow(1 - g, n)) / (i + g)));

      return {"vp": vp, "vf": vf};
    } else {
      // Caso especial: i == g
      double vp = A / (1 + i);
      return {"vp": vp};
    }
  }
}

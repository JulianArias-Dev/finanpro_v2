import 'dart:math';
import 'package:finanpro_v2/controllers/validations.dart';

class GradientesController {
  GradientesController();

  Map<String, double> aritmetica({
    double g = 0,
    double A = 0,
    int n = 0,
    double i = 0,
  }) {
    // Validar argumentos
    validarDiferenteDeCero(g, 'Variación (g)');
    validarMayorQueCero(A, 'Aporte (A)');
    validarRango(A, 'Aporte (A)', max: 1e12); // Aporte ≤ 1 billón
    validarMayorQueCero(n, 'Número de periodos (n)');
    validarMayorQueCero(i, 'Tasa de interés (i)');
    validarRango(i, 'Tasa de interés (i)', min: 0.0, max: 2.0); // Tasa ≤ 200%
    validarPrecision(i, 4, 'Tasa de interés (i)'); // Máximo 4 decimales

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
    // Validar argumentos
    validarMayorQueCero(g, 'Variación (g)');
    validarMayorQueCero(A, 'Aporte (A)');
    validarRango(A, 'Aporte (A)', max: 1e12); // Aporte ≤ 1 billón
    validarMayorQueCero(n, 'Número de periodos (n)');
    validarMayorQueCero(i, 'Tasa de interés (i)');
    validarRango(i, 'Tasa de interés (i)', min: 0.0, max: 2.0); // Tasa ≤ 200%
    validarPrecision(i, 4, 'Tasa de interés (i)'); // Máximo 4 decimales

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
    // Validar argumentos
    validarMayorQueCero(g, 'Variación (g)');
    validarMayorQueCero(A, 'Aporte (A)');
    validarRango(A, 'Aporte (A)', max: 1e12); // Aporte ≤ 1 billón
    validarMayorQueCero(n, 'Número de periodos (n)');
    validarMayorQueCero(i, 'Tasa de interés (i)');
    validarRango(i, 'Tasa de interés (i)', min: 0.0, max: 2.0); // Tasa ≤ 200%
    validarPrecision(i, 4, 'Tasa de interés (i)'); // Máximo 4 decimales

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

import 'dart:math';
import 'package:finanpro_v2/controllers/validations.dart';

class AmortizacionController {
  AmortizacionController();

  //p = capital
  //r = tasa de interes
  //n = numero de meses

  List<Map<String, dynamic>> francesa(double p, double i, int n) {
    // Validar argumentos
    validarPositivo(p, 'Capital (p)');
    validarRango(p, 'Capital (p)', max: 1e12); // Capital ≤ 1 billón
    validarPositivo(i, 'Tasa de interés (i)');
    validarRango(i, 'Tasa de interés (i)', min: 0.0, max: 2.0); // Tasa ≤ 200%
    validarPrecision(i, 4, 'Tasa de interés (i)'); // Máximo 4 decimales
    validarMayorQueCero(n, 'Número de meses (n)');

    double r = i; // tasa de interes mensual
    double A = (p * r) / (1 - pow(1 + r, -n));
    double abonoCapital = p / n;
    double abonoInteres = A - abonoCapital;

    List<Map<String, double>> amortizacion = [];

    for (int j = 0; j < n; j++) {
      p =
          p - abonoCapital > 0
              ? double.parse((p - abonoCapital).toStringAsFixed(2))
              : 0;
      amortizacion.add({
        'cuota': A,
        'abono interes': abonoInteres,
        'abono capital': abonoCapital,
        'capital': p,
      });
    }
    return amortizacion;
  }

  List<Map<String, dynamic>> alemana(double p, double i, int n) {
    // Validar argumentos
    validarPositivo(p, 'Capital (p)');
    validarRango(p, 'Capital (p)', max: 1e12); // Capital ≤ 1 billón
    validarPositivo(i, 'Tasa de interés (i)');
    validarRango(i, 'Tasa de interés (i)', min: 0.0, max: 2.0); // Tasa ≤ 200%
    validarPrecision(i, 4, 'Tasa de interés (i)'); // Máximo 4 decimales
    validarMayorQueCero(n, 'Número de meses (n)');

    // Cálculos
    double A = double.parse(
      (p / n).toStringAsFixed(2),
    ); // abono fijo de capital

    List<Map<String, double>> amortizacion = [];

    for (int j = 0; j < n; j++) {
      double interes = double.parse((p * i).toStringAsFixed(2));
      double cuota = double.parse((A + interes).toStringAsFixed(2));
      double nuevoCapital = p - A;

      // Asegurar que el capital no sea negativo
      p = nuevoCapital > 0 ? double.parse(nuevoCapital.toStringAsFixed(2)) : 0;

      amortizacion.add({
        'cuota': cuota,
        'abono interes': interes,
        'abono capital': A,
        'capital': p,
      });
    }

    return amortizacion;
  }

  List<Map<String, double>> americana(double p, double i, int n) {
    // Validar argumentos
    validarPositivo(p, 'Capital (p)');
    validarRango(p, 'Capital (p)', max: 1e12); // Capital ≤ 1 billón
    validarPositivo(i, 'Tasa de interés (i)');
    validarRango(i, 'Tasa de interés (i)', min: 0.0, max: 2.0); // Tasa ≤ 200%
    validarPrecision(i, 4, 'Tasa de interés (i)'); // Máximo 4 decimales
    validarMayorQueCero(n, 'Número de meses (n)');

    double cuota = p * i;

    List<Map<String, double>> amortizacion = [];
    for (int j = 0; j < n - 1; j++) {
      amortizacion.add({
        'cuota': cuota,
        'abono interes': cuota,
        'abono capital': 0,
        'capital': p,
      });
    }

    amortizacion.add({
      'cuota': cuota + p,
      'abono interes': cuota,
      'abono capital': p,
      'capital': 0,
    });

    return amortizacion; // cuota de interes
  }
}

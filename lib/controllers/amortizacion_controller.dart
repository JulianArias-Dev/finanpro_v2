import 'dart:math';
import 'package:finanpro_v2/controllers/validations.dart';

class AmortizacionController {
  AmortizacionController();

  //p = capital
  //r = tasa de interes
  //n = numero de meses

  List<Map<String, dynamic>> francesa(double p, double i, int n) {
    //Validar Argumentos
    validarPositivo(p, 'Capital (p)');
    validarPositivo(i, 'Tasa de interés (i)');
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
    //Validar Argumentos
    validarPositivo(p, 'Capital (p)');
    validarPositivo(i, 'Tasa de interés (i)');
    validarMayorQueCero(n, 'Número de meses (n)');

    //Calculos
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
    //Validar Argumentos
    validarPositivo(p, 'Capital (p)');
    validarPositivo(i, 'Tasa de interés (i)');
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

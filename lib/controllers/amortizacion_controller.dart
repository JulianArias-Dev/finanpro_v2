import 'dart:math';
import 'package:finanpro_v2/controllers/validations.dart';

class AmortizacionController {
  AmortizacionController();

  //p = capital
  //r = tasa de interes
  //n = numero de meses

  double francesa(double p, double i, int n) {
    //Validar Argumentos
    validarPositivo(p, 'Capital (p)');
    validarPositivo(i, 'Tasa de interés (i)');
    validarMayorQueCero(n, 'Número de meses (n)');

    double r = i; // tasa de interes mensual
    double A = (p * r) / (1 - pow(1 + r, -n));

    return A; // cuota mensual
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

  double americana(double p, double i, int n) {
    //Validar Argumentos
    validarPositivo(p, 'Capital (p)');
    validarPositivo(i, 'Tasa de interés (i)');
    validarMayorQueCero(n, 'Número de meses (n)');

    double cuota = p * i;
    return cuota; // cuota de interes
  }
}

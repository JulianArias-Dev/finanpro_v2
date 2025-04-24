import 'dart:math';
import 'package:finanpro_v2/controllers/validations.dart';

class AnualidadesController {
  AnualidadesController();

  double calcularValorFinal(double capital, double i, int n) {
    // Validar argumentos
    validarMayorQueCero(capital, 'Capital inicial (capital)');
    validarRango(
      capital,
      'Capital inicial (capital)',
      max: 1e12,
    ); // Capital ≤ 1 billón
    validarMayorQueCero(i, 'Tasa de interés (i)');
    validarRango(i, 'Tasa de interés (i)', min: 0.0, max: 2.0); // Tasa ≤ 200%
    validarPrecision(i, 4, 'Tasa de interés (i)'); // Máximo 4 decimales
    validarMayorQueCero(n, 'Número de periodos (n)');

    return capital * ((pow((1 + i), n) - 1) / i);
  }

  double calcularValorActual(double capital, double i, int n) {
    // Validar argumentos
    validarMayorQueCero(capital, 'Capital inicial (capital)');
    validarRango(
      capital,
      'Capital inicial (capital)',
      max: 1e12,
    ); // Capital ≤ 1 billón
    validarMayorQueCero(i, 'Tasa de interés (i)');
    validarRango(i, 'Tasa de interés (i)', min: 0.0, max: 2.0); // Tasa ≤ 200%
    validarPrecision(i, 4, 'Tasa de interés (i)'); // Máximo 4 decimales
    validarMayorQueCero(n, 'Número de periodos (n)');

    return capital * ((1 - pow((1 + i), -1 * n)) / i);
  }
}

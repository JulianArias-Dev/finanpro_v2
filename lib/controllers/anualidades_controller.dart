import 'dart:math';
import 'package:finanpro_v2/controllers/validations.dart';

class AnualidadesController {
  AnualidadesController();

  double calcularValorFinal(double capital, double i, int n) {
    // Validar argumentos
    validarMayorQueCero(capital, 'Capital inicial (capital)');
    validarMayorQueCero(i, 'Tasa de interés (i)');
    validarMayorQueCero(n, 'Número de periodos (n)');

    return capital * ((pow((1 + i), n) - 1) / i);
  }

  double calcularValorActual(double capital, double i, int n) {
    // Validar argumentos
    validarMayorQueCero(capital, 'Capital inicial (capital)');
    validarMayorQueCero(i, 'Tasa de interés (i)');
    validarMayorQueCero(n, 'Número de periodos (n)');

    return capital * ((1 - pow((1 + i), -1 * n)) / i);
  }
}

import 'dart:math';

class AnualidadesController {
  AnualidadesController();

  double calcularValorFinal(double capital, double i, int n) {
    if (capital <= 0 || i <= 0 || n <= 0) {
      throw ArgumentError(
        "Todos los argumentos deben ser mayores que cero y el tipo no debe estar vacío.",
      );
    }

    return capital * ((pow((1 + i), n) - 1) / i);
  }

  double calcularValorActual(double capital, double i, int n) {
    if (capital <= 0 || i <= 0 || n <= 0) {
      throw ArgumentError(
        "Todos los argumentos deben ser mayores que cero y el tipo no debe estar vacío.",
      );
    }

    return capital * ((1 - pow((1 + i), -1 * n)) / i);
  }
}

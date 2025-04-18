import 'dart:math';

class CapitalizacionController {
  CapitalizacionController();

  double capitalizacionIndividualCompuesta(double p, double r, int n, int t) {
    _validarPositivo(p, 'Capital inicial (p)');
    _validarPositivo(r, 'Tasa de interés (r)');
    _validarMayorQueCero(n, 'Número de periodos por año (n)');
    _validarMayorQueCero(t, 'Número de años (t)');

    return p * pow(1 + (r / n), n * t);
  }

  double capitalizacionIndividualConAportes(double p, double r, int n) {
    _validarPositivo(p, 'Aporte periódico (p)');
    _validarPositivo(r, 'Tasa de interés (r)');
    _validarMayorQueCero(n, 'Número de aportes (n)');

    return p * ((pow(1 + r, n) - 1) / r);
  }

  double capitalizacionColectiva(
    List<double> aportes,
    List<int> tiempos,
    double tasa,
  ) {
    if (aportes.isEmpty || tiempos.isEmpty) {
      throw ArgumentError(
        "Las listas de aportes y tiempos no deben estar vacías.",
      );
    }

    if (aportes.length != tiempos.length) {
      throw ArgumentError(
        "Los tamaños de las listas de aportes y tiempos deben coincidir.",
      );
    }

    _validarPositivo(tasa, 'Tasa de interés (tasa)');

    for (int i = 0; i < aportes.length; i++) {
      _validarPositivo(aportes[i], 'Aporte en posición $i');
      _validarMayorIgualCero(tiempos[i], 'Tiempo en posición $i');
    }

    double valorFuturo = 0.0;

    for (int i = 0; i < aportes.length; i++) {
      valorFuturo += aportes[i] * pow(1 + tasa, tiempos[i]);
    }

    return valorFuturo;
  }

  // Métodos privados de validación
  void _validarPositivo(num valor, String nombreCampo) {
    if (valor <= 0) {
      throw ArgumentError('$nombreCampo debe ser mayor que 0.');
    }
  }

  void _validarMayorQueCero(num valor, String nombreCampo) {
    if (valor <= 0) {
      throw ArgumentError('$nombreCampo debe ser mayor que 0.');
    }
  }

  void _validarMayorIgualCero(num valor, String nombreCampo) {
    if (valor < 0) {
      throw ArgumentError('$nombreCampo no puede ser negativo.');
    }
  }
}

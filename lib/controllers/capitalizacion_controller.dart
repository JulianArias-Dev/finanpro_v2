import 'dart:math';
import 'package:finanpro_v2/controllers/validations.dart';

class CapitalizacionController {
  CapitalizacionController();

  double capitalizacionIndividualCompuesta(double p, double r, int n, int t) {
    validarPositivo(p, 'Capital inicial (p)');
    validarPositivo(r, 'Tasa de interés (r)');
    validarMayorQueCero(n, 'Número de periodos por año (n)');
    validarMayorQueCero(t, 'Número de años (t)');

    return p * pow(1 + (r / n), n * t);
  }

  double capitalizacionIndividualConAportes(double p, double r, int n) {
    validarPositivo(p, 'Aporte periódico (p)');
    validarPositivo(r, 'Tasa de interés (r)');
    validarMayorQueCero(n, 'Número de aportes (n)');

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

    validarPositivo(tasa, 'Tasa de interés (tasa)');

    for (int i = 0; i < aportes.length; i++) {
      validarPositivo(aportes[i], 'Aporte en posición $i');
      validarMayorIgualCero(tiempos[i], 'Tiempo en posición $i');
    }

    double valorFuturo = 0.0;

    for (int i = 0; i < aportes.length; i++) {
      valorFuturo += aportes[i] * pow(1 + tasa, tiempos[i]);
    }

    return valorFuturo;
  }
}

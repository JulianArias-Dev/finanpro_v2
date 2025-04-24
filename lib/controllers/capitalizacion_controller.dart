import 'dart:math';
import 'package:finanpro_v2/controllers/validations.dart';

class CapitalizacionController {
  CapitalizacionController();

  double capitalizacionIndividualCompuesta(double p, double r, int n, int t) {
    // Validar argumentos
    validarPositivo(p, 'Capital inicial (p)');
    validarRango(p, 'Capital inicial (p)', max: 1e12); // Capital ≤ 1 billón
    validarPositivo(r, 'Tasa de interés (r)');
    validarRango(r, 'Tasa de interés (r)', min: 0.0, max: 2.0); // Tasa ≤ 200%
    validarPrecision(r, 4, 'Tasa de interés (r)'); // Máximo 4 decimales
    validarMayorQueCero(n, 'Número de periodos por año (n)');
    validarMayorQueCero(t, 'Número de años (t)');

    return p * pow(1 + (r / n), n * t);
  }

  double capitalizacionIndividualConAportes(double p, double r, int n) {
    // Validar argumentos
    validarPositivo(p, 'Aporte periódico (p)');
    validarRango(p, 'Aporte periódico (p)', max: 1e12); // Aporte ≤ 1 billón
    validarPositivo(r, 'Tasa de interés (r)');
    validarRango(r, 'Tasa de interés (r)', min: 0.0, max: 2.0); // Tasa ≤ 200%
    validarPrecision(r, 4, 'Tasa de interés (r)'); // Máximo 4 decimales
    validarMayorQueCero(n, 'Número de aportes (n)');

    return p * ((pow(1 + r, n) - 1) / r);
  }

  double capitalizacionColectiva(
    List<double> aportes,
    List<int> tiempos,
    double tasa,
  ) {
    // Validar listas
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

    // Validar tasa de interés
    validarPositivo(tasa, 'Tasa de interés (tasa)');
    validarRango(
      tasa,
      'Tasa de interés (tasa)',
      min: 0.0,
      max: 2.0,
    ); // Tasa ≤ 200%
    validarPrecision(tasa, 4, 'Tasa de interés (tasa)'); // Máximo 4 decimales

    // Validar elementos de las listas
    for (int i = 0; i < aportes.length; i++) {
      validarPositivo(aportes[i], 'Aporte en posición $i');
      validarRango(
        aportes[i],
        'Aporte en posición $i',
        max: 1e12,
      ); // Aporte ≤ 1 billón
      validarMayorIgualCero(tiempos[i], 'Tiempo en posición $i');
    }

    double valorFuturo = 0.0;

    for (int i = 0; i < aportes.length; i++) {
      valorFuturo += aportes[i] * pow(1 + tasa, tiempos[i]);
    }

    return valorFuturo;
  }
}

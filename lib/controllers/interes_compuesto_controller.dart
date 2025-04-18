import 'package:finanpro_v2/controllers/validations.dart';
import '../models/tiempo.dart';
import 'dart:math';

class InteresCompuestoController {
  InteresCompuestoController();

  double calcularInteresCompuesto(
    double capital,
    double interes,
    Tiempo duree,
    String type,
  ) {
    // Validar argumentos
    validarMayorQueCero(capital, 'Capital inicial');
    validarMayorQueCero(interes, 'Tasa de interés');
    validarMayorIgualCero(duree.years, 'Años');
    validarMayorIgualCero(duree.months, 'Meses');
    validarMayorIgualCero(duree.days, 'Días');
    if (type.isEmpty) {
      throw ArgumentError("El tipo de capiptalización no debe estar vacío.");
    }

    switch (type) {
      case 'monthly':
        int cicles = duree.years * 12 + duree.months;
        return capital * pow((1 + interes), (cicles));
      case 'annual':
        return capital * pow((1 + interes), (duree.years));
      default:
        throw ArgumentError("Tipo no válido. Debe ser 'monthly' o 'annual'.");
    }
  }

  double calcularTasaInteresCompuesto(
    double capital,
    double generatedInteres,
    Tiempo duree,
    String type,
  ) {
    // Validar argumentos
    validarMayorQueCero(capital, 'Capital inicial');
    validarMayorQueCero(generatedInteres, 'Interés generado');
    validarMayorIgualCero(duree.years, 'Años');
    validarMayorIgualCero(duree.months, 'Meses');
    validarMayorIgualCero(duree.days, 'Días');
    if (type.isEmpty) {
      throw ArgumentError("El tipo de capiptalización no debe estar vacío.");
    }
    int cicles;
    switch (type) {
      case 'monthly':
        cicles = duree.years * 12 + duree.months;
        break;
      case 'annual':
        cicles = duree.years;
        break;
      default:
        throw ArgumentError("Tipo no válido. Debe ser 'monthly' o 'annual'.");
    }
    return pow((generatedInteres / capital), (1 / cicles)) - 1;
  }

  double calcularCapitalCompuesto(
    double interes,
    double generatedInteres,
    Tiempo duree,
    String type,
  ) {
    // Validar argumentos
    validarMayorQueCero(interes, 'Tasa de interés');
    validarMayorQueCero(generatedInteres, 'Interés generado');
    validarMayorIgualCero(duree.years, 'Años');
    validarMayorIgualCero(duree.months, 'Meses');
    validarMayorIgualCero(duree.days, 'Días');
    if (type.isEmpty) {
      throw ArgumentError("El tipo de capiptalización no debe estar vacío.");
    }
    int cicles;
    switch (type) {
      case 'monthly':
        cicles = duree.years * 12 + duree.months;
        break;
      case 'annual':
        cicles = duree.years;
        break;
      default:
        throw ArgumentError("Tipo no válido. Debe ser 'monthly' o 'annual'.");
    }
    return generatedInteres / pow((1 + interes), cicles);
  }

  Tiempo calcularTiempoInteresCompuesto(
    double capital,
    double interes,
    double montoCompuesto,
    String type,
  ) {
    // Validar argumentos
    validarMayorQueCero(capital, 'Capital inicial');
    validarMayorQueCero(interes, 'Tasa de interés');
    validarMayorQueCero(montoCompuesto, 'Monto compuesto');
    if (type.isEmpty) {
      throw ArgumentError("El tipo de capiptalización no debe estar vacío.");
    }
    double cicles = (log(montoCompuesto) - log(capital)) / log(1 + interes);

    switch (type) {
      case 'monthly':
        int totalMonths = cicles.floor();
        int years = totalMonths ~/ 12;
        int months = totalMonths % 12;
        return Tiempo(years, months, 0);
      case 'annual':
        return Tiempo(cicles.floor(), 0, 0);
      default:
        throw ArgumentError("Tipo no válido. Debe ser 'monthly' o 'annual'.");
    }
  }
}

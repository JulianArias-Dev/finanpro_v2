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
    validarRango(capital, 'Capital inicial', max: 1e12); // Capital ≤ 1 billón
    validarMayorQueCero(interes, 'Tasa de interés');
    validarRango(interes, 'Tasa de interés', min: 0.0, max: 2.0); // Tasa ≤ 200%
    validarPrecision(interes, 4, 'Tasa de interés'); // Máximo 4 decimales
    validarMayorIgualCero(duree.years, 'Años');
    validarMayorIgualCero(duree.months, 'Meses');
    validarMayorIgualCero(duree.days, 'Días');
    if (type.isEmpty) {
      throw ArgumentError("El tipo de capitalización no debe estar vacío.");
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
    validarRango(capital, 'Capital inicial', max: 1e12); // Capital ≤ 1 billón
    validarMayorQueCero(generatedInteres, 'Interés generado');
    validarPrecision(
      generatedInteres,
      4,
      'Interés generado',
    ); // Máximo 4 decimales
    validarMayorIgualCero(duree.years, 'Años');
    validarMayorIgualCero(duree.months, 'Meses');
    validarMayorIgualCero(duree.days, 'Días');
    if (type.isEmpty) {
      throw ArgumentError("El tipo de capitalización no debe estar vacío.");
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
    validarRango(interes, 'Tasa de interés', min: 0.0, max: 2.0); // Tasa ≤ 200%
    validarPrecision(interes, 4, 'Tasa de interés'); // Máximo 4 decimales
    validarMayorQueCero(generatedInteres, 'Interés generado');
    validarPrecision(
      generatedInteres,
      4,
      'Interés generado',
    ); // Máximo 4 decimales
    validarMayorIgualCero(duree.years, 'Años');
    validarMayorIgualCero(duree.months, 'Meses');
    validarMayorIgualCero(duree.days, 'Días');
    if (type.isEmpty) {
      throw ArgumentError("El tipo de capitalización no debe estar vacío.");
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
    validarRango(capital, 'Capital inicial', max: 1e12); // Capital ≤ 1 billón
    validarMayorQueCero(interes, 'Tasa de interés');
    validarRango(interes, 'Tasa de interés', min: 0.0, max: 2.0); // Tasa ≤ 200%
    validarPrecision(interes, 4, 'Tasa de interés'); // Máximo 4 decimales
    validarMayorQueCero(montoCompuesto, 'Monto compuesto');
    if (type.isEmpty) {
      throw ArgumentError("El tipo de capitalización no debe estar vacío.");
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

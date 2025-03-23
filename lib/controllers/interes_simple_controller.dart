import '../models/tiempo.dart';

class InteresSimpleController {
  InteresSimpleController();

  double calculerInteretSimple(double capital, double interes, Tiempo duree) {
    if (capital <= 0 || interes <= 0 || duree.isEmpty()) {
      throw ArgumentError(
        "Todos los argumentos deben ser mayores que cero y el tipo no debe estar vacío.",
      );
    }
    return capital *
        interes *
        (duree.years + duree.months / 12 + duree.days / 365);
  }

  double calcularTasaInteresSimple(
    double capital,
    double generatedInteres,
    Tiempo duree,
  ) {
    if (capital <= 0 || generatedInteres <= 0 || duree.isEmpty()) {
      throw ArgumentError(
        "Todos los argumentos deben ser mayores que cero y el tipo no debe estar vacío.",
      );
    }
    return generatedInteres /
        (capital * (duree.years + duree.months / 12 + duree.days / 365));
  }

  double calcularCapitalSimple(
    double interes,
    double generatedInteres,
    Tiempo duree,
  ) {
    if (generatedInteres <= 0 || interes <= 0 || duree.isEmpty()) {
      throw ArgumentError(
        "Todos los argumentos deben ser mayores que cero y el tipo no debe estar vacío.",
      );
    }
    return generatedInteres /
        (interes * (duree.years + duree.months / 12 + duree.days / 365));
  }

  Tiempo calcularTiempoInteresSimple(
    double capital,
    double interes,
    double generatedInteres,
  ) {
    if (capital <= 0 || interes <= 0 || generatedInteres <= 0) {
      throw ArgumentError(
        "Todos los argumentos deben ser mayores que cero y el tipo no debe estar vacío.",
      );
    }
    double time = generatedInteres / (capital * interes);
    int years = time.toInt();
    int months = ((time - years) * 12).toInt();
    int days = (((time - years) * 12 - months) * 30).toInt();

    return Tiempo(years, months, days);
  }
}

import '../models/tiempo.dart';
import 'package:finanpro_v2/controllers/validations.dart';

class InteresSimpleController {
  InteresSimpleController();

  double calculerInteretSimple(double capital, double interes, Tiempo duree) {
    // Validar argumentos
    validarMayorQueCero(capital, 'Capital');
    validarMayorQueCero(interes, 'Interés');
    validarMayorIgualCero(duree.years, 'Años');
    validarMayorIgualCero(duree.months, 'Meses');
    validarMayorIgualCero(duree.days, 'Días');

    return capital *
        interes *
        (duree.years + duree.months / 12 + duree.days / 365);
  }

  double calcularTasaInteresSimple(
    double capital,
    double generatedInteres,
    Tiempo duree,
  ) {
    // Validar argumentos
    validarMayorQueCero(capital, 'Capital');
    validarMayorQueCero(generatedInteres, 'Interés generado');
    validarMayorIgualCero(duree.years, 'Años');
    validarMayorIgualCero(duree.months, 'Meses');
    validarMayorIgualCero(duree.days, 'Días');

    return generatedInteres /
        (capital * (duree.years + duree.months / 12 + duree.days / 365));
  }

  double calcularCapitalSimple(
    double interes,
    double generatedInteres,
    Tiempo duree,
  ) {
    // Validar argumentos
    validarMayorQueCero(interes, 'Interés');
    validarMayorQueCero(generatedInteres, 'Interés generado');
    validarMayorIgualCero(duree.years, 'Años');
    validarMayorIgualCero(duree.months, 'Meses');
    validarMayorIgualCero(duree.days, 'Días');

    return generatedInteres /
        (interes * (duree.years + duree.months / 12 + duree.days / 365));
  }

  Tiempo calcularTiempoInteresSimple(
    double capital,
    double interes,
    double generatedInteres,
  ) {
    // Validar argumentos
    validarMayorQueCero(capital, 'Capital');
    validarMayorQueCero(interes, 'Interés');
    validarMayorQueCero(generatedInteres, 'Interés generado');

    double time = generatedInteres / (capital * interes);
    int years = time.toInt();
    int months = ((time - years) * 12).toInt();
    int days = (((time - years) * 12 - months) * 30).toInt();

    return Tiempo(years, months, days);
  }
}

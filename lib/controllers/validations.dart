// Métodos privados de validación
void validarPositivo(num valor, String nombreCampo) {
  if (valor <= 0) {
    throw ArgumentError('$nombreCampo debe ser mayor que 0.');
  }
}

void validarMayorQueCero(num valor, String nombreCampo) {
  if (valor <= 0) {
    throw ArgumentError('$nombreCampo debe ser mayor que 0.');
  }
}

void validarMayorIgualCero(num valor, String nombreCampo) {
  if (valor < 0) {
    throw ArgumentError('$nombreCampo no puede ser negativo.');
  }
}

void validarDiferenteDeCero(num valor, String nombreCampo) {
  if (valor == 0) {
    throw ArgumentError('$nombreCampo no puede ser cero.');
  }
}

/// Valida que [valor] no tenga más de [maxDecimals] decimales.
void validarPrecision(num valor, int maxDecimals, String nombreCampo) {
  final parts = valor.toString().split('.');
  if (parts.length == 2 && parts[1].length > maxDecimals) {
    throw ArgumentError(
      '$nombreCampo no puede tener más de $maxDecimals decimales.',
    );
  }
}

/// Valida que [valor] esté entre [min] y [max] inclusive.
/// Si no se especifican, [min] será 0 y [max] será 1 billón (por defecto).
void validarRango(
  num valor,
  String nombreCampo, {
  num min = 0,
  num max = 1e12, // 1 billón
}) {
  if (valor < min || valor > max) {
    throw ArgumentError('$nombreCampo debe estar entre $min y $max.');
  }
}

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

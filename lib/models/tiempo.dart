class Tiempo {
  int years;
  int months;
  int days;
  Tiempo(this.years, this.months, this.days);

  bool isEmpty() {
    if (years == 0 && days == 0 && months == 0) return true;

    return false;
  }
}

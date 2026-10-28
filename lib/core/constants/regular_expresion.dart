class CommonRegex {
  static final emailRegex = RegExp(r'^[a-zA-Z0-9]+$');
  static final passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );
}

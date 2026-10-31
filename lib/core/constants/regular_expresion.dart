class CommonRegex {
  static final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static final passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  static final userNameRegex = RegExp(r'^.{3,50}$');
  static final idNumberRegex = RegExp(r'^[0-9]{13}[a-zA-Z]$');
  static final createUserPasswordRegex = RegExp(
    r'^(?=.*[a-zA-Z])(?=.*\d).{6,}$',
  );
}

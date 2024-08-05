class Validator {
  final int minLength = 8;
  final int uppercaseCount = 1;
  final int lowercaseCount = 1;
  final int numericCount = 1;

  bool hasMinLength(String password) {
    return password.length >= minLength ? true : false;
  }

  bool hasSpace(String input) {
    return input.contains(' ');
  }

  bool hasMinUppercase(String password) {
    String pattern = '^(.*?[A-Z]){$uppercaseCount,}';
    return password.contains(RegExp(pattern));
  }

  bool hasMinLowercase(String password) {
    String pattern = '^(.*?[a-z]){$lowercaseCount,}';
    return password.contains(RegExp(pattern));
  }

  bool hasMinNumericChar(String password) {
    String pattern = '^(.*?[0-9]){$numericCount,}';
    return password.contains(RegExp(pattern));
  }

  Map<String, bool> validateAll(String password) {
    final result = {
      'doesNotHaveSpace': !hasSpace(password),
      'hasMinLength': hasMinLength(password),
      'hasUppercase': hasMinUppercase(password),
      'hasLowercase': hasMinLowercase(password),
      'hasNumericChar': hasMinNumericChar(password),
    };

    return {
      ...result,
      'isValid': result.values.every((element) => element),
    };
  }
}

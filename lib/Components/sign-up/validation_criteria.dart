import 'package:flutter/material.dart';

class ValidationCriteria extends StatelessWidget {
  final bool isSubmitted;
  final Map<String, bool> validationResult;

  const ValidationCriteria({
    Key? key,
    required this.validationResult,
    required this.isSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getTextColor(bool expresion) {
      if (isSubmitted) {
        return expresion ? const Color(0xFF63C59C) : const Color(0xFFFE807F);
      }

      return const Color(0xFF4A4E72);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '8 characters or more (no spaces)',
            style: TextStyle(
              fontSize: 14,
              color: getTextColor((validationResult['hasMinLength'] ?? false) &&
                  (validationResult['doesNotHaveSpace'] ?? false)),
            ),
          ),
          Text(
            'Uppercase and lowercase letters',
            style: TextStyle(
              fontSize: 14,
              color: getTextColor((validationResult['hasUppercase'] ?? false) &&
                  (validationResult['hasLowercase'] ?? false)),
            ),
          ),
          Text(
            'At least one digit',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14,
              color: getTextColor(validationResult['hasNumericChar'] ?? false),
            ),
          ),
        ],
      ),
    );
  }
}

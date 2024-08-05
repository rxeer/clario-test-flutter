import 'package:flutter/material.dart';
import 'package:clario_test_flutter/Utilities/validator.dart';
import 'package:clario_test_flutter/Components/sign-up/validation_criteria.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEFF6FE),
      ),
      home: SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const GradientButton({Key? key, required this.onPressed, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF70C3FF), Color(0xFF4C68FF)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Set background to transparent
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: child,
      ),
    );
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _submitFormCount = 0;
  bool _showPassword = false;
  final Validator _validator = Validator();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Map<String, bool> _passwordValidationResuls = {};

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  bool _validatePassword(String? value) {
    final validationResult = _validator.validateAll(value!);

    setState(() {
      _passwordValidationResuls = validationResult;
    });
    _submitFormCount++;

    return validationResult['isValid'] ?? false;
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign up success')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              filled: true,
                              labelStyle: TextStyle(
                                color: Color(0xFF4A4E72),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              fillColor: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                            if (!emailRegExp.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 16.0, bottom: 16.0),
                          child: TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Password',
                              filled: true,
                              labelStyle: const TextStyle(
                                color: Color(0xFF4A4E72),
                              ),
                              fillColor: Colors.white,
                              errorStyle: const TextStyle(height: 0),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: _togglePasswordVisibility,
                              ),
                            ),
                            obscureText: !_showPassword,
                            onChanged: (value) => {_validatePassword(value)},
                            validator: (value) {
                              final isValid = _validatePassword(value);
                              if (value == null || value.isEmpty || !isValid) {
                                return '';
                              }

                              return null;
                            },
                          ),
                        ),
                        ValidationCriteria(
                          isSubmitted: _submitFormCount > 0,
                          validationResult: _passwordValidationResuls,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: GradientButton(
                            onPressed: _signUp,
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

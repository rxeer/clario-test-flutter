import 'package:flutter/material.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

import 'package:clario_test_flutter/colors.dart';
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
          inputDecorationTheme: InputDecorationTheme(
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.red100, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20),
            ),
            filled: true,
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.gray200, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
          )),
      home: SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _submitFormCount = 0;
  bool _isEmailFieldValid = false;
  bool _isPasswordFieldValid = false;
  Color _emailFieldColor = AppColors.gray100;
  Color _passwordFieldColor = AppColors.gray100;
  Color _passwordIconColor = AppColors.gray200;
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

  bool _validatePassword(String? value, bool incrementSubmitCount) {
    final validationResult = _validator.validateAll(value!);

    setState(() {
      _passwordValidationResuls = validationResult;
      _submitFormCount =
          incrementSubmitCount ? _submitFormCount + 1 : _submitFormCount;
    });

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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_pattern.png'),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 40),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A4E71)),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEmailField(),
                    const SizedBox(height: 16),
                    _buildPasswordField(),
                    const SizedBox(height: 16),
                    ValidationCriteria(
                      isSubmitted: _submitFormCount > 0,
                      validationResult: _passwordValidationResuls,
                    ),
                    const SizedBox(height: 20),
                    _buildSignUpButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: _isEmailFieldValid
              ? const BorderSide(color: AppColors.green100, width: 1)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
        labelText: 'Email',
        errorStyle: const TextStyle(color: AppColors.red100),
        labelStyle: TextStyle(
          color: _emailFieldColor,
        ),
      ),
      style: TextStyle(
        color: _emailFieldColor,
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      validator: (value) {
        final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');

        if (value == null || value.isEmpty || !emailRegExp.hasMatch(value)) {
          setState(() {
            _emailFieldColor = AppColors.red100;
            _isEmailFieldValid = false;
          });

          return 'Enter a valid email address';
        }

        setState(() {
          _emailFieldColor = AppColors.green100;
          _isEmailFieldValid = true;
        });

        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: _isPasswordFieldValid
              ? const BorderSide(color: AppColors.green100, width: 1)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
        labelText: 'Password',
        labelStyle: TextStyle(
          color: _passwordFieldColor,
        ),
        errorStyle: const TextStyle(height: 0),
        suffixIcon: IconButton(
          icon: Icon(
            color: _passwordIconColor,
            _showPassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      style: TextStyle(
        color: _passwordFieldColor,
      ),
      obscureText: !_showPassword,
      onChanged: (value) => {_validatePassword(value, false)},
      validator: (value) {
        final isValid = _validatePassword(value, true);
        if (value == null || value.isEmpty || !isValid) {
          setState(() {
            _isPasswordFieldValid = false;
            _passwordFieldColor = AppColors.red100;
            _passwordIconColor = AppColors.red100;
          });
          return '';
        }

        setState(() {
          _isPasswordFieldValid = true;
          _passwordFieldColor = AppColors.green100;
          _passwordIconColor = AppColors.green100;
        });

        return null;
      },
    );
  }

  Widget _buildSignUpButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: GradientElevatedButton(
        onPressed: _signUp,
        style: GradientElevatedButton.styleFrom(
          gradient: const LinearGradient(
            colors: [Color(0xFF70C3FF), Color(0xFF4C68FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text("Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

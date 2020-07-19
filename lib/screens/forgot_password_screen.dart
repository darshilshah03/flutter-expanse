import 'package:flutter/material.dart';
import '../help/forgot.dart';

class ForgotPasswordScreen extends StatelessWidget {

  

  static const routeName = '/forgot-password';
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body : Forgot()
    );
  }
}


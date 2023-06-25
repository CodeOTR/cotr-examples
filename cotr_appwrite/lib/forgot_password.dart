import 'package:appwrite/appwrite.dart';
import 'package:appwrite_authentication/main.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          ElevatedButton(
            onPressed: () {
              Account(client).createRecovery(
                email: emailController.text,
                url: 'cotr-appwrite.firebaseapp.com',
              );
            },
            child: const Text('Send Reset Password Link'),
          ),
        ],
      ),
    );
  }
}

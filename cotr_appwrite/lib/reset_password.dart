import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'New Password'),
          ),
          TextField(
            controller: confirmPasswordController,
            decoration: const InputDecoration(labelText: 'Confirm Password'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
              onPressed: () {

              },
              child: const Text('Reset Password')),
        ],
      ),
    );
  }
}

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_authentication/main.dart';
import 'package:appwrite_authentication/widgets/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String get userId => Uri.base.queryParameters['userId'] ?? '';

  String get secret => Uri.base.queryParameters['secret'] ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasicPage(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'New Password'),
                  ),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(labelText: 'Confirm Password'),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('User ID: $userId'),
            ),
            ListTile(
              title: Text('Secret: $secret'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () async {
                  await Account(client)
                      .updateRecovery(
                    userId: userId,
                    secret: secret,
                    password: passwordController.text,
                    passwordAgain: confirmPasswordController.text,
                  )
                      .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Password reset successfully'),
                    ));

                    context.go('/sign-in');
                  }).onError((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(error.toString()),
                    ));
                  });
                },
                child: const Text('Reset Password')),
          ],
        ),
      ),
    );
  }
}

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_authentication/forgot_password.dart';
import 'package:appwrite_authentication/home.dart';
import 'package:appwrite_authentication/main.dart';
import 'package:appwrite_authentication/sign_up.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text))
                  return 'Enter valid email';

                return null;
              },
            ),
            TextFormField(
              textInputAction: TextInputAction.done,
              controller: passwordController,
              autofillHints: const [AutofillHints.password],
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ForgotPassword()));
                },
                child: const Text('Forgot Password?'),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  await Account(client).createEmailSession(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Home()), (route) => false);
                } catch (e) {
                  print(e);
                }
              },
              child: const Text('Sign In'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUp()));
                },
                child: const Text('Sign Up'))
          ],
        ),
      ),
    );
  }
}

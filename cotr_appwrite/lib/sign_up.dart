import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite_authentication/home.dart';
import 'package:appwrite_authentication/sign_in.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ValueNotifier<bool> loading = ValueNotifier<bool>(false);

  @override
  void initState() {
    loading.value = true;
    Account(client).get().then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
    }, onError: (e) {
      loading.value = false;
      if (e is AppwriteException) {
        if (e.code == 401) {
          debugPrint('User not logged in');
        }
      } else {
        debugPrint('Error fetching user: ' + e.toString());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: loading,
        builder: (context, value, child) {
          return Scaffold(
            body: value
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
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
                            if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text)) {
                              return 'Enter valid email';
                            }

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
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await Account(client).create(
                                userId: ID.unique(),
                                email: emailController.text,
                                password: passwordController.text,
                              );

                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Home()));
                            } on AppwriteException catch (e) {
                              if (e.code == 409) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: const Text('Email already exists'),
                                      action: SnackBarAction(
                                        label: 'Sign In',
                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignIn()));
                                        },
                                      )),
                                );
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: const Text('Sign Up'),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignIn()));
                            },
                            child: const Text('Sign In'))
                      ],
                    ),
                  ),
          );
        });
  }
}

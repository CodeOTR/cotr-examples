import 'package:appwrite/appwrite.dart';
import 'package:appwrite_authentication/main.dart';
import 'package:appwrite_authentication/sign_up.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: TextButton(
            onPressed: () async {
              await Account(client).deleteSessions();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignUp()));
            },
            child: Text('Sign Out')),
      ),
    );
  }
}

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_authentication/main.dart';
import 'package:appwrite_authentication/widgets/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: BasicPage(
        child: Center(
          child: TextButton(
              onPressed: () {
                Account(client).deleteSessions().then((value) => context.go('/sign-up'));
              },
              child: const Text('Sign Out')),
        ),
      ),
    );
  }
}

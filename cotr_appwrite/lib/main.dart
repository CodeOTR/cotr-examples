import 'package:appwrite/appwrite.dart';
import 'package:appwrite_authentication/sign_up.dart';
import 'package:flutter/material.dart';

late Client client;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  client = Client()
      .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
      .setProject(const String.fromEnvironment('APPWRITE_PROJECT_ID'));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignUp(),
    );
  }
}

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite_authentication/routes/home.dart';
import 'package:appwrite_authentication/routes/forgot_password.dart';
import 'package:appwrite_authentication/routes/reset_password.dart';
import 'package:appwrite_authentication/routes/sign_in.dart';
import 'package:appwrite_authentication/routes/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

late Client client;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();
  client = Client()
      .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
      .setProject(const String.fromEnvironment('APPWRITE_PROJECT_ID'));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            if (const String.fromEnvironment('APPWRITE_PROJECT_ID') == '')
              MaterialBanner(
                backgroundColor: Colors.red,
                content: const Text('APPWRITE_PROJECT_ID has not been set. Update'
                    ' your config.json file and make sure you are running the app using dart-define '),
                actions: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Okay'),
                  ),
                ],
              )
          ],
        );
      },
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(),
      redirect: (context, state) async {
        return await Account(client).get().then((user) => '/').onError((error, stackTrace) => '/sign-up');
      },
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUp(),
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignIn(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPassword(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPassword(),
    ),
  ],
);

import 'package:cotr_google_sign_in/home.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () async {
                GoogleSignIn googleSignIn = GoogleSignIn(
                  clientId: const String.fromEnvironment('GOOGLE_CLIENT_ID'),
                );

                await googleSignIn.signInSilently();
                debugPrint('User: ' + googleSignIn.currentUser.toString());

                bool hasAuthorization = await googleSignIn.canAccessScopes(['https://www.googleapis.com/auth/user.birthday.read']);

                debugPrint('hasAuthorization: ' + hasAuthorization.toString());

                if (!hasAuthorization) {
                  await googleSignIn.requestScopes(['https://www.googleapis.com/auth/user.birthday.read']);

                  bool hasAuthorization = await googleSignIn.canAccessScopes(['https://www.googleapis.com/auth/user.birthday.read']);

                  debugPrint('hasAuthorization: ' + hasAuthorization.toString());
                }
              },
              child: Text('Check User')),
          ElevatedButton(
              onPressed: () async {
                GoogleSignIn googleSignIn = GoogleSignIn(
                  clientId: const String.fromEnvironment('GOOGLE_CLIENT_ID'),
                );

                await googleSignIn.signIn();

                if (googleSignIn.currentUser != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
                }
              },
              child: Text('Continue with Google'))
        ],
      ),
    );
  }
}

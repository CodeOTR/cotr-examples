import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool loading = false;
  GoogleSignInAccount? user;

  @override
  Widget build(BuildContext context) {

    GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: const String.fromEnvironment('GOOGLE_CLIENT_ID'),
    );

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(loading) const LinearProgressIndicator(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {

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
                child: const Text('Check User'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {

                  setState(() {
                    loading = true;
                  });
                  await googleSignIn.signIn();

                  if (googleSignIn.currentUser != null) {
                    debugPrint('User: ' + googleSignIn.currentUser.toString());
                    setState(() {
                      user = googleSignIn.currentUser;
                      loading = false;
                    });
                  }
                },
                child: const Text('Continue with Google'),
              ),
              if(user != null)...[
                const SizedBox(height: 16),
                const Divider(),
                ListTile(
                  leading: GoogleUserCircleAvatar(identity: user!),
                  title: Text(user?.displayName ?? ''),
                  subtitle: Text(user?.email ?? ''),
                )
              ]

            ],
          ),
        ),
      ),
    );
  }
}

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
              if (loading) const LinearProgressIndicator(),
              const SizedBox(height: 16),
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
              if (user != null) ...[
                const SizedBox(height: 16),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, bottom: 16),
                    child: Column(
                      children: [
                        ListTile(
                          leading: GoogleUserCircleAvatar(identity: user!),
                          title: Text(user?.displayName ?? ''),
                          subtitle: Text(user?.email ?? ''),
                        ),
                        FutureBuilder(
                            future: user!.authHeaders,
                            builder: (context, headers) {
                              return Column(
                                children: [
                                  const ListTile(
                                    leading: Icon(Icons.key),
                                    title: Text('Auth Headers'),
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 48,
                                      ),
                                      Expanded(child: Text(headers.data.toString())),
                                    ],
                                  ),
                                ],
                              );
                            }),
                        FutureBuilder<GoogleSignInAuthentication>(
                            future: user!.authentication,
                            builder: (context, auth) {
                              return Column(
                                children: [
                                  const ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text('ID Token'),
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 48,
                                      ),
                                      Expanded(child: Text(auth.data?.idToken ?? '')),
                                    ],
                                  ),
                                  const ListTile(
                                    leading: Icon(Icons.lock),
                                    title: Text('Access Token'),
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 48,
                                      ),
                                      Expanded(child: Text(auth.data?.accessToken ?? '')),
                                    ],
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

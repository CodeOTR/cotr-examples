import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart' as web;

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool loading = false;
  GoogleSignInAccount? user;

  GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: const String.fromEnvironment('GOOGLE_CLIENT_ID'),
    scopes: [
      'https://www.googleapis.com/auth/user.birthday.read',
    ],
  );

  @override
  void initState() {
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        user = account;
      });
    });

    googleSignIn.signInSilently();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading) const LinearProgressIndicator(),
              if (user == null) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    try {
                      await googleSignIn.signIn();

                      setState(() {
                        loading = false;
                      });
                    } catch (e) {
                      debugPrint('Error: $e');
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                  child: const Text('Continue with Google: SignIn'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    try {
                      await googleSignIn.signInSilently();

                      setState(() {
                        loading = false;
                      });
                    } catch (e) {
                      debugPrint('Error: $e');
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                  child: const Text('Continue with Google: SignInSilently'),
                ),
                const SizedBox(height: 16),
                (GoogleSignInPlatform.instance as web.GoogleSignInPlugin).renderButton(configuration: web.GSIButtonConfiguration())
              ] else ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    await googleSignIn.signOut();

                    setState(() {
                      loading = false;
                    });
                  },
                  child: const Text('Sign Out'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    await googleSignIn.disconnect();

                    setState(() {
                      user = googleSignIn.currentUser;
                      loading = false;
                    });
                  },
                  child: const Text('Disconnect'),
                ),
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
                                      const SizedBox(width: 48),
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
                                    const SizedBox(width: 48),
                                    Expanded(child: SelectableText(auth.data?.idToken ?? '')),
                                  ],
                                ),
                                const ListTile(
                                  leading: Icon(Icons.lock),
                                  title: Text('Access Token'),
                                ),
                                Row(
                                  children: [
                                    const SizedBox(width: 48),
                                    Expanded(child: SelectableText(auth.data?.accessToken ?? '')),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
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

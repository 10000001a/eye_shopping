import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/service/auth_service.dart';
import '../../ui/detection/detection_view.dart';
import '../../ui/sign_in/sign_in_view_model.dart';

// import '../home/home_view.dart';

class SignInView extends ConsumerWidget {
  const SignInView({super.key});

  void _goToDetect(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const DetectionView(),
      ),
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(
    //     builder: (BuildContext context) => const HomeView(),
    //   ),
    // );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return userCredential;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      authServiceProvider.select((AuthState value) => value.status),
      (AuthStatus? previous, AuthStatus next) {
        if (next == AuthStatus.authenticated) {
          _goToDetect(context);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              onChanged:
                  ref.read(signInViewModelProvider.notifier).onChangeEmail,
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              obscureText: true,
              onChanged:
                  ref.read(signInViewModelProvider.notifier).onChangePassword,
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () async {
                await ref.read(signInViewModelProvider.notifier).signIn();
              },
              child: const Text('sign in'),
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () async {
                await ref
                    .read(signInViewModelProvider.notifier)
                    .signInWithGoogle();
              },
              child: const Text('sign in with google'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:eye_shopping/screen/home/home_view.dart';
import 'package:flutter/material.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const HomeView(),
              ),
            );
          },
          child: const Text('sign in'),
        ),
      ),
    );
  }
}
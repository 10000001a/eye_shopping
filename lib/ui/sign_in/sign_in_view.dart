import 'package:flutter/material.dart';

import '../home/home_view.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  void _goToHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const HomeView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _goToHome(context);
          },
          child: const Text('sign in'),
        ),
      ),
    );
  }
}

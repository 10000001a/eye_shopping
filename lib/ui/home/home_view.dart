import 'package:flutter/material.dart';

import '../../ui/detection/detection_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const DetectionView(),
                  ),
                );
              },
              child: const Text('Go to camera'),
            ),
          ],
        ),
      );
}

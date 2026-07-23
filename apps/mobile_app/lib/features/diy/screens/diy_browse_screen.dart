import 'package:flutter/material.dart';

class DiyBrowseScreen extends StatelessWidget {
  const DiyBrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DIY Studio')),
      body: const Center(
        child: Text('DIY Browse - FR-035, FR-036, FR-037'),
      ),
    );
  }
}

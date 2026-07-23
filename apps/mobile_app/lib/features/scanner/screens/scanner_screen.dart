import 'package:flutter/material.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Scanner')),
      body: const Center(
        child: Text('Scanner Screen - FR-023, FR-024, FR-025'),
      ),
    );
  }
}

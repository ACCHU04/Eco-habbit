import 'package:flutter/material.dart';

class ScanResultScreen extends StatelessWidget {
  const ScanResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Result')),
      body: const Center(
        child: Text('Scan Result - FR-026, FR-027, FR-028'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EcoHabit')),
      body: const Center(
        child: Text('Home Dashboard - FR-007, FR-008, FR-009, FR-010'),
      ),
    );
  }
}

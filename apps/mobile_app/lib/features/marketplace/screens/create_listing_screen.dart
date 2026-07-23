import 'package:flutter/material.dart';

class CreateListingScreen extends StatelessWidget {
  const CreateListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Listing')),
      body: const Center(
        child: Text('Create Listing - FR-011, FR-012'),
      ),
    );
  }
}

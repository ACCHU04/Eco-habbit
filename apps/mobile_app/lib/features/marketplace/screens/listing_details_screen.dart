import 'package:flutter/material.dart';

class ListingDetailsScreen extends StatelessWidget {
  const ListingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listing Details')),
      body: const Center(
        child: Text('Listing Details - FR-018, FR-019'),
      ),
    );
  }
}

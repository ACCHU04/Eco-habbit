import 'package:flutter/material.dart';

class CommunityFeedScreen extends StatelessWidget {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: const Center(
        child: Text('Community Feed - FR-043, FR-044, FR-045, FR-046'),
      ),
    );
  }
}

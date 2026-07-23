import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ListingDetailsScreen extends ConsumerWidget {
  const ListingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listing Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            onPressed: () {
              // TODO: Report listing
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image carousel placeholder
            Container(
              height: 300,
              width: double.infinity,
              color: theme.colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.image_outlined,
                size: 64,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price and condition
                  Row(
                    children: [
                      Text(
                        '₹0',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text('Condition', style: theme.textTheme.labelMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    'Item Title',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),

                  // Seller info
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(Icons.person, color: theme.colorScheme.primary),
                      ),
                      title: const Text('Seller Name'),
                      subtitle: const Text('College Name'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text('Description', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(
                    'Item description will appear here.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Contact seller
            },
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text('Contact Seller'),
          ),
        ),
      ),
    );
  }
}

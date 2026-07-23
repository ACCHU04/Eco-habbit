import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/marketplace/providers/marketplace_provider.dart';

class ListingDetailsScreen extends ConsumerWidget {
  final String listingId;
  const ListingDetailsScreen({super.key, required this.listingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final listingAsync = ref.watch(listingDetailProvider(listingId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listing Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: listingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Could not load listing', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => ref.invalidate(listingDetailProvider(listingId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (listing) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                width: double.infinity,
                color: theme.colorScheme.surfaceContainerHighest,
                child: listing.imageUrl != null
                    ? Image.network(listing.imageUrl!, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.image_outlined, size: 64,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                        ))
                    : Icon(Icons.image_outlined, size: 64,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '₹${listing.price}',
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
                          child: Text(
                            listing.condition[0].toUpperCase() + listing.condition.substring(1),
                            style: theme.textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Text(
                      listing.title,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),

                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.primaryContainer,
                          backgroundImage: listing.seller.profilePhoto != null
                              ? NetworkImage(listing.seller.profilePhoto!)
                              : null,
                          child: listing.seller.profilePhoto == null
                              ? Icon(Icons.person, color: theme.colorScheme.primary)
                              : null,
                        ),
                        title: Text(listing.seller.fullName.isNotEmpty ? listing.seller.fullName : 'Seller'),
                        subtitle: Text(listing.seller.college ?? ''),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text('Description', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(
                      listing.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('In-app chat coming soon')),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text('Contact Seller'),
          ),
        ),
      ),
    );
  }
}

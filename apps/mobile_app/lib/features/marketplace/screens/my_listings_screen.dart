import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/widgets/empty_state.dart';
import 'package:mobile_app/features/marketplace/data/marketplace_repository.dart';
import 'package:mobile_app/features/marketplace/models/listing.dart';
import 'package:mobile_app/features/marketplace/providers/marketplace_provider.dart';

class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingsAsync = ref.watch(myListingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Listings')),
      body: listingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Could not load listings', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => ref.invalidate(myListingsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (listings) {
          if (listings.isEmpty) {
            return EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'No listings yet',
              subtitle: 'Items you list will appear here',
              actionLabel: 'Create Listing',
              onAction: () => context.push('/create-listing'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: listings.length,
            itemBuilder: (_, index) {
              final listing = listings[index];
              return _MyListingCard(
                listing: listing,
                onEdit: () => context.push('/create-listing', extra: listing),
                onDelete: () => _confirmDelete(context, ref, listing),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Listing listing) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Listing'),
        content: Text('Remove "${listing.title}" from your listings?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref.read(marketplaceRepositoryProvider).deleteListing(listing.id);
                ref.invalidate(myListingsProvider);
                ref.invalidate(listingsProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Listing removed')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _MyListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MyListingCard({required this.listing, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: listing.imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: listing.imageUrl!,
                  fit: BoxFit.cover,
                  memCacheWidth: 112,
                  placeholder: (_, __) => Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  errorWidget: (_, __, ___) => Icon(Icons.image_outlined,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                )
              : Icon(Icons.image_outlined,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
        ),
        title: Text(listing.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text('₹${listing.price}'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/widgets/empty_state.dart';
import 'package:mobile_app/features/marketplace/models/listing.dart';
import 'package:mobile_app/features/marketplace/providers/marketplace_provider.dart';

class MarketplaceBrowseScreen extends ConsumerStatefulWidget {
  const MarketplaceBrowseScreen({super.key});

  @override
  ConsumerState<MarketplaceBrowseScreen> createState() => _MarketplaceBrowseScreenState();
}

class _MarketplaceBrowseScreenState extends ConsumerState<MarketplaceBrowseScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  final _categories = [
    {'id': 'textbooks_stationery', 'label': 'Textbooks', 'icon': Icons.book_outlined},
    {'id': 'electronics_gadgets', 'label': 'Electronics', 'icon': Icons.devices_outlined},
    {'id': 'furniture_decor', 'label': 'Furniture', 'icon': Icons.chair_outlined},
    {'id': 'clothing_accessories', 'label': 'Clothing', 'icon': Icons.checkroom_outlined},
    {'id': 'sports_fitness', 'label': 'Sports', 'icon': Icons.sports_basketball_outlined},
    {'id': 'others', 'label': 'Others', 'icon': Icons.more_horiz_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(listingsProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(marketplaceFilterProvider.notifier).state =
          ref.read(marketplaceFilterProvider).copyWith(search: value);
    });
  }

  void _onCategorySelected(String? categoryId) {
    final current = ref.read(marketplaceFilterProvider);
    ref.read(marketplaceFilterProvider.notifier).state = current.copyWith(
      category: categoryId,
      clearCategory: categoryId == null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final listingsAsync = ref.watch(listingsProvider);
    final currentFilters = ref.watch(marketplaceFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => context.push('/create-listing'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final cat = _categories[index];
                final isSelected = currentFilters.category == cat['id'];
                return FilterChip(
                  label: Text(cat['label'] as String),
                  avatar: Icon(cat['icon'] as IconData, size: 18),
                  selected: isSelected,
                  onSelected: (selected) => _onCategorySelected(selected ? cat['id'] as String : null),
                );
              },
            ),
          ),

          Expanded(
            child: listingsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Could not load listings', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => ref.invalidate(listingsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (paginated) {
                if (paginated.listings.isEmpty) {
                  return EmptyState(
                    icon: Icons.storefront_outlined,
                    title: 'No listings yet',
                    subtitle: currentFilters.search.isNotEmpty || currentFilters.category != null
                        ? 'Try adjusting your search or filters'
                        : 'Be the first to list an item on the marketplace',
                    actionLabel: currentFilters.search.isEmpty && currentFilters.category == null
                        ? 'Create Listing'
                        : null,
                    onAction: currentFilters.search.isEmpty && currentFilters.category == null
                        ? () => context.push('/create-listing')
                        : null,
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(listingsProvider),
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: paginated.listings.length + (paginated.hasMore ? 1 : 0),
                    itemBuilder: (_, index) {
                      if (index == paginated.listings.length) {
                        return const Center(child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ));
                      }
                      final listing = paginated.listings[index];
                      return _ListingCard(
                        listing: listing,
                        onTap: () => context.push('/marketplace/${listing.id}'),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback onTap;

  const _ListingCard({required this.listing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: theme.colorScheme.surfaceContainerHighest,
                child: listing.imageUrl != null
                    ? Image.network(listing.imageUrl!, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.image_outlined, size: 48,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                        ))
                    : Icon(Icons.image_outlined, size: 48,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${listing.price}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      listing.condition[0].toUpperCase() + listing.condition.substring(1),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

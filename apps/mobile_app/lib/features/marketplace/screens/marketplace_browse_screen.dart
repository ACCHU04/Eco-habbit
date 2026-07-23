import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MarketplaceBrowseScreen extends ConsumerStatefulWidget {
  const MarketplaceBrowseScreen({super.key});

  @override
  ConsumerState<MarketplaceBrowseScreen> createState() => _MarketplaceBrowseScreenState();
}

class _MarketplaceBrowseScreenState extends ConsumerState<MarketplaceBrowseScreen> {
  final _searchController = TextEditingController();
  String? _selectedCategory;
  String? _selectedCondition;

  final _categories = [
    {'id': 'textbooks_stationery', 'label': 'Textbooks', 'icon': Icons.book_outlined},
    {'id': 'electronics_gadgets', 'label': 'Electronics', 'icon': Icons.devices_outlined},
    {'id': 'furniture_decor', 'label': 'Furniture', 'icon': Icons.chair_outlined},
    {'id': 'clothing_accessories', 'label': 'Clothing', 'icon': Icons.checkroom_outlined},
    {'id': 'sports_fitness', 'label': 'Sports', 'icon': Icons.sports_basketball_outlined},
    {'id': 'others', 'label': 'Others', 'icon': Icons.more_horiz_outlined},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          // Search bar
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
                          setState(() {});
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          // Category chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat['id'];
                return FilterChip(
                  label: Text(cat['label'] as String),
                  avatar: Icon(cat['icon'] as IconData, size: 18),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _selectedCategory = selected ? cat['id'] as String : null);
                  },
                );
              },
            ),
          ),

          // Listings grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 0, // TODO: Wire up to data source
              itemBuilder: (_, index) => _ListingCard(
                title: 'Sample Item',
                price: 250,
                condition: 'Good',
                imageUrl: null,
                onTap: () => context.push('/marketplace/placeholder'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final String title;
  final int price;
  final String condition;
  final String? imageUrl;
  final VoidCallback onTap;

  const _ListingCard({
    required this.title,
    required this.price,
    required this.condition,
    this.imageUrl,
    required this.onTap,
  });

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
                child: imageUrl != null
                    ? Image.network(imageUrl!, fit: BoxFit.cover)
                    : Icon(Icons.image_outlined, size: 48, color: theme.colorScheme.onSurface.withOpacity(0.3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹$price',
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
                      condition,
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

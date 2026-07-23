import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DiyBrowseScreen extends StatefulWidget {
  const DiyBrowseScreen({super.key});

  @override
  State<DiyBrowseScreen> createState() => _DiyBrowseScreenState();
}

class _DiyBrowseScreenState extends State<DiyBrowseScreen> {
  String? _selectedCategory;
  String? _selectedDifficulty;
  final _searchController = TextEditingController();

  final _categories = [
    {'id': 'plastic', 'label': 'Plastic', 'icon': Icons.local_drink_outlined},
    {'id': 'paper_cardboard', 'label': 'Paper', 'icon': Icons.description_outlined},
    {'id': 'glass', 'label': 'Glass', 'icon': Icons.wine_bar_outlined},
    {'id': 'metal', 'label': 'Metal', 'icon': Icons.hardware_outlined},
    {'id': 'textile', 'label': 'Textile', 'icon': Icons.checkroom_outlined},
    {'id': 'ewaste', 'label': 'E-Waste', 'icon': Icons.devices_other_outlined},
  ];

  final _difficulties = ['easy', 'medium', 'hard'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('DIY Studio')),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: Icon(Icons.search, size: 20),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Category chips
          SizedBox(
            height: 44,
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
                  avatar: Icon(cat['icon'] as IconData, size: 16),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _selectedCategory = selected ? cat['id'] as String : null);
                  },
                );
              },
            ),
          ),

          // Difficulty chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text('Difficulty: ', style: theme.textTheme.labelMedium),
                ..._difficulties.map((d) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(d[0].toUpperCase() + d.substring(1)),
                    selected: _selectedDifficulty == d,
                    onSelected: (selected) {
                      setState(() => _selectedDifficulty = selected ? d : null);
                    },
                  ),
                )),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Projects grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 0, // TODO: Wire up to data source
              itemBuilder: (_, index) => _ProjectCard(
                title: 'Sample Project',
                difficulty: 'easy',
                estimatedTime: '30 min',
                estimatedPrice: 150,
                onTap: () => context.push('/diy/placeholder'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String title;
  final String difficulty;
  final String estimatedTime;
  final int estimatedPrice;
  final VoidCallback onTap;

  const _ProjectCard({
    required this.title,
    required this.difficulty,
    required this.estimatedTime,
    required this.estimatedPrice,
    required this.onTap,
  });

  Color _difficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return const Color(0xFF059669);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'hard':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon placeholder
              Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.build_outlined,
                  size: 36,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _difficultyColor(difficulty).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      difficulty[0].toUpperCase() + difficulty.substring(1),
                      style: TextStyle(
                        fontSize: 10,
                        color: _difficultyColor(difficulty),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    estimatedTime,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

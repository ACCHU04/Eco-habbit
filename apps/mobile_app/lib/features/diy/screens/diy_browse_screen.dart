import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/widgets/empty_state.dart';
import 'package:mobile_app/features/diy/models/diy_project_model.dart';
import 'package:mobile_app/features/diy/providers/diy_provider.dart';

class DiyBrowseScreen extends ConsumerStatefulWidget {
  const DiyBrowseScreen({super.key});

  @override
  ConsumerState<DiyBrowseScreen> createState() => _DiyBrowseScreenState();
}

class _DiyBrowseScreenState extends ConsumerState<DiyBrowseScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

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
      ref.read(diyProjectsProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(diyFilterProvider.notifier).state =
          ref.read(diyFilterProvider).copyWith(search: value);
    });
  }

  void _onCategorySelected(String? categoryId) {
    final current = ref.read(diyFilterProvider);
    ref.read(diyFilterProvider.notifier).state = current.copyWith(
      category: categoryId,
      clearCategory: categoryId == null,
    );
  }

  void _onDifficultySelected(String? difficulty) {
    final current = ref.read(diyFilterProvider);
    ref.read(diyFilterProvider.notifier).state = current.copyWith(
      difficulty: difficulty,
      clearDifficulty: difficulty == null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectsAsync = ref.watch(diyProjectsProvider);
    final currentFilters = ref.watch(diyFilterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('DIY Studio')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search projects...',
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
            height: 44,
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
                  avatar: Icon(cat['icon'] as IconData, size: 16),
                  selected: isSelected,
                  onSelected: (selected) => _onCategorySelected(selected ? cat['id'] as String : null),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text('Difficulty: ', style: theme.textTheme.labelMedium),
                ..._difficulties.map((d) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(d[0].toUpperCase() + d.substring(1)),
                    selected: currentFilters.difficulty == d,
                    onSelected: (selected) => _onDifficultySelected(selected ? d : null),
                  ),
                )),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: projectsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Could not load projects', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => ref.invalidate(diyProjectsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (paginated) {
                if (paginated.projects.isEmpty) {
                  return EmptyState(
                    icon: Icons.build_outlined,
                    title: 'No DIY projects yet',
                    subtitle: currentFilters.search.isNotEmpty || currentFilters.category != null
                        ? 'Try adjusting your search or filters'
                        : 'Scan an item to get project suggestions',
                    actionLabel: currentFilters.search.isEmpty && currentFilters.category == null
                        ? 'Scan Item'
                        : null,
                    onAction: currentFilters.search.isEmpty && currentFilters.category == null
                        ? () => context.go('/scanner')
                        : null,
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(diyProjectsProvider),
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: paginated.projects.length + (paginated.hasMore ? 1 : 0),
                    itemBuilder: (_, index) {
                      if (index == paginated.projects.length) {
                        return const Center(child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ));
                      }
                      final project = paginated.projects[index];
                      return _ProjectCard(
                        project: project,
                        onTap: () => context.push('/diy/${project.id}'),
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

class _ProjectCard extends StatelessWidget {
  final DiyProject project;
  final VoidCallback onTap;

  const _ProjectCard({required this.project, required this.onTap});

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
                project.title,
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
                      color: _difficultyColor(project.difficulty).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      project.difficulty[0].toUpperCase() + project.difficulty.substring(1),
                      style: TextStyle(
                        fontSize: 10,
                        color: _difficultyColor(project.difficulty),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    project.estimatedTime,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
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

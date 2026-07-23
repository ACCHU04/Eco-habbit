import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/diy/data/diy_repository.dart';
import 'package:mobile_app/features/diy/providers/diy_provider.dart';

class ProjectDetailsScreen extends ConsumerStatefulWidget {
  final String projectId;
  const ProjectDetailsScreen({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends ConsumerState<ProjectDetailsScreen> {
  final Set<int> _completedSteps = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectAsync = ref.watch(diyDetailProvider(widget.projectId));
    final savedAsync = ref.watch(savedProjectsProvider);

    final isSaved = savedAsync.whenOrNull(
      data: (saved) => saved.any((s) => s.project.id == widget.projectId),
    ) ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
        actions: [
          IconButton(
            icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border),
            color: isSaved ? Colors.red : null,
            onPressed: () => _toggleSave(isSaved),
            tooltip: isSaved ? 'Unsave' : 'Save',
          ),
        ],
      ),
      body: projectAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Could not load project', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => ref.invalidate(diyDetailProvider(widget.projectId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (project) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                color: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.build_outlined,
                  size: 64,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            project.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _difficultyColor(project.difficulty).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            project.difficulty[0].toUpperCase() + project.difficulty.substring(1),
                            style: TextStyle(
                              color: _difficultyColor(project.difficulty),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                        const SizedBox(width: 4),
                        Text(project.estimatedTime, style: theme.textTheme.bodySmall),
                        const SizedBox(width: 16),
                        Icon(Icons.sell_outlined, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                        const SizedBox(width: 4),
                        Text('Est. ₹${project.estimatedPrice}', style: theme.textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      project.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Materials Needed',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    ...project.materials.map((m) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 18, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(m, style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    )),
                    const SizedBox(height: 24),
                    Text(
                      'Instructions',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    ...project.steps.asMap().entries.map((entry) {
                      final i = entry.key;
                      final step = entry.value;
                      final isCompleted = _completedSteps.contains(i);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isCompleted) {
                                    _completedSteps.remove(i);
                                  } else {
                                    _completedSteps.add(i);
                                  }
                                });
                              },
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isCompleted ? theme.colorScheme.primary : Colors.transparent,
                                  border: Border.all(
                                    color: isCompleted
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: isCompleted
                                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                                    : Center(
                                        child: Text('${i + 1}', style: theme.textTheme.labelSmall),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                step,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                                  color: isCompleted
                                      ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
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
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share to Community coming soon')),
              );
            },
            icon: const Icon(Icons.share_outlined),
            label: const Text('Share to Community'),
          ),
        ),
      ),
    );
  }

  Color _difficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy': return const Color(0xFF059669);
      case 'medium': return const Color(0xFFF59E0B);
      case 'hard': return const Color(0xFFDC2626);
      default: return const Color(0xFF6B7280);
    }
  }

  Future<void> _toggleSave(bool currentlySaved) async {
    final repo = ref.read(diyRepositoryProvider);
    try {
      if (currentlySaved) {
        await repo.unsaveProject(widget.projectId);
      } else {
        await repo.saveProject(widget.projectId);
      }
      ref.invalidate(savedProjectsProvider);
      ref.invalidate(diyDetailProvider(widget.projectId));
      ref.invalidate(diyProjectsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}

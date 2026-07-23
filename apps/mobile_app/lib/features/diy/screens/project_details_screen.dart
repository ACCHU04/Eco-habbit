import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({super.key});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  bool _isSaved = false;
  final Set<int> _completedSteps = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Sample data — will be replaced with API data
    const title = 'Plastic Bottle Planter';
    const description = 'Turn plastic bottles into hanging planters for your dorm room.';
    const difficulty = 'easy';
    const estimatedTime = '30 minutes';
    const estimatedPrice = 150;
    const materials = ['Plastic bottle', 'Scissors', 'Rope', 'Paint'];
    const steps = [
      'Cut the bottle in half horizontally',
      'Poke drainage holes in the bottom',
      'Paint and decorate the outside',
      'Thread rope through holes for hanging',
      'Add soil and plant',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
        actions: [
          IconButton(
            icon: Icon(_isSaved ? Icons.favorite : Icons.favorite_border),
            color: _isSaved ? Colors.red : null,
            onPressed: () => setState(() => _isSaved = !_isSaved),
            tooltip: _isSaved ? 'Unsave' : 'Save',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image placeholder
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
                  // Title + difficulty badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          difficulty[0].toUpperCase() + difficulty.substring(1),
                          style: const TextStyle(
                            color: Color(0xFF059669),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Meta row
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                      const SizedBox(width: 4),
                      Text(estimatedTime, style: theme.textTheme.bodySmall),
                      const SizedBox(width: 16),
                      Icon(Icons.sell_outlined, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                      const SizedBox(width: 4),
                      Text('Est. ₹$estimatedPrice', style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Materials
                  Text(
                    'Materials Needed',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...materials.map((m) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(m, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  )),
                  const SizedBox(height: 24),

                  // Steps
                  Text(
                    'Instructions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...steps.asMap().entries.map((entry) {
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
                                color: isCompleted
                                    ? theme.colorScheme.primary
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isCompleted
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.outline.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: isCompleted
                                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                                  : Center(
                                      child: Text(
                                        '${i + 1}',
                                        style: theme.textTheme.labelSmall,
                                      ),
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
                                    ? theme.colorScheme.onSurface.withOpacity(0.4)
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Share to community
            },
            icon: const Icon(Icons.share_outlined),
            label: const Text('Share to Community'),
          ),
        ),
      ),
    );
  }
}

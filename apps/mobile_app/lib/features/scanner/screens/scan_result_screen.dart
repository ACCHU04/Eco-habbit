import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScanResultScreen extends StatelessWidget {
  final String imagePath;
  final String category;
  final double confidence;
  final String disposalTips;
  final bool isUncertain;
  final List<Map<String, dynamic>> diySuggestions;

  const ScanResultScreen({
    super.key,
    required this.imagePath,
    required this.category,
    required this.confidence,
    required this.disposalTips,
    required this.isUncertain,
    required this.diySuggestions,
  });

  Color _confidenceColor(double confidence, ThemeData theme) {
    if (confidence >= 0.80) return const Color(0xFF059669);
    if (confidence >= 0.60) return const Color(0xFFF59E0B);
    return const Color(0xFFDC2626);
  }

  String _categoryLabel(String category) {
    const labels = {
      'plastic': 'Plastic',
      'paper_cardboard': 'Paper & Cardboard',
      'glass': 'Glass',
      'metal': 'Metal',
      'organic': 'Organic',
      'ewaste': 'E-Waste',
      'textile': 'Textile',
      'others': 'Others',
    };
    return labels[category] ?? category;
  }

  IconData _categoryIcon(String category) {
    const icons = {
      'plastic': Icons.local_drink_outlined,
      'paper_cardboard': Icons.description_outlined,
      'glass': Icons.wine_bar_outlined,
      'metal': Icons.hardware_outlined,
      'organic': Icons.eco_outlined,
      'ewaste': Icons.devices_other_outlined,
      'textile': Icons.checkroom_outlined,
      'others': Icons.help_outline,
    };
    return icons[category] ?? Icons.help_outline;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final confColor = _confidenceColor(confidence, theme);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.pop(),
            tooltip: 'Scan Again',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image preview
            SizedBox(
              height: 220,
              width: double.infinity,
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 48,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Classification card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _categoryIcon(category),
                                size: 32,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _categoryLabel(category),
                                      style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (isUncertain)
                                      Container(
                                        margin: const EdgeInsets.only(top: 4),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF3C7),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'Uncertain — select manually below',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF92400E),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Confidence bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Confidence', style: theme.textTheme.labelMedium),
                              Text(
                                '${(confidence * 100).toStringAsFixed(0)}%',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: confColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: confidence,
                              backgroundColor: theme.colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation(confColor),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Disposal tips
                          Text('Disposal Tips', style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          )),
                          const SizedBox(height: 6),
                          Text(
                            disposalTips,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Manual fallback for uncertain results
                  if (isUncertain) ...[
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select correct category:',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                'plastic', 'paper_cardboard', 'glass', 'metal',
                                'organic', 'ewaste', 'textile', 'others',
                              ].map((cat) => ActionChip(
                                label: Text(_categoryLabel(cat)),
                                avatar: Icon(_categoryIcon(cat), size: 16),
                                onPressed: () {
                                  // TODO: Re-classify with manual selection
                                },
                              )).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // DIY Suggestions
                  if (diySuggestions.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'DIY Suggestions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...diySuggestions.map((s) => Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.secondaryContainer,
                          child: Icon(
                            Icons.build_outlined,
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                        title: Text(s['title'] ?? ''),
                        subtitle: Text(s['difficulty'] ?? ''),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/diy/${s['project_id']}'),
                      ),
                    )),
                  ],

                  const SizedBox(height: 24),
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
            onPressed: () => context.pop(),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Scan Again'),
          ),
        ),
      ),
    );
  }
}

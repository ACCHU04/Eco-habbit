import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/features/scanner/models/scan_result_data.dart';

class ScanResultScreen extends ConsumerWidget {
  final ScanResultData data;
  const ScanResultScreen({super.key, required this.data});

  Color _confidenceColor(double confidence) {
    if (confidence >= 0.80) return const Color(0xFF059669);
    if (confidence >= 0.60) return const Color(0xFFF59E0B);
    return const Color(0xFFDC2626);
  }

  String _confidenceLabel(double confidence) {
    if (confidence >= 0.80) return 'High confidence';
    if (confidence >= 0.60) return 'Medium confidence';
    return 'Low confidence — consider retaking the photo';
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final confColor = _confidenceColor(data.confidence);

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
            SizedBox(
              height: 220,
              width: double.infinity,
              child: Image.file(
                File(data.imagePath),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 48,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EcoTokens.paddingPage,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: EcoTokens.paddingCard,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(_categoryIcon(data.category), size: 32,
                                color: theme.colorScheme.primary),
                              const SizedBox(width: EcoTokens.spacing3),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_categoryLabel(data.category),
                                      style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold)),
                                    if (data.isUncertain)
                                      Container(
                                        margin: const EdgeInsets.only(top: 4),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: EcoTokens.spacing2,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF3C7),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'Uncertain — select manually below',
                                          style: TextStyle(fontSize: 11,
                                            color: Color(0xFF92400E)),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: EcoTokens.spacing4),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Confidence', style: theme.textTheme.labelMedium),
                              Text(
                                '${(data.confidence * 100).toStringAsFixed(0)}%',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: confColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: EcoTokens.spacing2),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: data.confidence,
                              backgroundColor: theme.colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation(confColor),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: EcoTokens.spacing2),
                          Text(
                            _confidenceLabel(data.confidence),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: confColor,
                            ),
                          ),
                          const SizedBox(height: EcoTokens.spacing4),

                          if (data.explanation.isNotEmpty) ...[
                            Text('AI Analysis',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600)),
                            const SizedBox(height: EcoTokens.spacing2),
                            Container(
                              padding: const EdgeInsets.all(EcoTokens.spacing3),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.psychology_outlined, size: 20,
                                    color: theme.colorScheme.tertiary),
                                  const SizedBox(width: EcoTokens.spacing2),
                                  Expanded(
                                    child: Text(
                                      data.explanation,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: EcoTokens.spacing4),
                          ],

                          Text('Disposal Tips', style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600)),
                          const SizedBox(height: EcoTokens.spacing2),
                          Text(
                            data.disposalTips,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (data.isUncertain) ...[
                    const SizedBox(height: EcoTokens.spacing4),
                    Card(
                      child: Padding(
                        padding: EcoTokens.paddingCard,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Select correct category:',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600)),
                            const SizedBox(height: EcoTokens.spacing3),
                            Text(
                              'The AI is not fully confident. Choose the category that best fits:',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                            ),
                            const SizedBox(height: EcoTokens.spacing3),
                            Wrap(
                              spacing: EcoTokens.spacing2,
                              runSpacing: EcoTokens.spacing2,
                              children: [
                                'plastic', 'paper_cardboard', 'glass', 'metal',
                                'organic', 'ewaste', 'textile', 'others',
                              ].map((cat) => ActionChip(
                                label: Text(_categoryLabel(cat)),
                                avatar: Icon(_categoryIcon(cat), size: 16),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Manual re-classification coming soon')),
                                  );
                                },
                              )).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  if (data.diySuggestions.isNotEmpty) ...[
                    const SizedBox(height: EcoTokens.spacing4),
                    Text('DIY Suggestions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600)),
                    const SizedBox(height: EcoTokens.spacing2),
                    ...data.diySuggestions.map((s) => Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.secondaryContainer,
                          child: Icon(Icons.build_outlined,
                            color: theme.colorScheme.onSecondaryContainer),
                        ),
                        title: Text(s.title),
                        subtitle: Text(s.difficulty[0].toUpperCase() +
                            s.difficulty.substring(1)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/diy/${s.projectId}'),
                      ),
                    )),
                  ],
                  const SizedBox(height: EcoTokens.spacing6),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EcoTokens.paddingPage,
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

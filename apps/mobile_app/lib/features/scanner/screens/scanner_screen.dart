import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/services/analytics_service.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/scanner/data/ai_repository.dart';
import 'package:mobile_app/features/scanner/models/scan_result_data.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  final _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image == null) return;

      setState(() => _isLoading = true);
      final file = File(image.path);
      final result = await ref.read(aiRepositoryProvider).classifyImage(file);
      final scanData = ScanResultData.fromResult(result, image.path);

      ref.read(analyticsServiceProvider).logEvent(
        AnalyticsEvent.scanCompleted,
        parameters: {
          'category': result.category,
          'confidence': result.confidence.toStringAsFixed(4),
          'is_uncertain': result.isUncertain.toString(),
          'cached': result.cached.toString(),
        },
      );

      if (mounted) {
        setState(() => _isLoading = false);
        context.push('/scan-result', extra: scanData);
      }
    } catch (e) {
      ref.read(analyticsServiceProvider).logEvent(
        AnalyticsEvent.scanFailed,
        parameters: {'error': e.toString()},
      );

      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('AI Scanner')),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(EcoTokens.spacing7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.document_scanner_outlined, size: 120,
                    color: theme.colorScheme.primary.withValues(alpha: 0.3)),
                  const SizedBox(height: EcoTokens.spacing6),
                  Text('Scan an Item',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold)),
                  const SizedBox(height: EcoTokens.spacing2),
                  Text('Identify waste material and get\nrecycling tips + DIY suggestions',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                  const SizedBox(height: EcoTokens.spacing9),
                  SizedBox(width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take Photo'))),
                  const SizedBox(height: EcoTokens.spacing4),
                  SizedBox(width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Choose from Gallery'))),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(EcoTokens.spacing7),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: EcoTokens.spacing4),
                        Text('Analyzing...', style: theme.textTheme.titleMedium),
                        const SizedBox(height: EcoTokens.spacing1),
                        Text('AI is classifying your item',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

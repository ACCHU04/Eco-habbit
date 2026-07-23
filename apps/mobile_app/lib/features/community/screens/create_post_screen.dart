import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/features/diy/models/diy_project_model.dart';
import 'package:mobile_app/features/community/data/community_repository.dart';
import 'package:mobile_app/features/community/models/post.dart';
import 'package:mobile_app/features/community/providers/community_provider.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? extra;
  const CreatePostScreen({super.key, this.extra});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  late String _selectedType;
  late final TextEditingController _contentController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.extra?['type'] as String? ?? 'tip';

    final project = widget.extra?['project'] as DiyProject?;
    if (project != null) {
      _contentController = TextEditingController(
        text:
            'Just completed "${project.title}"! ${project.description}\n\n'
            'Materials: ${project.materials.join(", ")}\n'
            'Time: ${project.estimatedTime} | Difficulty: ${project.difficulty}',
      );
    } else {
      _contentController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submitPost,
            child: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Post', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Post Type', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                _TypeChip(
                  icon: Icons.build,
                  label: 'DIY',
                  selected: _selectedType == 'diy',
                  onTap: () => setState(() => _selectedType = 'diy'),
                ),
                const SizedBox(width: 8),
                _TypeChip(
                  icon: Icons.lightbulb,
                  label: 'Tip',
                  selected: _selectedType == 'tip',
                  onTap: () => setState(() => _selectedType = 'tip'),
                ),
                const SizedBox(width: 8),
                _TypeChip(
                  icon: Icons.storefront,
                  label: 'Marketplace',
                  selected: _selectedType == 'marketplace',
                  onTap: () => setState(() => _selectedType = 'marketplace'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _contentController,
              maxLines: 6,
              maxLength: 2000,
              decoration: InputDecoration(
                hintText: _getHintText(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _ActionButton(icon: Icons.camera_alt, label: 'Camera', onTap: () {}),
                const SizedBox(width: 16),
                _ActionButton(icon: Icons.photo_library, label: 'Gallery', onTap: () {}),
                const SizedBox(width: 16),
                _ActionButton(icon: Icons.link, label: 'Link', onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getHintText() {
    switch (_selectedType) {
      case 'diy':
        return 'Share your DIY project... What did you create? What materials did you use?';
      case 'tip':
        return 'Share a sustainability tip... What eco-friendly advice do you have?';
      case 'marketplace':
        return 'Share a marketplace listing... Tell others about what you are selling.';
      default:
        return 'Write something...';
    }
  }

  Future<void> _submitPost() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ref.read(communityRepositoryProvider).createPost(
        CreatePostRequest(
          postType: _selectedType,
          content: _contentController.text.trim(),
        ),
      );
      ref.invalidate(communityFeedProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create post: $e')),
        );
      }
    }
  }
}

class _TypeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: selected ? Colors.white : Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/features/diy/models/diy_project_model.dart';
import 'package:mobile_app/features/community/data/community_repository.dart';
import 'package:mobile_app/features/community/models/post.dart';
import 'package:mobile_app/features/community/providers/community_provider.dart';

const int _maxImages = 4;

class CreatePostScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? extra;
  const CreatePostScreen({super.key, this.extra});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  late PostType _selectedType;
  late final TextEditingController _contentController;
  bool _isSubmitting = false;
  final List<File> _selectedImages = [];
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final typeStr = widget.extra?['type'] as String?;
    _selectedType = postTypeFromString(typeStr);

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

  Future<void> _pickImage(ImageSource source) async {
    if (_selectedImages.length >= _maxImages) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum $_maxImages images allowed')),
        );
      }
      return;
    }

    final image = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() => _selectedImages.add(File(image.path)));
    }
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
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
      final repo = ref.read(communityRepositoryProvider);
      List<String> imageUrls = [];

      if (_selectedImages.isNotEmpty) {
        for (final image in _selectedImages) {
          final url = await repo.uploadImage(image.path);
          imageUrls.add(url);
        }
      }

      await repo.createPost(
        CreatePostRequest(
          postType: _selectedType,
          content: _contentController.text.trim(),
          imageUrls: imageUrls.isNotEmpty ? imageUrls : null,
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
                  selected: _selectedType == PostType.diy,
                  onTap: () => setState(() => _selectedType = PostType.diy),
                ),
                const SizedBox(width: 8),
                _TypeChip(
                  icon: Icons.lightbulb,
                  label: 'Tip',
                  selected: _selectedType == PostType.tip,
                  onTap: () => setState(() => _selectedType = PostType.tip),
                ),
                const SizedBox(width: 8),
                _TypeChip(
                  icon: Icons.storefront,
                  label: 'Marketplace',
                  selected: _selectedType == PostType.marketplace,
                  onTap: () => setState(() => _selectedType = PostType.marketplace),
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
            if (_selectedImages.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedImages[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(Icons.close, size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                _ActionButton(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                const SizedBox(width: 16),
                _ActionButton(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
                const SizedBox(width: 16),
                _ActionButton(
                  icon: Icons.link,
                  label: 'Link',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getHintText() {
    switch (_selectedType) {
      case PostType.diy:
        return 'Share your DIY project... What did you create? What materials did you use?';
      case PostType.tip:
        return 'Share a sustainability tip... What eco-friendly advice do you have?';
      case PostType.marketplace:
        return 'Share a marketplace listing... Tell others about what you are selling.';
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

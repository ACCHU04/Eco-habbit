import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/features/marketplace/models/listing.dart';
import 'package:mobile_app/features/marketplace/data/marketplace_repository.dart';
import 'package:mobile_app/features/marketplace/providers/marketplace_provider.dart';

class CreateListingScreen extends ConsumerStatefulWidget {
  final Listing? existingListing;
  const CreateListingScreen({super.key, this.existingListing});

  @override
  ConsumerState<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends ConsumerState<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String _category = 'textbooks_stationery';
  String _condition = 'good';
  bool _isLoading = false;

  bool get _isEditing => widget.existingListing != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final listing = widget.existingListing!;
      _titleController.text = listing.title;
      _descriptionController.text = listing.description;
      _priceController.text = listing.price.toString();
      _category = listing.category;
      _condition = listing.condition;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final repo = ref.read(marketplaceRepositoryProvider);
      if (_isEditing) {
        await repo.updateListing(widget.existingListing!.id, UpdateListingRequest(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          price: int.parse(_priceController.text.trim()),
          category: _category,
          condition: _condition,
        ));
      } else {
        await repo.createListing(CreateListingRequest(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          price: int.parse(_priceController.text.trim()),
          category: _category,
          condition: _condition,
        ));
      }

      ref.invalidate(listingsProvider);
      ref.invalidate(myListingsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? 'Listing updated!' : 'Listing created!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Listing' : 'Create Listing')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Image upload coming soon')),
                  );
                },
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add Photos (up to 5)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Title required' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                ),
                validator: (v) => v == null || v.isEmpty ? 'Description required' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price (₹)',
                  prefixText: '₹ ',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Price required';
                  if (int.tryParse(v) == null) return 'Invalid price';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: const [
                  DropdownMenuItem(value: 'textbooks_stationery', child: Text('Textbooks & Stationery')),
                  DropdownMenuItem(value: 'electronics_gadgets', child: Text('Electronics & Gadgets')),
                  DropdownMenuItem(value: 'furniture_decor', child: Text('Furniture & Decor')),
                  DropdownMenuItem(value: 'clothing_accessories', child: Text('Clothing & Accessories')),
                  DropdownMenuItem(value: 'sports_fitness', child: Text('Sports & Fitness')),
                  DropdownMenuItem(value: 'others', child: Text('Others')),
                ],
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _condition,
                decoration: const InputDecoration(labelText: 'Condition'),
                items: const [
                  DropdownMenuItem(value: 'new', child: Text('New')),
                  DropdownMenuItem(value: 'good', child: Text('Good')),
                  DropdownMenuItem(value: 'fair', child: Text('Fair')),
                  DropdownMenuItem(value: 'used', child: Text('Used')),
                ],
                onChanged: (v) => setState(() => _condition = v!),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(_isEditing ? 'Update Listing' : 'Post Listing'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

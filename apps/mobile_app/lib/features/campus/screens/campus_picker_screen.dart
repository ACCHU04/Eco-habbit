import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/core/widgets/eco_error_view.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import '../models/campus.dart';
import '../providers/campus_provider.dart';
import '../widgets/campus_avatar.dart';

class CampusPickerScreen extends ConsumerStatefulWidget {
  final bool showSkip;
  const CampusPickerScreen({super.key, this.showSkip = true});

  @override
  ConsumerState<CampusPickerScreen> createState() => _CampusPickerScreenState();
}

class _CampusPickerScreenState extends ConsumerState<CampusPickerScreen> {
  String _search = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _selectCampus(Campus campus) async {
    final storage = ref.read(storageServiceProvider);
    await storage.setSelectedCampus(campus.slug);
    ref.read(selectedCampusProvider.notifier).state = campus;

    try {
      await ref.read(campusRepositoryProvider).setUserCampus(campus.slug);
    } catch (_) {}

    if (mounted) Navigator.of(context).pop(campus);
  }

  Future<void> _skip() async {
    final storage = ref.read(storageServiceProvider);
    await storage.clearSelectedCampus();
    ref.read(selectedCampusProvider.notifier).state = null;
    if (mounted) Navigator.of(context).pop(null);
  }

  @override
  Widget build(BuildContext context) {
    final campusesAsync = ref.watch(activeCampusesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Campus')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(EcoTokens.spacing4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search campuses...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(EcoTokens.radiusMd),
                ),
              ),
              onChanged: (v) => setState(() => _search = v.toLowerCase()),
            ),
          ),
          Expanded(
            child: campusesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => EcoErrorView(
                message: 'Failed to load campuses',
                onRetry: () => ref.invalidate(activeCampusesProvider),
              ),
              data: (campuses) {
                final filtered = campuses.where((c) =>
                    c.name.toLowerCase().contains(_search) ||
                    (c.shortName?.toLowerCase().contains(_search) ?? false) ||
                    (c.city?.toLowerCase().contains(_search) ?? false));

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 64,
                            color: Theme.of(context).colorScheme.outline),
                        const SizedBox(height: EcoTokens.spacing4),
                        Text('No campuses found',
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: EcoTokens.spacing4),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final campus = filtered.elementAt(index);
                    return Card(
                      margin: const EdgeInsets.only(bottom: EcoTokens.spacing3),
                      child: ListTile(
                        leading: CampusAvatar(campus: campus),
                        title: Text(campus.name),
                        subtitle: campus.location.isNotEmpty
                            ? Text(campus.location)
                            : null,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _selectCampus(campus),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.showSkip
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(EcoTokens.spacing4),
                child: TextButton(
                  onPressed: _skip,
                  child: const Text('Skip for now'),
                ),
              ),
            )
          : null,
    );
  }
}

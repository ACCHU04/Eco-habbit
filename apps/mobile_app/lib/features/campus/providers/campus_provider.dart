import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import '../data/campus_repository.dart';
import '../models/campus.dart';

final campusRepositoryProvider = Provider<CampusRepository>((ref) {
  return CampusRepository(ref.read(apiClientProvider));
});

final activeCampusesProvider = FutureProvider<List<Campus>>((ref) async {
  final repo = ref.read(campusRepositoryProvider);
  return repo.getActiveCampuses();
});

final selectedCampusProvider = StateProvider<Campus?>((ref) => null);

final setCampusProvider = FutureProvider.family<void, String>((ref, slug) async {
  final repo = ref.read(campusRepositoryProvider);
  await repo.setUserCampus(slug);
  ref.invalidate(activeCampusesProvider);
});

final campusBySlugProvider = FutureProvider.family<Campus, String>((ref, slug) async {
  final repo = ref.read(campusRepositoryProvider);
  return repo.getCampusBySlug(slug);
});

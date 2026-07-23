import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/marketplace/data/marketplace_repository.dart';
import 'package:mobile_app/features/marketplace/models/listing.dart';
import 'package:mobile_app/features/marketplace/models/marketplace_filters.dart';

final marketplaceFilterProvider = StateProvider<MarketplaceFilters>((ref) => const MarketplaceFilters());

class ListingsNotifier extends AsyncNotifier<PaginatedListings> {
  @override
  Future<PaginatedListings> build() async {
    final filters = ref.watch(marketplaceFilterProvider);
    return ref.read(marketplaceRepositoryProvider).browseListings(filters: filters);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore) return;
    state = AsyncValue.data(current);
    try {
      final filters = ref.read(marketplaceFilterProvider);
      final next = await ref.read(marketplaceRepositoryProvider).browseListings(
        filters: filters,
        page: current.page + 1,
        limit: current.limit,
      );
      state = AsyncValue.data(PaginatedListings(
        listings: [...current.listings, ...next.listings],
        page: next.page,
        limit: next.limit,
        total: next.total,
        totalPages: next.totalPages,
      ));
    } catch (e) {
      state = AsyncValue.data(current);
      rethrow;
    }
  }
}

final listingsProvider = AsyncNotifierProvider<ListingsNotifier, PaginatedListings>(
  ListingsNotifier.new,
);

final listingDetailProvider = FutureProvider.family<Listing, String>((ref, id) async {
  return ref.read(marketplaceRepositoryProvider).getListing(id);
});

class MyListingsNotifier extends AsyncNotifier<List<Listing>> {
  @override
  Future<List<Listing>> build() async {
    return ref.read(marketplaceRepositoryProvider).getMyListings();
  }
}

final myListingsProvider = AsyncNotifierProvider<MyListingsNotifier, List<Listing>>(
  MyListingsNotifier.new,
);

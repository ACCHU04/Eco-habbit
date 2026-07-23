import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_app/features/marketplace/data/marketplace_repository.dart';
import 'package:mobile_app/features/marketplace/models/listing.dart';
import 'package:mobile_app/features/marketplace/models/marketplace_filters.dart';
import 'package:mobile_app/features/marketplace/providers/marketplace_provider.dart';

import 'marketplace_provider_test.mocks.dart';

@GenerateMocks([MarketplaceRepository])
void main() {
  late MockMarketplaceRepository mockRepo;
  late ProviderContainer container;

  final testListing = Listing(
    id: 'l1', title: 'Chair', description: 'Nice chair', price: 500,
    category: 'furniture_decor', condition: 'good', status: 'active',
    createdAt: DateTime(2026, 1, 1), images: const [],
    seller: const SellerInfo(id: 'u1', fullName: 'Test User'),
  );

  setUp(() {
    mockRepo = MockMarketplaceRepository();
    container = ProviderContainer(
      overrides: [marketplaceRepositoryProvider.overrideWithValue(mockRepo)],
    );
  });

  tearDown(() => container.dispose());

  group('ListingsNotifier', () {
    test('loads listings successfully', () async {
      when(mockRepo.browseListings(filters: anyNamed('filters'), page: anyNamed('page'), limit: anyNamed('limit')))
          .thenAnswer((_) async => PaginatedListings(
            listings: [testListing], page: 1, limit: 20, total: 1, totalPages: 1,
          ));

      final result = await container.read(listingsProvider.future);
      expect(result.listings.length, 1);
      expect(result.listings[0].title, 'Chair');
    });

    test('loadMore appends pages', () async {
      final listing2 = testListing.copyWith(id: 'l2', title: 'Desk');
      when(mockRepo.browseListings(filters: anyNamed('filters'), page: 1, limit: 20))
          .thenAnswer((_) async => PaginatedListings(
            listings: [testListing], page: 1, limit: 20, total: 2, totalPages: 2,
          ));
      when(mockRepo.browseListings(filters: anyNamed('filters'), page: 2, limit: 20))
          .thenAnswer((_) async => PaginatedListings(
            listings: [listing2], page: 2, limit: 20, total: 2, totalPages: 2,
          ));

      await container.read(listingsProvider.future);
      await container.read(listingsProvider.notifier).loadMore();

      final result = container.read(listingsProvider).valueOrNull;
      expect(result?.listings.length, 2);
      expect(result?.listings[1].title, 'Desk');
    });

    test('API failure propagates error', () async {
      when(mockRepo.browseListings(filters: anyNamed('filters'), page: anyNamed('page'), limit: anyNamed('limit')))
          .thenThrow(Exception('server error'));

      final future = container.read(listingsProvider.future);
      expect(future, throwsException);
    });
  });

  group('ListingDetailProvider', () {
    test('loads listing by ID', () async {
      when(mockRepo.getListing('l1')).thenAnswer((_) async => testListing);

      final result = await container.read(listingDetailProvider('l1').future);
      expect(result.id, 'l1');
      expect(result.title, 'Chair');
    });

    test('not found throws', () async {
      when(mockRepo.getListing('missing')).thenThrow(Exception('not found'));

      final future = container.read(listingDetailProvider('missing').future);
      expect(future, throwsException);
    });
  });

  group('MyListingsNotifier', () {
    test('loads user listings', () async {
      when(mockRepo.getMyListings()).thenAnswer((_) async => [testListing]);

      final result = await container.read(myListingsProvider.future);
      expect(result.length, 1);
    });

    test('empty state returns empty list', () async {
      when(mockRepo.getMyListings()).thenAnswer((_) async => []);

      final result = await container.read(myListingsProvider.future);
      expect(result, isEmpty);
    });
  });

  group('MarketplaceFilters', () {
    test('copyWith preserves values', () {
      const filters = MarketplaceFilters(search: 'chair', category: 'furniture_decor');
      final updated = filters.copyWith(condition: 'good');

      expect(updated.search, 'chair');
      expect(updated.category, 'furniture_decor');
      expect(updated.condition, 'good');
    });

    test('copyWith clearCategory works', () {
      const filters = MarketplaceFilters(category: 'furniture_decor');
      final updated = filters.copyWith(clearCategory: true);

      expect(updated.category, isNull);
    });
  });
}

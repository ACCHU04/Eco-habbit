import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/marketplace/screens/marketplace_browse_screen.dart';
import 'package:mobile_app/features/marketplace/providers/marketplace_provider.dart';
import 'package:mobile_app/features/marketplace/models/listing.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';

import '../../helpers/test_wrappers.dart';

void main() {
  group('MarketplaceBrowseScreen', () {
    final testListings = PaginatedListings(
      listings: [
        Listing(
          id: 'l1',
          title: 'Calculus Textbook',
          description: 'Great condition',
          price: 250,
          category: 'textbooks_stationery',
          condition: 'good',
          status: 'active',
          createdAt: DateTime(2026, 1, 1),
          images: [],
          seller: const SellerInfo(id: 's1', fullName: 'Seller', college: 'Test'),
        ),
        Listing(
          id: 'l2',
          title: 'Desk Lamp',
          description: 'Works perfectly',
          price: 400,
          category: 'furniture_decor',
          condition: 'like_new',
          status: 'active',
          createdAt: DateTime(2026, 1, 1),
          images: [],
          seller: const SellerInfo(id: 's2', fullName: 'Seller2', college: 'Test'),
        ),
      ],
      page: 1,
      limit: 20,
      total: 2,
      totalPages: 1,
    );

    Widget buildMarketplace({
      AsyncValue<PaginatedListings> listingsState =
          const AsyncValue.data(PaginatedListings(
        listings: [],
        page: 1,
        limit: 20,
        total: 0,
        totalPages: 0,
      )),
    }) {
      return buildTestWidget(
        const MarketplaceBrowseScreen(),
        initialLocation: '/marketplace',
        overrides: [
          authOverride(initial: const AsyncValue.data(AuthData(user: testUser))),
          listingsProvider.overrideWith(() => _FakeListingsNotifier(listingsState)),
        ],
        destinationRoutes: {
          '/create-listing': (_, __) => const Scaffold(body: Text('create-listing-page')),
        },
      );
    }

    testWidgets('renders search bar and category filter chips', (tester) async {
      await tester.pumpWidget(buildMarketplace());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Textbooks'), findsOneWidget);
      expect(find.text('Electronics'), findsOneWidget);
      expect(find.text('Furniture'), findsOneWidget);
    });

    testWidgets('shows loading state during initial load', (tester) async {
      await tester.pumpWidget(buildMarketplace(
        listingsState: const AsyncValue.loading(),
      ));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows listing cards when data is loaded', (tester) async {
      await tester.pumpWidget(buildMarketplace(
        listingsState: AsyncValue.data(testListings),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Calculus Textbook'), findsOneWidget);
      expect(find.text('₹250'), findsOneWidget);
      expect(find.text('Desk Lamp'), findsOneWidget);
    });
  });
}

class _FakeListingsNotifier extends AsyncNotifier<PaginatedListings>
    implements ListingsNotifier {
  final AsyncValue<PaginatedListings>? _initial;
  _FakeListingsNotifier(this._initial);

  @override
  Future<PaginatedListings> build() async {
    final initial = _initial;
    if (initial == null || initial.isLoading) {
      await Completer<PaginatedListings>().future;
    }
    return initial!.value!;
  }

  @override
  Future<void> loadMore() async {}
}

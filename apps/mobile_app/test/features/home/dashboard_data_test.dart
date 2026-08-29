import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/home/models/dashboard_data.dart';

void main() {
  group('DashboardData', () {
    test('fromJson parses points and listings', () {
      final json = {
        'points': 500,
        'recent_listings': [
          {
            'id': 'l1',
            'title': 'Chair',
            'price': 200,
            'category': 'furniture',
            'condition': 'good',
            'marketplace_listing_images': [
              {'image_url': 'https://example.com/chair.jpg'},
            ],
          },
        ],
      };
      final data = DashboardData.fromJson(json);
      expect(data.points, 500);
      expect(data.recentListings, hasLength(1));
      expect(data.recentListings[0].title, 'Chair');
      expect(data.recentListings[0].imageUrl, 'https://example.com/chair.jpg');
    });

    test('fromJson defaults to zero points and empty listings when missing', () {
      final data = DashboardData.fromJson({});
      expect(data.points, 0);
      expect(data.recentListings, isEmpty);
    });

    test('fromJson handles null recent_listings', () {
      final data = DashboardData.fromJson({'points': 100, 'recent_listings': null});
      expect(data.points, 100);
      expect(data.recentListings, isEmpty);
    });
  });

  group('ListingSummary', () {
    test('fromJson extracts imageUrl from first image', () {
      final json = {
        'id': 'l1',
        'title': 'Desk',
        'price': 150,
        'category': 'furniture',
        'condition': 'like_new',
        'marketplace_listing_images': [
          {'image_url': 'https://example.com/desk.jpg'},
          {'image_url': 'https://example.com/desk2.jpg'},
        ],
      };
      final summary = ListingSummary.fromJson(json);
      expect(summary.imageUrl, 'https://example.com/desk.jpg');
    });

    test('fromJson returns null imageUrl when images list is empty', () {
      final json = {
        'id': 'l1',
        'title': 'Lamp',
        'price': 50,
        'category': 'lighting',
        'condition': 'good',
        'marketplace_listing_images': [],
      };
      final summary = ListingSummary.fromJson(json);
      expect(summary.imageUrl, isNull);
    });

    test('fromJson returns null imageUrl when images field is missing', () {
      final json = {
        'id': 'l1',
        'title': 'Lamp',
        'price': 50,
        'category': 'lighting',
        'condition': 'good',
      };
      final summary = ListingSummary.fromJson(json);
      expect(summary.imageUrl, isNull);
    });

    test('fromJson defaults fields when values are missing', () {
      final summary = ListingSummary.fromJson({});
      expect(summary.id, '');
      expect(summary.title, '');
      expect(summary.price, 0);
      expect(summary.category, '');
      expect(summary.condition, '');
      expect(summary.imageUrl, isNull);
    });
  });
}

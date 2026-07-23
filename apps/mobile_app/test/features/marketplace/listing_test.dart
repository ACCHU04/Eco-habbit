import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/marketplace/models/listing.dart';

void main() {
  group('Listing', () {
    group('fromJson', () {
      test('parses all fields with images and seller', () {
        final json = {
          'id': 'l1',
          'title': 'Chair',
          'description': 'Comfortable chair',
          'price': 200,
          'category': 'furniture',
          'condition': 'good',
          'status': 'active',
          'created_at': '2026-07-23T10:00:00Z',
          'marketplace_listing_images': [
            {'id': 'img1', 'image_url': 'https://example.com/chair.jpg', 'sort_order': 0},
          ],
          'users': {
            'id': 'u1',
            'full_name': 'Seller Name',
            'profile_photo': 'https://example.com/seller.jpg',
            'college': 'MIT',
          },
        };
        final listing = Listing.fromJson(json);
        expect(listing.id, 'l1');
        expect(listing.title, 'Chair');
        expect(listing.price, 200);
        expect(listing.images, hasLength(1));
        expect(listing.images[0].imageUrl, 'https://example.com/chair.jpg');
        expect(listing.seller.fullName, 'Seller Name');
        expect(listing.seller.college, 'MIT');
      });

      test('defaults to empty seller when users field is missing', () {
        final json = {
          'id': 'l1',
          'title': 'Desk',
          'price': 100,
          'marketplace_listing_images': [],
        };
        final listing = Listing.fromJson(json);
        expect(listing.seller.id, '');
        expect(listing.seller.fullName, '');
      });

      test('defaults to empty images when field is missing', () {
        final json = {'id': 'l1', 'title': 'Desk', 'price': 100};
        final listing = Listing.fromJson(json);
        expect(listing.images, isEmpty);
      });

      test('defaults to active status when missing', () {
        final json = {'id': 'l1', 'title': 'X', 'price': 0};
        final listing = Listing.fromJson(json);
        expect(listing.status, 'active');
      });

      test('handles numeric price as double', () {
        final json = {'id': 'l1', 'title': 'X', 'price': 99.5};
        final listing = Listing.fromJson(json);
        expect(listing.price, 99);
      });
    });

    group('imageUrl getter', () {
      test('returns first image URL when images exist', () {
        final listing = Listing(
          id: '1',
          title: 'T',
          description: 'D',
          price: 0,
          category: 'c',
          condition: 'good',
          status: 'active',
          createdAt: DateTime(2026),
          images: const [
            ListingImage(id: '1', imageUrl: 'https://example.com/a.jpg', sortOrder: 0),
            ListingImage(id: '2', imageUrl: 'https://example.com/b.jpg', sortOrder: 1),
          ],
          seller: const SellerInfo(id: '1', fullName: 'S'),
        );
        expect(listing.imageUrl, 'https://example.com/a.jpg');
      });

      test('returns null when images list is empty', () {
        final listing = Listing(
          id: '1',
          title: 'T',
          description: 'D',
          price: 0,
          category: 'c',
          condition: 'good',
          status: 'active',
          createdAt: DateTime(2026),
          images: const [],
          seller: const SellerInfo(id: '1', fullName: 'S'),
        );
        expect(listing.imageUrl, isNull);
      });
    });

    group('copyWith', () {
      test('overrides provided fields', () {
        final listing = Listing(
          id: '1', title: 'Old', description: 'D', price: 100,
          category: 'c', condition: 'good', status: 'active',
          createdAt: DateTime(2026), images: const [], seller: const SellerInfo(id: '1', fullName: 'S'),
        );
        final updated = listing.copyWith(title: 'New', price: 200);
        expect(updated.title, 'New');
        expect(updated.price, 200);
        expect(updated.id, '1');
      });
    });
  });

  group('ListingImage', () {
    test('fromJson parses all fields', () {
      final json = {'id': 'img1', 'image_url': 'https://example.com/img.jpg', 'sort_order': 2};
      final image = ListingImage.fromJson(json);
      expect(image.id, 'img1');
      expect(image.imageUrl, 'https://example.com/img.jpg');
      expect(image.sortOrder, 2);
    });

    test('fromJson defaults when fields missing', () {
      final image = ListingImage.fromJson({});
      expect(image.id, '');
      expect(image.imageUrl, '');
      expect(image.sortOrder, 0);
    });
  });

  group('SellerInfo', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'u1',
        'full_name': 'Seller',
        'profile_photo': 'https://example.com/photo.jpg',
        'college': 'MIT',
      };
      final seller = SellerInfo.fromJson(json);
      expect(seller.id, 'u1');
      expect(seller.fullName, 'Seller');
      expect(seller.profilePhoto, 'https://example.com/photo.jpg');
      expect(seller.college, 'MIT');
    });

    test('fromJson defaults optional fields to null', () {
      final seller = SellerInfo.fromJson({'id': 'u1', 'full_name': 'S'});
      expect(seller.profilePhoto, isNull);
      expect(seller.college, isNull);
    });
  });

  group('PaginatedListings', () {
    test('hasMore returns true when page < totalPages', () {
      const paginated = PaginatedListings(
        listings: [], page: 1, limit: 20, total: 50, totalPages: 3,
      );
      expect(paginated.hasMore, true);
    });

    test('hasMore returns false on last page', () {
      const paginated = PaginatedListings(
        listings: [], page: 3, limit: 20, total: 50, totalPages: 3,
      );
      expect(paginated.hasMore, false);
    });
  });

  group('CreateListingRequest', () {
    test('toJson includes imageUrls when provided', () {
      const request = CreateListingRequest(
        title: 'Chair',
        description: 'Nice chair',
        price: 200,
        category: 'furniture',
        condition: 'good',
        imageUrls: ['https://example.com/img.jpg'],
      );
      final json = request.toJson();
      expect(json['title'], 'Chair');
      expect(json['image_urls'], ['https://example.com/img.jpg']);
    });

    test('toJson omits imageUrls when null', () {
      const request = CreateListingRequest(
        title: 'Chair',
        description: 'Nice chair',
        price: 200,
        category: 'furniture',
        condition: 'good',
      );
      final json = request.toJson();
      expect(json.containsKey('image_urls'), false);
    });
  });

  group('UpdateListingRequest', () {
    test('toJson includes only non-null fields', () {
      const request = UpdateListingRequest(title: 'New Title', price: 300);
      final json = request.toJson();
      expect(json['title'], 'New Title');
      expect(json['price'], 300);
      expect(json.containsKey('description'), false);
      expect(json.containsKey('category'), false);
    });

    test('toJson returns empty map when all fields null', () {
      const request = UpdateListingRequest();
      final json = request.toJson();
      expect(json, isEmpty);
    });
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/services/api_client.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/marketplace/models/listing.dart';
import 'package:mobile_app/features/marketplace/models/marketplace_filters.dart';

class MarketplaceRepository {
  final ApiClient _api;
  MarketplaceRepository(this._api);

  Future<PaginatedListings> browseListings({
    MarketplaceFilters? filters,
    int page = 1,
    int limit = 20,
  }) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (filters != null) {
      if (filters.search.isNotEmpty) params['search'] = filters.search;
      if (filters.category != null) params['category'] = filters.category;
      if (filters.condition != null) params['condition'] = filters.condition;
    }
    final response = await _api.get('/marketplace/listings', queryParameters: params);
    final data = response.data['data'] as List<dynamic>;
    final pagination = response.data['pagination'] as Map<String, dynamic>;
    return PaginatedListings(
      listings: data.map((l) => Listing.fromJson(l)).toList(),
      page: pagination['page'] as int? ?? page,
      limit: pagination['limit'] as int? ?? limit,
      total: pagination['total'] as int? ?? 0,
      totalPages: pagination['total_pages'] as int? ?? 1,
    );
  }

  Future<Listing> getListing(String id) async {
    final response = await _api.get('/marketplace/listings/$id');
    return Listing.fromJson(response.data['data']);
  }

  Future<Listing> createListing(CreateListingRequest request) async {
    final response = await _api.post('/marketplace/listings', data: request.toJson());
    return Listing.fromJson(response.data['data']);
  }

  Future<Listing> updateListing(String id, UpdateListingRequest request) async {
    final response = await _api.put('/marketplace/listings/$id', data: request.toJson());
    return Listing.fromJson(response.data['data']);
  }

  Future<void> deleteListing(String id) async {
    await _api.delete('/marketplace/listings/$id');
  }

  Future<List<Listing>> getMyListings() async {
    final response = await _api.get('/marketplace/my-listings');
    final data = response.data['data'] as List<dynamic>;
    return data.map((l) => Listing.fromJson(l)).toList();
  }
}

final marketplaceRepositoryProvider = Provider((ref) {
  return MarketplaceRepository(ref.read(apiClientProvider));
});

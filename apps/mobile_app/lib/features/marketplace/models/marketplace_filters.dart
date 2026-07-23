class MarketplaceFilters {
  final String search;
  final String? category;
  final String? condition;

  const MarketplaceFilters({this.search = '', this.category, this.condition});

  MarketplaceFilters copyWith({String? search, String? category, String? condition, bool clearCategory = false, bool clearCondition = false}) {
    return MarketplaceFilters(
      search: search ?? this.search,
      category: clearCategory ? null : (category ?? this.category),
      condition: clearCondition ? null : (condition ?? this.condition),
    );
  }
}

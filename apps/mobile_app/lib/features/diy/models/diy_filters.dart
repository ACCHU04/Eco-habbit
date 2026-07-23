class DiyFilters {
  final String search;
  final String? category;
  final String? difficulty;

  const DiyFilters({this.search = '', this.category, this.difficulty});

  DiyFilters copyWith({String? search, String? category, String? difficulty, bool clearCategory = false, bool clearDifficulty = false}) {
    return DiyFilters(
      search: search ?? this.search,
      category: clearCategory ? null : (category ?? this.category),
      difficulty: clearDifficulty ? null : (difficulty ?? this.difficulty),
    );
  }
}

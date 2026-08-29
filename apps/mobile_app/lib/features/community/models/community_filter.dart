class CommunityFilter {
  final String? postType;

  const CommunityFilter({this.postType});

  CommunityFilter copyWith({String? postType, bool clearType = false}) {
    return CommunityFilter(
      postType: clearType ? null : (postType ?? this.postType),
    );
  }
}

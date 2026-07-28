class Campus {
  final String id;
  final String slug;
  final String name;
  final String? shortName;
  final String? domain;
  final String? logoUrl;
  final String? city;
  final String? state;
  final String country;
  final bool isActive;
  final Map<String, dynamic> settings;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Campus({
    required this.id,
    required this.slug,
    required this.name,
    this.shortName,
    this.domain,
    this.logoUrl,
    this.city,
    this.state,
    this.country = 'IN',
    this.isActive = true,
    this.settings = const {},
    this.createdAt,
    this.updatedAt,
  });

  bool get leaderboardEnabled => settings['leaderboard_enabled'] as bool? ?? true;
  bool get marketplaceEnabled => settings['marketplace_enabled'] as bool? ?? true;
  bool get aiEnabled => settings['ai_enabled'] as bool? ?? true;
  String get themeColor => settings['theme_color'] as String? ?? '#10B981';

  String get displayName {
    if (shortName != null && shortName!.isNotEmpty) return shortName!;
    return name;
  }

  String get location {
    if (city != null && state != null) return '$city, $state';
    if (city != null) return city!;
    return '';
  }

  factory Campus.fromJson(Map<String, dynamic> json) {
    return Campus(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      shortName: json['short_name'] as String?,
      domain: json['domain'] as String?,
      logoUrl: json['logo_url'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String? ?? 'IN',
      isActive: json['is_active'] as bool? ?? true,
      settings: (json['settings'] as Map<String, dynamic>?) ?? const {},
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'short_name': shortName,
      'domain': domain,
      'logo_url': logoUrl,
      'city': city,
      'state': state,
      'country': country,
      'is_active': isActive,
      'settings': settings,
    };
  }

  Campus copyWith({
    String? id,
    String? slug,
    String? name,
    String? shortName,
    String? domain,
    String? logoUrl,
    String? city,
    String? state,
    String? country,
    bool? isActive,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Campus(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      domain: domain ?? this.domain,
      logoUrl: logoUrl ?? this.logoUrl,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      isActive: isActive ?? this.isActive,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Campus && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

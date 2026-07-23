class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? college;
  final String? role;
  final String? profilePhoto;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.college,
    this.role,
    this.profilePhoto,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String? ?? '',
      college: json['college'] as String?,
      role: json['role'] as String?,
      profilePhoto: json['profile_photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'full_name': fullName,
    'college': college,
    'role': role,
    'profile_photo': profilePhoto,
  };

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? college,
    String? role,
    String? profilePhoto,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      college: college ?? this.college,
      role: role ?? this.role,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }
}

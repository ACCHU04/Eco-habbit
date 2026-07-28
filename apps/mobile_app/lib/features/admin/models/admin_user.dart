class AdminUser {
  final String id;
  final String email;
  final String fullName;
  final String? college;
  final String role;
  final String status;
  final String? profilePhoto;
  final String? hostel;
  final String? department;
  final DateTime createdAt;

  AdminUser({
    required this.id,
    required this.email,
    required this.fullName,
    this.college,
    required this.role,
    required this.status,
    this.profilePhoto,
    this.hostel,
    this.department,
    required this.createdAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      fullName: json['full_name'] as String? ?? 'Unknown',
      college: json['college'] as String?,
      role: json['role'] as String? ?? 'student',
      status: json['status'] as String? ?? 'active',
      profilePhoto: json['profile_photo'] as String?,
      hostel: json['hostel'] as String?,
      department: json['department'] as String?,
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  bool get isActive => status == 'active';
  bool get isAdmin => role == 'admin' || role == 'super_admin';
}

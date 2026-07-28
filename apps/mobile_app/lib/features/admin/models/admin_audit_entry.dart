class AdminAuditEntry {
  final String id;
  final String adminId;
  final String? adminName;
  final String? adminEmail;
  final String action;
  final String resourceType;
  final String resourceId;
  final String? reason;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  AdminAuditEntry({
    required this.id,
    required this.adminId,
    this.adminName,
    this.adminEmail,
    required this.action,
    required this.resourceType,
    required this.resourceId,
    this.reason,
    this.metadata,
    required this.createdAt,
  });

  factory AdminAuditEntry.fromJson(Map<String, dynamic> json) {
    final admin = json['admin'] as Map<String, dynamic>?;
    return AdminAuditEntry(
      id: json['id'] as String,
      adminId: json['admin_id'] as String,
      adminName: admin?['full_name'] as String?,
      adminEmail: admin?['email'] as String?,
      action: json['action'] as String,
      resourceType: json['resource_type'] as String,
      resourceId: json['resource_id'] as String,
      reason: json['reason'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  String get actionLabel {
    final parts = action.split('_');
    return parts.map((p) => p[0].toUpperCase() + p.substring(1)).join(' ');
  }
}

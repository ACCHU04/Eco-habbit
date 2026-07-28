class AdminReport {
  final String id;
  final String contentType;
  final String contentId;
  final String reason;
  final String? description;
  final String status;
  final String reporterId;
  final String? reporterName;
  final String? reporterPhoto;
  final String? adminId;
  final String? actionTaken;
  final DateTime createdAt;

  AdminReport({
    required this.id,
    required this.contentType,
    required this.contentId,
    required this.reason,
    this.description,
    required this.status,
    required this.reporterId,
    this.reporterName,
    this.reporterPhoto,
    this.adminId,
    this.actionTaken,
    required this.createdAt,
  });

  factory AdminReport.fromJson(Map<String, dynamic> json) {
    final reporter = json['reporter'] as Map<String, dynamic>?;
    return AdminReport(
      id: json['id'] as String,
      contentType: json['content_type'] as String,
      contentId: json['content_id'] as String,
      reason: json['reason'] as String? ?? 'other',
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'pending',
      reporterId: json['reporter_id'] as String,
      reporterName: reporter?['full_name'] as String?,
      reporterPhoto: reporter?['profile_photo'] as String?,
      adminId: json['admin_id'] as String?,
      actionTaken: json['action_taken'] as String?,
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  bool get isPending => status == 'pending';
}

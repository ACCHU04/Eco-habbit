class CoinTransaction {
  final String id;
  final String userId;
  final int points;
  final int coinValue;
  final String action;
  final DateTime createdAt;

  const CoinTransaction({
    required this.id,
    required this.userId,
    required this.points,
    required this.coinValue,
    required this.action,
    required this.createdAt,
  });

  factory CoinTransaction.fromJson(Map<String, dynamic> json) {
    return CoinTransaction(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      points: json['points'] as int? ?? 0,
      coinValue: json['coin_value'] as int? ?? 0,
      action: json['action'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

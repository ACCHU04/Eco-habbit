class CoinBalance {
  final String userId;
  final int totalCoins;

  const CoinBalance({
    required this.userId,
    required this.totalCoins,
  });

  factory CoinBalance.fromJson(Map<String, dynamic> json) {
    return CoinBalance(
      userId: json['user_id'] as String? ?? '',
      totalCoins: json['total_coins'] as int? ?? 0,
    );
  }
}

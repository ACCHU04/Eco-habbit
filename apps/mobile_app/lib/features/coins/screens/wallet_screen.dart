import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/features/coins/providers/coins_provider.dart';
import 'package:mobile_app/features/coins/models/coin_transaction.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final balanceAsync = ref.watch(coinBalanceProvider);
    final historyAsync = ref.watch(coinHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(coinBalanceProvider.notifier).reload();
          ref.read(coinHistoryProvider.notifier).reload();
        },
        child: ListView(
          padding: const EdgeInsets.all(EcoTokens.spacing4),
          children: [
            balanceAsync.when(
              loading: () => const Card(
                child: SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (_, __) => Card(
                child: SizedBox(
                  height: 120,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Could not load balance', style: TextStyle(color: Colors.grey)),
                        TextButton(
                          onPressed: () => ref.read(coinBalanceProvider.notifier).reload(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              data: (balance) => Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(EcoTokens.spacing6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.coinGold,
                        AppColors.coinGoldDark,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(EcoTokens.radiusMd),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.monetization_on, size: 48, color: Colors.white),
                      const SizedBox(height: EcoTokens.spacing2),
                      Text(
                        '${balance.totalCoins}',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Green Coins',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: EcoTokens.spacing5),
            Text(
              'Transaction History',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: EcoTokens.spacing3),
            historyAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(
                child: Text('Could not load history', style: TextStyle(color: Colors.grey)),
              ),
              data: (transactions) {
                if (transactions.isEmpty) {
                  return const SizedBox(
                    height: 100,
                    child: Center(
                      child: Text('No transactions yet', style: TextStyle(color: Colors.grey)),
                    ),
                  );
                }
                return Column(
                  children: transactions.map((t) => _TransactionTile(transaction: t)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final CoinTransaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = transaction.coinValue > 0;

    String actionLabel;
    IconData actionIcon;
    switch (transaction.action) {
      case final a when a.startsWith('quest_complete:'):
        actionLabel = 'Quest Complete';
        actionIcon = Icons.task_alt;
      case 'scan_item':
        actionLabel = 'Item Scanned';
        actionIcon = Icons.camera_alt;
      case 'list_item':
        actionLabel = 'Item Listed';
        actionIcon = Icons.add_box;
      case 'complete_sale':
        actionLabel = 'Sale Completed';
        actionIcon = Icons.storefront;
      default:
        actionLabel = transaction.action;
        actionIcon = Icons.monetization_on;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: EcoTokens.spacing2),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPositive
              ? AppColors.success.withValues(alpha: 0.1)
              : AppColors.error.withValues(alpha: 0.1),
          child: Icon(actionIcon, size: 20, color: isPositive ? AppColors.success : AppColors.error),
        ),
        title: Text(actionLabel, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
          '${transaction.createdAt.day}/${transaction.createdAt.month}/${transaction.createdAt.year}',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
        ),
        trailing: Text(
          '${isPositive ? '+' : ''}${transaction.coinValue}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isPositive ? AppColors.success : AppColors.error,
          ),
        ),
      ),
    );
  }
}

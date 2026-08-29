import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/features/passport/models/passport_data.dart';
import 'package:share_plus/share_plus.dart';

class ShareCard {
  static void show(BuildContext context, ImpactData impact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ShareCardContent(impact: impact),
    );
  }
}

class _ShareCardContent extends StatelessWidget {
  final ImpactData impact;
  const _ShareCardContent({required this.impact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(EcoTokens.spacing4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundary(
            key: GlobalKey(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(EcoTokens.spacing6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                ),
                borderRadius: BorderRadius.circular(EcoTokens.radiusLg),
              ),
              child: Column(
                children: [
                  const Text(
                    'My Eco Impact',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: EcoTokens.spacing4),
                  Text(
                    '${impact.co2.displayValue} kg CO₂ Saved',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${impact.waste.displayValue} kg Waste Diverted',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: EcoTokens.spacing3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ShareStat(value: '${impact.level}', label: 'Level'),
                      const SizedBox(width: EcoTokens.spacing6),
                      _ShareStat(value: '${impact.totalXp}', label: 'XP'),
                    ],
                  ),
                  const SizedBox(height: EcoTokens.spacing4),
                  Text(
                    'Powered by EcoHabit 🌱',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: EcoTokens.spacing4),
          Text(
            'Share your impact!',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: EcoTokens.spacing2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ShareOption(
                icon: Icons.copy,
                label: 'Copy',
                onTap: () async {
                  final text = _buildShareText(impact);
                  await Clipboard.setData(ClipboardData(text: text));
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Impact summary copied!')),
                    );
                  }
                },
              ),
              _ShareOption(
                icon: Icons.share,
                label: 'Share',
                onTap: () async {
                  final text = _buildShareText(impact);
                  Navigator.pop(context);
                  await Share.share(text);
                },
              ),
            ],
          ),
          const SizedBox(height: EcoTokens.spacing4),
        ],
      ),
    );
  }
}

class _ShareStat extends StatelessWidget {
  final String value;
  final String label;
  const _ShareStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ShareOption({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(EcoTokens.radiusMd),
      child: Padding(
        padding: const EdgeInsets.all(EcoTokens.spacing3),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppColors.primary),
            const SizedBox(height: EcoTokens.spacing1),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}

String _buildShareText(ImpactData impact) {
  return 'My Eco Impact 🌱\n'
      '${impact.co2.displayValue} kg CO₂ saved\n'
      '${impact.waste.displayValue} kg waste diverted\n'
      '${impact.water.displayValue} L water saved\n'
      '${impact.energy.displayValue} kWh energy saved\n\n'
      'Level ${impact.level} · ${impact.totalXp} XP\n\n'
      'Powered by EcoHabit';
}

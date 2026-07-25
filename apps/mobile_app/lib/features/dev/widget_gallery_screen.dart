import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/core/widgets/eco_animated_counter.dart';
import 'package:mobile_app/core/widgets/eco_avatar.dart';
import 'package:mobile_app/core/widgets/eco_badge.dart';
import 'package:mobile_app/core/widgets/eco_button.dart';
import 'package:mobile_app/core/widgets/eco_card.dart';
import 'package:mobile_app/core/widgets/eco_chip.dart';
import 'package:mobile_app/core/widgets/eco_coin_display.dart';
import 'package:mobile_app/core/widgets/eco_empty_state.dart';
import 'package:mobile_app/core/widgets/eco_filter_row.dart';
import 'package:mobile_app/core/widgets/eco_gradient_banner.dart';
import 'package:mobile_app/core/widgets/eco_hero_image.dart';
import 'package:mobile_app/core/widgets/eco_impact_card.dart';
import 'package:mobile_app/core/widgets/eco_level_badge.dart';
import 'package:mobile_app/core/widgets/eco_listing_card.dart';
import 'package:mobile_app/core/widgets/eco_menu_item.dart';
import 'package:mobile_app/core/widgets/eco_notification_tile.dart';
import 'package:mobile_app/core/widgets/eco_post_card.dart';
import 'package:mobile_app/features/community/models/post.dart' show PostType;
import 'package:mobile_app/core/widgets/eco_progress_bar.dart';
import 'package:mobile_app/core/widgets/eco_project_card.dart';
import 'package:mobile_app/core/widgets/eco_quest_card.dart';
import 'package:mobile_app/core/widgets/eco_search_bar.dart';
import 'package:mobile_app/core/widgets/eco_section_header.dart';
import 'package:mobile_app/core/widgets/eco_skeleton.dart';
import 'package:mobile_app/core/widgets/eco_snackbar.dart';
import 'package:mobile_app/core/widgets/eco_stat_card.dart';
import 'package:mobile_app/core/widgets/eco_stat_item.dart';
import 'package:mobile_app/core/widgets/eco_streak_display.dart';
import 'package:mobile_app/core/widgets/eco_text_field.dart';

/// Debug-only Widget Gallery showcasing all 32+ design system widgets.
///
/// Access via `/dev/gallery` route in debug mode.
class WidgetGalleryScreen extends StatefulWidget {
  const WidgetGalleryScreen({super.key});

  @override
  State<WidgetGalleryScreen> createState() => _WidgetGalleryScreenState();
}

class _WidgetGalleryScreenState extends State<WidgetGalleryScreen> {
  int _selectedFilter = 0;
  bool _skeletonEnabled = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Widget Gallery'),
          actions: [
            IconButton(
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: () {
                // Theme toggle handled by parent
              },
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Primitives'),
              Tab(text: 'Layout'),
              Tab(text: 'Domain'),
              Tab(text: 'Golden Screens'),
              Tab(text: 'Skeleton'),
              Tab(text: 'Typography'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPrimitivesTab(),
            _buildLayoutTab(),
            _buildDomainTab(),
            _buildGoldenScreensTab(),
            _buildSkeletonTab(),
            _buildTypographyTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(EcoTokens.spacing4),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        ...children,
        const SizedBox(height: EcoTokens.spacing6),
      ],
    );
  }

  Widget _buildPrimitivesTab() {
    final cs = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(EcoTokens.spacing4),
      children: [
        _buildSection('Buttons', [
          Wrap(
            spacing: EcoTokens.spacing2,
            runSpacing: EcoTokens.spacing2,
            children: [
              EcoButton(label: 'Filled', variant: EcoButtonVariant.filled, onPressed: () {}),
              EcoButton(label: 'Outlined', variant: EcoButtonVariant.outlined, onPressed: () {}),
              EcoButton(label: 'Text', variant: EcoButtonVariant.text, onPressed: () {}),
              EcoButton(label: 'Tonal', variant: EcoButtonVariant.tonal, onPressed: () {}),
              const EcoButton(label: 'Loading', loading: true),
              EcoButton(label: 'Small', size: EcoButtonSize.sm, onPressed: () {}),
              EcoButton(label: 'Large', size: EcoButtonSize.lg, onPressed: () {}),
              EcoButton(label: 'Full Width', fullWidth: true, onPressed: () {}),
              EcoButton(label: 'With Icon', icon: Icons.add, onPressed: () {}),
            ],
          ),
        ]),
        _buildSection('Cards', [
          EcoCard(
            child: Text('Basic Card', style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(height: EcoTokens.spacing2),
          EcoCard(
            onTap: () {},
            borderColor: cs.primary,
            child: const Text('Tappable Card with Border'),
          ),
        ]),
        _buildSection('Chips', [
          Wrap(
            spacing: EcoTokens.spacing2,
            children: [
              const EcoChip(label: 'Textbooks'),
              const EcoChip(label: 'Electronics', icon: Icons.devices),
              EcoChip(label: 'Furniture', onDeleted: () {}),
              EcoChip(label: 'Active', selected: true, onSelected: (_) {}),
            ],
          ),
        ]),
        _buildSection('Badge', [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              EcoBadge(
                count: 3,
                child: Icon(Icons.notifications, size: 28),
              ),
              EcoBadge(
                child: Icon(Icons.mail, size: 28),
              ),
              EcoBadge(
                count: 150,
                child: Icon(Icons.shopping_cart, size: 28),
              ),
            ],
          ),
        ]),
        _buildSection('Avatar', [
          const Wrap(
            spacing: EcoTokens.spacing4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              EcoAvatar(name: 'CU', size: EcoAvatarSize.xs),
              EcoAvatar(name: 'CU', size: EcoAvatarSize.sm),
              EcoAvatar(name: 'CU', size: EcoAvatarSize.md),
              EcoAvatar(name: 'CU', size: EcoAvatarSize.lg),
              EcoAvatar(name: 'CU', size: EcoAvatarSize.xl),
              EcoAvatar(
                name: 'CU',
                size: EcoAvatarSize.lg,
                showStatusRing: true,
                statusColor: EcoColors.success,
              ),
            ],
          ),
        ]),
        _buildSection('Text Fields', [
          const EcoTextField(
            label: 'Item Name',
            hint: 'e.g. Organic Chemistry',
            prefixIcon: Icons.edit,
          ),
          const SizedBox(height: EcoTokens.spacing2),
          const EcoTextField(
            label: 'Password',
            obscureText: true,
            suffixIcon: Icons.visibility_off,
          ),
        ]),
        _buildSection('Progress Bar', [
          const EcoProgressBar(value: 0.7, label: 'Quest Progress', showPercentage: true),
          const SizedBox(height: EcoTokens.spacing2),
          const EcoProgressBar(
            value: 0.3,
            color: EcoColors.streakFlame,
            backgroundColor: EcoColors.errorContainer,
          ),
        ]),
        _buildSection('Snackbar', [
          EcoButton(
            label: 'Show Success',
            onPressed: () {
              EcoSnackBar.show(context, message: 'Item listed!', type: EcoSnackBarType.success);
            },
          ),
          const SizedBox(height: EcoTokens.spacing2),
          EcoButton(
            label: 'Show Error',
            variant: EcoButtonVariant.outlined,
            onPressed: () {
              EcoSnackBar.show(context, message: 'Failed to upload', type: EcoSnackBarType.error);
            },
          ),
        ]),
      ],
    );
  }

  Widget _buildLayoutTab() {
    return ListView(
      padding: const EdgeInsets.all(EcoTokens.spacing4),
      children: [
        _buildSection('Search Bar', [
          const EcoSearchBar(hint: 'Search items, projects...'),
        ]),
        _buildSection('Section Header', [
          EcoSectionHeader(
            title: "Today's Quest",
            subtitle: 'Complete actions to earn XP',
            actionLabel: 'See All',
            onAction: () {},
          ),
        ]),
        _buildSection('Gradient Banner', [
          EcoGradientBanner(
            title: 'Welcome back, Chandu!',
            subtitle: 'You saved 12kg of CO₂ this week',
            child: EcoButton(
              label: 'Continue Quest',
              variant: EcoButtonVariant.outlined,
              onPressed: () {},
            ),
          ),
        ]),
        _buildSection('Hero Image', [
          const EcoHeroImage(
            height: 180,
            iconFallback: Icons.eco,
          ),
        ]),
        _buildSection('Empty State', [
          EcoEmptyState(
            icon: Icons.inbox_outlined,
            title: 'No listings yet',
            subtitle: 'Start by scanning an item to sell or recycle',
            actionLabel: 'Scan Item',
            onAction: () {},
          ),
        ]),
        _buildSection('Animated Counter', [
          const EcoAnimatedCounter(
            value: 1250,
            prefix: '',
            suffix: ' kg CO₂',
          ),
        ]),
      ],
    );
  }

  Widget _buildDomainTab() {
    return ListView(
      padding: const EdgeInsets.all(EcoTokens.spacing4),
      children: [
        _buildSection('Coin Display', [
          const EcoCoinDisplay(amount: 250),
          const SizedBox(height: EcoTokens.spacing2),
          const EcoCoinDisplay(amount: 1500, label: 'Balance', size: EcoCoinDisplaySize.lg),
        ]),
        _buildSection('Level Badge', [
          const Wrap(
            spacing: EcoTokens.spacing6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              EcoLevelBadge(level: 3, xpProgress: 0.4, size: EcoLevelBadgeSize.sm),
              EcoLevelBadge(level: 7, xpProgress: 0.65, size: EcoLevelBadgeSize.md),
              EcoLevelBadge(level: 12, xpProgress: 0.9, size: EcoLevelBadgeSize.lg),
            ],
          ),
        ]),
        _buildSection('Streak Display', [
          const Wrap(
            spacing: EcoTokens.spacing6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              EcoStreakDisplay(days: 0, size: EcoStreakDisplaySize.sm),
              EcoStreakDisplay(days: 7, size: EcoStreakDisplaySize.md),
              EcoStreakDisplay(days: 30, size: EcoStreakDisplaySize.lg),
            ],
          ),
        ]),
        _buildSection('Stat Card', [
          const EcoStatCard(
            icon: Icons.recycling,
            value: '42',
            label: 'Items Recycled',
            trend: '+12%',
            trendUp: true,
          ),
        ]),
        _buildSection('Impact Card', [
          const EcoImpactCard(
            type: EcoImpactType.co2,
            value: 12.5,
            unit: 'kg',
            comparison: 'Equivalent to 250 km car travel',
          ),
        ]),
        _buildSection('Quest Card', [
          const EcoQuestCard(
            title: 'Campus Cleanup',
            description: 'Pick up 5 pieces of litter around campus buildings',
            xpReward: 150,
            coinReward: 25,
            difficulty: QuestDifficulty.medium,
            progress: 0.6,
          ),
        ]),
        _buildSection('Listing Card', [
          const EcoListingCard(
            title: 'Organic Chemistry Textbook',
            price: '₹350',
            condition: 'Good',
            category: 'Textbooks',
            sellerName: 'Priya K.',
          ),
        ]),
        _buildSection('Post Card', [
          const EcoPostCard(
            authorName: 'Chandu',
            content: 'Built a planter from old tires! Step-by-step guide inside.',
            postType: PostType.diy,
            likes: 24,
            comments: 8,
            timeAgo: '2h ago',
          ),
        ]),
        _buildSection('Project Card', [
          const EcoProjectCard(
            title: 'Tire Planter',
            difficulty: 'Easy',
            timeEstimate: '45 min',
            likes: 89,
          ),
        ]),
        _buildSection('Notification Tile', [
          const EcoNotificationTile(
            icon: Icons.emoji_events,
            title: 'Badge Unlocked!',
            body: 'You earned the Recycling Champion badge',
            timeAgo: '5m ago',
          ),
          const EcoNotificationTile(
            icon: Icons.local_fire_department,
            title: 'Keep your streak alive!',
            body: 'Complete a quest today to maintain your 7-day streak',
            timeAgo: '1h ago',
            read: true,
          ),
        ]),
        _buildSection('Menu Item', [
          EcoMenuItem(
            icon: Icons.settings,
            label: 'Settings',
            onTap: () {},
          ),
          EcoMenuItem(
            icon: Icons.logout,
            label: 'Sign Out',
            destructive: true,
            onTap: () {},
          ),
        ]),
        _buildSection('Filter Row', [
          EcoFilterRow(
            options: const ['All', 'Textbooks', 'Electronics', 'Furniture', 'Clothing'],
            selectedIndex: _selectedFilter,
            onSelected: (i) => setState(() => _selectedFilter = i),
          ),
        ]),
      ],
    );
  }

  Widget _buildGoldenScreensTab() {
    return ListView(
      padding: const EdgeInsets.all(EcoTokens.spacing4),
      children: [
        _buildSection('1. Home Dashboard', [
          _GoldenHomeDashboard(),
        ]),
        _buildSection('2. Marketplace Browse', [
          _GoldenMarketplaceBrowse(),
        ]),
        _buildSection('3. Quest Screen', [
          _GoldenQuestScreen(),
        ]),
        _buildSection('4. Profile', [
          _GoldenProfileScreen(),
        ]),
        _buildSection('5. Community Feed', [
          _GoldenCommunityFeed(),
        ]),
      ],
    );
  }

  Widget _buildSkeletonTab() {
    return ListView(
      padding: const EdgeInsets.all(EcoTokens.spacing4),
      children: [
        _buildSection('Toggle Skeleton', [
          SwitchListTile(
            title: const Text('Enable Skeleton Loading'),
            value: _skeletonEnabled,
            onChanged: (v) => setState(() => _skeletonEnabled = v),
          ),
        ]),
        _buildSection('Skeleton Card', [
          EcoSkeleton(
            enabled: _skeletonEnabled,
            child: EcoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 16, width: 120, color: Colors.grey),
                  const SizedBox(height: 8),
                  Container(height: 14, width: 200, color: Colors.grey),
                  const SizedBox(height: 8),
                  Container(height: 14, width: 160, color: Colors.grey),
                ],
              ),
            ),
          ),
        ]),
        _buildSection('Skeleton Tile List', [
          EcoSkeleton(
            enabled: _skeletonEnabled,
            child: Column(
              children: List.generate(
                4,
                (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(height: 14, width: 150, color: Colors.grey),
                            const SizedBox(height: 6),
                            Container(height: 12, width: 100, color: Colors.grey),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
        _buildSection('Skeleton Card Grid', [
          EcoSkeleton(
            enabled: _skeletonEnabled,
            child: Wrap(
              spacing: EcoTokens.spacing2,
              runSpacing: EcoTokens.spacing2,
              children: List.generate(
                4,
                (_) => Container(
                  width: (MediaQuery.of(context).size.width - EcoTokens.spacing4 * 2 - EcoTokens.spacing2) / 2,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(EcoTokens.radiusMd),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ],
    );
  }

  Widget _buildTypographyTab() {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(EcoTokens.spacing4),
      children: [
        Text('Display Large', style: textTheme.displayLarge),
        const SizedBox(height: 4),
        Text('Display Medium', style: textTheme.displayMedium),
        const SizedBox(height: 4),
        Text('Display Small', style: textTheme.displaySmall),
        const Divider(height: 32),
        Text('Headline Large', style: textTheme.headlineLarge),
        const SizedBox(height: 4),
        Text('Headline Medium', style: textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text('Headline Small', style: textTheme.headlineSmall),
        const Divider(height: 32),
        Text('Title Large', style: textTheme.titleLarge),
        const SizedBox(height: 4),
        Text('Title Medium', style: textTheme.titleMedium),
        const SizedBox(height: 4),
        Text('Title Small', style: textTheme.titleSmall),
        const Divider(height: 32),
        Text('Body Large — The quick brown fox jumps over the lazy dog', style: textTheme.bodyLarge),
        const SizedBox(height: 4),
        Text('Body Medium — The quick brown fox jumps over the lazy dog', style: textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text('Body Small — The quick brown fox jumps over the lazy dog', style: textTheme.bodySmall),
        const Divider(height: 32),
        Text('Label Large', style: textTheme.labelLarge),
        const SizedBox(height: 4),
        Text('Label Medium', style: textTheme.labelMedium),
        const SizedBox(height: 4),
        Text('Label Small', style: textTheme.labelSmall),
      ],
    );
  }
}

// ── Golden Screen: Home Dashboard ──

class _GoldenHomeDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const EcoCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EcoGradientBanner(
            title: 'Good morning, Chandu!',
            subtitle: 'Complete today\'s quest to earn XP',
            gradientColors: [EcoColors.primary, EcoColors.primaryDark],
          ),
          Padding(
            padding: EdgeInsets.all(EcoTokens.spacing3),
            child: EcoSearchBar(hint: 'Search items, projects...'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: EcoTokens.spacing3),
            child: EcoQuestCard(
              title: 'Campus Cleanup',
              description: 'Pick up 5 pieces of litter',
              xpReward: 150,
              coinReward: 25,
              difficulty: QuestDifficulty.easy,
              progress: 0.4,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(EcoTokens.spacing3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                EcoStatItem(
                  icon: Icons.recycling,
                  value: '42',
                  label: 'Recycled',
                ),
                EcoStatItem(
                  icon: Icons.monetization_on,
                  value: '1,250',
                  label: 'Coins',
                ),
                EcoStatItem(
                  icon: Icons.local_fire_department,
                  value: '7',
                  label: 'Streak',
                  iconColor: EcoColors.streakFlame,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Golden Screen: Marketplace Browse ──

class _GoldenMarketplaceBrowse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EcoCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(EcoTokens.spacing3),
            child: EcoSearchBar(hint: 'Search marketplace...'),
          ),
          EcoFilterRow(
            options: const ['All', 'Textbooks', 'Electronics', 'Furniture', 'Clothing'],
            selectedIndex: 0,
            onSelected: (_) {},
          ),
          const SizedBox(height: EcoTokens.spacing3),
          const EcoSectionHeader(title: 'Featured', actionLabel: 'See All'),
          const EcoListingCard(
            title: 'Organic Chemistry Textbook',
            price: '₹350',
            condition: 'Good',
            category: 'Textbooks',
            sellerName: 'Priya K.',
          ),
        ],
      ),
    );
  }
}

// ── Golden Screen: Quest Screen ──

class _GoldenQuestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const EcoCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EcoGradientBanner(
            title: 'Daily Quest',
            subtitle: 'Level 7 • 2,450 XP to next level',
            gradientColors: [EcoColors.xpPurple, EcoColors.xpPurpleDark],
          ),
          Padding(
            padding: EdgeInsets.all(EcoTokens.spacing3),
            child: EcoQuestCard(
              title: 'List One Item for Sale',
              description: 'Post a listing in the marketplace',
              xpReward: 50,
              coinReward: 10,
              difficulty: QuestDifficulty.easy,
              completed: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: EcoTokens.spacing3),
            child: EcoQuestCard(
              title: 'Campus Cleanup',
              description: 'Pick up 5 pieces of litter around campus',
              xpReward: 150,
              coinReward: 25,
              difficulty: QuestDifficulty.medium,
              progress: 0.6,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(EcoTokens.spacing3),
            child: EcoQuestCard(
              title: 'Upcycle Challenge',
              description: 'Turn a waste item into something useful',
              xpReward: 200,
              coinReward: 40,
              difficulty: QuestDifficulty.hard,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Golden Screen: Profile ──

class _GoldenProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EcoCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          const SizedBox(height: EcoTokens.spacing4),
          const EcoAvatar(name: 'Chandu', size: EcoAvatarSize.xl),
          const SizedBox(height: EcoTokens.spacing2),
          Text('Chandu', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: EcoTokens.spacing2),
          const Wrap(
            spacing: EcoTokens.spacing4,
            children: [
              EcoLevelBadge(level: 7, xpProgress: 0.65),
              EcoStreakDisplay(days: 14),
              EcoCoinDisplay(amount: 1250),
            ],
          ),
          const SizedBox(height: EcoTokens.spacing4),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: EcoTokens.spacing3),
            child: EcoProgressBar(value: 0.65, label: 'Level 7 Progress', showPercentage: true),
          ),
          const SizedBox(height: EcoTokens.spacing4),
        ],
      ),
    );
  }
}

// ── Golden Screen: Community Feed ──

class _GoldenCommunityFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const EcoCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          EcoSectionHeader(title: 'Community', subtitle: 'See what others are up to'),
          EcoPostCard(
            authorName: 'Ananya R.',
            content: 'Found an amazing DIY project for old glass bottles!',
            postType: PostType.diy,
            likes: 45,
            comments: 12,
            timeAgo: '1h ago',
          ),
          SizedBox(height: EcoTokens.spacing2),
          EcoPostCard(
            authorName: 'Rahul M.',
            content: 'Selling my laptop stand — barely used, great condition.',
            postType: PostType.marketplace,
            likes: 8,
            comments: 3,
            timeAgo: '3h ago',
          ),
        ],
      ),
    );
  }
}

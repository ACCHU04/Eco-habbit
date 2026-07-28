import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/core/widgets/eco_empty_state.dart';
import 'package:mobile_app/core/widgets/eco_error_view.dart';
import 'package:mobile_app/core/widgets/eco_skeleton.dart';
import 'package:mobile_app/features/engagement/providers/engagement_providers.dart';
import 'package:mobile_app/features/engagement/widgets/leaderboard_widgets.dart';
import 'package:mobile_app/features/engagement/widgets/hostel_widgets.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'campus';
  String _selectedPeriod = 'allTime';

  static const _filterLabels = ['Campus', 'Hostel', 'Department'];
  static const _filterValues = ['campus', 'hostel', 'department'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    setState(() {});
    ref.invalidate(filteredLeaderboardProvider);
    ref.invalidate(hostelLeaderboardProvider);
    ref.invalidate(friendLeaderboardProvider);
    ref.invalidate(periodLeaderboardProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboards'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overall'),
            Tab(text: 'Hostels'),
            Tab(text: 'Friends'),
            Tab(text: 'Period'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverallTab(),
          _buildHostelTab(),
          _buildFriendsTab(),
          _buildPeriodTab(),
        ],
      ),
    );
  }

  Widget _buildOverallTab() {
    final leaderboardAsync = ref.watch(filteredLeaderboardProvider);

    return Column(
      children: [
        const SizedBox(height: EcoTokens.spacing3),
        FilterChipRow(
          labels: _filterLabels,
          values: _filterValues,
          selected: _selectedFilter,
          onSelected: (value) {
            setState(() => _selectedFilter = value);
            ref.read(filteredLeaderboardProvider.notifier).setFilter(value);
          },
        ),
        const SizedBox(height: EcoTokens.spacing2),
        Expanded(
          child: leaderboardAsync.when(
            loading: () => const _LeaderboardSkeleton(),
            error: (e, _) => EcoErrorView(
              message: 'Failed to load leaderboard',
              onRetry: () => ref.invalidate(filteredLeaderboardProvider),
            ),
            data: (entries) {
              if (entries.isEmpty) {
                return const EcoEmptyState(
                  icon: Icons.leaderboard_outlined,
                  title: 'No leaderboard data yet',
                  subtitle: 'Start earning points to climb the ranks!',
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(EcoTokens.spacing4),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return LeaderboardTile(
                    rank: entry.rank,
                    name: entry.fullName,
                    profilePhoto: entry.profilePhoto,
                    score: entry.totalPoints,
                    scoreLabel: 'pts',
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHostelTab() {
    final hostelAsync = ref.watch(hostelLeaderboardProvider);

    return hostelAsync.when(
      loading: () => const _LeaderboardSkeleton(),
      error: (e, _) => EcoErrorView(
        message: 'Failed to load hostel leaderboard',
        onRetry: () => ref.invalidate(hostelLeaderboardProvider),
      ),
      data: (hostels) {
        if (hostels.isEmpty) {
          return const EcoEmptyState(
            icon: Icons.apartment_outlined,
            title: 'No hostels yet',
            subtitle: 'Join a hostel to compete with others!',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(EcoTokens.spacing4),
          itemCount: hostels.length,
          itemBuilder: (context, index) {
            final h = hostels[index];
            return HostelCard(
              name: h.hostelName,
              totalScore: h.totalScore,
              memberCount: h.memberCount,
              rank: h.rank,
            );
          },
        );
      },
    );
  }

  Widget _buildFriendsTab() {
    final friendsAsync = ref.watch(friendLeaderboardProvider);

    return friendsAsync.when(
      loading: () => const _LeaderboardSkeleton(),
      error: (e, _) => EcoErrorView(
        message: 'Failed to load friends leaderboard',
        onRetry: () => ref.invalidate(friendLeaderboardProvider),
      ),
      data: (entries) {
        if (entries.isEmpty) {
          return const EcoEmptyState(
            icon: Icons.people_outline,
            title: 'No friends yet',
            subtitle: 'Add friends to compare your eco progress!',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(EcoTokens.spacing4),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return LeaderboardTile(
              rank: entry.rank,
              name: entry.fullName,
              profilePhoto: entry.profilePhoto,
              score: entry.totalPoints,
              scoreLabel: 'pts',
            );
          },
        );
      },
    );
  }

  Widget _buildPeriodTab() {
    final periodAsync = ref.watch(periodLeaderboardProvider);

    return Column(
      children: [
        const SizedBox(height: EcoTokens.spacing3),
        PeriodChipRow(
          selected: _selectedPeriod,
          onSelected: (value) {
            setState(() => _selectedPeriod = value);
            ref.read(periodLeaderboardProvider.notifier).setPeriod(value);
          },
        ),
        const SizedBox(height: EcoTokens.spacing2),
        Expanded(
          child: periodAsync.when(
            loading: () => const _LeaderboardSkeleton(),
            error: (e, _) => EcoErrorView(
              message: 'Failed to load period leaderboard',
              onRetry: () => ref.invalidate(periodLeaderboardProvider),
            ),
            data: (entries) {
              if (entries.isEmpty) {
                return const EcoEmptyState(
                  icon: Icons.timeline_outlined,
                  title: 'No activity this period',
                  subtitle: 'Complete actions to see your progress!',
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(EcoTokens.spacing4),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return LeaderboardTile(
                    rank: entry.rank,
                    name: entry.fullName,
                    profilePhoto: entry.profilePhoto,
                    score: entry.totalPoints,
                    scoreLabel: 'pts',
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LeaderboardSkeleton extends StatelessWidget {
  const _LeaderboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return EcoSkeleton(
      enabled: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(EcoTokens.spacing4),
        itemCount: 5,
        itemBuilder: (_, __) => const EcoSkeletonTile(),
      ),
    );
  }
}

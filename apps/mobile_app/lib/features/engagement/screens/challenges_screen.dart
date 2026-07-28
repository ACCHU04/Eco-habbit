import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/core/widgets/eco_empty_state.dart';
import 'package:mobile_app/core/widgets/eco_error_view.dart';
import 'package:mobile_app/core/widgets/eco_skeleton.dart';
import 'package:mobile_app/features/engagement/providers/engagement_providers.dart';
import 'package:mobile_app/features/engagement/widgets/challenge_widgets.dart';
import 'package:mobile_app/features/engagement/data/engagement_repository.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';

class ChallengesScreen extends ConsumerStatefulWidget {
  const ChallengesScreen({super.key});

  @override
  ConsumerState<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends ConsumerState<ChallengesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenges'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Friends',
            onPressed: () => _showFriendsSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Challenge',
            onPressed: () => _showCreateChallengeSheet(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Pending'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ChallengesListTab(status: 'active'),
          _ChallengesListTab(status: 'pending'),
          _ChallengesListTab(status: 'completed'),
        ],
      ),
    );
  }

  void _showFriendsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _FriendsSheet(),
    );
  }

  void _showCreateChallengeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _CreateChallengeSheet(),
    );
  }
}

class _ChallengesListTab extends ConsumerWidget {
  final String status;
  const _ChallengesListTab({required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengesAsync = ref.watch(challengesProvider);
    final currentUserId = ref.watch(authProvider).valueOrNull?.user?.id;

    return challengesAsync.when(
      loading: () => EcoSkeleton(
        enabled: true,
        child: ListView.builder(
          padding: const EdgeInsets.all(EcoTokens.spacing4),
          itemCount: 5,
          itemBuilder: (_, __) => const EcoSkeletonTile(),
        ),
      ),
      error: (e, _) => EcoErrorView(
        message: 'Failed to load challenges',
        onRetry: () => ref.invalidate(challengesProvider),
      ),
      data: (challenges) {
        final filtered = challenges.where((c) => c.status == status).toList();
        if (filtered.isEmpty) {
          return EcoEmptyState(
            icon: status == 'active'
                ? Icons.sports_esports_outlined
                : status == 'pending'
                    ? Icons.hourglass_empty_outlined
                    : Icons.history_outlined,
            title: status == 'active'
                ? 'No active challenges'
                : status == 'pending'
                    ? 'No pending challenges'
                    : 'No completed challenges yet',
            subtitle: 'Challenge a friend to start competing!',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(EcoTokens.spacing4),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final challenge = filtered[index];
            final isChallenger = challenge.challenger?.id == currentUserId;
            return ChallengeCard(
              challenge: challenge,
              isChallenger: isChallenger,
            );
          },
        );
      },
    );
  }
}

class _FriendsSheet extends ConsumerWidget {
  const _FriendsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);
    final pendingAsync = ref.watch(pendingRequestsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(EcoTokens.spacing4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Friends',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: EcoTokens.spacing3),
              pendingAsync.when(
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
                data: (requests) {
                  if (requests.isEmpty) return const SizedBox();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pending Requests',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: EcoColors.warning,
                        ),
                      ),
                      ...requests.map((r) => FriendRequestTile(
                            name: r.requester.fullName,
                            profilePhoto: r.requester.profilePhoto,
                            onAccept: () async {
                              await ref
                                  .read(engagementRepositoryProvider)
                                  .respondToFriendRequest(r.friendshipId, true);
                              ref.invalidate(friendsProvider);
                              ref.invalidate(pendingRequestsProvider);
                              ref.invalidate(friendLeaderboardProvider);
                            },
                            onDecline: () async {
                              await ref
                                  .read(engagementRepositoryProvider)
                                  .respondToFriendRequest(r.friendshipId, false);
                              ref.invalidate(pendingRequestsProvider);
                            },
                          )),
                      const SizedBox(height: EcoTokens.spacing3),
                    ],
                  );
                },
              ),
              const Text(
                'Your Friends',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: EcoTokens.spacing2),
              Expanded(
                child: friendsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => EcoErrorView(
                    message: 'Failed to load friends',
                    onRetry: () => ref.invalidate(friendsProvider),
                  ),
                  data: (friends) {
                    if (friends.isEmpty) {
                      return const EcoEmptyState(
                        icon: Icons.people_outline,
                        title: 'No friends yet',
                        subtitle: 'Send a friend request to get started!',
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        final f = friends[index];
                        return FriendTile(
                          name: f.friend.fullName,
                          profilePhoto: f.friend.profilePhoto,
                          friendshipId: f.friendshipId,
                          onRemove: () async {
                            await ref
                                .read(engagementRepositoryProvider)
                                .removeFriend(f.friendshipId);
                            ref.invalidate(friendsProvider);
                            ref.invalidate(friendLeaderboardProvider);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CreateChallengeSheet extends ConsumerStatefulWidget {
  const _CreateChallengeSheet();

  @override
  ConsumerState<_CreateChallengeSheet> createState() =>
      _CreateChallengeSheetState();
}

class _CreateChallengeSheetState extends ConsumerState<_CreateChallengeSheet> {
  String? _selectedFriendId;
  String _title = '';
  String _description = '';
  String _goalAction = 'recycle_item';
  int _goalCount = 5;
  int _durationDays = 7;

  static const _goalActions = [
    ('recycle_item', 'Recycle items'),
    ('complete_sale', 'Complete sales'),
    ('complete_donation', 'Donate items'),
    ('ai_scan', 'Scan items'),
    ('complete_diy', 'DIY projects'),
    ('create_post', 'Create posts'),
    ('list_item', 'List items'),
  ];

  @override
  Widget build(BuildContext context) {
    final friendsAsync = ref.watch(friendsProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: EcoTokens.spacing4,
        right: EcoTokens.spacing4,
        top: EcoTokens.spacing4,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Challenge a Friend',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: EcoTokens.spacing4),
            friendsAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => const Text('Failed to load friends'),
              data: (friends) {
                if (friends.isEmpty) {
                  return const Text(
                    'Add friends first to create challenges!',
                    style: TextStyle(color: EcoColors.onSurfaceVariantLight),
                  );
                }
                return DropdownButtonFormField<String>(
                  initialValue: _selectedFriendId,
                  hint: const Text('Select a friend'),
                  items: friends
                      .map((f) => DropdownMenuItem(
                            value: f.friend.id,
                            child: Text(f.friend.fullName),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedFriendId = v),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Friend',
                  ),
                );
              },
            ),
            const SizedBox(height: EcoTokens.spacing3),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
                hintText: 'e.g., Recycle 5 items this week',
              ),
              onChanged: (v) => _title = v,
            ),
            const SizedBox(height: EcoTokens.spacing3),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description (optional)',
              ),
              onChanged: (v) => _description = v,
            ),
            const SizedBox(height: EcoTokens.spacing3),
            DropdownButtonFormField<String>(
              initialValue: _goalAction,
              items: _goalActions
                  .map((g) => DropdownMenuItem(
                        value: g.$1,
                        child: Text(g.$2),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _goalAction = v!),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Goal',
              ),
            ),
            const SizedBox(height: EcoTokens.spacing3),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _goalCount,
                    items: [1, 3, 5, 10, 15, 20, 50]
                        .map((n) => DropdownMenuItem(
                              value: n,
                              child: Text('$n items'),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _goalCount = v!),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Count',
                    ),
                  ),
                ),
                const SizedBox(width: EcoTokens.spacing3),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _durationDays,
                    items: [1, 3, 7, 14, 30]
                        .map((n) => DropdownMenuItem(
                              value: n,
                              child: Text('$n days'),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _durationDays = v!),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Duration',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: EcoTokens.spacing4),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _selectedFriendId != null && _title.isNotEmpty
                    ? () async {
                        await ref
                            .read(engagementRepositoryProvider)
                            .createChallenge(
                              challengeeId: _selectedFriendId!,
                              title: _title,
                              description: _description.isEmpty
                                  ? 'Challenge to $_goalAction'
                                  : _description,
                              goalAction: _goalAction,
                              goalCount: _goalCount,
                              durationDays: _durationDays,
                            );
                        ref.invalidate(challengesProvider);
                        if (context.mounted) Navigator.pop(context);
                      }
                    : null,
                child: const Text('Send Challenge'),
              ),
            ),
            const SizedBox(height: EcoTokens.spacing4),
          ],
        ),
      ),
    );
  }
}

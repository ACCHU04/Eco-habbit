import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/community/screens/community_feed_screen.dart';
import 'package:mobile_app/features/community/providers/community_provider.dart';
import 'package:mobile_app/features/community/models/post.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/notifications/providers/notification_provider.dart';

import '../../helpers/test_wrappers.dart';

void main() {
  group('CommunityFeedScreen', () {
    final testPosts = PaginatedPosts(
      posts: [
        Post(
          id: 'p1',
          content: 'Here is a great recycling tip for plastics!',
          postType: 'tip',
          likesCount: 5,
          commentsCount: 2,
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          author: const PostAuthor(id: 'a1', fullName: 'Jane Doe'),
          imageUrls: [],
          isLiked: false,
          comments: [],
        ),
      ],
      page: 1,
      limit: 20,
      total: 1,
      totalPages: 1,
    );

    Widget buildCommunity({
      AsyncValue<PaginatedPosts> feedState =
          const AsyncValue.data(PaginatedPosts(
        posts: [],
        page: 1,
        limit: 20,
        total: 0,
        totalPages: 0,
      )),
    }) {
      return buildTestWidget(
        const CommunityFeedScreen(),
        initialLocation: '/community',
        overrides: [
          authOverride(initial: const AsyncValue.data(AuthData(user: testUser))),
          communityFeedProvider.overrideWith(() => _FakeFeedNotifier(feedState)),
          unreadCountProvider.overrideWith(() => _FakeUnreadCountNotifier(0)),
        ],
        destinationRoutes: {
          '/notifications': (_, __) => const Scaffold(body: Text('notifications-page')),
        },
      );
    }

    testWidgets('renders filter chips (All, DIY, Tips, Market)', (tester) async {
      await tester.pumpWidget(buildCommunity());
      await tester.pumpAndSettle();

      expect(find.text('All'), findsOneWidget);
      expect(find.text('DIY'), findsOneWidget);
      expect(find.text('Tips'), findsOneWidget);
      expect(find.text('Market'), findsOneWidget);
    });

    testWidgets('shows loading indicator while feed loads', (tester) async {
      await tester.pumpWidget(buildCommunity(
        feedState: const AsyncValue.loading(),
      ));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows post cards when feed data is loaded', (tester) async {
      await tester.pumpWidget(buildCommunity(feedState: AsyncValue.data(testPosts)));
      await tester.pumpAndSettle();

      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.textContaining('recycling tip'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });
  });
}

class _FakeFeedNotifier extends AsyncNotifier<PaginatedPosts>
    implements CommunityFeedNotifier {
  final AsyncValue<PaginatedPosts>? _initial;
  _FakeFeedNotifier(this._initial);
  @override
  Future<PaginatedPosts> build() async {
    final initial = _initial;
    if (initial == null || initial.isLoading) {
      await Completer<PaginatedPosts>().future;
    }
    return initial!.value!;
  }
  @override
  Future<void> loadMore() async {}
  @override
  void toggleLike(String postId, {required bool isCurrentlyLiked, required int currentLikesCount}) {}
}

class _FakeUnreadCountNotifier extends AsyncNotifier<int>
    implements UnreadCountNotifier {
  final int _count;
  _FakeUnreadCountNotifier(this._count);
  @override
  Future<int> build() async => _count;
}

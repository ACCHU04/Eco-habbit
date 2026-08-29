import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/engagement/models/challenge_models.dart';

void main() {
  group('FriendUser', () {
    test('fromJson parses all fields', () {
      final user = FriendUser.fromJson({
        'id': 'u1',
        'full_name': 'Bob',
        'profile_photo': 'https://example.com/bob.jpg',
      });
      expect(user.id, 'u1');
      expect(user.fullName, 'Bob');
      expect(user.profilePhoto, 'https://example.com/bob.jpg');
    });

    test('fromJson defaults when missing', () {
      final user = FriendUser.fromJson({});
      expect(user.id, '');
      expect(user.fullName, '');
      expect(user.profilePhoto, isNull);
    });
  });

  group('Friend', () {
    test('fromJson parses all fields', () {
      final friend = Friend.fromJson({
        'friendship_id': 'f1',
        'friend': {'id': 'u1', 'full_name': 'Alice'},
        'since': '2026-07-01T00:00:00Z',
      });
      expect(friend.friendshipId, 'f1');
      expect(friend.friend.id, 'u1');
      expect(friend.friend.fullName, 'Alice');
      expect(friend.since.year, 2026);
    });

    test('fromJson defaults when missing', () {
      final friend = Friend.fromJson({});
      expect(friend.friendshipId, '');
      expect(friend.friend.id, '');
    });
  });

  group('FriendRequest', () {
    test('fromJson parses all fields', () {
      final request = FriendRequest.fromJson({
        'id': 'fr1',
        'requester': {'id': 'u2', 'full_name': 'Charlie'},
        'created_at': '2026-07-15T10:00:00Z',
      });
      expect(request.friendshipId, 'fr1');
      expect(request.requester.id, 'u2');
      expect(request.requester.fullName, 'Charlie');
    });

    test('fromJson defaults when missing', () {
      final request = FriendRequest.fromJson({});
      expect(request.friendshipId, '');
    });
  });

  group('FriendChallenge', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'ch1',
        'title': 'Recycle Race',
        'description': 'Recycle 10 items',
        'challenger': {'id': 'u1', 'full_name': 'Alice'},
        'challengee': {'id': 'u2', 'full_name': 'Bob'},
        'status': 'active',
        'goal_action': 'recycle_item',
        'goal_count': 10,
        'challenger_progress': 5,
        'challengee_progress': 3,
        'winner_id': null,
        'xp_reward': 200,
        'coin_reward': 50,
        'starts_at': '2026-07-20T00:00:00Z',
        'ends_at': '2026-07-30T00:00:00Z',
        'created_at': '2026-07-19T00:00:00Z',
      };
      final c = FriendChallenge.fromJson(json);
      expect(c.id, 'ch1');
      expect(c.title, 'Recycle Race');
      expect(c.challenger?.id, 'u1');
      expect(c.challengee?.id, 'u2');
      expect(c.status, 'active');
      expect(c.goalAction, 'recycle_item');
      expect(c.goalCount, 10);
      expect(c.challengerProgress, 5);
      expect(c.challengeeProgress, 3);
      expect(c.xpReward, 200);
      expect(c.coinReward, 50);
    });

    test('fromJson defaults when missing', () {
      final c = FriendChallenge.fromJson({});
      expect(c.id, '');
      expect(c.title, '');
      expect(c.status, 'pending');
      expect(c.goalCount, 1);
      expect(c.xpReward, 100);
      expect(c.coinReward, 25);
      expect(c.challengerProgress, 0);
      expect(c.challengeeProgress, 0);
    });

    test('fromJson handles null challenger and challengee', () {
      final c = FriendChallenge.fromJson({
        'challenger': null,
        'challengee': null,
      });
      expect(c.challenger, isNull);
      expect(c.challengee, isNull);
    });

    test('goalActionLabel returns human-readable text', () {
      final now = DateTime.now();
      expect(
        FriendChallenge(
          id: '',
          title: '',
          description: '',
          status: '',
          goalAction: 'recycle_item',
          goalCount: 1,
          endsAt: now,
          createdAt: now,
        ).goalActionLabel,
        'Recycle items',
      );
      expect(
        FriendChallenge(
          id: '',
          title: '',
          description: '',
          status: '',
          goalAction: 'complete_sale',
          goalCount: 1,
          endsAt: now,
          createdAt: now,
        ).goalActionLabel,
        'Complete sales',
      );
      expect(
        FriendChallenge(
          id: '',
          title: '',
          description: '',
          status: '',
          goalAction: 'complete_donation',
          goalCount: 1,
          endsAt: now,
          createdAt: now,
        ).goalActionLabel,
        'Donate items',
      );
      expect(
        FriendChallenge(
          id: '',
          title: '',
          description: '',
          status: '',
          goalAction: 'ai_scan',
          goalCount: 1,
          endsAt: now,
          createdAt: now,
        ).goalActionLabel,
        'Scan items',
      );
      expect(
        FriendChallenge(
          id: '',
          title: '',
          description: '',
          status: '',
          goalAction: 'complete_diy',
          goalCount: 1,
          endsAt: now,
          createdAt: now,
        ).goalActionLabel,
        'DIY projects',
      );
      expect(
        FriendChallenge(
          id: '',
          title: '',
          description: '',
          status: '',
          goalAction: 'create_post',
          goalCount: 1,
          endsAt: now,
          createdAt: now,
        ).goalActionLabel,
        'Create posts',
      );
      expect(
        FriendChallenge(
          id: '',
          title: '',
          description: '',
          status: '',
          goalAction: 'list_item',
          goalCount: 1,
          endsAt: now,
          createdAt: now,
        ).goalActionLabel,
        'List items',
      );
    });

    test('goalActionLabel returns snake_case-to-spaces fallback', () {
      final now = DateTime.now();
      final c = FriendChallenge(
        id: '',
        title: '',
        description: '',
        status: '',
        goalAction: 'some_unknown_action',
        goalCount: 1,
        endsAt: now,
        createdAt: now,
      );
      expect(c.goalActionLabel, 'some unknown action');
    });

    test('isExpired returns true when endsAt is in the past', () {
      final c = FriendChallenge(
        id: '',
        title: '',
        description: '',
        status: '',
        goalAction: 'recycle_item',
        goalCount: 1,
        endsAt: DateTime.now().subtract(const Duration(days: 1)),
        createdAt: DateTime.now(),
      );
      expect(c.isExpired, isTrue);
    });

    test('isExpired returns false when endsAt is in the future', () {
      final c = FriendChallenge(
        id: '',
        title: '',
        description: '',
        status: '',
        goalAction: 'recycle_item',
        goalCount: 1,
        endsAt: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now(),
      );
      expect(c.isExpired, isFalse);
    });
  });
}

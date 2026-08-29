import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/rewards/models/reward_models.dart';

void main() {
  group('UserPoints', () {
    test('fromJson parses total_points', () {
      final json = {'total_points': 1250};
      final points = UserPoints.fromJson(json);
      expect(points.totalPoints, 1250);
    });

    test('fromJson defaults to 0 when missing', () {
      final points = UserPoints.fromJson({});
      expect(points.totalPoints, 0);
    });
  });

  group('PointsHistoryItem', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'p1',
        'action': 'ai_scan',
        'points': 5,
        'created_at': '2026-07-23T10:00:00Z',
      };
      final item = PointsHistoryItem.fromJson(json);
      expect(item.id, 'p1');
      expect(item.action, 'ai_scan');
      expect(item.points, 5);
    });

    test('actionLabel returns human-readable text', () {
      final item = PointsHistoryItem(id: '1', action: 'complete_sale', points: 50, createdAt: DateTime(2026));
      expect(item.actionLabel, 'Completed a sale');
    });

    test('actionLabel handles unknown action', () {
      final item = PointsHistoryItem(id: '1', action: 'unknown_action', points: 10, createdAt: DateTime(2026));
      expect(item.actionLabel, 'unknown action');
    });
  });

  group('Badge', () {
    test('fromJson parses badge_type and earned_at', () {
      final json = {
        'id': 'b1',
        'badge_type': 'recycler',
        'earned_at': '2026-07-23T10:00:00Z',
      };
      final badge = Badge.fromJson(json);
      expect(badge.badgeType, 'recycler');
      expect(badge.id, 'b1');
    });
  });

  group('LeaderboardEntry', () {
    test('fromJson parses nested users object', () {
      final json = {
        'user_id': 'u1',
        'total_points': 2450,
        'users': {'full_name': 'Priya M.', 'profile_photo': null},
      };
      final entry = LeaderboardEntry.fromJson(json, rank: 1);
      expect(entry.userId, 'u1');
      expect(entry.fullName, 'Priya M.');
      expect(entry.totalPoints, 2450);
      expect(entry.rank, 1);
    });

    test('fromJson handles missing users object', () {
      final json = {'user_id': 'u2', 'total_points': 100};
      final entry = LeaderboardEntry.fromJson(json, rank: 5);
      expect(entry.fullName, '');
      expect(entry.rank, 5);
    });
  });

  group('PaginatedPointsHistory', () {
    test('hasMore returns true when page < totalPages', () {
      const history = PaginatedPointsHistory(items: [], page: 1, limit: 20, total: 50, totalPages: 3);
      expect(history.hasMore, true);
    });

    test('hasMore returns false on last page', () {
      const history = PaginatedPointsHistory(items: [], page: 3, limit: 20, total: 50, totalPages: 3);
      expect(history.hasMore, false);
    });
  });

  group('badgeDisplay', () {
    test('contains all 6 badge types', () {
      expect(badgeDisplay.length, 6);
      expect(badgeDisplay.containsKey('first_sale'), true);
      expect(badgeDisplay.containsKey('eco_warrior'), true);
    });

    test('each badge has emoji and label', () {
      for (final entry in badgeDisplay.entries) {
        expect(entry.value.$1.isNotEmpty, true);
        expect(entry.value.$2.isNotEmpty, true);
      }
    });
  });
}

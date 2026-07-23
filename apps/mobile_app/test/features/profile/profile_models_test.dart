import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/profile/models/user_stats.dart';
import 'package:mobile_app/features/profile/models/notification_prefs.dart';

void main() {
  group('UserStats', () {
    test('fromJson parses all fields', () {
      final json = {
        'listings_count': 5,
        'total_points': 1250,
        'badges_count': 3,
        'badges': ['recycler', 'first_sale'],
      };
      final stats = UserStats.fromJson(json);
      expect(stats.listingsCount, 5);
      expect(stats.totalPoints, 1250);
      expect(stats.badgesCount, 3);
      expect(stats.badges, ['recycler', 'first_sale']);
    });

    test('fromJson defaults to zero and empty list when fields missing', () {
      final stats = UserStats.fromJson({});
      expect(stats.listingsCount, 0);
      expect(stats.totalPoints, 0);
      expect(stats.badgesCount, 0);
      expect(stats.badges, isEmpty);
    });

    test('fromJson handles null badges list', () {
      final stats = UserStats.fromJson({'badges': null});
      expect(stats.badges, isEmpty);
    });
  });

  group('NotificationPrefs', () {
    test('fromJson parses all fields', () {
      final json = {
        'like_comment': false,
        'marketplace_inquiry': false,
        'reward_achievement': true,
        'community_update': true,
      };
      final prefs = NotificationPrefs.fromJson(json);
      expect(prefs.likeComment, false);
      expect(prefs.marketplaceInquiry, false);
      expect(prefs.rewardAchievement, true);
      expect(prefs.communityUpdate, true);
    });

    test('fromJson applies sensible defaults when fields missing', () {
      final prefs = NotificationPrefs.fromJson({});
      expect(prefs.likeComment, true);
      expect(prefs.marketplaceInquiry, true);
      expect(prefs.rewardAchievement, true);
      expect(prefs.communityUpdate, false);
    });

    test('toJson serializes to snake_case keys', () {
      const prefs = NotificationPrefs(
        likeComment: true,
        marketplaceInquiry: false,
        rewardAchievement: true,
        communityUpdate: false,
      );
      final json = prefs.toJson();
      expect(json['like_comment'], true);
      expect(json['marketplace_inquiry'], false);
      expect(json['reward_achievement'], true);
      expect(json['community_update'], false);
    });

    test('copyWith overrides provided fields', () {
      const prefs = NotificationPrefs(
        likeComment: true,
        marketplaceInquiry: true,
        rewardAchievement: true,
        communityUpdate: false,
      );
      final updated = prefs.copyWith(likeComment: false, communityUpdate: true);
      expect(updated.likeComment, false);
      expect(updated.communityUpdate, true);
      expect(updated.marketplaceInquiry, true);
      expect(updated.rewardAchievement, true);
    });

    test('copyWith preserves existing values when args are null', () {
      const prefs = NotificationPrefs(
        likeComment: false,
        marketplaceInquiry: false,
        rewardAchievement: false,
        communityUpdate: false,
      );
      final copy = prefs.copyWith();
      expect(copy.likeComment, false);
      expect(copy.marketplaceInquiry, false);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/engagement/models/leaderboard_models.dart';

void main() {
  group('LeaderboardEntry', () {
    test('fromJson parses all fields', () {
      final json = {
        'user_id': 'u1',
        'full_name': 'Alice',
        'profile_photo': 'https://example.com/photo.jpg',
        'total_points': 500,
        'level': 3,
        'badge_count': 2,
        'rank': 1,
      };
      final entry = LeaderboardEntry.fromJson(json);
      expect(entry.userId, 'u1');
      expect(entry.fullName, 'Alice');
      expect(entry.profilePhoto, 'https://example.com/photo.jpg');
      expect(entry.totalPoints, 500);
      expect(entry.level, 3);
      expect(entry.badgeCount, 2);
      expect(entry.rank, 1);
    });

    test('fromJson defaults to zero and empty when fields missing', () {
      final entry = LeaderboardEntry.fromJson({});
      expect(entry.userId, '');
      expect(entry.fullName, '');
      expect(entry.profilePhoto, isNull);
      expect(entry.totalPoints, 0);
      expect(entry.level, 1);
      expect(entry.badgeCount, 0);
      expect(entry.rank, 0);
    });

    test('fromJson handles null profile_photo', () {
      final entry = LeaderboardEntry.fromJson({'profile_photo': null});
      expect(entry.profilePhoto, isNull);
    });

    test('fromJson handles numeric types correctly', () {
      final json = {
        'total_points': 100.5,
        'level': 2.9,
        'badge_count': 1.1,
        'rank': 3.7,
      };
      final entry = LeaderboardEntry.fromJson(json);
      expect(entry.totalPoints, 100);
      expect(entry.level, 2);
      expect(entry.badgeCount, 1);
      expect(entry.rank, 3);
    });
  });

  group('HostelEntry', () {
    test('fromJson parses all fields', () {
      final json = {
        'hostel_id': 'h1',
        'hostel_name': 'Green Tower',
        'total_points': 1200,
        'member_count': 50,
        'avg_score': 24.0,
        'rank': 2,
      };
      final entry = HostelEntry.fromJson(json);
      expect(entry.hostelId, 'h1');
      expect(entry.hostelName, 'Green Tower');
      expect(entry.totalScore, 1200);
      expect(entry.memberCount, 50);
      expect(entry.avgScore, 24.0);
      expect(entry.rank, 2);
    });

    test('fromJson defaults when missing', () {
      final entry = HostelEntry.fromJson({});
      expect(entry.hostelId, '');
      expect(entry.hostelName, '');
      expect(entry.totalScore, 0);
      expect(entry.memberCount, 0);
      expect(entry.avgScore, 0.0);
      expect(entry.rank, 0);
    });

    test('fromJson handles numeric types correctly', () {
      final json = {
        'total_points': 100.7,
        'member_count': 30.2,
        'avg_score': 15.8,
        'rank': 1.9,
      };
      final entry = HostelEntry.fromJson(json);
      expect(entry.totalScore, 100);
      expect(entry.memberCount, 30);
      expect(entry.avgScore, closeTo(15.8, 0.01));
      expect(entry.rank, 1);
    });
  });

  group('LeaderboardFilter', () {
    test('has all expected values', () {
      expect(LeaderboardFilter.values.length, 4);
      expect(LeaderboardFilter.campus, isNotNull);
      expect(LeaderboardFilter.hostel, isNotNull);
      expect(LeaderboardFilter.department, isNotNull);
      expect(LeaderboardFilter.friends, isNotNull);
    });
  });

  group('LeaderboardPeriod', () {
    test('has all expected values', () {
      expect(LeaderboardPeriod.values.length, 3);
      expect(LeaderboardPeriod.weekly, isNotNull);
      expect(LeaderboardPeriod.monthly, isNotNull);
      expect(LeaderboardPeriod.allTime, isNotNull);
    });
  });
}

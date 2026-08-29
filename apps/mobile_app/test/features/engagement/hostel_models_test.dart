import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/engagement/models/hostel_models.dart';

void main() {
  group('Hostel', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'h1',
        'name': 'Sunrise Hostel',
        'college': 'MIT',
        'total_score': 800,
        'member_count': 40,
        'avatar_url': 'https://example.com/avatar.png',
      };
      final hostel = Hostel.fromJson(json);
      expect(hostel.id, 'h1');
      expect(hostel.name, 'Sunrise Hostel');
      expect(hostel.college, 'MIT');
      expect(hostel.totalScore, 800);
      expect(hostel.memberCount, 40);
      expect(hostel.avatarUrl, 'https://example.com/avatar.png');
    });

    test('fromJson defaults when missing', () {
      final hostel = Hostel.fromJson({});
      expect(hostel.id, '');
      expect(hostel.name, '');
      expect(hostel.college, '');
      expect(hostel.totalScore, 0);
      expect(hostel.memberCount, 0);
      expect(hostel.avatarUrl, isNull);
    });

    test('fromJson handles null avatar_url', () {
      final hostel = Hostel.fromJson({'avatar_url': null});
      expect(hostel.avatarUrl, isNull);
    });
  });

  group('HostelBattle', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'b1',
        'title': 'Eco Battle',
        'description': 'Recycle more',
        'hosteler': {'id': 'h1', 'name': 'A', 'college': 'C'},
        'challenger': {'id': 'h2', 'name': 'B', 'college': 'C'},
        'status': 'active',
        'metric': 'recycle_count',
        'start_score_hosteler': 100,
        'start_score_challenger': 90,
        'end_score_hosteler': 150,
        'end_score_challenger': 120,
        'winner_id': 'h1',
        'starts_at': '2026-07-20T00:00:00Z',
        'ends_at': '2026-07-30T00:00:00Z',
      };
      final battle = HostelBattle.fromJson(json);
      expect(battle.id, 'b1');
      expect(battle.title, 'Eco Battle');
      expect(battle.description, 'Recycle more');
      expect(battle.hosteler?.id, 'h1');
      expect(battle.challenger?.id, 'h2');
      expect(battle.status, 'active');
      expect(battle.metric, 'recycle_count');
      expect(battle.startScoreHosteler, 100);
      expect(battle.startScoreChallenger, 90);
      expect(battle.endScoreHosteler, 150);
      expect(battle.endScoreChallenger, 120);
      expect(battle.winnerId, 'h1');
    });

    test('fromJson defaults when missing', () {
      final battle = HostelBattle.fromJson({});
      expect(battle.id, '');
      expect(battle.title, '');
      expect(battle.hosteler, isNull);
      expect(battle.challenger, isNull);
      expect(battle.status, 'active');
      expect(battle.metric, 'total_score');
      expect(battle.winnerId, isNull);
    });

    test('isActive returns true when status is active and not expired', () {
      final battle = HostelBattle(
        id: 'b1',
        title: 'T',
        description: 'D',
        status: 'active',
        metric: 'm',
        startsAt: DateTime.now().subtract(const Duration(days: 1)),
        endsAt: DateTime.now().add(const Duration(days: 1)),
      );
      expect(battle.isActive, isTrue);
    });

    test('isActive returns false when status is completed', () {
      final battle = HostelBattle(
        id: 'b1',
        title: 'T',
        description: 'D',
        status: 'completed',
        metric: 'm',
        startsAt: DateTime.now().subtract(const Duration(days: 1)),
        endsAt: DateTime.now().add(const Duration(days: 1)),
      );
      expect(battle.isActive, isFalse);
    });

    test('isActive returns false when expired', () {
      final battle = HostelBattle(
        id: 'b1',
        title: 'T',
        description: 'D',
        status: 'active',
        metric: 'm',
        startsAt: DateTime.now().subtract(const Duration(days: 10)),
        endsAt: DateTime.now().subtract(const Duration(days: 1)),
      );
      expect(battle.isActive, isFalse);
      expect(battle.isExpired, isTrue);
    });

    test('durationDays computes correctly', () {
      final battle = HostelBattle(
        id: 'b1',
        title: 'T',
        description: 'D',
        status: 'active',
        metric: 'm',
        startsAt: DateTime(2026, 7, 20),
        endsAt: DateTime(2026, 7, 30),
      );
      expect(battle.durationDays, 10);
    });
  });
}

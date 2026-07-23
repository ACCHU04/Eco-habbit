import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/auth/models/user_model.dart';

void main() {
  group('UserModel', () {
    group('fromJson', () {
      test('parses all fields from complete JSON', () {
        final json = {
          'id': 'u1',
          'email': 'test@example.com',
          'full_name': 'Test User',
          'college': 'MIT',
          'role': 'student',
          'profile_photo': 'https://example.com/photo.jpg',
        };
        final user = UserModel.fromJson(json);
        expect(user.id, 'u1');
        expect(user.email, 'test@example.com');
        expect(user.fullName, 'Test User');
        expect(user.college, 'MIT');
        expect(user.role, 'student');
        expect(user.profilePhoto, 'https://example.com/photo.jpg');
      });

      test('defaults fullName to empty string when missing', () {
        final json = {'id': 'u1', 'email': 'a@b.com'};
        final user = UserModel.fromJson(json);
        expect(user.fullName, '');
      });

      test('defaults optional fields to null when missing', () {
        final json = {'id': 'u1', 'email': 'a@b.com', 'full_name': 'X'};
        final user = UserModel.fromJson(json);
        expect(user.college, isNull);
        expect(user.role, isNull);
        expect(user.profilePhoto, isNull);
      });
    });

    group('toJson', () {
      test('serializes all fields to snake_case keys', () {
        const user = UserModel(
          id: 'u1',
          email: 'a@b.com',
          fullName: 'Test',
          college: 'MIT',
          role: 'student',
          profilePhoto: 'https://example.com/photo.jpg',
        );
        final json = user.toJson();
        expect(json['id'], 'u1');
        expect(json['email'], 'a@b.com');
        expect(json['full_name'], 'Test');
        expect(json['college'], 'MIT');
        expect(json['role'], 'student');
        expect(json['profile_photo'], 'https://example.com/photo.jpg');
      });

      test('fromJson toJson round-trip preserves data', () {
        final json = {
          'id': 'u1',
          'email': 'a@b.com',
          'full_name': 'Test',
          'college': 'MIT',
          'role': 'student',
        };
        final user = UserModel.fromJson(json);
        final result = user.toJson();
        expect(result['id'], json['id']);
        expect(result['email'], json['email']);
        expect(result['full_name'], json['full_name']);
        expect(result['college'], json['college']);
        expect(result['role'], json['role']);
      });
    });

    group('copyWith', () {
      test('overrides provided fields', () {
        const user = UserModel(id: 'u1', email: 'a@b.com', fullName: 'Old');
        final updated = user.copyWith(fullName: 'New', role: 'seller');
        expect(updated.fullName, 'New');
        expect(updated.role, 'seller');
        expect(updated.id, 'u1');
        expect(updated.email, 'a@b.com');
      });

      test('preserves existing values when args are null', () {
        const user = UserModel(
          id: 'u1',
          email: 'a@b.com',
          fullName: 'Test',
          college: 'MIT',
        );
        final copy = user.copyWith();
        expect(copy.fullName, 'Test');
        expect(copy.college, 'MIT');
      });
    });
  });
}

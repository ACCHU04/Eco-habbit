import {
  ROLE_HIERARCHY,
  PERMISSIONS,
  hasPermission,
  canManageUser,
  VALID_STATUS_TRANSITIONS,
} from './admin.permissions';

describe('Admin Permissions', () => {
  describe('ROLE_HIERARCHY', () => {
    it('defines 6 roles with ascending levels', () => {
      expect(Object.keys(ROLE_HIERARCHY)).toHaveLength(6);
      expect(ROLE_HIERARCHY.student).toBe(0);
      expect(ROLE_HIERARCHY.ngo).toBe(1);
      expect(ROLE_HIERARCHY.organization).toBe(2);
      expect(ROLE_HIERARCHY.moderator).toBe(3);
      expect(ROLE_HIERARCHY.admin).toBe(4);
      expect(ROLE_HIERARCHY.super_admin).toBe(5);
    });
  });

  describe('hasPermission', () => {
    it('returns true for moderator with canModeratePosts', () => {
      expect(hasPermission('moderator', 'canModeratePosts')).toBe(true);
    });

    it('returns false for moderator with canManageUsers', () => {
      expect(hasPermission('moderator', 'canManageUsers')).toBe(false);
    });

    it('returns true for admin with canManageUsers', () => {
      expect(hasPermission('admin', 'canManageUsers')).toBe(true);
    });

    it('returns true for super_admin with canManageAdmins', () => {
      expect(hasPermission('super_admin', 'canManageAdmins')).toBe(true);
    });

    it('returns false for student with any permission', () => {
      expect(hasPermission('student', 'canModeratePosts')).toBe(false);
    });

    it('returns false for unknown role', () => {
      expect(hasPermission('unknown', 'canModeratePosts')).toBe(false);
    });
  });

  describe('canManageUser', () => {
    it('admin can manage student', () => {
      expect(canManageUser('admin', 'student')).toBe(true);
    });

    it('admin can manage moderator', () => {
      expect(canManageUser('admin', 'moderator')).toBe(true);
    });

    it('admin cannot manage super_admin', () => {
      expect(canManageUser('admin', 'super_admin')).toBe(false);
    });

    it('super_admin can manage admin', () => {
      expect(canManageUser('super_admin', 'admin')).toBe(true);
    });

    it('super_admin cannot manage super_admin', () => {
      expect(canManageUser('super_admin', 'super_admin')).toBe(false);
    });

    it('moderator cannot manage admin', () => {
      expect(canManageUser('moderator', 'admin')).toBe(false);
    });

    it('student cannot manage anyone', () => {
      expect(canManageUser('student', 'student')).toBe(false);
      expect(canManageUser('student', 'ngo')).toBe(false);
    });
  });

  describe('VALID_STATUS_TRANSITIONS', () => {
    it('active can transition to suspended and deactivated', () => {
      expect(VALID_STATUS_TRANSITIONS.active).toEqual([
        'suspended',
        'deactivated',
      ]);
    });

    it('suspended can transition to active', () => {
      expect(VALID_STATUS_TRANSITIONS.suspended).toEqual(['active']);
    });

    it('deactivated is terminal (no transitions)', () => {
      expect(VALID_STATUS_TRANSITIONS.deactivated).toEqual([]);
    });
  });
});

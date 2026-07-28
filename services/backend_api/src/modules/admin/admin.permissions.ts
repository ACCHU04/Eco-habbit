export const ROLE_HIERARCHY: Record<string, number> = {
  student: 0,
  ngo: 1,
  organization: 2,
  moderator: 3,
  admin: 4,
  super_admin: 5,
};

export const PERMISSIONS: Record<string, string[]> = {
  moderator: [
    'canModeratePosts',
    'canModerateMarketplace',
    'canResolveReports',
  ],
  admin: [
    'canManageUsers',
    'canModeratePosts',
    'canModerateMarketplace',
    'canResolveReports',
    'canManageSettings',
    'canViewAuditLog',
    'canManageCampuses',
  ],
  super_admin: [
    'canManageUsers',
    'canModeratePosts',
    'canModerateMarketplace',
    'canResolveReports',
    'canManageSettings',
    'canViewAuditLog',
    'canManageAdmins',
    'canManageSystem',
    'canManageCampuses',
  ],
};

export function hasPermission(role: string, permission: string): boolean {
  return PERMISSIONS[role]?.includes(permission) ?? false;
}

export function canManageUser(operatorRole: string, targetRole: string): boolean {
  const operatorLevel = ROLE_HIERARCHY[operatorRole] ?? 0;
  const targetLevel = ROLE_HIERARCHY[targetRole] ?? 0;
  return operatorLevel > targetLevel;
}

export const VALID_STATUS_TRANSITIONS: Record<string, string[]> = {
  active: ['suspended', 'deactivated'],
  suspended: ['active'],
  deactivated: [],
};

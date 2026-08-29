export type Role =
  | "student"
  | "ngo"
  | "organization"
  | "moderator"
  | "admin"
  | "super_admin";

export type UserStatus = "active" | "suspended" | "deactivated";
export type ReportStatus = "pending" | "resolved" | "dismissed";

export interface Pagination {
  page: number;
  limit: number;
  total: number;
  total_pages: number;
}

export interface ApiEnvelope<T> {
  success: boolean;
  data: T;
  pagination?: Pagination;
  message?: string;
}

export interface DashboardStats {
  total_users: number;
  total_posts: number;
  pending_reports: number;
  active_listings: number;
  role_breakdown: Record<Role, number>;
}

export interface AdminUser {
  id: string;
  email: string;
  full_name: string;
  college: string | null;
  role: Role;
  status: UserStatus;
  profile_photo: string | null;
  created_at: string;
  updated_at?: string | null;
  hostel?: string | null;
  department?: string | null;
  last_active_date?: string | null;
  stats?: {
    total_points: number;
    posts_count: number;
    listings_count: number;
  };
}

export interface AdminReport {
  id: string;
  reporter_id: string;
  content_type: string;
  content_id: string;
  reason: string;
  description: string | null;
  status: ReportStatus;
  admin_id: string | null;
  action_taken: string | null;
  created_at: string;
  reporter?: {
    full_name: string | null;
    profile_photo: string | null;
  };
}

export interface AuditEntry {
  id: string;
  admin_id: string;
  action: string;
  resource_type: string;
  resource_id: string;
  reason: string | null;
  metadata: Record<string, unknown> | null;
  created_at: string;
  admin?: {
    full_name: string | null;
    email: string | null;
  };
}

export const ROLES: Role[] = [
  "student",
  "ngo",
  "organization",
  "moderator",
  "admin",
  "super_admin",
];

export const USER_STATUSES: UserStatus[] = ["active", "suspended", "deactivated"];
export const REPORT_STATUSES: ReportStatus[] = ["pending", "resolved", "dismissed"];

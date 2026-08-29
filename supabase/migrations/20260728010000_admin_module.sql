-- ============================================================
-- M8: Admin Module — audit log, system settings, status column,
--     enum extension, RLS policies
-- ============================================================

-- 1. Extend user_role enum
ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'moderator';
ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'super_admin';

-- 2. Add status column to users (independent of role)
ALTER TABLE users ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'active'
  CHECK (status IN ('active', 'suspended', 'deactivated'));

CREATE INDEX IF NOT EXISTS idx_users_status ON users(status);

-- 3. Admin audit log
CREATE TABLE IF NOT EXISTS admin_audit_log (
  id            TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  admin_id      TEXT NOT NULL REFERENCES users(id),
  action        TEXT NOT NULL,
  resource_type TEXT NOT NULL,
  resource_id   TEXT NOT NULL,
  reason        TEXT,
  metadata      JSONB DEFAULT '{}',
  created_at    TIMESTAMP NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_audit_admin_id ON admin_audit_log(admin_id);
CREATE INDEX IF NOT EXISTS idx_audit_action ON admin_audit_log(action);
CREATE INDEX IF NOT EXISTS idx_audit_resource ON admin_audit_log(resource_type, resource_id);
CREATE INDEX IF NOT EXISTS idx_audit_created ON admin_audit_log(created_at DESC);

-- 4. System settings
CREATE TABLE IF NOT EXISTS system_settings (
  key         TEXT PRIMARY KEY,
  value       JSONB NOT NULL,
  updated_by  TEXT REFERENCES users(id),
  updated_at  TIMESTAMP NOT NULL DEFAULT now()
);

-- 5. RLS policies for admin access
-- Admin can read all users
CREATE POLICY "admin_read_all_users" ON users
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM users AS u
      WHERE u.id = auth.uid()::text
        AND u.role IN ('admin', 'super_admin')
        AND u.status = 'active'
    )
  );

-- Admin can update users (role/status changes)
CREATE POLICY "admin_update_users" ON users
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM users AS u
      WHERE u.id = auth.uid()::text
        AND u.role IN ('admin', 'super_admin')
        AND u.status = 'active'
    )
  );

-- Admin can read all reports
CREATE POLICY "admin_read_reports" ON reports
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()::text
        AND role IN ('admin', 'super_admin')
        AND status = 'active'
    )
  );

-- Admin can update reports (resolve/dismiss)
CREATE POLICY "admin_update_reports" ON reports
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()::text
        AND role IN ('admin', 'super_admin')
        AND status = 'active'
    )
  );

-- Admin can read all posts
CREATE POLICY "admin_read_posts" ON posts
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()::text
        AND role IN ('admin', 'super_admin')
        AND status = 'active'
    )
  );

-- Admin can delete posts
CREATE POLICY "admin_delete_posts" ON posts
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()::text
        AND role IN ('admin', 'super_admin')
        AND status = 'active'
    )
  );

-- Admin can read all marketplace listings
CREATE POLICY "admin_read_listings" ON marketplace_listings
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()::text
        AND role IN ('admin', 'super_admin')
        AND status = 'active'
    )
  );

-- Admin can delete marketplace listings
CREATE POLICY "admin_delete_listings" ON marketplace_listings
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()::text
        AND role IN ('admin', 'super_admin')
        AND status = 'active'
    )
  );

-- Audit log: admins can insert and read
CREATE POLICY "admin_insert_audit" ON admin_audit_log
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()::text
        AND role IN ('admin', 'super_admin')
        AND status = 'active'
    )
  );

CREATE POLICY "admin_read_audit" ON admin_audit_log
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()::text
        AND role IN ('admin', 'super_admin')
        AND status = 'active'
    )
  );

-- System settings: admin read/write
CREATE POLICY "admin_read_settings" ON system_settings
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()::text
        AND role IN ('admin', 'super_admin')
        AND status = 'active'
    )
  );

CREATE POLICY "admin_write_settings" ON system_settings
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()::text
        AND role IN ('admin', 'super_admin')
        AND status = 'active'
    )
  );

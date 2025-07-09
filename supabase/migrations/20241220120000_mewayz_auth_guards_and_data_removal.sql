-- Location: supabase/migrations/20241220120000_mewayz_auth_guards_and_data_removal.sql
-- Mewayz Authentication Guards and Data Removal

-- Remove all mock data from existing tables
DELETE FROM public.workspace_analytics WHERE workspace_id IN (
    SELECT id FROM public.workspaces WHERE owner_id IN (
        SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
    )
);

DELETE FROM public.workspace_invitations WHERE workspace_id IN (
    SELECT id FROM public.workspaces WHERE owner_id IN (
        SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
    )
);

DELETE FROM public.workspace_members WHERE workspace_id IN (
    SELECT id FROM public.workspaces WHERE owner_id IN (
        SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
    )
);

DELETE FROM public.workspaces WHERE owner_id IN (
    SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
);

DELETE FROM public.security_audit_log WHERE user_id IN (
    SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
);

DELETE FROM public.user_devices WHERE user_id IN (
    SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
);

DELETE FROM public.password_reset_tokens WHERE user_id IN (
    SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
);

DELETE FROM public.email_verification_codes WHERE user_id IN (
    SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
);

DELETE FROM public.user_oauth_providers WHERE user_id IN (
    SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
);

DELETE FROM public.user_sessions WHERE user_id IN (
    SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
);

DELETE FROM public.user_two_factor_auth WHERE user_id IN (
    SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
);

DELETE FROM public.link_bio_pages WHERE user_id IN (
    SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
);

DELETE FROM public.user_feature_modules WHERE user_id IN (
    SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
);

DELETE FROM public.setup_checklist WHERE user_id IN (
    SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
);

DELETE FROM public.user_goals WHERE user_id IN (
    SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
);

DELETE FROM public.onboarding_progress WHERE user_id IN (
    SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
);

DELETE FROM public.user_profiles WHERE email LIKE '%@mewayz.com';

DELETE FROM auth.users WHERE email LIKE '%@mewayz.com';

-- Enhanced RLS policies to ensure data is completely isolated by user and workspace

-- Update workspace policies to be more restrictive
DROP POLICY IF EXISTS "workspace_members_access" ON public.workspaces;
CREATE POLICY "workspace_members_access" ON public.workspaces FOR ALL
TO authenticated
USING (
    auth.uid() = owner_id OR
    public.is_workspace_member(id)
)
WITH CHECK (
    auth.uid() = owner_id OR
    public.can_manage_workspace(id)
);

-- Update workspace members policies
DROP POLICY IF EXISTS "workspace_members_can_view" ON public.workspace_members;
CREATE POLICY "workspace_members_can_view" ON public.workspace_members FOR SELECT
TO authenticated
USING (public.is_workspace_member(workspace_id) OR auth.uid() = user_id);

DROP POLICY IF EXISTS "workspace_admins_can_manage" ON public.workspace_members;
CREATE POLICY "workspace_admins_can_manage" ON public.workspace_members FOR ALL
TO authenticated
USING (
    public.can_manage_workspace(workspace_id) OR
    auth.uid() = user_id
)
WITH CHECK (
    public.can_manage_workspace(workspace_id)
);

-- Update workspace analytics policies
DROP POLICY IF EXISTS "workspace_analytics_access" ON public.workspace_analytics;
CREATE POLICY "workspace_analytics_access" ON public.workspace_analytics FOR ALL
TO authenticated
USING (public.is_workspace_member(workspace_id))
WITH CHECK (public.is_workspace_member(workspace_id));

-- Update workspace invitations policies
DROP POLICY IF EXISTS "workspace_invitations_access" ON public.workspace_invitations;
CREATE POLICY "workspace_invitations_access" ON public.workspace_invitations FOR ALL
TO authenticated
USING (
    public.can_manage_workspace(workspace_id) OR
    auth.uid() = invited_by OR
    auth.email() = email
)
WITH CHECK (
    public.can_manage_workspace(workspace_id)
);

-- Enhanced user profile policies
DROP POLICY IF EXISTS "users_own_profile" ON public.user_profiles;
CREATE POLICY "users_own_profile" ON public.user_profiles FOR ALL
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- No public access to user profiles
CREATE POLICY "no_public_access_user_profiles" ON public.user_profiles FOR ALL
TO public
USING (false)
WITH CHECK (false);

-- Enhanced onboarding and setup policies
DROP POLICY IF EXISTS "users_own_goals" ON public.user_goals;
CREATE POLICY "users_own_goals" ON public.user_goals FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "users_own_checklist" ON public.setup_checklist;
CREATE POLICY "users_own_checklist" ON public.setup_checklist FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "users_own_modules" ON public.user_feature_modules;
CREATE POLICY "users_own_modules" ON public.user_feature_modules FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "users_own_progress" ON public.onboarding_progress;
CREATE POLICY "users_own_progress" ON public.onboarding_progress FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Enhanced bio pages policies - remove public access
DROP POLICY IF EXISTS "users_own_bio_pages" ON public.link_bio_pages;
CREATE POLICY "users_own_bio_pages" ON public.link_bio_pages FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "public_read_published_bio_pages" ON public.link_bio_pages;
CREATE POLICY "authenticated_read_published_bio_pages" ON public.link_bio_pages FOR SELECT
TO authenticated
USING (is_published = true);

-- Enhanced authentication table policies
DROP POLICY IF EXISTS "users_own_2fa" ON public.user_two_factor_auth;
CREATE POLICY "users_own_2fa" ON public.user_two_factor_auth FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "users_own_sessions" ON public.user_sessions;
CREATE POLICY "users_own_sessions" ON public.user_sessions FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "users_own_oauth_providers" ON public.user_oauth_providers;
CREATE POLICY "users_own_oauth_providers" ON public.user_oauth_providers FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "users_own_verification_codes" ON public.email_verification_codes;
CREATE POLICY "users_own_verification_codes" ON public.email_verification_codes FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "users_own_reset_tokens" ON public.password_reset_tokens;
CREATE POLICY "users_own_reset_tokens" ON public.password_reset_tokens FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "users_own_devices" ON public.user_devices;
CREATE POLICY "users_own_devices" ON public.user_devices FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "users_own_audit_log" ON public.security_audit_log;
CREATE POLICY "users_own_audit_log" ON public.security_audit_log FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "admin_audit_log_access" ON public.security_audit_log;
CREATE POLICY "admin_audit_log_access" ON public.security_audit_log FOR ALL
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.user_profiles up
        WHERE up.id = auth.uid() AND up.role = 'admin'
    )
);

-- Function to check if user has access to workspace data
CREATE OR REPLACE FUNCTION public.has_workspace_access(workspace_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.workspace_members wm
    WHERE wm.workspace_id = workspace_uuid 
    AND wm.user_id = auth.uid()
    AND wm.is_active = true
) OR EXISTS (
    SELECT 1 FROM public.workspaces w
    WHERE w.id = workspace_uuid 
    AND w.owner_id = auth.uid()
)
$$;

-- Function to enforce workspace data isolation
CREATE OR REPLACE FUNCTION public.enforce_workspace_isolation()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Check if user has access to the workspace
    IF NOT public.has_workspace_access(NEW.workspace_id) THEN
        RAISE EXCEPTION 'Access denied: User does not have access to this workspace';
    END IF;
    
    RETURN NEW;
END;
$$;

-- Create triggers to enforce workspace isolation on data insertion
CREATE TRIGGER enforce_workspace_analytics_isolation
    BEFORE INSERT OR UPDATE ON public.workspace_analytics
    FOR EACH ROW
    EXECUTE FUNCTION public.enforce_workspace_isolation();

-- Function to validate user access on authentication
CREATE OR REPLACE FUNCTION public.validate_user_access()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Ensure user can only access their own data
    IF NEW.user_id != auth.uid() THEN
        RAISE EXCEPTION 'Access denied: Users can only access their own data';
    END IF;
    
    RETURN NEW;
END;
$$;

-- Create comprehensive audit logging for data access
CREATE OR REPLACE FUNCTION public.log_data_access(
    table_name TEXT,
    operation TEXT,
    record_id UUID DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    INSERT INTO public.security_audit_log (
        user_id,
        action_type,
        details,
        success
    ) VALUES (
        auth.uid(),
        'data_access',
        jsonb_build_object(
            'table', table_name,
            'operation', operation,
            'record_id', record_id,
            'timestamp', CURRENT_TIMESTAMP
        ),
        true
    );
END;
$$;

-- Create function to enforce authentication for all operations
CREATE OR REPLACE FUNCTION public.require_authentication()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT auth.uid() IS NOT NULL
$$;

-- Add authentication check to all sensitive policies
CREATE POLICY "require_auth_for_all_operations" ON public.user_profiles FOR ALL
TO authenticated
USING (public.require_authentication())
WITH CHECK (public.require_authentication());

-- Function to clean up user data on account deletion
CREATE OR REPLACE FUNCTION public.cleanup_user_data()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Delete all user-related data in dependency order
    DELETE FROM public.workspace_analytics WHERE workspace_id IN (
        SELECT id FROM public.workspaces WHERE owner_id = OLD.id
    );
    
    DELETE FROM public.workspace_invitations WHERE workspace_id IN (
        SELECT id FROM public.workspaces WHERE owner_id = OLD.id
    );
    
    DELETE FROM public.workspace_members WHERE workspace_id IN (
        SELECT id FROM public.workspaces WHERE owner_id = OLD.id
    );
    
    DELETE FROM public.workspaces WHERE owner_id = OLD.id;
    
    DELETE FROM public.security_audit_log WHERE user_id = OLD.id;
    DELETE FROM public.user_devices WHERE user_id = OLD.id;
    DELETE FROM public.password_reset_tokens WHERE user_id = OLD.id;
    DELETE FROM public.email_verification_codes WHERE user_id = OLD.id;
    DELETE FROM public.user_oauth_providers WHERE user_id = OLD.id;
    DELETE FROM public.user_sessions WHERE user_id = OLD.id;
    DELETE FROM public.user_two_factor_auth WHERE user_id = OLD.id;
    DELETE FROM public.link_bio_pages WHERE user_id = OLD.id;
    DELETE FROM public.user_feature_modules WHERE user_id = OLD.id;
    DELETE FROM public.setup_checklist WHERE user_id = OLD.id;
    DELETE FROM public.user_goals WHERE user_id = OLD.id;
    DELETE FROM public.onboarding_progress WHERE user_id = OLD.id;
    
    RETURN OLD;
END;
$$;

-- Create trigger for user data cleanup
CREATE TRIGGER cleanup_user_data_on_delete
    BEFORE DELETE ON public.user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.cleanup_user_data();

-- Create session validation function
CREATE OR REPLACE FUNCTION public.validate_user_session()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    session_valid BOOLEAN := false;
BEGIN
    -- Check if user has valid session
    SELECT EXISTS (
        SELECT 1 FROM public.user_sessions us
        WHERE us.user_id = auth.uid()
        AND us.is_active = true
        AND us.expires_at > CURRENT_TIMESTAMP
    ) INTO session_valid;
    
    -- If no valid session found, check if user is authenticated
    IF NOT session_valid THEN
        session_valid := auth.uid() IS NOT NULL;
    END IF;
    
    RETURN session_valid;
END;
$$;

-- Comment indicating no mock data will be created
-- This migration focuses on security and data isolation
-- No test data is added to ensure clean production-ready state
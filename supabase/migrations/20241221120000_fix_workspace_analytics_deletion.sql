-- Location: supabase/migrations/20241221120000_fix_workspace_analytics_deletion.sql
-- Fix workspace analytics table deletion errors

-- Create workspace_analytics table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.workspace_analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID,
    metric_type TEXT NOT NULL,
    metric_value DECIMAL(12,2) DEFAULT 0,
    metric_data JSONB DEFAULT '{}',
    recorded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    date_bucket DATE DEFAULT CURRENT_DATE
);

-- Add foreign key constraint if it doesn't exist
DO $$
BEGIN
    -- Check if workspaces table exists and add foreign key if both tables exist
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'workspaces') THEN
        -- Add foreign key constraint if it doesn't exist
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.table_constraints 
            WHERE table_schema = 'public' 
            AND table_name = 'workspace_analytics' 
            AND constraint_type = 'FOREIGN KEY'
            AND constraint_name = 'workspace_analytics_workspace_id_fkey'
        ) THEN
            ALTER TABLE public.workspace_analytics 
            ADD CONSTRAINT workspace_analytics_workspace_id_fkey 
            FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;
        END IF;
    END IF;
END $$;

-- Create index if it doesn't exist
CREATE INDEX IF NOT EXISTS idx_workspace_analytics_workspace_id ON public.workspace_analytics(workspace_id);
CREATE INDEX IF NOT EXISTS idx_workspace_analytics_date_bucket ON public.workspace_analytics(date_bucket);

-- Enable RLS if not already enabled
ALTER TABLE public.workspace_analytics ENABLE ROW LEVEL SECURITY;

-- Safe deletion of mock data with existence checks
DO $$
BEGIN
    -- Delete workspace analytics data safely
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'workspace_analytics') THEN
        DELETE FROM public.workspace_analytics WHERE workspace_id IN (
            SELECT id FROM public.workspaces WHERE owner_id IN (
                SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
            )
        );
    END IF;

    -- Delete workspace invitations safely
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'workspace_invitations') THEN
        DELETE FROM public.workspace_invitations WHERE workspace_id IN (
            SELECT id FROM public.workspaces WHERE owner_id IN (
                SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
            )
        );
    END IF;

    -- Delete team invitations safely (alternative table name)
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'team_invitations') THEN
        DELETE FROM public.team_invitations WHERE workspace_id IN (
            SELECT id FROM public.workspaces WHERE owner_id IN (
                SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
            )
        );
    END IF;

    -- Delete workspace members safely
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'workspace_members') THEN
        DELETE FROM public.workspace_members WHERE workspace_id IN (
            SELECT id FROM public.workspaces WHERE owner_id IN (
                SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
            )
        );
    END IF;

    -- Delete workspace features safely
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'workspace_features') THEN
        DELETE FROM public.workspace_features WHERE workspace_id IN (
            SELECT id FROM public.workspaces WHERE owner_id IN (
                SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
            )
        );
    END IF;

    -- Delete workspaces safely
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'workspaces') THEN
        DELETE FROM public.workspaces WHERE owner_id IN (
            SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
        );
    END IF;

    -- Delete other user-related data safely
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'security_audit_log') THEN
        DELETE FROM public.security_audit_log WHERE user_id IN (
            SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
        );
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'user_devices') THEN
        DELETE FROM public.user_devices WHERE user_id IN (
            SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
        );
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'password_reset_tokens') THEN
        DELETE FROM public.password_reset_tokens WHERE user_id IN (
            SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
        );
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'email_verification_codes') THEN
        DELETE FROM public.email_verification_codes WHERE user_id IN (
            SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
        );
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'user_oauth_providers') THEN
        DELETE FROM public.user_oauth_providers WHERE user_id IN (
            SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
        );
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'user_sessions') THEN
        DELETE FROM public.user_sessions WHERE user_id IN (
            SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
        );
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'user_two_factor_auth') THEN
        DELETE FROM public.user_two_factor_auth WHERE user_id IN (
            SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
        );
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'link_bio_pages') THEN
        DELETE FROM public.link_bio_pages WHERE user_id IN (
            SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
        );
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'user_feature_modules') THEN
        DELETE FROM public.user_feature_modules WHERE user_id IN (
            SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
        );
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'setup_checklist') THEN
        DELETE FROM public.setup_checklist WHERE user_id IN (
            SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
        );
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'user_goals') THEN
        DELETE FROM public.user_goals WHERE user_id IN (
            SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
        );
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'onboarding_progress') THEN
        DELETE FROM public.onboarding_progress WHERE user_id IN (
            SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
        );
    END IF;

    -- Delete user profiles safely
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'user_profiles') THEN
        DELETE FROM public.user_profiles WHERE email LIKE '%@mewayz.com';
    END IF;

    -- Delete auth users safely
    DELETE FROM auth.users WHERE email LIKE '%@mewayz.com';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error during safe data cleanup: %', SQLERRM;
END $$;

-- Add RLS policy for workspace_analytics if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'workspace_analytics' 
        AND policyname = 'workspace_analytics_access'
    ) THEN
        CREATE POLICY "workspace_analytics_access" ON public.workspace_analytics FOR ALL
        TO authenticated
        USING (
            EXISTS (
                SELECT 1 FROM public.workspace_members wm
                WHERE wm.workspace_id = workspace_analytics.workspace_id 
                AND wm.user_id = auth.uid()
                AND wm.is_active = true
            ) OR EXISTS (
                SELECT 1 FROM public.workspaces w
                WHERE w.id = workspace_analytics.workspace_id 
                AND w.owner_id = auth.uid()
            )
        )
        WITH CHECK (
            EXISTS (
                SELECT 1 FROM public.workspace_members wm
                WHERE wm.workspace_id = workspace_analytics.workspace_id 
                AND wm.user_id = auth.uid()
                AND wm.is_active = true
            ) OR EXISTS (
                SELECT 1 FROM public.workspaces w
                WHERE w.id = workspace_analytics.workspace_id 
                AND w.owner_id = auth.uid()
            )
        );
    END IF;
END $$;

-- Create function to safely clean up workspace analytics
CREATE OR REPLACE FUNCTION public.cleanup_workspace_analytics()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Remove any orphaned analytics records
    DELETE FROM public.workspace_analytics 
    WHERE workspace_id NOT IN (
        SELECT id FROM public.workspaces
    );
    
    -- Log cleanup action
    RAISE NOTICE 'Workspace analytics cleanup completed successfully';
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Workspace analytics cleanup failed: %', SQLERRM;
END;
$$;

-- Run cleanup function
SELECT public.cleanup_workspace_analytics();
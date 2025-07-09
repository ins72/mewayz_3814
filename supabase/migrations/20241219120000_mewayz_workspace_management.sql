-- Location: supabase/migrations/20241219120000_mewayz_workspace_management.sql
-- Mewayz Workspace Management System

-- 1. Types and Enums
CREATE TYPE public.workspace_goal AS ENUM ('social_media_growth', 'e_commerce_sales', 'course_creation', 'lead_generation', 'content_creation', 'brand_building', 'other');
CREATE TYPE public.workspace_status AS ENUM ('active', 'suspended', 'archived');
CREATE TYPE public.member_role AS ENUM ('owner', 'admin', 'editor', 'viewer');
CREATE TYPE public.invitation_status AS ENUM ('pending', 'accepted', 'declined', 'expired');

-- 2. Core Tables

-- Workspaces table
CREATE TABLE public.workspaces (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    owner_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    goal public.workspace_goal NOT NULL,
    custom_goal_description TEXT,
    status public.workspace_status DEFAULT 'active'::public.workspace_status,
    logo_url TEXT,
    theme_settings JSONB DEFAULT '{}',
    features_enabled JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Workspace members table
CREATE TABLE public.workspace_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    role public.member_role DEFAULT 'viewer'::public.member_role,
    joined_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    invited_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    is_active BOOLEAN DEFAULT true,
    UNIQUE(workspace_id, user_id)
);

-- Workspace invitations table
CREATE TABLE public.workspace_invitations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    role public.member_role DEFAULT 'viewer'::public.member_role,
    invited_by UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    status public.invitation_status DEFAULT 'pending'::public.invitation_status,
    invitation_token TEXT NOT NULL,
    message TEXT,
    expires_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP + INTERVAL '7 days',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Workspace analytics table
CREATE TABLE public.workspace_analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    metric_type TEXT NOT NULL,
    metric_value DECIMAL(12,2) DEFAULT 0,
    metric_data JSONB DEFAULT '{}',
    recorded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    date_bucket DATE DEFAULT CURRENT_DATE
);

-- 3. Essential Indexes
CREATE INDEX idx_workspaces_owner_id ON public.workspaces(owner_id);
CREATE INDEX idx_workspaces_goal ON public.workspaces(goal);
CREATE INDEX idx_workspaces_status ON public.workspaces(status);
CREATE INDEX idx_workspace_members_workspace_id ON public.workspace_members(workspace_id);
CREATE INDEX idx_workspace_members_user_id ON public.workspace_members(user_id);
CREATE INDEX idx_workspace_invitations_workspace_id ON public.workspace_invitations(workspace_id);
CREATE INDEX idx_workspace_invitations_email ON public.workspace_invitations(email);
CREATE INDEX idx_workspace_invitations_token ON public.workspace_invitations(invitation_token);
CREATE INDEX idx_workspace_analytics_workspace_id ON public.workspace_analytics(workspace_id);
CREATE INDEX idx_workspace_analytics_date_bucket ON public.workspace_analytics(date_bucket);

-- 4. RLS Setup
ALTER TABLE public.workspaces ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workspace_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workspace_invitations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workspace_analytics ENABLE ROW LEVEL SECURITY;

-- 5. Helper Functions for RLS
CREATE OR REPLACE FUNCTION public.is_workspace_member(workspace_uuid UUID)
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
)
$$;

CREATE OR REPLACE FUNCTION public.is_workspace_owner(workspace_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.workspaces w
    WHERE w.id = workspace_uuid 
    AND w.owner_id = auth.uid()
)
$$;

CREATE OR REPLACE FUNCTION public.can_manage_workspace(workspace_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.workspace_members wm
    WHERE wm.workspace_id = workspace_uuid 
    AND wm.user_id = auth.uid()
    AND wm.role IN ('owner', 'admin')
    AND wm.is_active = true
)
$$;

CREATE OR REPLACE FUNCTION public.get_workspace_features_for_goal(selected_goal public.workspace_goal)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    CASE selected_goal
        WHEN 'social_media_growth' THEN
            RETURN '{"social_media_manager": true, "analytics_dashboard": true, "content_calendar": true, "hashtag_research": true, "instagram_lead_search": true}'::jsonb;
        WHEN 'e_commerce_sales' THEN
            RETURN '{"marketplace_store": true, "analytics_dashboard": true, "crm_contact_management": true, "email_marketing": true, "qr_code_generator": true}'::jsonb;
        WHEN 'course_creation' THEN
            RETURN '{"course_creator": true, "analytics_dashboard": true, "email_marketing": true, "content_templates": true}'::jsonb;
        WHEN 'lead_generation' THEN
            RETURN '{"crm_contact_management": true, "analytics_dashboard": true, "email_marketing": true, "instagram_lead_search": true, "qr_code_generator": true}'::jsonb;
        WHEN 'content_creation' THEN
            RETURN '{"content_templates": true, "social_media_manager": true, "content_calendar": true, "multi_platform_posting": true}'::jsonb;
        WHEN 'brand_building' THEN
            RETURN '{"social_media_manager": true, "analytics_dashboard": true, "content_calendar": true, "link_in_bio_builder": true, "qr_code_generator": true}'::jsonb;
        ELSE
            RETURN '{"analytics_dashboard": true}'::jsonb;
    END CASE;
END;
$$;

-- Function to create workspace with default settings
CREATE OR REPLACE FUNCTION public.create_workspace(
    workspace_name TEXT,
    workspace_description TEXT,
    workspace_goal public.workspace_goal,
    custom_goal_desc TEXT DEFAULT NULL,
    owner_uuid UUID DEFAULT auth.uid()
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    new_workspace_id UUID;
    default_features JSONB;
BEGIN
    -- Get default features for the goal
    default_features := public.get_workspace_features_for_goal(workspace_goal);
    
    -- Create workspace
    INSERT INTO public.workspaces (
        name, 
        description, 
        owner_id, 
        goal, 
        custom_goal_description,
        features_enabled
    ) VALUES (
        workspace_name,
        workspace_description,
        owner_uuid,
        workspace_goal,
        custom_goal_desc,
        default_features
    ) RETURNING id INTO new_workspace_id;
    
    -- Add owner as first member
    INSERT INTO public.workspace_members (workspace_id, user_id, role, invited_by)
    VALUES (new_workspace_id, owner_uuid, 'owner', owner_uuid);
    
    -- Initialize basic analytics
    INSERT INTO public.workspace_analytics (workspace_id, metric_type, metric_value, metric_data)
    VALUES 
        (new_workspace_id, 'total_members', 1, '{"description": "Total workspace members"}'::jsonb),
        (new_workspace_id, 'features_enabled', jsonb_array_length(to_jsonb(jsonb_object_keys(default_features))), '{"description": "Number of enabled features"}'::jsonb);
    
    RETURN new_workspace_id;
END;
$$;

-- Function to invite member to workspace
CREATE OR REPLACE FUNCTION public.invite_workspace_member(
    workspace_uuid UUID,
    member_email TEXT,
    member_role public.member_role,
    invitation_message TEXT DEFAULT NULL,
    inviter_uuid UUID DEFAULT auth.uid()
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    invitation_id UUID;
    invitation_token TEXT;
BEGIN
    -- Generate invitation token
    invitation_token := encode(gen_random_bytes(32), 'hex');
    
    -- Create invitation
    INSERT INTO public.workspace_invitations (
        workspace_id,
        email,
        role,
        invited_by,
        invitation_token,
        message
    ) VALUES (
        workspace_uuid,
        member_email,
        member_role,
        inviter_uuid,
        invitation_token,
        invitation_message
    ) RETURNING id INTO invitation_id;
    
    RETURN invitation_id;
END;
$$;

-- Function to accept workspace invitation
CREATE OR REPLACE FUNCTION public.accept_workspace_invitation(
    invitation_token TEXT,
    accepting_user_uuid UUID DEFAULT auth.uid()
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    invitation_record RECORD;
BEGIN
    -- Get invitation details
    SELECT * INTO invitation_record 
    FROM public.workspace_invitations 
    WHERE invitation_token = invitation_token 
    AND status = 'pending' 
    AND expires_at > CURRENT_TIMESTAMP;
    
    IF NOT FOUND THEN
        RETURN false;
    END IF;
    
    -- Add member to workspace
    INSERT INTO public.workspace_members (workspace_id, user_id, role, invited_by)
    VALUES (
        invitation_record.workspace_id,
        accepting_user_uuid,
        invitation_record.role,
        invitation_record.invited_by
    )
    ON CONFLICT (workspace_id, user_id) DO UPDATE SET
        role = EXCLUDED.role,
        is_active = true;
    
    -- Update invitation status
    UPDATE public.workspace_invitations
    SET status = 'accepted', updated_at = CURRENT_TIMESTAMP
    WHERE id = invitation_record.id;
    
    -- Update member count analytics
    INSERT INTO public.workspace_analytics (workspace_id, metric_type, metric_value, metric_data)
    VALUES (
        invitation_record.workspace_id,
        'member_joined',
        1,
        jsonb_build_object('user_id', accepting_user_uuid, 'role', invitation_record.role)
    );
    
    RETURN true;
END;
$$;

-- Function to get workspace analytics
CREATE OR REPLACE FUNCTION public.get_workspace_dashboard_metrics(workspace_uuid UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    workspace_goal_type public.workspace_goal;
    metrics JSONB := '{}';
    member_count INTEGER;
    features_count INTEGER;
BEGIN
    -- Get workspace goal
    SELECT goal INTO workspace_goal_type FROM public.workspaces WHERE id = workspace_uuid;
    
    -- Get member count
    SELECT COUNT(*) INTO member_count FROM public.workspace_members WHERE workspace_id = workspace_uuid AND is_active = true;
    
    -- Get features count
    SELECT jsonb_array_length(to_jsonb(jsonb_object_keys(features_enabled))) INTO features_count
    FROM public.workspaces WHERE id = workspace_uuid;
    
    -- Build metrics based on goal
    CASE workspace_goal_type
        WHEN 'social_media_growth' THEN
            metrics := jsonb_build_object(
                'followers', 0,
                'engagement_rate', 0,
                'posts_scheduled', 0,
                'reach', 0,
                'member_count', member_count,
                'features_enabled', features_count
            );
        WHEN 'e_commerce_sales' THEN
            metrics := jsonb_build_object(
                'revenue', 0,
                'orders', 0,
                'products', 0,
                'conversion_rate', 0,
                'member_count', member_count,
                'features_enabled', features_count
            );
        WHEN 'course_creation' THEN
            metrics := jsonb_build_object(
                'students', 0,
                'courses', 0,
                'completion_rate', 0,
                'revenue', 0,
                'member_count', member_count,
                'features_enabled', features_count
            );
        WHEN 'lead_generation' THEN
            metrics := jsonb_build_object(
                'leads_captured', 0,
                'conversion_rate', 0,
                'email_opens', 0,
                'campaigns', 0,
                'member_count', member_count,
                'features_enabled', features_count
            );
        ELSE
            metrics := jsonb_build_object(
                'total_activity', 0,
                'member_count', member_count,
                'features_enabled', features_count
            );
    END CASE;
    
    RETURN metrics;
END;
$$;

-- 6. RLS Policies
CREATE POLICY "workspace_members_access" ON public.workspaces FOR ALL
USING (public.is_workspace_member(id) OR public.is_workspace_owner(id));

CREATE POLICY "workspace_members_can_view" ON public.workspace_members FOR SELECT
USING (public.is_workspace_member(workspace_id));

CREATE POLICY "workspace_admins_can_manage" ON public.workspace_members FOR ALL
USING (public.can_manage_workspace(workspace_id));

CREATE POLICY "workspace_invitations_access" ON public.workspace_invitations FOR ALL
USING (public.can_manage_workspace(workspace_id));

CREATE POLICY "workspace_analytics_access" ON public.workspace_analytics FOR ALL
USING (public.is_workspace_member(workspace_id));

-- 7. Mock Data
DO $$
DECLARE
    creator_uuid UUID;
    workspace_id UUID;
    invitation_id UUID;
BEGIN
    -- Get existing user
    SELECT id INTO creator_uuid FROM public.user_profiles WHERE email = 'creator@mewayz.com';
    
    IF creator_uuid IS NOT NULL THEN
        -- Create sample workspace
        workspace_id := public.create_workspace(
            'Creative Studio',
            'Digital marketing and content creation workspace',
            'social_media_growth',
            NULL,
            creator_uuid
        );
        
        -- Create another workspace for e-commerce
        PERFORM public.create_workspace(
            'Online Store',
            'E-commerce business workspace',
            'e_commerce_sales',
            NULL,
            creator_uuid
        );
        
        -- Create invitation
        invitation_id := public.invite_workspace_member(
            workspace_id,
            'team@example.com',
            'editor',
            'Welcome to our creative workspace!',
            creator_uuid
        );
        
        -- Add some analytics data
        INSERT INTO public.workspace_analytics (workspace_id, metric_type, metric_value, metric_data)
        VALUES 
            (workspace_id, 'followers', 1250, '{"platform": "instagram", "growth": 15.5}'::jsonb),
            (workspace_id, 'engagement_rate', 4.2, '{"platform": "instagram", "trend": "up"}'::jsonb),
            (workspace_id, 'posts_scheduled', 12, '{"this_week": 12, "next_week": 8}'::jsonb);
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error creating workspace test data: %', SQLERRM;
END $$;

-- 8. Cleanup function
CREATE OR REPLACE FUNCTION public.cleanup_workspace_test_data()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    test_workspace_ids UUID[];
BEGIN
    -- Get workspace IDs for test data
    SELECT ARRAY_AGG(id) INTO test_workspace_ids
    FROM public.workspaces
    WHERE owner_id IN (
        SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
    );
    
    -- Delete in dependency order
    DELETE FROM public.workspace_analytics WHERE workspace_id = ANY(test_workspace_ids);
    DELETE FROM public.workspace_invitations WHERE workspace_id = ANY(test_workspace_ids);
    DELETE FROM public.workspace_members WHERE workspace_id = ANY(test_workspace_ids);
    DELETE FROM public.workspaces WHERE id = ANY(test_workspace_ids);
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Workspace cleanup failed: %', SQLERRM;
END;
$$;
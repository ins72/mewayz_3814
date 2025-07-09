-- Location: supabase/migrations/20241219120000_workspace_management_system.sql
-- Workspace management system with goal-based features

-- Workspace-specific types and enums
CREATE TYPE public.workspace_goal AS ENUM (
  'social_media_management',
  'ecommerce_business', 
  'course_creation',
  'lead_generation',
  'all_in_one_business'
);

CREATE TYPE public.workspace_privacy AS ENUM ('public', 'private', 'team_only');
CREATE TYPE public.member_role AS ENUM ('owner', 'admin', 'manager', 'member', 'viewer');
CREATE TYPE public.invitation_status AS ENUM ('pending', 'accepted', 'declined', 'expired');

-- Workspaces table
CREATE TABLE public.workspaces (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    logo_url TEXT,
    owner_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    workspace_url TEXT UNIQUE,
    goal public.workspace_goal NOT NULL,
    privacy_level public.workspace_privacy DEFAULT 'private'::public.workspace_privacy,
    default_member_permissions JSONB DEFAULT '{"can_view": true, "can_edit": false, "can_invite": false}',
    billing_preferences JSONB DEFAULT '{}',
    settings JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Workspace members table
CREATE TABLE public.workspace_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    role public.member_role DEFAULT 'member'::public.member_role,
    permissions JSONB DEFAULT '{}',
    joined_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    invited_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    is_active BOOLEAN DEFAULT true,
    UNIQUE(workspace_id, user_id)
);

-- Team invitations table
CREATE TABLE public.team_invitations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    role public.member_role DEFAULT 'member'::public.member_role,
    invited_by UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    invitation_token TEXT UNIQUE DEFAULT gen_random_uuid()::TEXT,
    status public.invitation_status DEFAULT 'pending'::public.invitation_status,
    custom_message TEXT,
    expires_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP + INTERVAL '7 days',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Workspace features table
CREATE TABLE public.workspace_features (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    feature_key TEXT NOT NULL,
    is_enabled BOOLEAN DEFAULT false,
    configuration JSONB DEFAULT '{}',
    enabled_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(workspace_id, feature_key)
);

-- Indexes for performance
CREATE INDEX idx_workspaces_owner_id ON public.workspaces(owner_id);
CREATE INDEX idx_workspaces_goal ON public.workspaces(goal);
CREATE INDEX idx_workspaces_url ON public.workspaces(workspace_url);
CREATE INDEX idx_workspace_members_workspace_id ON public.workspace_members(workspace_id);
CREATE INDEX idx_workspace_members_user_id ON public.workspace_members(user_id);
CREATE INDEX idx_team_invitations_workspace_id ON public.team_invitations(workspace_id);
CREATE INDEX idx_team_invitations_email ON public.team_invitations(email);
CREATE INDEX idx_team_invitations_token ON public.team_invitations(invitation_token);
CREATE INDEX idx_workspace_features_workspace_id ON public.workspace_features(workspace_id);

-- Enable RLS
ALTER TABLE public.workspaces ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workspace_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.team_invitations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workspace_features ENABLE ROW LEVEL SECURITY;

-- Helper functions for workspace access control
CREATE OR REPLACE FUNCTION public.is_workspace_owner(workspace_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.workspaces w
    WHERE w.id = workspace_uuid AND w.owner_id = auth.uid()
)
$$;

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

CREATE OR REPLACE FUNCTION public.can_access_workspace(workspace_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT public.is_workspace_owner(workspace_uuid) OR public.is_workspace_member(workspace_uuid)
$$;

CREATE OR REPLACE FUNCTION public.can_invite_to_workspace(workspace_uuid UUID)
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
    AND (wm.role IN ('owner', 'admin', 'manager') OR (wm.permissions->>'can_invite')::boolean = true)
)
$$;

-- Function to generate default workspace features based on goal
CREATE OR REPLACE FUNCTION public.setup_workspace_features(workspace_uuid UUID, selected_goal public.workspace_goal)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Common features for all workspaces
    INSERT INTO public.workspace_features (workspace_id, feature_key, is_enabled)
    VALUES 
        (workspace_uuid, 'dashboard', true),
        (workspace_uuid, 'analytics', true),
        (workspace_uuid, 'team_management', true);
    
    -- Goal-specific features
    CASE selected_goal
        WHEN 'social_media_management' THEN
            INSERT INTO public.workspace_features (workspace_id, feature_key, is_enabled)
            VALUES 
                (workspace_uuid, 'social_media_scheduler', true),
                (workspace_uuid, 'content_calendar', true),
                (workspace_uuid, 'hashtag_research', true),
                (workspace_uuid, 'social_analytics', true);
        
        WHEN 'ecommerce_business' THEN
            INSERT INTO public.workspace_features (workspace_id, feature_key, is_enabled)
            VALUES 
                (workspace_uuid, 'product_catalog', true),
                (workspace_uuid, 'order_management', true),
                (workspace_uuid, 'inventory_tracking', true),
                (workspace_uuid, 'payment_processing', true);
        
        WHEN 'course_creation' THEN
            INSERT INTO public.workspace_features (workspace_id, feature_key, is_enabled)
            VALUES 
                (workspace_uuid, 'course_builder', true),
                (workspace_uuid, 'student_management', true),
                (workspace_uuid, 'progress_tracking', true),
                (workspace_uuid, 'assessment_tools', true);
        
        WHEN 'lead_generation' THEN
            INSERT INTO public.workspace_features (workspace_id, feature_key, is_enabled)
            VALUES 
                (workspace_uuid, 'crm_system', true),
                (workspace_uuid, 'lead_capture', true),
                (workspace_uuid, 'email_marketing', true),
                (workspace_uuid, 'conversion_tracking', true);
        
        WHEN 'all_in_one_business' THEN
            INSERT INTO public.workspace_features (workspace_id, feature_key, is_enabled)
            VALUES 
                (workspace_uuid, 'social_media_scheduler', true),
                (workspace_uuid, 'product_catalog', true),
                (workspace_uuid, 'crm_system', true),
                (workspace_uuid, 'email_marketing', true),
                (workspace_uuid, 'content_calendar', true),
                (workspace_uuid, 'lead_capture', true);
        
        ELSE
            -- Default features for unknown goals
            INSERT INTO public.workspace_features (workspace_id, feature_key, is_enabled)
            VALUES (workspace_uuid, 'basic_tools', true);
    END CASE;
END;
$$;

-- Function to create workspace with owner membership
CREATE OR REPLACE FUNCTION public.create_workspace_with_owner(
    workspace_name TEXT,
    workspace_description TEXT,
    workspace_goal public.workspace_goal,
    owner_user_id UUID
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    new_workspace_id UUID;
    workspace_url_slug TEXT;
BEGIN
    -- Generate URL slug from workspace name
    workspace_url_slug := lower(regexp_replace(workspace_name, '[^a-zA-Z0-9]', '-', 'g'));
    workspace_url_slug := regexp_replace(workspace_url_slug, '-+', '-', 'g');
    workspace_url_slug := trim(workspace_url_slug, '-');
    
    -- Create workspace
    INSERT INTO public.workspaces (name, description, owner_id, workspace_url, goal)
    VALUES (workspace_name, workspace_description, owner_user_id, workspace_url_slug, workspace_goal)
    RETURNING id INTO new_workspace_id;
    
    -- Add owner as member
    INSERT INTO public.workspace_members (workspace_id, user_id, role, permissions)
    VALUES (
        new_workspace_id, 
        owner_user_id, 
        'owner'::public.member_role,
        '{"can_view": true, "can_edit": true, "can_invite": true, "can_manage": true}'::jsonb
    );
    
    -- Setup goal-based features
    PERFORM public.setup_workspace_features(new_workspace_id, workspace_goal);
    
    RETURN new_workspace_id;
END;
$$;

-- Function to send team invitation
CREATE OR REPLACE FUNCTION public.send_team_invitation(
    workspace_uuid UUID,
    invitee_email TEXT,
    invitee_role public.member_role,
    inviter_user_id UUID,
    custom_message_text TEXT DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    invitation_id UUID;
BEGIN
    -- Check if user can invite to workspace
    IF NOT public.can_invite_to_workspace(workspace_uuid) THEN
        RAISE EXCEPTION 'User does not have permission to invite to this workspace';
    END IF;
    
    -- Create invitation
    INSERT INTO public.team_invitations (workspace_id, email, role, invited_by, custom_message)
    VALUES (workspace_uuid, invitee_email, invitee_role, inviter_user_id, custom_message_text)
    RETURNING id INTO invitation_id;
    
    RETURN invitation_id;
END;
$$;

-- Function to accept team invitation
CREATE OR REPLACE FUNCTION public.accept_team_invitation(invitation_token_param TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    invitation_record RECORD;
    user_id UUID := auth.uid();
BEGIN
    -- Get invitation details
    SELECT * INTO invitation_record
    FROM public.team_invitations
    WHERE invitation_token = invitation_token_param
    AND status = 'pending'
    AND expires_at > CURRENT_TIMESTAMP;
    
    IF NOT FOUND THEN
        RETURN false;
    END IF;
    
    -- Add user to workspace
    INSERT INTO public.workspace_members (workspace_id, user_id, role, invited_by)
    VALUES (invitation_record.workspace_id, user_id, invitation_record.role, invitation_record.invited_by)
    ON CONFLICT (workspace_id, user_id) DO UPDATE SET
        role = invitation_record.role,
        is_active = true,
        joined_at = CURRENT_TIMESTAMP;
    
    -- Update invitation status
    UPDATE public.team_invitations
    SET status = 'accepted', updated_at = CURRENT_TIMESTAMP
    WHERE id = invitation_record.id;
    
    RETURN true;
END;
$$;

-- RLS Policies
CREATE POLICY "users_own_workspaces" ON public.workspaces FOR ALL
USING (public.is_workspace_owner(id)) WITH CHECK (public.is_workspace_owner(id));

CREATE POLICY "workspace_members_can_view" ON public.workspaces FOR SELECT
USING (public.can_access_workspace(id));

CREATE POLICY "workspace_members_access" ON public.workspace_members FOR ALL
USING (public.can_access_workspace(workspace_id)) WITH CHECK (public.can_access_workspace(workspace_id));

CREATE POLICY "workspace_invitations_access" ON public.team_invitations FOR ALL
USING (public.can_invite_to_workspace(workspace_id)) WITH CHECK (public.can_invite_to_workspace(workspace_id));

-- Public read access to invitations by token
CREATE POLICY "public_read_invitations_by_token" ON public.team_invitations FOR SELECT
TO public
USING (invitation_token IS NOT NULL);

CREATE POLICY "workspace_features_access" ON public.workspace_features FOR ALL
USING (public.can_access_workspace(workspace_id)) WITH CHECK (public.can_access_workspace(workspace_id));

-- Mock data for testing
DO $$
DECLARE
    creator_uuid UUID;
    workspace_id UUID;
    invitation_id UUID;
BEGIN
    -- Get existing user
    SELECT id INTO creator_uuid FROM public.user_profiles WHERE email = 'creator@mewayz.com';
    
    IF creator_uuid IS NOT NULL THEN
        -- Create test workspace
        workspace_id := public.create_workspace_with_owner(
            'Creative Agency Hub',
            'A comprehensive workspace for managing creative projects and social media campaigns',
            'social_media_management'::public.workspace_goal,
            creator_uuid
        );
        
        -- Send sample invitation
        invitation_id := public.send_team_invitation(
            workspace_id,
            'teammate@example.com',
            'member'::public.member_role,
            creator_uuid,
            'Join our creative team and help us manage amazing social media campaigns!'
        );
        
        -- Create another workspace for testing
        workspace_id := public.create_workspace_with_owner(
            'E-Commerce Solutions',
            'Complete e-commerce business management platform',
            'ecommerce_business'::public.workspace_goal,
            creator_uuid
        );
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error creating workspace test data: %', SQLERRM;
END $$;

-- Cleanup function for workspace test data
CREATE OR REPLACE FUNCTION public.cleanup_workspace_test_data()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    auth_user_ids_to_delete UUID[];
    workspace_ids_to_delete UUID[];
BEGIN
    -- Get auth user IDs
    SELECT ARRAY_AGG(id) INTO auth_user_ids_to_delete
    FROM auth.users
    WHERE email LIKE '%@mewayz.com' OR email LIKE '%@example.com';

    -- Get workspace IDs to delete
    SELECT ARRAY_AGG(id) INTO workspace_ids_to_delete
    FROM public.workspaces
    WHERE owner_id = ANY(auth_user_ids_to_delete);

    -- Delete workspace-related data in dependency order
    DELETE FROM public.workspace_features WHERE workspace_id = ANY(workspace_ids_to_delete);
    DELETE FROM public.team_invitations WHERE workspace_id = ANY(workspace_ids_to_delete);
    DELETE FROM public.workspace_members WHERE workspace_id = ANY(workspace_ids_to_delete);
    DELETE FROM public.workspaces WHERE id = ANY(workspace_ids_to_delete);

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Workspace cleanup failed: %', SQLERRM;
END;
$$;
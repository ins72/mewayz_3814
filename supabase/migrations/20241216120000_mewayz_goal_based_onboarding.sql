-- Location: supabase/migrations/20241216120000_mewayz_goal_based_onboarding.sql
-- Mewayz Goal-Based Onboarding System

-- 1. Types and Enums
CREATE TYPE public.user_role AS ENUM ('admin', 'creator', 'member');
CREATE TYPE public.onboarding_goal AS ENUM ('sell_products', 'showcase_work', 'accept_payments', 'build_brand', 'book_appointments', 'other');
CREATE TYPE public.setup_step_status AS ENUM ('pending', 'in_progress', 'completed', 'skipped');
CREATE TYPE public.feature_module AS ENUM ('storefront', 'profile_page', 'payments', 'booking', 'analytics', 'custom_domain');
CREATE TYPE public.subscription_tier AS ENUM ('free', 'storefront', 'booking', 'analytics_pro', 'custom_domain');

-- 2. Core Tables

-- User profiles table (intermediary for auth relationships)
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id),
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    role public.user_role DEFAULT 'creator'::public.user_role,
    avatar_url TEXT,
    bio TEXT,
    website_url TEXT,
    social_links JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- User goals (selected during onboarding)
CREATE TABLE public.user_goals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    goal public.onboarding_goal NOT NULL,
    is_primary BOOLEAN DEFAULT false,
    custom_goal_description TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Smart setup checklist based on goals
CREATE TABLE public.setup_checklist (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    step_key TEXT NOT NULL,
    step_title TEXT NOT NULL,
    step_description TEXT,
    required_for_goals public.onboarding_goal[] DEFAULT '{}',
    status public.setup_step_status DEFAULT 'pending'::public.setup_step_status,
    order_index INTEGER DEFAULT 0,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Feature modules enabled per user
CREATE TABLE public.user_feature_modules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    module public.feature_module NOT NULL,
    is_enabled BOOLEAN DEFAULT false,
    enabled_at TIMESTAMPTZ,
    subscription_tier public.subscription_tier DEFAULT 'free'::public.subscription_tier,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Onboarding progress tracking
CREATE TABLE public.onboarding_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    current_step INTEGER DEFAULT 0,
    total_steps INTEGER DEFAULT 4,
    completion_percentage DECIMAL(5,2) DEFAULT 0.00,
    is_completed BOOLEAN DEFAULT false,
    completed_at TIMESTAMPTZ,
    session_data JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Link-in-bio pages
CREATE TABLE public.link_bio_pages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    page_title TEXT NOT NULL,
    page_url TEXT UNIQUE NOT NULL,
    template_type TEXT DEFAULT 'basic',
    custom_domain TEXT,
    is_published BOOLEAN DEFAULT false,
    page_config JSONB DEFAULT '{}',
    view_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Essential Indexes
CREATE INDEX idx_user_profiles_email ON public.user_profiles(email);
CREATE INDEX idx_user_goals_user_id ON public.user_goals(user_id);
CREATE INDEX idx_user_goals_goal ON public.user_goals(goal);
CREATE INDEX idx_setup_checklist_user_id ON public.setup_checklist(user_id);
CREATE INDEX idx_setup_checklist_status ON public.setup_checklist(status);
CREATE INDEX idx_user_feature_modules_user_id ON public.user_feature_modules(user_id);
CREATE INDEX idx_user_feature_modules_module ON public.user_feature_modules(module);
CREATE INDEX idx_onboarding_progress_user_id ON public.onboarding_progress(user_id);
CREATE INDEX idx_link_bio_pages_user_id ON public.link_bio_pages(user_id);
CREATE INDEX idx_link_bio_pages_url ON public.link_bio_pages(page_url);

-- 4. RLS Setup
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.setup_checklist ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_feature_modules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.onboarding_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.link_bio_pages ENABLE ROW LEVEL SECURITY;

-- 5. Helper Functions for RLS
CREATE OR REPLACE FUNCTION public.is_owner(user_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT auth.uid() = user_uuid
$$;

CREATE OR REPLACE FUNCTION public.can_access_user_data(target_user_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.user_profiles up
    WHERE up.id = target_user_id AND up.id = auth.uid()
) OR EXISTS (
    SELECT 1 FROM public.user_profiles up
    WHERE up.id = auth.uid() AND up.role = 'admin'
)
$$;

-- Function for automatic profile creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.user_profiles (id, email, full_name, role)
    VALUES (
        NEW.id, 
        NEW.email, 
        COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
        COALESCE((NEW.raw_user_meta_data->>'role')::public.user_role, 'creator'::public.user_role)
    );
    
    -- Initialize onboarding progress
    INSERT INTO public.onboarding_progress (user_id, current_step, total_steps)
    VALUES (NEW.id, 0, 4);
    
    RETURN NEW;
END;
$$;

-- Trigger for new user creation
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Function to generate smart setup checklist
CREATE OR REPLACE FUNCTION public.generate_setup_checklist(user_uuid UUID, selected_goals public.onboarding_goal[])
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Clear existing checklist
    DELETE FROM public.setup_checklist WHERE user_id = user_uuid;
    
    -- Add common steps for all users
    INSERT INTO public.setup_checklist (user_id, step_key, step_title, step_description, order_index)
    VALUES 
        (user_uuid, 'complete_profile', 'Complete Your Profile', 'Add your bio, avatar, and social links', 1),
        (user_uuid, 'create_link_bio', 'Create Link-in-Bio Page', 'Build your personalized link page', 2);
    
    -- Add goal-specific steps
    IF 'sell_products' = ANY(selected_goals) OR 'accept_payments' = ANY(selected_goals) THEN
        INSERT INTO public.setup_checklist (user_id, step_key, step_title, step_description, required_for_goals, order_index)
        VALUES 
            (user_uuid, 'setup_payments', 'Setup Payment Gateway', 'Configure payment processing for your products', ARRAY['sell_products', 'accept_payments']::public.onboarding_goal[], 3),
            (user_uuid, 'create_storefront', 'Create Storefront', 'Set up your online store', ARRAY['sell_products']::public.onboarding_goal[], 4);
    END IF;
    
    IF 'showcase_work' = ANY(selected_goals) OR 'build_brand' = ANY(selected_goals) THEN
        INSERT INTO public.setup_checklist (user_id, step_key, step_title, step_description, required_for_goals, order_index)
        VALUES 
            (user_uuid, 'customize_profile', 'Customize Profile Page', 'Design your professional profile', ARRAY['showcase_work', 'build_brand']::public.onboarding_goal[], 3);
    END IF;
    
    IF 'book_appointments' = ANY(selected_goals) THEN
        INSERT INTO public.setup_checklist (user_id, step_key, step_title, step_description, required_for_goals, order_index)
        VALUES 
            (user_uuid, 'setup_booking', 'Setup Booking System', 'Configure appointment scheduling', ARRAY['book_appointments']::public.onboarding_goal[], 3);
    END IF;
    
    IF 'build_brand' = ANY(selected_goals) THEN
        INSERT INTO public.setup_checklist (user_id, step_key, step_title, step_description, required_for_goals, order_index)
        VALUES 
            (user_uuid, 'setup_custom_domain', 'Setup Custom Domain', 'Connect your own domain name', ARRAY['build_brand']::public.onboarding_goal[], 5);
    END IF;
END;
$$;

-- Function to update onboarding progress
CREATE OR REPLACE FUNCTION public.update_onboarding_progress(user_uuid UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    completed_steps INTEGER;
    total_steps INTEGER;
    completion_pct DECIMAL(5,2);
BEGIN
    -- Count completed steps
    SELECT COUNT(*) INTO completed_steps
    FROM public.setup_checklist
    WHERE user_id = user_uuid AND status = 'completed';
    
    -- Count total steps
    SELECT COUNT(*) INTO total_steps
    FROM public.setup_checklist
    WHERE user_id = user_uuid;
    
    -- Calculate completion percentage
    IF total_steps > 0 THEN
        completion_pct := (completed_steps::DECIMAL / total_steps::DECIMAL) * 100;
    ELSE
        completion_pct := 0;
    END IF;
    
    -- Update progress
    UPDATE public.onboarding_progress
    SET 
        completion_percentage = completion_pct,
        is_completed = (completion_pct >= 100),
        completed_at = CASE WHEN completion_pct >= 100 THEN CURRENT_TIMESTAMP ELSE NULL END,
        updated_at = CURRENT_TIMESTAMP
    WHERE user_id = user_uuid;
END;
$$;

-- 6. RLS Policies
CREATE POLICY "users_own_profile" ON public.user_profiles FOR ALL
USING (public.is_owner(id)) WITH CHECK (public.is_owner(id));

CREATE POLICY "users_own_goals" ON public.user_goals FOR ALL
USING (public.can_access_user_data(user_id)) WITH CHECK (public.can_access_user_data(user_id));

CREATE POLICY "users_own_checklist" ON public.setup_checklist FOR ALL
USING (public.can_access_user_data(user_id)) WITH CHECK (public.can_access_user_data(user_id));

CREATE POLICY "users_own_modules" ON public.user_feature_modules FOR ALL
USING (public.can_access_user_data(user_id)) WITH CHECK (public.can_access_user_data(user_id));

CREATE POLICY "users_own_progress" ON public.onboarding_progress FOR ALL
USING (public.can_access_user_data(user_id)) WITH CHECK (public.can_access_user_data(user_id));

CREATE POLICY "users_own_bio_pages" ON public.link_bio_pages FOR ALL
USING (public.can_access_user_data(user_id)) WITH CHECK (public.can_access_user_data(user_id));

-- Public read access for published bio pages
CREATE POLICY "public_read_published_bio_pages" ON public.link_bio_pages FOR SELECT
TO public
USING (is_published = true);

-- 7. Complete Mock Data
DO $$
DECLARE
    creator_uuid UUID := gen_random_uuid();
    admin_uuid UUID := gen_random_uuid();
    selected_goals public.onboarding_goal[] := ARRAY['sell_products', 'build_brand'];
BEGIN
    -- Create complete auth.users records
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (creator_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'creator@mewayz.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Sarah Johnson", "role": "creator"}'::jsonb, 
         '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (admin_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'admin@mewayz.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Admin User", "role": "admin"}'::jsonb, 
         '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null);

    -- Add user goals
    INSERT INTO public.user_goals (user_id, goal, is_primary, custom_goal_description)
    VALUES 
        (creator_uuid, 'sell_products', true, null),
        (creator_uuid, 'build_brand', false, null),
        (creator_uuid, 'showcase_work', false, null);

    -- Generate setup checklist
    PERFORM public.generate_setup_checklist(creator_uuid, selected_goals);

    -- Add some feature modules
    INSERT INTO public.user_feature_modules (user_id, module, is_enabled, subscription_tier)
    VALUES 
        (creator_uuid, 'storefront', true, 'storefront'),
        (creator_uuid, 'profile_page', true, 'free'),
        (creator_uuid, 'payments', true, 'storefront'),
        (creator_uuid, 'analytics', false, 'free');

    -- Create sample link-in-bio page
    INSERT INTO public.link_bio_pages (user_id, page_title, page_url, template_type, is_published, page_config)
    VALUES 
        (creator_uuid, 'Sarah Johnson - Creative Designer', 'sarahjohnson', 'creative_portfolio', true, 
         '{"theme": "minimal", "colors": {"primary": "#6366f1", "accent": "#f59e0b"}, "blocks": ["bio", "social_links", "products"]}'::jsonb);

    -- Update onboarding progress
    UPDATE public.setup_checklist 
    SET status = 'completed', completed_at = CURRENT_TIMESTAMP
    WHERE user_id = creator_uuid AND step_key IN ('complete_profile', 'create_link_bio');

    PERFORM public.update_onboarding_progress(creator_uuid);

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key error: %', SQLERRM;
    WHEN unique_violation THEN
        RAISE NOTICE 'Unique constraint error: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error: %', SQLERRM;
END $$;

-- 8. Cleanup function for testing
CREATE OR REPLACE FUNCTION public.cleanup_test_data()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    auth_user_ids_to_delete UUID[];
BEGIN
    -- Get auth user IDs first
    SELECT ARRAY_AGG(id) INTO auth_user_ids_to_delete
    FROM auth.users
    WHERE email LIKE '%@mewayz.com';

    -- Delete in dependency order (children first)
    DELETE FROM public.link_bio_pages WHERE user_id = ANY(auth_user_ids_to_delete);
    DELETE FROM public.user_feature_modules WHERE user_id = ANY(auth_user_ids_to_delete);
    DELETE FROM public.setup_checklist WHERE user_id = ANY(auth_user_ids_to_delete);
    DELETE FROM public.user_goals WHERE user_id = ANY(auth_user_ids_to_delete);
    DELETE FROM public.onboarding_progress WHERE user_id = ANY(auth_user_ids_to_delete);
    DELETE FROM public.user_profiles WHERE id = ANY(auth_user_ids_to_delete);

    -- Delete auth.users last
    DELETE FROM auth.users WHERE id = ANY(auth_user_ids_to_delete);

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key constraint prevents deletion: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Cleanup failed: %', SQLERRM;
END;
$$;
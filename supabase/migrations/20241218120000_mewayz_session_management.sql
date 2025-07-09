-- Location: supabase/migrations/20241218120000_mewayz_session_management.sql
-- Enhanced session management and biometric authentication support

-- Add biometric authentication support to user profiles
ALTER TABLE public.user_profiles ADD COLUMN IF NOT EXISTS biometric_enabled BOOLEAN DEFAULT false;
ALTER TABLE public.user_profiles ADD COLUMN IF NOT EXISTS last_login_at TIMESTAMPTZ;
ALTER TABLE public.user_profiles ADD COLUMN IF NOT EXISTS login_attempts INTEGER DEFAULT 0;
ALTER TABLE public.user_profiles ADD COLUMN IF NOT EXISTS account_locked_until TIMESTAMPTZ;

-- Create user preferences table for app settings
CREATE TABLE IF NOT EXISTS public.user_preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    biometric_enabled BOOLEAN DEFAULT false,
    auto_logout_minutes INTEGER DEFAULT 30,
    privacy_mode BOOLEAN DEFAULT false,
    notification_settings JSONB DEFAULT '{}',
    theme_preference TEXT DEFAULT 'dark',
    language_preference TEXT DEFAULT 'en',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create session tracking table
CREATE TABLE IF NOT EXISTS public.user_session_tracking (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    session_start TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    session_end TIMESTAMPTZ,
    device_fingerprint TEXT,
    location_data JSONB,
    session_duration_minutes INTEGER,
    logout_type TEXT DEFAULT 'manual', -- manual, auto, forced
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_user_preferences_user_id ON public.user_preferences(user_id);
CREATE INDEX IF NOT EXISTS idx_user_session_tracking_user_id ON public.user_session_tracking(user_id);
CREATE INDEX IF NOT EXISTS idx_user_session_tracking_session_start ON public.user_session_tracking(session_start);

-- Enable RLS
ALTER TABLE public.user_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_session_tracking ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "users_own_preferences" ON public.user_preferences FOR ALL
USING (public.can_access_user_data(user_id)) WITH CHECK (public.can_access_user_data(user_id));

CREATE POLICY "users_own_session_tracking" ON public.user_session_tracking FOR ALL
USING (public.can_access_user_data(user_id)) WITH CHECK (public.can_access_user_data(user_id));

-- Function to update user login tracking
CREATE OR REPLACE FUNCTION public.update_user_login_tracking(user_uuid UUID, login_successful BOOLEAN DEFAULT true)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    IF login_successful THEN
        -- Reset login attempts on successful login
        UPDATE public.user_profiles 
        SET 
            last_login_at = CURRENT_TIMESTAMP,
            login_attempts = 0,
            account_locked_until = NULL
        WHERE id = user_uuid;
        
        -- Create session tracking record
        INSERT INTO public.user_session_tracking (user_id, session_start)
        VALUES (user_uuid, CURRENT_TIMESTAMP);
    ELSE
        -- Increment login attempts on failed login
        UPDATE public.user_profiles 
        SET 
            login_attempts = login_attempts + 1,
            account_locked_until = CASE 
                WHEN login_attempts >= 5 THEN CURRENT_TIMESTAMP + INTERVAL '15 minutes'
                ELSE account_locked_until
            END
        WHERE id = user_uuid;
    END IF;
END;
$$;

-- Function to check if account is locked
CREATE OR REPLACE FUNCTION public.is_account_locked(user_uuid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.user_profiles up
        WHERE up.id = user_uuid 
        AND up.account_locked_until IS NOT NULL
        AND up.account_locked_until > CURRENT_TIMESTAMP
    );
END;
$$;

-- Function to update session end
CREATE OR REPLACE FUNCTION public.end_user_session(user_uuid UUID, logout_type_param TEXT DEFAULT 'manual')
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE public.user_session_tracking
    SET 
        session_end = CURRENT_TIMESTAMP,
        logout_type = logout_type_param,
        session_duration_minutes = EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - session_start)) / 60
    WHERE user_id = user_uuid 
    AND session_end IS NULL;
END;
$$;

-- Function to get user preferences with defaults
CREATE OR REPLACE FUNCTION public.get_user_preferences(user_uuid UUID)
RETURNS TABLE(
    biometric_enabled BOOLEAN,
    auto_logout_minutes INTEGER,
    privacy_mode BOOLEAN,
    notification_settings JSONB,
    theme_preference TEXT,
    language_preference TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COALESCE(up.biometric_enabled, false) as biometric_enabled,
        COALESCE(up.auto_logout_minutes, 30) as auto_logout_minutes,
        COALESCE(up.privacy_mode, false) as privacy_mode,
        COALESCE(up.notification_settings, '{}'::jsonb) as notification_settings,
        COALESCE(up.theme_preference, 'dark') as theme_preference,
        COALESCE(up.language_preference, 'en') as language_preference
    FROM public.user_preferences up
    WHERE up.user_id = user_uuid;
    
    -- If no preferences found, return defaults
    IF NOT FOUND THEN
        RETURN QUERY
        SELECT 
            false as biometric_enabled,
            30 as auto_logout_minutes,
            false as privacy_mode,
            '{}'::jsonb as notification_settings,
            'dark' as theme_preference,
            'en' as language_preference;
    END IF;
END;
$$;

-- Function to update user preferences
CREATE OR REPLACE FUNCTION public.update_user_preferences(
    user_uuid UUID,
    biometric_enabled_param BOOLEAN DEFAULT NULL,
    auto_logout_minutes_param INTEGER DEFAULT NULL,
    privacy_mode_param BOOLEAN DEFAULT NULL,
    notification_settings_param JSONB DEFAULT NULL,
    theme_preference_param TEXT DEFAULT NULL,
    language_preference_param TEXT DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    INSERT INTO public.user_preferences (
        user_id, 
        biometric_enabled, 
        auto_logout_minutes, 
        privacy_mode, 
        notification_settings, 
        theme_preference, 
        language_preference,
        updated_at
    ) VALUES (
        user_uuid,
        COALESCE(biometric_enabled_param, false),
        COALESCE(auto_logout_minutes_param, 30),
        COALESCE(privacy_mode_param, false),
        COALESCE(notification_settings_param, '{}'::jsonb),
        COALESCE(theme_preference_param, 'dark'),
        COALESCE(language_preference_param, 'en'),
        CURRENT_TIMESTAMP
    )
    ON CONFLICT (user_id) DO UPDATE SET
        biometric_enabled = COALESCE(biometric_enabled_param, user_preferences.biometric_enabled),
        auto_logout_minutes = COALESCE(auto_logout_minutes_param, user_preferences.auto_logout_minutes),
        privacy_mode = COALESCE(privacy_mode_param, user_preferences.privacy_mode),
        notification_settings = COALESCE(notification_settings_param, user_preferences.notification_settings),
        theme_preference = COALESCE(theme_preference_param, user_preferences.theme_preference),
        language_preference = COALESCE(language_preference_param, user_preferences.language_preference),
        updated_at = CURRENT_TIMESTAMP;
END;
$$;

-- Enhanced user profile creation with preferences
CREATE OR REPLACE FUNCTION public.handle_new_user_with_preferences()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Create user profile
    INSERT INTO public.user_profiles (id, email, full_name, role)
    VALUES (
        NEW.id, 
        NEW.email, 
        COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
        COALESCE((NEW.raw_user_meta_data->>'role')::public.user_role, 'creator'::public.user_role)
    );
    
    -- Create default user preferences
    INSERT INTO public.user_preferences (user_id)
    VALUES (NEW.id);
    
    -- Initialize onboarding progress
    INSERT INTO public.onboarding_progress (user_id, current_step, total_steps)
    VALUES (NEW.id, 0, 4);
    
    -- If OAuth provider is specified, create OAuth record
    IF NEW.raw_user_meta_data ? 'provider' AND NEW.raw_user_meta_data->>'provider' != 'email' THEN
        INSERT INTO public.user_oauth_providers (user_id, provider_name, provider_id, provider_email, provider_data, is_primary)
        VALUES (
            NEW.id,
            NEW.raw_user_meta_data->>'provider',
            NEW.raw_user_meta_data->>'provider_id',
            NEW.email,
            NEW.raw_user_meta_data,
            true
        );
    END IF;
    
    -- Log signup event
    PERFORM public.log_security_event(
        NEW.id,
        'user_signup',
        jsonb_build_object(
            'method', COALESCE(NEW.raw_user_meta_data->>'provider', 'email'),
            'email', NEW.email
        )
    );
    
    RETURN NEW;
END;
$$;

-- Replace the existing trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user_with_preferences();

-- Mock data for testing
DO $$
DECLARE
    creator_uuid UUID;
BEGIN
    -- Get existing user
    SELECT id INTO creator_uuid FROM public.user_profiles WHERE email = 'creator@mewayz.com';
    
    IF creator_uuid IS NOT NULL THEN
        -- Add user preferences
        PERFORM public.update_user_preferences(
            creator_uuid,
            false, -- biometric_enabled
            30, -- auto_logout_minutes
            false, -- privacy_mode
            '{"email": true, "push": true, "sms": false}'::jsonb, -- notification_settings
            'dark', -- theme_preference
            'en' -- language_preference
        );
        
        -- Add session tracking
        INSERT INTO public.user_session_tracking (user_id, session_start, session_end, logout_type, session_duration_minutes)
        VALUES (
            creator_uuid,
            CURRENT_TIMESTAMP - INTERVAL '2 hours',
            CURRENT_TIMESTAMP - INTERVAL '1 hour',
            'manual',
            60
        );
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error creating session test data: %', SQLERRM;
END $$;
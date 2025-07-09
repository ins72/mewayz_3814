-- Location: supabase/migrations/20241217120000_mewayz_authentication_system.sql
-- Mewayz Enhanced Authentication System

-- Add new authentication-related tables building on existing schema

-- Two-factor authentication table
CREATE TABLE public.user_two_factor_auth (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    is_enabled BOOLEAN DEFAULT false,
    secret_key TEXT,
    backup_codes TEXT[],
    phone_number TEXT,
    email_verified BOOLEAN DEFAULT false,
    phone_verified BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- User sessions for enhanced security
CREATE TABLE public.user_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    session_token TEXT NOT NULL,
    device_info JSONB DEFAULT '{}',
    ip_address TEXT,
    user_agent TEXT,
    is_active BOOLEAN DEFAULT true,
    expires_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    last_activity_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- OAuth providers table
CREATE TABLE public.user_oauth_providers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    provider_name TEXT NOT NULL,
    provider_id TEXT NOT NULL,
    provider_email TEXT,
    provider_data JSONB DEFAULT '{}',
    is_primary BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Email verification codes
CREATE TABLE public.email_verification_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    code TEXT NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    is_used BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Password reset tokens
CREATE TABLE public.password_reset_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    is_used BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- User devices for security monitoring
CREATE TABLE public.user_devices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    device_id TEXT NOT NULL,
    device_name TEXT,
    device_type TEXT,
    os_version TEXT,
    app_version TEXT,
    is_trusted BOOLEAN DEFAULT false,
    last_seen_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Security audit log
CREATE TABLE public.security_audit_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    action_type TEXT NOT NULL,
    details JSONB DEFAULT '{}',
    ip_address TEXT,
    user_agent TEXT,
    success BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_user_two_factor_auth_user_id ON public.user_two_factor_auth(user_id);
CREATE INDEX idx_user_sessions_user_id ON public.user_sessions(user_id);
CREATE INDEX idx_user_sessions_token ON public.user_sessions(session_token);
CREATE INDEX idx_user_sessions_expires_at ON public.user_sessions(expires_at);
CREATE INDEX idx_user_oauth_providers_user_id ON public.user_oauth_providers(user_id);
CREATE INDEX idx_user_oauth_providers_provider ON public.user_oauth_providers(provider_name, provider_id);
CREATE INDEX idx_email_verification_codes_user_id ON public.email_verification_codes(user_id);
CREATE INDEX idx_email_verification_codes_code ON public.email_verification_codes(code);
CREATE INDEX idx_password_reset_tokens_user_id ON public.password_reset_tokens(user_id);
CREATE INDEX idx_password_reset_tokens_token ON public.password_reset_tokens(token);
CREATE INDEX idx_user_devices_user_id ON public.user_devices(user_id);
CREATE INDEX idx_user_devices_device_id ON public.user_devices(device_id);
CREATE INDEX idx_security_audit_log_user_id ON public.security_audit_log(user_id);
CREATE INDEX idx_security_audit_log_action_type ON public.security_audit_log(action_type);

-- Enable RLS on new tables
ALTER TABLE public.user_two_factor_auth ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_oauth_providers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.email_verification_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.password_reset_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_devices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.security_audit_log ENABLE ROW LEVEL SECURITY;

-- Helper functions for authentication
CREATE OR REPLACE FUNCTION public.generate_verification_code()
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');
END;
$$;

CREATE OR REPLACE FUNCTION public.is_valid_email_verification_code(user_uuid UUID, verification_code TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.email_verification_codes evc
        WHERE evc.user_id = user_uuid 
        AND evc.code = verification_code
        AND evc.expires_at > CURRENT_TIMESTAMP
        AND evc.is_used = false
    );
END;
$$;

CREATE OR REPLACE FUNCTION public.verify_email_code(user_uuid UUID, verification_code TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE public.email_verification_codes
    SET is_used = true
    WHERE user_id = user_uuid 
    AND code = verification_code
    AND expires_at > CURRENT_TIMESTAMP
    AND is_used = false;
    
    RETURN FOUND;
END;
$$;

CREATE OR REPLACE FUNCTION public.create_user_session(user_uuid UUID, session_token TEXT, device_info JSONB DEFAULT '{}', ip_addr TEXT DEFAULT NULL, user_agent_str TEXT DEFAULT NULL)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    session_id UUID;
BEGIN
    INSERT INTO public.user_sessions (user_id, session_token, device_info, ip_address, user_agent, expires_at)
    VALUES (
        user_uuid,
        session_token,
        device_info,
        ip_addr,
        user_agent_str,
        CURRENT_TIMESTAMP + INTERVAL '30 days'
    )
    RETURNING id INTO session_id;
    
    RETURN session_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.log_security_event(user_uuid UUID, action_type TEXT, details JSONB DEFAULT '{}', ip_addr TEXT DEFAULT NULL, user_agent_str TEXT DEFAULT NULL, success_flag BOOLEAN DEFAULT true)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    INSERT INTO public.security_audit_log (user_id, action_type, details, ip_address, user_agent, success)
    VALUES (user_uuid, action_type, details, ip_addr, user_agent_str, success_flag);
END;
$$;

-- Enhanced user profile creation with OAuth support
CREATE OR REPLACE FUNCTION public.handle_new_user_with_oauth()
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
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user_with_oauth();

-- Function to cleanup expired tokens and sessions
CREATE OR REPLACE FUNCTION public.cleanup_expired_auth_data()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Cleanup expired verification codes
    DELETE FROM public.email_verification_codes 
    WHERE expires_at < CURRENT_TIMESTAMP;
    
    -- Cleanup expired password reset tokens
    DELETE FROM public.password_reset_tokens 
    WHERE expires_at < CURRENT_TIMESTAMP;
    
    -- Cleanup expired sessions
    DELETE FROM public.user_sessions 
    WHERE expires_at < CURRENT_TIMESTAMP;
    
    -- Cleanup old audit logs (keep last 90 days)
    DELETE FROM public.security_audit_log 
    WHERE created_at < CURRENT_TIMESTAMP - INTERVAL '90 days';
END;
$$;

-- RLS Policies for new tables
CREATE POLICY "users_own_2fa" ON public.user_two_factor_auth FOR ALL
USING (public.can_access_user_data(user_id)) WITH CHECK (public.can_access_user_data(user_id));

CREATE POLICY "users_own_sessions" ON public.user_sessions FOR ALL
USING (public.can_access_user_data(user_id)) WITH CHECK (public.can_access_user_data(user_id));

CREATE POLICY "users_own_oauth_providers" ON public.user_oauth_providers FOR ALL
USING (public.can_access_user_data(user_id)) WITH CHECK (public.can_access_user_data(user_id));

CREATE POLICY "users_own_verification_codes" ON public.email_verification_codes FOR ALL
USING (public.can_access_user_data(user_id)) WITH CHECK (public.can_access_user_data(user_id));

CREATE POLICY "users_own_reset_tokens" ON public.password_reset_tokens FOR ALL
USING (public.can_access_user_data(user_id)) WITH CHECK (public.can_access_user_data(user_id));

CREATE POLICY "users_own_devices" ON public.user_devices FOR ALL
USING (public.can_access_user_data(user_id)) WITH CHECK (public.can_access_user_data(user_id));

CREATE POLICY "users_own_audit_log" ON public.security_audit_log FOR SELECT
USING (public.can_access_user_data(user_id));

-- Admin access to audit logs
CREATE POLICY "admin_audit_log_access" ON public.security_audit_log FOR ALL
USING (
    EXISTS (
        SELECT 1 FROM public.user_profiles up
        WHERE up.id = auth.uid() AND up.role = 'admin'
    )
);

-- Mock data for testing authentication features
DO $$
DECLARE
    creator_uuid UUID;
    test_session_token TEXT := 'test_session_' || gen_random_uuid()::TEXT;
    verification_code TEXT := public.generate_verification_code();
BEGIN
    -- Get existing user
    SELECT id INTO creator_uuid FROM public.user_profiles WHERE email = 'creator@mewayz.com';
    
    IF creator_uuid IS NOT NULL THEN
        -- Add 2FA setup
        INSERT INTO public.user_two_factor_auth (user_id, is_enabled, email_verified)
        VALUES (creator_uuid, false, true);
        
        -- Add test session
        PERFORM public.create_user_session(
            creator_uuid,
            test_session_token,
            '{"device": "iPhone", "os": "iOS 17.0"}'::jsonb,
            '192.168.1.1',
            'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X)'
        );
        
        -- Add test verification code
        INSERT INTO public.email_verification_codes (user_id, email, code, expires_at)
        VALUES (
            creator_uuid,
            'creator@mewayz.com',
            verification_code,
            CURRENT_TIMESTAMP + INTERVAL '10 minutes'
        );
        
        -- Add OAuth provider
        INSERT INTO public.user_oauth_providers (user_id, provider_name, provider_id, provider_email, is_primary)
        VALUES (
            creator_uuid,
            'google',
            'google_' || creator_uuid::TEXT,
            'creator@mewayz.com',
            false
        );
        
        -- Log some security events
        PERFORM public.log_security_event(
            creator_uuid,
            'login_success',
            '{"method": "email", "device": "iPhone"}'::jsonb,
            '192.168.1.1',
            'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X)'
        );
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error creating auth test data: %', SQLERRM;
END $$;

-- Cleanup function for auth test data
CREATE OR REPLACE FUNCTION public.cleanup_auth_test_data()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    auth_user_ids_to_delete UUID[];
BEGIN
    -- Get auth user IDs
    SELECT ARRAY_AGG(id) INTO auth_user_ids_to_delete
    FROM auth.users
    WHERE email LIKE '%@mewayz.com';

    -- Delete auth-related data in dependency order
    DELETE FROM public.security_audit_log WHERE user_id = ANY(auth_user_ids_to_delete);
    DELETE FROM public.user_devices WHERE user_id = ANY(auth_user_ids_to_delete);
    DELETE FROM public.password_reset_tokens WHERE user_id = ANY(auth_user_ids_to_delete);
    DELETE FROM public.email_verification_codes WHERE user_id = ANY(auth_user_ids_to_delete);
    DELETE FROM public.user_oauth_providers WHERE user_id = ANY(auth_user_ids_to_delete);
    DELETE FROM public.user_sessions WHERE user_id = ANY(auth_user_ids_to_delete);
    DELETE FROM public.user_two_factor_auth WHERE user_id = ANY(auth_user_ids_to_delete);

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Auth cleanup failed: %', SQLERRM;
END;
$$;
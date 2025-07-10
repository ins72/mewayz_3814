-- Location: supabase/migrations/20250110140000_enhanced_biometric_authentication_system.sql
-- Enhanced Biometric Authentication System for Production Release

-- 1. Enhanced User Devices Table
ALTER TABLE public.user_devices ADD COLUMN IF NOT EXISTS biometric_enabled BOOLEAN DEFAULT false;
ALTER TABLE public.user_devices ADD COLUMN IF NOT EXISTS biometric_type TEXT;
ALTER TABLE public.user_devices ADD COLUMN IF NOT EXISTS device_fingerprint TEXT;
ALTER TABLE public.user_devices ADD COLUMN IF NOT EXISTS registration_method TEXT DEFAULT 'password';
ALTER TABLE public.user_devices ADD COLUMN IF NOT EXISTS first_login_at TIMESTAMPTZ;

-- 2. Biometric Authentication Records
CREATE TABLE IF NOT EXISTS public.biometric_auth_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    device_id TEXT NOT NULL,
    auth_type TEXT NOT NULL, -- 'fingerprint', 'face_id', 'pattern'
    encrypted_credential TEXT,
    is_active BOOLEAN DEFAULT true,
    attempts_count INTEGER DEFAULT 0,
    last_success_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP + INTERVAL '365 days'
);

-- 3. Anonymous User Profiles Support
ALTER TABLE public.user_profiles ADD COLUMN IF NOT EXISTS is_anonymous BOOLEAN DEFAULT false;
ALTER TABLE public.user_profiles ADD COLUMN IF NOT EXISTS device_registration_id TEXT;
ALTER TABLE public.user_profiles ADD COLUMN IF NOT EXISTS multi_device_enabled BOOLEAN DEFAULT false;
ALTER TABLE public.user_profiles ADD COLUMN IF NOT EXISTS requires_password_setup BOOLEAN DEFAULT false;

-- 4. Enhanced Auth Methods Tracking
CREATE TABLE IF NOT EXISTS public.user_auth_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    method_type TEXT NOT NULL, -- 'password', 'biometric', 'oauth'
    is_primary BOOLEAN DEFAULT false,
    is_enabled BOOLEAN DEFAULT true,
    setup_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    last_used_at TIMESTAMPTZ,
    device_specific BOOLEAN DEFAULT false,
    device_id TEXT,
    metadata JSONB DEFAULT '{}'
);

-- 5. Device Registration Events
CREATE TABLE IF NOT EXISTS public.device_registration_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    device_id TEXT NOT NULL,
    event_type TEXT NOT NULL, -- 'registered', 'verified', 'deregistered'
    registration_method TEXT, -- 'biometric', 'password', 'oauth'
    device_info JSONB DEFAULT '{}',
    ip_address TEXT,
    user_agent TEXT,
    success BOOLEAN DEFAULT true,
    error_message TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 6. Indexes for Performance
CREATE INDEX IF NOT EXISTS idx_biometric_auth_records_user_device ON public.biometric_auth_records(user_id, device_id);
CREATE INDEX IF NOT EXISTS idx_biometric_auth_records_active ON public.biometric_auth_records(is_active, expires_at);
CREATE INDEX IF NOT EXISTS idx_user_auth_methods_user_id ON public.user_auth_methods(user_id);
CREATE INDEX IF NOT EXISTS idx_user_auth_methods_type ON public.user_auth_methods(method_type, is_enabled);
CREATE INDEX IF NOT EXISTS idx_device_registration_events_user_device ON public.device_registration_events(user_id, device_id);
CREATE INDEX IF NOT EXISTS idx_user_profiles_anonymous ON public.user_profiles(is_anonymous, device_registration_id);

-- 7. RLS Policies
ALTER TABLE public.biometric_auth_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_auth_methods ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.device_registration_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_biometric_records" ON public.biometric_auth_records FOR ALL
USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "users_own_auth_methods" ON public.user_auth_methods FOR ALL
USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "users_own_device_events" ON public.device_registration_events FOR ALL
USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- 8. Enhanced Device Registration Function
CREATE OR REPLACE FUNCTION public.register_device_for_biometric(
    device_info JSONB,
    user_email TEXT DEFAULT NULL,
    user_full_name TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    device_id TEXT := device_info->>'device_id';
    result JSONB;
    existing_record UUID;
BEGIN
    -- Validate device info
    IF device_id IS NULL OR device_id = '' THEN
        RAISE EXCEPTION 'Device ID is required';
    END IF;
    
    -- Check if device is already registered for this user
    SELECT id INTO existing_record
    FROM public.user_devices
    WHERE user_id = current_user_id AND device_id = device_id;
    
    IF existing_record IS NOT NULL THEN
        -- Update existing device
        UPDATE public.user_devices
        SET 
            biometric_enabled = true,
            registration_method = 'biometric',
            last_seen_at = CURRENT_TIMESTAMP,
            device_name = COALESCE(device_info->>'device_name', device_name),
            device_type = COALESCE(device_info->>'device_type', device_type),
            os_version = COALESCE(device_info->>'os_version', os_version)
        WHERE id = existing_record;
        
        result := jsonb_build_object(
            'success', true,
            'is_new_registration', false,
            'device_id', device_id,
            'user_id', current_user_id
        );
    ELSE
        -- Register new device
        INSERT INTO public.user_devices (
            user_id, device_id, device_name, device_type, os_version,
            biometric_enabled, registration_method, is_trusted, first_login_at
        ) VALUES (
            current_user_id,
            device_id,
            device_info->>'device_name',
            device_info->>'device_type',
            device_info->>'os_version',
            true,
            'biometric',
            true,
            CURRENT_TIMESTAMP
        );
        
        result := jsonb_build_object(
            'success', true,
            'is_new_registration', true,
            'device_id', device_id,
            'user_id', current_user_id
        );
    END IF;
    
    -- Update user profile if email/name provided
    IF user_email IS NOT NULL OR user_full_name IS NOT NULL THEN
        UPDATE public.user_profiles
        SET 
            email = COALESCE(user_email, email),
            full_name = COALESCE(user_full_name, full_name),
            is_anonymous = false,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = current_user_id;
    END IF;
    
    -- Add auth method record
    INSERT INTO public.user_auth_methods (
        user_id, method_type, is_primary, device_specific, device_id, setup_at
    ) VALUES (
        current_user_id, 'biometric', true, true, device_id, CURRENT_TIMESTAMP
    ) ON CONFLICT (user_id, method_type, device_id) DO UPDATE SET
        is_enabled = true,
        last_used_at = CURRENT_TIMESTAMP;
    
    -- Log registration event
    INSERT INTO public.device_registration_events (
        user_id, device_id, event_type, registration_method, device_info, success
    ) VALUES (
        current_user_id, device_id, 'registered', 'biometric', device_info, true
    );
    
    RETURN result;
END;
$$;

-- 9. Biometric Authentication Verification Function
CREATE OR REPLACE FUNCTION public.verify_biometric_authentication(
    device_id TEXT,
    auth_type TEXT DEFAULT 'fingerprint'
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    auth_record UUID;
    result JSONB;
BEGIN
    -- Check if user has biometric auth enabled for this device
    SELECT id INTO auth_record
    FROM public.biometric_auth_records
    WHERE user_id = current_user_id 
    AND device_id = device_id 
    AND auth_type = auth_type
    AND is_active = true
    AND expires_at > CURRENT_TIMESTAMP;
    
    IF auth_record IS NULL THEN
        -- Create new biometric record
        INSERT INTO public.biometric_auth_records (
            user_id, device_id, auth_type, is_active, last_success_at
        ) VALUES (
            current_user_id, device_id, auth_type, true, CURRENT_TIMESTAMP
        );
        
        result := jsonb_build_object(
            'success', true,
            'is_new_setup', true,
            'auth_type', auth_type
        );
    ELSE
        -- Update existing record
        UPDATE public.biometric_auth_records
        SET 
            last_success_at = CURRENT_TIMESTAMP,
            attempts_count = attempts_count + 1
        WHERE id = auth_record;
        
        result := jsonb_build_object(
            'success', true,
            'is_new_setup', false,
            'auth_type', auth_type
        );
    END IF;
    
    -- Update device last seen
    UPDATE public.user_devices
    SET last_seen_at = CURRENT_TIMESTAMP
    WHERE user_id = current_user_id AND device_id = device_id;
    
    -- Update auth method usage
    UPDATE public.user_auth_methods
    SET last_used_at = CURRENT_TIMESTAMP
    WHERE user_id = current_user_id 
    AND method_type = 'biometric' 
    AND device_id = device_id;
    
    -- Log security event
    PERFORM public.log_security_event(
        current_user_id,
        'biometric_auth_success',
        jsonb_build_object(
            'device_id', device_id,
            'auth_type', auth_type
        )
    );
    
    RETURN result;
END;
$$;

-- 10. Enable Multi-Device Access Function
CREATE OR REPLACE FUNCTION public.enable_multi_device_access(
    user_password TEXT,
    user_email TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    result JSONB;
BEGIN
    -- Update user profile
    UPDATE public.user_profiles
    SET 
        email = COALESCE(user_email, email),
        multi_device_enabled = true,
        requires_password_setup = false,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = current_user_id;
    
    -- Add password auth method
    INSERT INTO public.user_auth_methods (
        user_id, method_type, is_primary, device_specific, setup_at
    ) VALUES (
        current_user_id, 'password', false, false, CURRENT_TIMESTAMP
    ) ON CONFLICT (user_id, method_type) DO UPDATE SET
        is_enabled = true,
        setup_at = CURRENT_TIMESTAMP;
    
    -- Log security event
    PERFORM public.log_security_event(
        current_user_id,
        'multi_device_enabled',
        jsonb_build_object(
            'email_provided', user_email IS NOT NULL
        )
    );
    
    result := jsonb_build_object(
        'success', true,
        'multi_device_enabled', true,
        'email_updated', user_email IS NOT NULL
    );
    
    RETURN result;
END;
$$;

-- 11. Get User Authentication Methods Function
CREATE OR REPLACE FUNCTION public.get_user_auth_methods()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    current_user_id UUID := auth.uid();
    auth_methods JSONB;
    device_count INTEGER;
    biometric_devices JSONB;
BEGIN
    -- Get authentication methods
    SELECT jsonb_agg(
        jsonb_build_object(
            'method_type', method_type,
            'is_primary', is_primary,
            'is_enabled', is_enabled,
            'device_specific', device_specific,
            'device_id', device_id,
            'setup_at', setup_at,
            'last_used_at', last_used_at
        )
    ) INTO auth_methods
    FROM public.user_auth_methods
    WHERE user_id = current_user_id AND is_enabled = true;
    
    -- Get device count
    SELECT COUNT(*) INTO device_count
    FROM public.user_devices
    WHERE user_id = current_user_id;
    
    -- Get biometric devices
    SELECT jsonb_agg(
        jsonb_build_object(
            'device_id', device_id,
            'device_name', device_name,
            'device_type', device_type,
            'biometric_enabled', biometric_enabled,
            'last_seen_at', last_seen_at
        )
    ) INTO biometric_devices
    FROM public.user_devices
    WHERE user_id = current_user_id AND biometric_enabled = true;
    
    RETURN jsonb_build_object(
        'auth_methods', COALESCE(auth_methods, '[]'),
        'device_count', device_count,
        'biometric_devices', COALESCE(biometric_devices, '[]'),
        'multi_device_enabled', (
            SELECT multi_device_enabled FROM public.user_profiles 
            WHERE id = current_user_id
        )
    );
END;
$$;

-- 12. Cleanup Functions
CREATE OR REPLACE FUNCTION public.cleanup_expired_biometric_records()
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM public.biometric_auth_records
    WHERE expires_at < CURRENT_TIMESTAMP OR is_active = false;
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    
    RETURN deleted_count;
END;
$$;

-- 13. Enhanced User Profile Creation Trigger
CREATE OR REPLACE FUNCTION public.handle_enhanced_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
DECLARE
    auth_method TEXT := COALESCE(NEW.raw_user_meta_data->>'auth_method', 'password');
    is_anonymous BOOLEAN := COALESCE((NEW.raw_user_meta_data->>'is_anonymous')::BOOLEAN, false);
    device_info JSONB := COALESCE(NEW.raw_user_meta_data->'device_info', '{}');
BEGIN
    INSERT INTO public.user_profiles (
        id, email, full_name, role, is_anonymous, 
        requires_password_setup, device_registration_id
    ) VALUES (
        NEW.id, 
        NEW.email, 
        COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
        COALESCE((NEW.raw_user_meta_data->>'role')::public.user_role, 'creator'::public.user_role),
        is_anonymous,
        COALESCE((NEW.raw_user_meta_data->>'requires_password_setup')::BOOLEAN, false),
        CASE WHEN is_anonymous THEN device_info->>'device_id' ELSE NULL END
    );
    
    -- Initialize onboarding progress
    INSERT INTO public.onboarding_progress (user_id, current_step, total_steps)
    VALUES (NEW.id, 0, 4);
    
    -- Add primary auth method
    INSERT INTO public.user_auth_methods (user_id, method_type, is_primary, device_specific, device_id)
    VALUES (
        NEW.id,
        auth_method,
        true,
        auth_method = 'biometric',
        CASE WHEN auth_method = 'biometric' THEN device_info->>'device_id' ELSE NULL END
    );
    
    -- Register device if provided
    IF device_info ? 'device_id' THEN
        INSERT INTO public.user_devices (
            user_id, device_id, device_name, device_type, os_version,
            biometric_enabled, registration_method, is_trusted, first_login_at
        ) VALUES (
            NEW.id,
            device_info->>'device_id',
            device_info->>'device_name',
            device_info->>'device_type',
            device_info->>'os_version',
            auth_method = 'biometric',
            auth_method,
            true,
            CURRENT_TIMESTAMP
        );
    END IF;
    
    -- Log signup event
    PERFORM public.log_security_event(
        NEW.id,
        'user_signup',
        jsonb_build_object(
            'method', auth_method,
            'email', NEW.email,
            'is_anonymous', is_anonymous,
            'device_id', device_info->>'device_id'
        )
    );
    
    RETURN NEW;
END;
$$;

-- Replace the existing trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_enhanced_new_user();

-- 14. Mock Data for Testing Enhanced Biometric Auth
DO $$
DECLARE
    test_user_id UUID;
    test_device_id TEXT := 'test_device_' || gen_random_uuid()::TEXT;
BEGIN
    -- Get or create test user
    SELECT id INTO test_user_id FROM public.user_profiles WHERE email = 'biometric@test.com';
    
    IF test_user_id IS NULL THEN
        -- Create test auth user
        INSERT INTO auth.users (
            id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
            created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
            is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
            recovery_token, recovery_sent_at, email_change_token_new, email_change,
            email_change_sent_at, email_change_token_current, email_change_confirm_status,
            reauthentication_token, reauthentication_sent_at, phone, phone_change,
            phone_change_token, phone_change_sent_at
        ) VALUES (
            gen_random_uuid(), '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
            'biometric@test.com', crypt('testpass123', gen_salt('bf', 10)), now(), now(), now(),
            jsonb_build_object(
                'full_name', 'Biometric Test User',
                'auth_method', 'biometric',
                'device_info', jsonb_build_object(
                    'device_id', test_device_id,
                    'device_name', 'Test iPhone',
                    'device_type', 'mobile',
                    'os_version', 'iOS 17.0'
                )
            ),
            '{"provider": "biometric", "providers": ["biometric"]}'::jsonb,
            false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null
        ) RETURNING id INTO test_user_id;
    END IF;
    
    -- Add biometric authentication record
    INSERT INTO public.biometric_auth_records (
        user_id, device_id, auth_type, is_active, last_success_at
    ) VALUES (
        test_user_id, test_device_id, 'fingerprint', true, CURRENT_TIMESTAMP
    ) ON CONFLICT (user_id, device_id, auth_type) DO NOTHING;
    
    -- Add device registration event
    INSERT INTO public.device_registration_events (
        user_id, device_id, event_type, registration_method, 
        device_info, success
    ) VALUES (
        test_user_id, test_device_id, 'registered', 'biometric',
        jsonb_build_object(
            'device_name', 'Test iPhone',
            'device_type', 'mobile',
            'os_version', 'iOS 17.0'
        ), true
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error creating enhanced biometric test data: %', SQLERRM;
END $$;

-- 15. Production Cleanup Function
CREATE OR REPLACE FUNCTION public.cleanup_enhanced_auth_test_data()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Delete test data
    DELETE FROM public.device_registration_events WHERE user_id IN (
        SELECT id FROM public.user_profiles WHERE email LIKE '%@test.com'
    );
    DELETE FROM public.biometric_auth_records WHERE user_id IN (
        SELECT id FROM public.user_profiles WHERE email LIKE '%@test.com'
    );
    DELETE FROM public.user_auth_methods WHERE user_id IN (
        SELECT id FROM public.user_profiles WHERE email LIKE '%@test.com'
    );
    
    -- Clean up existing test data from other migrations
    PERFORM public.cleanup_auth_test_data();
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Enhanced auth cleanup failed: %', SQLERRM;
END;
$$;
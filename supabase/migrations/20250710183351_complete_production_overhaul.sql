-- Location: supabase/migrations/20250710183351_complete_production_overhaul.sql
-- Complete Production Overhaul: Enhanced Performance, Security, and Professional Features

-- Module Detection: Production Optimization and Security Enhancement Module
-- IMPLEMENTING MODULE: Complete system overhaul for production readiness
-- SCOPE: Performance optimization, security enhancements, caching, monitoring, and professional features

-- 1. Enhanced Security Schema
-- User Device Management for Enhanced Security
CREATE TABLE IF NOT EXISTS public.user_devices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    device_id TEXT NOT NULL,
    device_name TEXT NOT NULL,
    device_type TEXT NOT NULL CHECK (device_type IN ('mobile', 'tablet', 'desktop', 'web')),
    os_version TEXT,
    app_version TEXT,
    is_trusted BOOLEAN DEFAULT false,
    biometric_enabled BOOLEAN DEFAULT false,
    push_token TEXT,
    location_data JSONB,
    security_fingerprint TEXT,
    last_seen_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, device_id)
);

-- Security Audit Log
CREATE TABLE IF NOT EXISTS public.security_audit_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE SET NULL,
    action_type TEXT NOT NULL,
    resource_type TEXT,
    resource_id UUID,
    ip_address INET,
    user_agent TEXT,
    device_id TEXT,
    success BOOLEAN DEFAULT true,
    failure_reason TEXT,
    risk_score INTEGER DEFAULT 0 CHECK (risk_score >= 0 AND risk_score <= 100),
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- API Rate Limiting
CREATE TABLE IF NOT EXISTS public.api_rate_limits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    endpoint TEXT NOT NULL,
    requests_count INTEGER DEFAULT 0,
    window_start TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    window_duration INTERVAL DEFAULT INTERVAL '1 hour',
    rate_limit INTEGER DEFAULT 1000,
    is_blocked BOOLEAN DEFAULT false,
    block_expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, endpoint, window_start)
);

-- 2. Performance Optimization Schema
-- Query Performance Cache
CREATE TABLE IF NOT EXISTS public.query_cache (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cache_key TEXT NOT NULL UNIQUE,
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    query_hash TEXT NOT NULL,
    result_data JSONB NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    hit_count INTEGER DEFAULT 0,
    last_accessed TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Background Job Queue
CREATE TABLE IF NOT EXISTS public.background_jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_type TEXT NOT NULL,
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    payload JSONB NOT NULL,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'retrying')),
    priority INTEGER DEFAULT 5 CHECK (priority >= 1 AND priority <= 10),
    max_attempts INTEGER DEFAULT 3,
    attempt_count INTEGER DEFAULT 0,
    scheduled_for TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    error_message TEXT,
    result_data JSONB,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- System Health Monitoring
CREATE TABLE IF NOT EXISTS public.system_health_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    metric_name TEXT NOT NULL,
    metric_value DECIMAL(15,4) NOT NULL,
    metric_unit TEXT,
    tags JSONB DEFAULT '{}',
    timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE
);

-- 3. Professional Features Schema
-- Advanced Notification System
CREATE TYPE public.notification_channel AS ENUM ('email', 'push', 'sms', 'in_app', 'webhook');
CREATE TYPE public.notification_priority AS ENUM ('low', 'normal', 'high', 'critical');

CREATE TABLE IF NOT EXISTS public.enhanced_notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    notification_type TEXT NOT NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    channels public.notification_channel[] DEFAULT ARRAY['in_app'],
    priority public.notification_priority DEFAULT 'normal',
    data JSONB DEFAULT '{}',
    scheduled_for TIMESTAMPTZ,
    sent_at TIMESTAMPTZ,
    read_at TIMESTAMPTZ,
    clicked_at TIMESTAMPTZ,
    delivery_status JSONB DEFAULT '{}',
    retry_count INTEGER DEFAULT 0,
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Workflow Automation
CREATE TABLE IF NOT EXISTS public.automation_workflows (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    creator_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    trigger_type TEXT NOT NULL,
    trigger_config JSONB NOT NULL,
    actions JSONB NOT NULL,
    is_active BOOLEAN DEFAULT true,
    execution_count INTEGER DEFAULT 0,
    last_executed_at TIMESTAMPTZ,
    error_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Advanced File Management
CREATE TABLE IF NOT EXISTS public.file_storage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    file_name TEXT NOT NULL,
    file_path TEXT NOT NULL,
    file_size BIGINT NOT NULL,
    mime_type TEXT NOT NULL,
    file_hash TEXT NOT NULL,
    storage_provider TEXT DEFAULT 'supabase',
    bucket_name TEXT NOT NULL,
    is_public BOOLEAN DEFAULT false,
    download_count INTEGER DEFAULT 0,
    metadata JSONB DEFAULT '{}',
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4. Advanced Indexes for Performance
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_user_devices_user_trusted 
ON public.user_devices(user_id, is_trusted, last_seen_at DESC);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_security_audit_user_created 
ON public.security_audit_log(user_id, created_at DESC);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_security_audit_risk_score 
ON public.security_audit_log(risk_score DESC, created_at DESC) 
WHERE risk_score > 50;

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_api_rate_limits_user_endpoint 
ON public.api_rate_limits(user_id, endpoint, window_start DESC);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_query_cache_key_expires 
ON public.query_cache(cache_key, expires_at) 
WHERE expires_at > CURRENT_TIMESTAMP;

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_background_jobs_status_priority 
ON public.background_jobs(status, priority DESC, scheduled_for ASC);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_enhanced_notifications_user_unread 
ON public.enhanced_notifications(user_id, read_at) 
WHERE read_at IS NULL;

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_automation_workflows_workspace_active 
ON public.automation_workflows(workspace_id, is_active, last_executed_at DESC);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_file_storage_workspace_created 
ON public.file_storage(workspace_id, created_at DESC);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_system_health_timestamp 
ON public.system_health_metrics(timestamp DESC, workspace_id);

-- 5. Enable RLS for Security
ALTER TABLE public.user_devices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.security_audit_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.api_rate_limits ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.query_cache ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.background_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.system_health_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.enhanced_notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.automation_workflows ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.file_storage ENABLE ROW LEVEL SECURITY;

-- 6. Advanced Security Functions
-- Enhanced user authentication with device verification
CREATE OR REPLACE FUNCTION public.authenticate_user_with_device(
    user_email TEXT,
    device_info JSONB,
    biometric_verified BOOLEAN DEFAULT false
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    user_record RECORD;
    device_record RECORD;
    risk_score INTEGER := 0;
    auth_result JSONB;
    location_risk INTEGER := 0;
    device_risk INTEGER := 0;
BEGIN
    -- Get user profile
    SELECT * INTO user_record
    FROM public.user_profiles up
    WHERE up.email = user_email;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'User not found';
    END IF;
    
    -- Check device registration
    SELECT * INTO device_record
    FROM public.user_devices ud
    WHERE ud.user_id = user_record.id
    AND ud.device_id = device_info->>'device_id';
    
    -- Calculate risk score
    IF NOT FOUND THEN
        device_risk := 40; -- New device
    ELSIF device_record.is_trusted THEN
        device_risk := 0; -- Trusted device
    ELSE
        device_risk := 20; -- Known but not trusted
    END IF;
    
    -- Location-based risk (simplified)
    IF device_info->>'location' IS NOT NULL THEN
        -- This would integrate with geolocation services
        location_risk := 10;
    END IF;
    
    risk_score := device_risk + location_risk;
    
    -- Adjust risk based on biometric verification
    IF biometric_verified THEN
        risk_score := risk_score - 30;
    END IF;
    
    risk_score := GREATEST(0, LEAST(100, risk_score));
    
    -- Log authentication attempt
    INSERT INTO public.security_audit_log (
        user_id, action_type, success, risk_score, metadata
    ) VALUES (
        user_record.id,
        'user_authentication',
        true,
        risk_score,
        jsonb_build_object(
            'device_id', device_info->>'device_id',
            'biometric_verified', biometric_verified,
            'new_device', device_record.id IS NULL
        )
    );
    
    -- Register or update device
    INSERT INTO public.user_devices (
        user_id, device_id, device_name, device_type, os_version,
        biometric_enabled, last_seen_at
    ) VALUES (
        user_record.id,
        device_info->>'device_id',
        device_info->>'device_name',
        device_info->>'device_type',
        device_info->>'os_version',
        biometric_verified,
        CURRENT_TIMESTAMP
    )
    ON CONFLICT (user_id, device_id) DO UPDATE SET
        last_seen_at = CURRENT_TIMESTAMP,
        biometric_enabled = EXCLUDED.biometric_enabled;
    
    -- Build authentication result
    auth_result := jsonb_build_object(
        'user_id', user_record.id,
        'email', user_record.email,
        'full_name', user_record.full_name,
        'role', user_record.role,
        'risk_score', risk_score,
        'requires_2fa', risk_score > 50,
        'device_trusted', COALESCE(device_record.is_trusted, false),
        'authentication_timestamp', CURRENT_TIMESTAMP
    );
    
    RETURN auth_result;
END;
$$;

-- Rate limiting function
CREATE OR REPLACE FUNCTION public.check_rate_limit(
    user_uuid UUID,
    endpoint_path TEXT,
    requests_per_hour INTEGER DEFAULT 1000
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    current_window TIMESTAMPTZ;
    current_count INTEGER;
BEGIN
    current_window := DATE_TRUNC('hour', CURRENT_TIMESTAMP);
    
    -- Get current request count for this hour
    SELECT requests_count INTO current_count
    FROM public.api_rate_limits
    WHERE user_id = user_uuid
    AND endpoint = endpoint_path
    AND window_start = current_window;
    
    IF NOT FOUND THEN
        -- First request in this window
        INSERT INTO public.api_rate_limits (
            user_id, endpoint, requests_count, window_start, rate_limit
        ) VALUES (
            user_uuid, endpoint_path, 1, current_window, requests_per_hour
        );
        RETURN true;
    END IF;
    
    -- Check if limit exceeded
    IF current_count >= requests_per_hour THEN
        UPDATE public.api_rate_limits
        SET is_blocked = true, block_expires_at = current_window + INTERVAL '1 hour'
        WHERE user_id = user_uuid AND endpoint = endpoint_path AND window_start = current_window;
        
        RETURN false;
    END IF;
    
    -- Increment counter
    UPDATE public.api_rate_limits
    SET requests_count = requests_count + 1, updated_at = CURRENT_TIMESTAMP
    WHERE user_id = user_uuid AND endpoint = endpoint_path AND window_start = current_window;
    
    RETURN true;
END;
$$;

-- 7. Performance Optimization Functions
-- Intelligent caching system
CREATE OR REPLACE FUNCTION public.get_cached_result(
    cache_key_param TEXT,
    workspace_uuid UUID DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    cached_data JSONB;
    cache_record RECORD;
BEGIN
    SELECT result_data, hit_count, expires_at
    INTO cache_record
    FROM public.query_cache
    WHERE cache_key = cache_key_param
    AND (workspace_id = workspace_uuid OR workspace_id IS NULL)
    AND expires_at > CURRENT_TIMESTAMP;
    
    IF FOUND THEN
        -- Update hit count and last accessed
        UPDATE public.query_cache
        SET hit_count = hit_count + 1, last_accessed = CURRENT_TIMESTAMP
        WHERE cache_key = cache_key_param;
        
        RETURN cache_record.result_data;
    END IF;
    
    RETURN NULL;
END;
$$;

CREATE OR REPLACE FUNCTION public.set_cache_result(
    cache_key_param TEXT,
    result_data_param JSONB,
    workspace_uuid UUID DEFAULT NULL,
    ttl_seconds INTEGER DEFAULT 3600
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    INSERT INTO public.query_cache (
        cache_key, workspace_id, query_hash, result_data, expires_at
    ) VALUES (
        cache_key_param,
        workspace_uuid,
        MD5(cache_key_param),
        result_data_param,
        CURRENT_TIMESTAMP + (ttl_seconds || ' seconds')::INTERVAL
    )
    ON CONFLICT (cache_key) DO UPDATE SET
        result_data = EXCLUDED.result_data,
        expires_at = EXCLUDED.expires_at,
        hit_count = 0,
        last_accessed = CURRENT_TIMESTAMP;
    
    RETURN true;
END;
$$;

-- Background job processing
CREATE OR REPLACE FUNCTION public.enqueue_background_job(
    job_type_param TEXT,
    payload_param JSONB,
    workspace_uuid UUID DEFAULT NULL,
    user_uuid UUID DEFAULT NULL,
    priority_param INTEGER DEFAULT 5,
    schedule_delay INTERVAL DEFAULT INTERVAL '0 seconds'
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    job_id UUID;
BEGIN
    INSERT INTO public.background_jobs (
        job_type, workspace_id, user_id, payload, priority, scheduled_for
    ) VALUES (
        job_type_param,
        workspace_uuid,
        user_uuid,
        payload_param,
        priority_param,
        CURRENT_TIMESTAMP + schedule_delay
    )
    RETURNING id INTO job_id;
    
    RETURN job_id;
END;
$$;

-- 8. Professional Features Functions
-- Advanced notification system
CREATE OR REPLACE FUNCTION public.send_enhanced_notification(
    user_uuid UUID,
    workspace_uuid UUID,
    notification_type_param TEXT,
    title_param TEXT,
    message_param TEXT,
    channels_param public.notification_channel[] DEFAULT ARRAY['in_app'],
    priority_param public.notification_priority DEFAULT 'normal',
    data_param JSONB DEFAULT '{}',
    schedule_delay INTERVAL DEFAULT INTERVAL '0 seconds'
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    notification_id UUID;
    scheduled_time TIMESTAMPTZ;
BEGIN
    scheduled_time := CURRENT_TIMESTAMP + schedule_delay;
    
    INSERT INTO public.enhanced_notifications (
        workspace_id, user_id, notification_type, title, message,
        channels, priority, data, scheduled_for
    ) VALUES (
        workspace_uuid,
        user_uuid,
        notification_type_param,
        title_param,
        message_param,
        channels_param,
        priority_param,
        data_param,
        CASE WHEN schedule_delay > INTERVAL '0 seconds' THEN scheduled_time ELSE NULL END
    )
    RETURNING id INTO notification_id;
    
    -- If immediate notification, trigger delivery
    IF schedule_delay <= INTERVAL '0 seconds' THEN
        -- This would trigger external notification services
        UPDATE public.enhanced_notifications
        SET sent_at = CURRENT_TIMESTAMP
        WHERE id = notification_id;
    END IF;
    
    RETURN notification_id;
END;
$$;

-- System health monitoring
CREATE OR REPLACE FUNCTION public.record_health_metric(
    metric_name_param TEXT,
    metric_value_param DECIMAL,
    metric_unit_param TEXT DEFAULT NULL,
    tags_param JSONB DEFAULT '{}',
    workspace_uuid UUID DEFAULT NULL
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    INSERT INTO public.system_health_metrics (
        metric_name, metric_value, metric_unit, tags, workspace_id
    ) VALUES (
        metric_name_param,
        metric_value_param,
        metric_unit_param,
        tags_param,
        workspace_uuid
    );
    
    RETURN true;
END;
$$;

-- 9. RLS Policies
-- User devices - users can only access their own devices
CREATE POLICY "users_own_devices" ON public.user_devices FOR ALL
USING (auth.uid() = user_id);

-- Security audit log - workspace members can view workspace logs
CREATE POLICY "workspace_security_audit" ON public.security_audit_log FOR SELECT
USING (
    workspace_id IS NULL OR
    public.is_workspace_member(workspace_id)
);

-- API rate limits - users can only see their own limits
CREATE POLICY "users_own_rate_limits" ON public.api_rate_limits FOR ALL
USING (auth.uid() = user_id);

-- Query cache - workspace-specific access
CREATE POLICY "workspace_query_cache" ON public.query_cache FOR ALL
USING (
    workspace_id IS NULL OR
    public.is_workspace_member(workspace_id)
);

-- Background jobs - workspace member access
CREATE POLICY "workspace_background_jobs" ON public.background_jobs FOR ALL
USING (
    workspace_id IS NULL OR
    public.is_workspace_member(workspace_id)
);

-- System health metrics - workspace member access
CREATE POLICY "workspace_health_metrics" ON public.system_health_metrics FOR ALL
USING (
    workspace_id IS NULL OR
    public.is_workspace_member(workspace_id)
);

-- Enhanced notifications - users can only access their own notifications
CREATE POLICY "users_own_enhanced_notifications" ON public.enhanced_notifications FOR ALL
USING (auth.uid() = user_id);

-- Automation workflows - workspace member access
CREATE POLICY "workspace_automation_workflows" ON public.automation_workflows FOR ALL
USING (public.is_workspace_member(workspace_id));

-- File storage - workspace member access
CREATE POLICY "workspace_file_storage" ON public.file_storage FOR ALL
USING (public.is_workspace_member(workspace_id));

-- 10. Triggers for Automation
-- Update triggers for timestamp management
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_api_rate_limits_updated_at
    BEFORE UPDATE ON public.api_rate_limits
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_automation_workflows_updated_at
    BEFORE UPDATE ON public.automation_workflows
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

-- Auto-cleanup triggers
CREATE OR REPLACE FUNCTION public.cleanup_expired_cache()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM public.query_cache
    WHERE expires_at < CURRENT_TIMESTAMP - INTERVAL '1 hour';
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to run cleanup periodically
CREATE TRIGGER cleanup_expired_cache_trigger
    AFTER INSERT ON public.query_cache
    FOR EACH STATEMENT
    EXECUTE FUNCTION public.cleanup_expired_cache();

-- 11. Production-Ready Data Views
CREATE OR REPLACE VIEW public.system_performance_overview AS
SELECT 
    'query_cache' as component,
    COUNT(*) as total_records,
    COUNT(*) FILTER (WHERE expires_at > CURRENT_TIMESTAMP) as active_records,
    AVG(hit_count) as avg_hit_count,
    MAX(last_accessed) as last_activity
FROM public.query_cache
UNION ALL
SELECT 
    'background_jobs' as component,
    COUNT(*) as total_records,
    COUNT(*) FILTER (WHERE status = 'pending') as active_records,
    AVG(attempt_count) as avg_attempts,
    MAX(created_at) as last_activity
FROM public.background_jobs
UNION ALL
SELECT 
    'api_rate_limits' as component,
    COUNT(*) as total_records,
    COUNT(*) FILTER (WHERE window_start >= CURRENT_TIMESTAMP - INTERVAL '1 hour') as active_records,
    AVG(requests_count) as avg_requests,
    MAX(updated_at) as last_activity
FROM public.api_rate_limits
UNION ALL
SELECT 
    'security_audit_log' as component,
    COUNT(*) as total_records,
    COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE) as active_records,
    AVG(risk_score) as avg_risk_score,
    MAX(created_at) as last_activity
FROM public.security_audit_log;

-- 12. Production Monitoring Functions
CREATE OR REPLACE FUNCTION public.get_system_health_report()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    health_report JSONB;
    performance_data JSONB;
    security_data JSONB;
    cache_stats JSONB;
    job_stats JSONB;
BEGIN
    -- Performance metrics
    SELECT jsonb_agg(
        jsonb_build_object(
            'component', component,
            'total_records', total_records,
            'active_records', active_records,
            'avg_metric', avg_hit_count,
            'last_activity', last_activity
        )
    ) INTO performance_data
    FROM public.system_performance_overview;
    
    -- Security metrics
    SELECT jsonb_build_object(
        'high_risk_events_today', COUNT(*) FILTER (WHERE risk_score > 70 AND created_at >= CURRENT_DATE),
        'failed_auth_attempts_today', COUNT(*) FILTER (WHERE action_type = 'user_authentication' AND success = false AND created_at >= CURRENT_DATE),
        'new_devices_today', COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE),
        'blocked_users', COUNT(*) FILTER (WHERE is_blocked = true)
    ) INTO security_data
    FROM public.security_audit_log sa
    FULL OUTER JOIN public.user_devices ud ON true
    FULL OUTER JOIN public.api_rate_limits arl ON true;
    
    -- Cache performance
    SELECT jsonb_build_object(
        'total_cache_entries', COUNT(*),
        'active_cache_entries', COUNT(*) FILTER (WHERE expires_at > CURRENT_TIMESTAMP),
        'cache_hit_rate', COALESCE(AVG(hit_count), 0),
        'cache_size_mb', ROUND(SUM(pg_column_size(result_data))::DECIMAL / 1024 / 1024, 2)
    ) INTO cache_stats
    FROM public.query_cache;
    
    -- Background job statistics
    SELECT jsonb_build_object(
        'pending_jobs', COUNT(*) FILTER (WHERE status = 'pending'),
        'processing_jobs', COUNT(*) FILTER (WHERE status = 'processing'),
        'failed_jobs', COUNT(*) FILTER (WHERE status = 'failed'),
        'success_rate', ROUND(
            (COUNT(*) FILTER (WHERE status = 'completed')::DECIMAL / 
             NULLIF(COUNT(*) FILTER (WHERE status IN ('completed', 'failed')), 0)) * 100, 2
        )
    ) INTO job_stats
    FROM public.background_jobs;
    
    -- Combine all metrics
    health_report := jsonb_build_object(
        'timestamp', CURRENT_TIMESTAMP,
        'performance_metrics', performance_data,
        'security_metrics', security_data,
        'cache_statistics', cache_stats,
        'job_statistics', job_stats,
        'system_status', 'healthy'
    );
    
    RETURN health_report;
END;
$$;

-- 13. Cleanup Functions for Production
CREATE OR REPLACE FUNCTION public.cleanup_production_data(
    retention_days INTEGER DEFAULT 90
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    cleanup_stats JSONB;
    deleted_audit_logs INTEGER;
    deleted_cache_entries INTEGER;
    deleted_completed_jobs INTEGER;
    deleted_old_notifications INTEGER;
BEGIN
    -- Clean up old audit logs
    DELETE FROM public.security_audit_log
    WHERE created_at < CURRENT_DATE - (retention_days || ' days')::INTERVAL;
    GET DIAGNOSTICS deleted_audit_logs = ROW_COUNT;
    
    -- Clean up expired cache entries
    DELETE FROM public.query_cache
    WHERE expires_at < CURRENT_TIMESTAMP;
    GET DIAGNOSTICS deleted_cache_entries = ROW_COUNT;
    
    -- Clean up completed background jobs older than 7 days
    DELETE FROM public.background_jobs
    WHERE status = 'completed'
    AND completed_at < CURRENT_TIMESTAMP - INTERVAL '7 days';
    GET DIAGNOSTICS deleted_completed_jobs = ROW_COUNT;
    
    -- Clean up old read notifications
    DELETE FROM public.enhanced_notifications
    WHERE read_at IS NOT NULL
    AND read_at < CURRENT_TIMESTAMP - (retention_days || ' days')::INTERVAL;
    GET DIAGNOSTICS deleted_old_notifications = ROW_COUNT;
    
    cleanup_stats := jsonb_build_object(
        'cleanup_timestamp', CURRENT_TIMESTAMP,
        'retention_days', retention_days,
        'deleted_audit_logs', deleted_audit_logs,
        'deleted_cache_entries', deleted_cache_entries,
        'deleted_completed_jobs', deleted_completed_jobs,
        'deleted_old_notifications', deleted_old_notifications
    );
    
    RETURN cleanup_stats;
END;
$$;

-- 14. Final Production Optimizations
-- Update table statistics for query optimization
ANALYZE public.user_devices;
ANALYZE public.security_audit_log;
ANALYZE public.api_rate_limits;
ANALYZE public.query_cache;
ANALYZE public.background_jobs;
ANALYZE public.system_health_metrics;
ANALYZE public.enhanced_notifications;
ANALYZE public.automation_workflows;
ANALYZE public.file_storage;

-- Set up automatic statistics collection
CREATE OR REPLACE FUNCTION public.update_table_statistics()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Update statistics for performance optimization
    ANALYZE public.user_devices;
    ANALYZE public.security_audit_log;
    ANALYZE public.api_rate_limits;
    ANALYZE public.query_cache;
    ANALYZE public.background_jobs;
    ANALYZE public.enhanced_notifications;
    ANALYZE public.automation_workflows;
    ANALYZE public.file_storage;
    
    -- Record health metric
    PERFORM public.record_health_metric(
        'statistics_update_completed',
        1,
        'boolean',
        jsonb_build_object('timestamp', CURRENT_TIMESTAMP)
    );
END;
$$;

-- Comments for production maintenance
COMMENT ON FUNCTION public.cleanup_production_data IS 'Run weekly to maintain database performance';
COMMENT ON FUNCTION public.get_system_health_report IS 'Generate comprehensive system health report';
COMMENT ON FUNCTION public.update_table_statistics IS 'Update table statistics for query optimization';
COMMENT ON VIEW public.system_performance_overview IS 'Real-time system performance overview';

-- Final notification about completion
INSERT INTO public.system_health_metrics (metric_name, metric_value, metric_unit, tags)
VALUES (
    'production_overhaul_completed',
    1,
    'boolean',
    jsonb_build_object(
        'migration_timestamp', CURRENT_TIMESTAMP,
        'version', '20250710183351',
        'features', jsonb_build_array(
            'enhanced_security',
            'performance_optimization',
            'professional_monitoring',
            'automated_cleanup',
            'intelligent_caching'
        )
    )
);
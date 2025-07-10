-- Location: supabase/migrations/20250710190000_enhanced_production_optimization.sql
-- Enhanced Production Optimization: Ultimate Performance, Security, and Professional Features

-- Module Detection: Enhanced Production Optimization Module
-- IMPLEMENTING MODULE: Ultimate system enhancement for enterprise-grade production deployment
-- SCOPE: Advanced caching, intelligent monitoring, predictive analytics, and automated scaling

-- 1. Advanced Performance Optimization Tables
-- Intelligent Query Optimization
CREATE TABLE IF NOT EXISTS public.query_optimization_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    query_signature TEXT NOT NULL,
    execution_plan JSONB,
    execution_time_ms INTEGER NOT NULL,
    row_count INTEGER,
    cache_used BOOLEAN DEFAULT false,
    optimization_suggestions JSONB DEFAULT '{}',
    cpu_usage_percent DECIMAL(5,2),
    memory_usage_mb DECIMAL(10,2),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Advanced Connection Pool Management
CREATE TABLE IF NOT EXISTS public.connection_pool_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    active_connections INTEGER NOT NULL,
    idle_connections INTEGER NOT NULL,
    waiting_connections INTEGER NOT NULL,
    max_connections INTEGER NOT NULL,
    connection_utilization_percent DECIMAL(5,2),
    avg_query_time_ms DECIMAL(10,3),
    slow_query_count INTEGER DEFAULT 0,
    error_count INTEGER DEFAULT 0,
    timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Predictive Scaling Analytics
CREATE TABLE IF NOT EXISTS public.predictive_scaling_data (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    metric_type TEXT NOT NULL CHECK (metric_type IN ('cpu', 'memory', 'storage', 'bandwidth', 'queries_per_second')),
    current_value DECIMAL(15,4) NOT NULL,
    predicted_value DECIMAL(15,4),
    prediction_confidence DECIMAL(5,2),
    scaling_recommendation TEXT,
    auto_scale_triggered BOOLEAN DEFAULT false,
    forecast_period_hours INTEGER DEFAULT 24,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Advanced Error Analytics
CREATE TABLE IF NOT EXISTS public.error_analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    error_type TEXT NOT NULL,
    error_code TEXT,
    error_message TEXT NOT NULL,
    stack_trace TEXT,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    endpoint TEXT,
    request_method TEXT,
    request_payload JSONB,
    response_status INTEGER,
    user_agent TEXT,
    ip_address INET,
    resolution_status TEXT DEFAULT 'unresolved' CHECK (resolution_status IN ('unresolved', 'investigating', 'resolved', 'ignored')),
    resolution_time INTERVAL,
    impact_level TEXT DEFAULT 'low' CHECK (impact_level IN ('low', 'medium', 'high', 'critical')),
    first_occurrence TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    last_occurrence TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    occurrence_count INTEGER DEFAULT 1,
    automated_fix_applied BOOLEAN DEFAULT false,
    fix_description TEXT
);

-- Real-time Performance Alerts
CREATE TABLE IF NOT EXISTS public.performance_alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    alert_type TEXT NOT NULL,
    alert_level TEXT NOT NULL CHECK (alert_level IN ('info', 'warning', 'error', 'critical')),
    alert_title TEXT NOT NULL,
    alert_message TEXT NOT NULL,
    metric_name TEXT,
    threshold_value DECIMAL(15,4),
    current_value DECIMAL(15,4),
    auto_resolution_attempted BOOLEAN DEFAULT false,
    resolution_action TEXT,
    acknowledged_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    acknowledged_at TIMESTAMPTZ,
    resolved_at TIMESTAMPTZ,
    escalation_level INTEGER DEFAULT 0,
    notification_sent BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Advanced Cache Management
CREATE TABLE IF NOT EXISTS public.intelligent_cache_analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    cache_key TEXT NOT NULL,
    cache_layer TEXT NOT NULL CHECK (cache_layer IN ('memory', 'redis', 'database', 'cdn')),
    hit_count INTEGER DEFAULT 0,
    miss_count INTEGER DEFAULT 0,
    eviction_count INTEGER DEFAULT 0,
    size_bytes BIGINT,
    ttl_seconds INTEGER,
    last_accessed TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    access_pattern JSONB DEFAULT '{}',
    performance_impact_score DECIMAL(5,2),
    optimization_suggestion TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 2. Advanced Performance Indexes
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_query_optimization_signature_time 
ON public.query_optimization_logs(query_signature, execution_time_ms DESC, created_at DESC);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_query_optimization_workspace_performance 
ON public.query_optimization_logs(workspace_id, execution_time_ms DESC) 
WHERE execution_time_ms > 1000;

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_connection_pool_utilization 
ON public.connection_pool_metrics(connection_utilization_percent DESC, timestamp DESC) 
WHERE connection_utilization_percent > 80;

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_predictive_scaling_workspace_type 
ON public.predictive_scaling_data(workspace_id, metric_type, created_at DESC);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_predictive_scaling_recommendations 
ON public.predictive_scaling_data(scaling_recommendation, prediction_confidence DESC) 
WHERE scaling_recommendation IS NOT NULL;

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_error_analytics_workspace_unresolved 
ON public.error_analytics(workspace_id, resolution_status, impact_level DESC) 
WHERE resolution_status = 'unresolved';

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_error_analytics_frequency 
ON public.error_analytics(error_type, occurrence_count DESC, last_occurrence DESC);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_performance_alerts_workspace_level 
ON public.performance_alerts(workspace_id, alert_level, created_at DESC) 
WHERE resolved_at IS NULL;

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_performance_alerts_escalation 
ON public.performance_alerts(escalation_level DESC, created_at ASC) 
WHERE escalation_level > 0 AND resolved_at IS NULL;

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_cache_analytics_performance 
ON public.intelligent_cache_analytics(cache_key, performance_impact_score DESC, last_accessed DESC);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_cache_analytics_hit_ratio 
ON public.intelligent_cache_analytics(workspace_id, hit_count, miss_count, updated_at DESC);

-- 3. Enable RLS for New Tables
ALTER TABLE public.query_optimization_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.connection_pool_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.predictive_scaling_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.error_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.performance_alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.intelligent_cache_analytics ENABLE ROW LEVEL SECURITY;

-- 4. Advanced Performance Functions

-- Intelligent Query Optimizer
CREATE OR REPLACE FUNCTION public.optimize_query_performance(
    query_signature_param TEXT,
    execution_time_param INTEGER,
    workspace_uuid UUID DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    avg_execution_time DECIMAL;
    optimization_suggestions JSONB := '[]'::JSONB;
    performance_score DECIMAL;
    similar_queries_count INTEGER;
BEGIN
    -- Get average execution time for similar queries
    SELECT AVG(execution_time_ms), COUNT(*)
    INTO avg_execution_time, similar_queries_count
    FROM public.query_optimization_logs
    WHERE query_signature = query_signature_param
    AND created_at >= CURRENT_TIMESTAMP - INTERVAL '7 days';
    
    -- Calculate performance score
    performance_score := CASE 
        WHEN avg_execution_time IS NULL THEN 100.0
        WHEN execution_time_param <= avg_execution_time * 0.8 THEN 95.0
        WHEN execution_time_param <= avg_execution_time THEN 80.0
        WHEN execution_time_param <= avg_execution_time * 1.5 THEN 60.0
        ELSE 30.0
    END;
    
    -- Generate optimization suggestions
    IF execution_time_param > 5000 THEN
        optimization_suggestions := optimization_suggestions || '["Consider adding database indexes"]'::JSONB;
    END IF;
    
    IF execution_time_param > 10000 THEN
        optimization_suggestions := optimization_suggestions || '["Implement query result caching"]'::JSONB;
    END IF;
    
    IF similar_queries_count > 100 THEN
        optimization_suggestions := optimization_suggestions || '["Optimize frequently executed query"]'::JSONB;
    END IF;
    
    -- Log the query performance
    INSERT INTO public.query_optimization_logs (
        workspace_id, query_signature, execution_time_ms, optimization_suggestions, created_at
    ) VALUES (
        workspace_uuid, query_signature_param, execution_time_param, optimization_suggestions, CURRENT_TIMESTAMP
    );
    
    RETURN jsonb_build_object(
        'performance_score', performance_score,
        'avg_execution_time', COALESCE(avg_execution_time, execution_time_param),
        'optimization_suggestions', optimization_suggestions,
        'similar_queries_count', similar_queries_count,
        'is_performing_well', performance_score > 80
    );
END;
$$;

-- Predictive Scaling Analyzer
CREATE OR REPLACE FUNCTION public.analyze_predictive_scaling(
    workspace_uuid UUID,
    forecast_hours INTEGER DEFAULT 24
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    scaling_analysis JSONB;
    cpu_trend DECIMAL;
    memory_trend DECIMAL;
    query_trend DECIMAL;
    recommendations JSONB := '[]'::JSONB;
BEGIN
    -- Analyze CPU trend
    SELECT 
        CASE 
            WHEN COUNT(*) > 1 THEN 
                (MAX(current_value) - MIN(current_value)) / NULLIF(COUNT(*) - 1, 0)
            ELSE 0 
        END
    INTO cpu_trend
    FROM public.predictive_scaling_data
    WHERE workspace_id = workspace_uuid
    AND metric_type = 'cpu'
    AND created_at >= CURRENT_TIMESTAMP - INTERVAL '24 hours';
    
    -- Analyze memory trend
    SELECT 
        CASE 
            WHEN COUNT(*) > 1 THEN 
                (MAX(current_value) - MIN(current_value)) / NULLIF(COUNT(*) - 1, 0)
            ELSE 0 
        END
    INTO memory_trend
    FROM public.predictive_scaling_data
    WHERE workspace_id = workspace_uuid
    AND metric_type = 'memory'
    AND created_at >= CURRENT_TIMESTAMP - INTERVAL '24 hours';
    
    -- Analyze query performance trend
    SELECT 
        CASE 
            WHEN COUNT(*) > 1 THEN 
                (MAX(current_value) - MIN(current_value)) / NULLIF(COUNT(*) - 1, 0)
            ELSE 0 
        END
    INTO query_trend
    FROM public.predictive_scaling_data
    WHERE workspace_id = workspace_uuid
    AND metric_type = 'queries_per_second'
    AND created_at >= CURRENT_TIMESTAMP - INTERVAL '24 hours';
    
    -- Generate scaling recommendations
    IF cpu_trend > 10 THEN
        recommendations := recommendations || '["Consider CPU scaling - increasing trend detected"]'::JSONB;
    END IF;
    
    IF memory_trend > 15 THEN
        recommendations := recommendations || '["Consider memory scaling - increasing usage detected"]'::JSONB;
    END IF;
    
    IF query_trend > 20 THEN
        recommendations := recommendations || '["Consider connection pool scaling - query load increasing"]'::JSONB;
    END IF;
    
    -- Create prediction record
    INSERT INTO public.predictive_scaling_data (
        workspace_id, metric_type, current_value, predicted_value, 
        prediction_confidence, scaling_recommendation, forecast_period_hours
    ) VALUES 
        (workspace_uuid, 'cpu', COALESCE(cpu_trend, 0), COALESCE(cpu_trend * 1.2, 0), 85.0, 
         CASE WHEN cpu_trend > 10 THEN 'scale_up' ELSE 'maintain' END, forecast_hours),
        (workspace_uuid, 'memory', COALESCE(memory_trend, 0), COALESCE(memory_trend * 1.15, 0), 82.0, 
         CASE WHEN memory_trend > 15 THEN 'scale_up' ELSE 'maintain' END, forecast_hours),
        (workspace_uuid, 'queries_per_second', COALESCE(query_trend, 0), COALESCE(query_trend * 1.3, 0), 78.0, 
         CASE WHEN query_trend > 20 THEN 'scale_connections' ELSE 'maintain' END, forecast_hours);
    
    scaling_analysis := jsonb_build_object(
        'workspace_id', workspace_uuid,
        'analysis_timestamp', CURRENT_TIMESTAMP,
        'forecast_hours', forecast_hours,
        'trends', jsonb_build_object(
            'cpu_trend', COALESCE(cpu_trend, 0),
            'memory_trend', COALESCE(memory_trend, 0),
            'query_trend', COALESCE(query_trend, 0)
        ),
        'recommendations', recommendations,
        'scaling_confidence', CASE 
            WHEN cpu_trend > 10 OR memory_trend > 15 OR query_trend > 20 THEN 'high'
            WHEN cpu_trend > 5 OR memory_trend > 8 OR query_trend > 10 THEN 'medium'
            ELSE 'low'
        END
    );
    
    RETURN scaling_analysis;
END;
$$;

-- Advanced Error Analytics
CREATE OR REPLACE FUNCTION public.analyze_error_patterns(
    workspace_uuid UUID DEFAULT NULL,
    analysis_period_hours INTEGER DEFAULT 24
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    error_analysis JSONB;
    top_errors JSONB;
    error_trends JSONB;
    resolution_suggestions JSONB := '[]'::JSONB;
    critical_error_count INTEGER;
    error_rate_increase DECIMAL;
BEGIN
    -- Get top errors by frequency
    SELECT jsonb_agg(
        jsonb_build_object(
            'error_type', error_type,
            'error_code', error_code,
            'occurrence_count', SUM(occurrence_count),
            'impact_level', MAX(impact_level),
            'avg_resolution_time', AVG(EXTRACT(EPOCH FROM resolution_time) / 3600)
        ) ORDER BY SUM(occurrence_count) DESC
    )
    INTO top_errors
    FROM public.error_analytics
    WHERE (workspace_uuid IS NULL OR workspace_id = workspace_uuid)
    AND first_occurrence >= CURRENT_TIMESTAMP - (analysis_period_hours || ' hours')::INTERVAL
    GROUP BY error_type, error_code
    LIMIT 10;
    
    -- Count critical errors
    SELECT COUNT(*)
    INTO critical_error_count
    FROM public.error_analytics
    WHERE (workspace_uuid IS NULL OR workspace_id = workspace_uuid)
    AND impact_level = 'critical'
    AND first_occurrence >= CURRENT_TIMESTAMP - (analysis_period_hours || ' hours')::INTERVAL;
    
    -- Calculate error rate increase
    WITH current_period AS (
        SELECT COUNT(*) as current_errors
        FROM public.error_analytics
        WHERE (workspace_uuid IS NULL OR workspace_id = workspace_uuid)
        AND first_occurrence >= CURRENT_TIMESTAMP - (analysis_period_hours || ' hours')::INTERVAL
    ),
    previous_period AS (
        SELECT COUNT(*) as previous_errors
        FROM public.error_analytics
        WHERE (workspace_uuid IS NULL OR workspace_id = workspace_uuid)
        AND first_occurrence >= CURRENT_TIMESTAMP - (analysis_period_hours * 2 || ' hours')::INTERVAL
        AND first_occurrence < CURRENT_TIMESTAMP - (analysis_period_hours || ' hours')::INTERVAL
    )
    SELECT 
        CASE 
            WHEN p.previous_errors > 0 THEN 
                ((c.current_errors - p.previous_errors)::DECIMAL / p.previous_errors) * 100
            ELSE 0 
        END
    INTO error_rate_increase
    FROM current_period c, previous_period p;
    
    -- Generate resolution suggestions
    IF critical_error_count > 0 THEN
        resolution_suggestions := resolution_suggestions || '["Immediate attention required for critical errors"]'::JSONB;
    END IF;
    
    IF error_rate_increase > 50 THEN
        resolution_suggestions := resolution_suggestions || '["Error rate increased significantly - investigate system changes"]'::JSONB;
    END IF;
    
    IF critical_error_count > 5 THEN
        resolution_suggestions := resolution_suggestions || '["Consider implementing automated error recovery"]'::JSONB;
    END IF;
    
    error_analysis := jsonb_build_object(
        'analysis_timestamp', CURRENT_TIMESTAMP,
        'analysis_period_hours', analysis_period_hours,
        'top_errors', COALESCE(top_errors, '[]'::JSONB),
        'critical_error_count', critical_error_count,
        'error_rate_increase_percent', COALESCE(error_rate_increase, 0),
        'resolution_suggestions', resolution_suggestions,
        'overall_health_score', CASE 
            WHEN critical_error_count = 0 AND error_rate_increase < 10 THEN 95
            WHEN critical_error_count <= 2 AND error_rate_increase < 25 THEN 80
            WHEN critical_error_count <= 5 AND error_rate_increase < 50 THEN 60
            ELSE 30
        END
    );
    
    RETURN error_analysis;
END;
$$;

-- Intelligent Cache Optimization
CREATE OR REPLACE FUNCTION public.optimize_cache_strategy(
    workspace_uuid UUID DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    cache_analysis JSONB;
    total_hits INTEGER;
    total_misses INTEGER;
    hit_ratio DECIMAL;
    optimization_actions JSONB := '[]'::JSONB;
    underperforming_caches JSONB;
BEGIN
    -- Calculate overall cache performance
    SELECT 
        SUM(hit_count),
        SUM(miss_count)
    INTO total_hits, total_misses
    FROM public.intelligent_cache_analytics
    WHERE (workspace_uuid IS NULL OR workspace_id = workspace_uuid)
    AND updated_at >= CURRENT_TIMESTAMP - INTERVAL '24 hours';
    
    hit_ratio := CASE 
        WHEN (total_hits + total_misses) > 0 THEN 
            (total_hits::DECIMAL / (total_hits + total_misses)) * 100
        ELSE 0 
    END;
    
    -- Identify underperforming cache keys
    SELECT jsonb_agg(
        jsonb_build_object(
            'cache_key', cache_key,
            'cache_layer', cache_layer,
            'hit_ratio', CASE 
                WHEN (hit_count + miss_count) > 0 THEN 
                    (hit_count::DECIMAL / (hit_count + miss_count)) * 100
                ELSE 0 
            END,
            'performance_impact_score', performance_impact_score,
            'last_accessed', last_accessed,
            'suggestion', optimization_suggestion
        )
    )
    INTO underperforming_caches
    FROM public.intelligent_cache_analytics
    WHERE (workspace_uuid IS NULL OR workspace_id = workspace_uuid)
    AND (hit_count + miss_count) > 10  -- Only consider caches with significant usage
    AND (hit_count::DECIMAL / NULLIF(hit_count + miss_count, 0)) < 0.7  -- Less than 70% hit ratio
    ORDER BY performance_impact_score DESC
    LIMIT 20;
    
    -- Generate optimization actions
    IF hit_ratio < 60 THEN
        optimization_actions := optimization_actions || '["Overall cache hit ratio is low - consider increasing cache TTL"]'::JSONB;
    END IF;
    
    IF hit_ratio < 40 THEN
        optimization_actions := optimization_actions || '["Critical cache performance - review cache strategy"]'::JSONB;
    END IF;
    
    -- Update cache analytics with performance scores
    UPDATE public.intelligent_cache_analytics
    SET 
        performance_impact_score = CASE 
            WHEN (hit_count + miss_count) > 0 THEN 
                (hit_count::DECIMAL / (hit_count + miss_count)) * 100
            ELSE 0 
        END,
        optimization_suggestion = CASE 
            WHEN (hit_count::DECIMAL / NULLIF(hit_count + miss_count, 0)) < 0.3 THEN 'Consider removing or redesigning cache key'
            WHEN (hit_count::DECIMAL / NULLIF(hit_count + miss_count, 0)) < 0.5 THEN 'Increase TTL or review cache invalidation'
            WHEN (hit_count::DECIMAL / NULLIF(hit_count + miss_count, 0)) < 0.7 THEN 'Fine-tune cache parameters'
            ELSE 'Performing well'
        END,
        updated_at = CURRENT_TIMESTAMP
    WHERE (workspace_uuid IS NULL OR workspace_id = workspace_uuid);
    
    cache_analysis := jsonb_build_object(
        'analysis_timestamp', CURRENT_TIMESTAMP,
        'overall_hit_ratio', hit_ratio,
        'total_cache_requests', total_hits + total_misses,
        'cache_health_score', CASE 
            WHEN hit_ratio >= 80 THEN 95
            WHEN hit_ratio >= 60 THEN 80
            WHEN hit_ratio >= 40 THEN 60
            ELSE 30
        END,
        'optimization_actions', optimization_actions,
        'underperforming_caches', COALESCE(underperforming_caches, '[]'::JSONB),
        'recommendations', jsonb_build_object(
            'increase_memory_cache', hit_ratio < 70,
            'implement_distributed_cache', total_hits + total_misses > 100000,
            'review_cache_keys', underperforming_caches IS NOT NULL
        )
    );
    
    RETURN cache_analysis;
END;
$$;

-- Real-time Performance Monitor
CREATE OR REPLACE FUNCTION public.monitor_real_time_performance()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    performance_status JSONB;
    connection_status JSONB;
    current_connections INTEGER;
    avg_query_time DECIMAL;
    slow_queries INTEGER;
    alert_level TEXT := 'normal';
    alerts_generated INTEGER := 0;
BEGIN
    -- Get current connection metrics
    SELECT 
        COUNT(*) FILTER (WHERE state = 'active'),
        AVG(EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - query_start)) * 1000) FILTER (WHERE state = 'active'),
        COUNT(*) FILTER (WHERE state = 'active' AND EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - query_start)) > 5)
    INTO current_connections, avg_query_time, slow_queries
    FROM pg_stat_activity
    WHERE state IS NOT NULL;
    
    -- Record connection pool metrics
    INSERT INTO public.connection_pool_metrics (
        active_connections,
        idle_connections,
        waiting_connections,
        max_connections,
        connection_utilization_percent,
        avg_query_time_ms,
        slow_query_count
    ) VALUES (
        current_connections,
        (SELECT setting::INTEGER FROM pg_settings WHERE name = 'max_connections') - current_connections,
        0, -- This would need to be calculated from connection pool stats
        (SELECT setting::INTEGER FROM pg_settings WHERE name = 'max_connections'),
        (current_connections::DECIMAL / (SELECT setting::INTEGER FROM pg_settings WHERE name = 'max_connections')) * 100,
        COALESCE(avg_query_time, 0),
        slow_queries
    );
    
    -- Determine alert level
    IF current_connections > 80 OR avg_query_time > 5000 OR slow_queries > 10 THEN
        alert_level := 'critical';
    ELSIF current_connections > 60 OR avg_query_time > 2000 OR slow_queries > 5 THEN
        alert_level := 'warning';
    ELSIF current_connections > 40 OR avg_query_time > 1000 OR slow_queries > 2 THEN
        alert_level := 'info';
    END IF;
    
    -- Generate alerts if needed
    IF alert_level IN ('critical', 'warning') THEN
        INSERT INTO public.performance_alerts (
            alert_type, alert_level, alert_title, alert_message,
            metric_name, current_value
        ) VALUES (
            'database_performance',
            alert_level,
            'Database Performance Alert',
            'Database performance metrics exceed normal thresholds',
            'avg_query_time_ms',
            avg_query_time
        );
        alerts_generated := alerts_generated + 1;
    END IF;
    
    performance_status := jsonb_build_object(
        'timestamp', CURRENT_TIMESTAMP,
        'connection_metrics', jsonb_build_object(
            'active_connections', current_connections,
            'max_connections', (SELECT setting::INTEGER FROM pg_settings WHERE name = 'max_connections'),
            'utilization_percent', (current_connections::DECIMAL / (SELECT setting::INTEGER FROM pg_settings WHERE name = 'max_connections')) * 100
        ),
        'query_performance', jsonb_build_object(
            'avg_query_time_ms', COALESCE(avg_query_time, 0),
            'slow_queries_count', slow_queries,
            'performance_score', CASE 
                WHEN avg_query_time <= 100 THEN 95
                WHEN avg_query_time <= 500 THEN 80
                WHEN avg_query_time <= 1000 THEN 60
                WHEN avg_query_time <= 2000 THEN 40
                ELSE 20
            END
        ),
        'alert_level', alert_level,
        'alerts_generated', alerts_generated,
        'health_status', CASE 
            WHEN alert_level = 'normal' THEN 'healthy'
            WHEN alert_level = 'info' THEN 'monitoring'
            WHEN alert_level = 'warning' THEN 'degraded'
            ELSE 'critical'
        END
    );
    
    RETURN performance_status;
END;
$$;

-- 5. RLS Policies for New Tables
-- Query optimization logs - workspace member access
CREATE POLICY "workspace_query_optimization_logs" ON public.query_optimization_logs FOR ALL
USING (public.is_workspace_member(workspace_id));

-- Connection pool metrics - admin access only
CREATE POLICY "admin_connection_pool_metrics" ON public.connection_pool_metrics FOR SELECT
USING (public.has_role('admin'));

-- Predictive scaling data - workspace member access
CREATE POLICY "workspace_predictive_scaling_data" ON public.predictive_scaling_data FOR ALL
USING (public.is_workspace_member(workspace_id));

-- Error analytics - workspace member access
CREATE POLICY "workspace_error_analytics" ON public.error_analytics FOR ALL
USING (
    workspace_id IS NULL OR
    public.is_workspace_member(workspace_id)
);

-- Performance alerts - workspace member access
CREATE POLICY "workspace_performance_alerts" ON public.performance_alerts FOR ALL
USING (
    workspace_id IS NULL OR
    public.is_workspace_member(workspace_id)
);

-- Cache analytics - workspace member access
CREATE POLICY "workspace_cache_analytics" ON public.intelligent_cache_analytics FOR ALL
USING (
    workspace_id IS NULL OR
    public.is_workspace_member(workspace_id)
);

-- 6. Advanced Automation Triggers
-- Auto-escalation for unresolved alerts
CREATE OR REPLACE FUNCTION public.auto_escalate_alerts()
RETURNS TRIGGER AS $$
BEGIN
    -- Auto-escalate critical alerts after 15 minutes
    IF NEW.alert_level = 'critical' AND NEW.escalation_level = 0 THEN
        -- Schedule escalation
        INSERT INTO public.background_jobs (
            job_type, payload, scheduled_for
        ) VALUES (
            'escalate_alert',
            jsonb_build_object('alert_id', NEW.id),
            CURRENT_TIMESTAMP + INTERVAL '15 minutes'
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER auto_escalate_performance_alerts
    AFTER INSERT ON public.performance_alerts
    FOR EACH ROW
    WHEN (NEW.alert_level = 'critical')
    EXECUTE FUNCTION public.auto_escalate_alerts();

-- Auto-optimization for repeated errors
CREATE OR REPLACE FUNCTION public.auto_optimize_errors()
RETURNS TRIGGER AS $$
BEGIN
    -- If error occurs more than 10 times, attempt automated fix
    IF NEW.occurrence_count > 10 AND NOT NEW.automated_fix_applied THEN
        UPDATE public.error_analytics
        SET 
            automated_fix_applied = true,
            fix_description = 'Automated optimization applied for frequent error'
        WHERE id = NEW.id;
        
        -- Schedule automated fix job
        INSERT INTO public.background_jobs (
            job_type, payload, priority
        ) VALUES (
            'auto_fix_error',
            jsonb_build_object(
                'error_id', NEW.id,
                'error_type', NEW.error_type,
                'error_code', NEW.error_code
            ),
            8
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER auto_optimize_repeated_errors
    AFTER UPDATE ON public.error_analytics
    FOR EACH ROW
    WHEN (NEW.occurrence_count > OLD.occurrence_count AND NEW.occurrence_count > 10)
    EXECUTE FUNCTION public.auto_optimize_errors();

-- 7. Advanced Views for Real-time Monitoring
CREATE OR REPLACE VIEW public.real_time_performance_dashboard AS
SELECT 
    'system_overview' as component,
    jsonb_build_object(
        'active_connections', COUNT(*) FILTER (WHERE pa.state = 'active'),
        'total_queries_today', (
            SELECT COUNT(*) FROM public.query_optimization_logs 
            WHERE created_at >= CURRENT_DATE
        ),
        'avg_response_time_ms', COALESCE(AVG(qol.execution_time_ms), 0),
        'cache_hit_ratio', COALESCE(
            (SELECT 
                CASE WHEN SUM(hit_count + miss_count) > 0 
                THEN (SUM(hit_count)::DECIMAL / SUM(hit_count + miss_count)) * 100 
                ELSE 0 END
             FROM public.intelligent_cache_analytics 
             WHERE updated_at >= CURRENT_TIMESTAMP - INTERVAL '1 hour'), 0
        ),
        'active_alerts', (
            SELECT COUNT(*) FROM public.performance_alerts 
            WHERE resolved_at IS NULL AND created_at >= CURRENT_TIMESTAMP - INTERVAL '24 hours'
        ),
        'error_rate_24h', (
            SELECT COUNT(*) FROM public.error_analytics 
            WHERE first_occurrence >= CURRENT_TIMESTAMP - INTERVAL '24 hours'
        )
    ) as metrics,
    CURRENT_TIMESTAMP as last_updated
FROM pg_stat_activity pa
LEFT JOIN public.query_optimization_logs qol ON qol.created_at >= CURRENT_TIMESTAMP - INTERVAL '1 hour'
WHERE pa.state IS NOT NULL;

-- 8. Automated Cleanup and Maintenance
CREATE OR REPLACE FUNCTION public.automated_performance_maintenance()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    maintenance_report JSONB;
    cleaned_query_logs INTEGER;
    cleaned_connection_metrics INTEGER;
    cleaned_cache_analytics INTEGER;
    cleaned_error_logs INTEGER;
    cleaned_alerts INTEGER;
    optimization_actions INTEGER := 0;
BEGIN
    -- Clean old query optimization logs (keep 30 days)
    DELETE FROM public.query_optimization_logs
    WHERE created_at < CURRENT_TIMESTAMP - INTERVAL '30 days';
    GET DIAGNOSTICS cleaned_query_logs = ROW_COUNT;
    
    -- Clean old connection pool metrics (keep 7 days)
    DELETE FROM public.connection_pool_metrics
    WHERE timestamp < CURRENT_TIMESTAMP - INTERVAL '7 days';
    GET DIAGNOSTICS cleaned_connection_metrics = ROW_COUNT;
    
    -- Clean old cache analytics (keep 14 days)
    DELETE FROM public.intelligent_cache_analytics
    WHERE created_at < CURRENT_TIMESTAMP - INTERVAL '14 days';
    GET DIAGNOSTICS cleaned_cache_analytics = ROW_COUNT;
    
    -- Clean resolved error analytics (keep 60 days)
    DELETE FROM public.error_analytics
    WHERE resolution_status = 'resolved' 
    AND first_occurrence < CURRENT_TIMESTAMP - INTERVAL '60 days';
    GET DIAGNOSTICS cleaned_error_logs = ROW_COUNT;
    
    -- Clean resolved alerts (keep 30 days)
    DELETE FROM public.performance_alerts
    WHERE resolved_at IS NOT NULL 
    AND resolved_at < CURRENT_TIMESTAMP - INTERVAL '30 days';
    GET DIAGNOSTICS cleaned_alerts = ROW_COUNT;
    
    -- Update table statistics for performance
    ANALYZE public.query_optimization_logs;
    ANALYZE public.connection_pool_metrics;
    ANALYZE public.intelligent_cache_analytics;
    ANALYZE public.error_analytics;
    ANALYZE public.performance_alerts;
    optimization_actions := optimization_actions + 5;
    
    -- Generate maintenance report
    maintenance_report := jsonb_build_object(
        'maintenance_timestamp', CURRENT_TIMESTAMP,
        'cleanup_summary', jsonb_build_object(
            'query_logs_cleaned', cleaned_query_logs,
            'connection_metrics_cleaned', cleaned_connection_metrics,
            'cache_analytics_cleaned', cleaned_cache_analytics,
            'error_logs_cleaned', cleaned_error_logs,
            'alerts_cleaned', cleaned_alerts
        ),
        'optimization_actions_performed', optimization_actions,
        'next_maintenance', CURRENT_TIMESTAMP + INTERVAL '24 hours'
    );
    
    -- Record maintenance completion
    INSERT INTO public.system_health_metrics (
        metric_name, metric_value, metric_unit, tags
    ) VALUES (
        'automated_maintenance_completed',
        1,
        'boolean',
        jsonb_build_object(
            'cleaned_records', cleaned_query_logs + cleaned_connection_metrics + cleaned_cache_analytics + cleaned_error_logs + cleaned_alerts,
            'optimization_actions', optimization_actions
        )
    );
    
    RETURN maintenance_report;
END;
$$;

-- 9. Final Production Optimizations
-- Create materialized view for dashboard performance
CREATE MATERIALIZED VIEW IF NOT EXISTS public.workspace_performance_summary AS
SELECT 
    w.id as workspace_id,
    w.name as workspace_name,
    COUNT(DISTINCT qol.id) as total_queries_24h,
    AVG(qol.execution_time_ms) as avg_query_time_ms,
    COUNT(DISTINCT ea.id) as error_count_24h,
    COUNT(DISTINCT pa.id) as active_alerts,
    COALESCE(
        (SELECT (SUM(hit_count)::DECIMAL / NULLIF(SUM(hit_count + miss_count), 0)) * 100
         FROM public.intelligent_cache_analytics ica 
         WHERE ica.workspace_id = w.id 
         AND ica.updated_at >= CURRENT_TIMESTAMP - INTERVAL '24 hours'), 0
    ) as cache_hit_ratio,
    CASE 
        WHEN COUNT(DISTINCT pa.id) = 0 AND COUNT(DISTINCT ea.id) < 5 AND AVG(qol.execution_time_ms) < 1000 THEN 'healthy'
        WHEN COUNT(DISTINCT pa.id) <= 2 AND COUNT(DISTINCT ea.id) < 10 AND AVG(qol.execution_time_ms) < 2000 THEN 'warning'
        ELSE 'critical'
    END as health_status,
    CURRENT_TIMESTAMP as last_updated
FROM public.workspaces w
LEFT JOIN public.query_optimization_logs qol ON qol.workspace_id = w.id 
    AND qol.created_at >= CURRENT_TIMESTAMP - INTERVAL '24 hours'
LEFT JOIN public.error_analytics ea ON ea.workspace_id = w.id 
    AND ea.first_occurrence >= CURRENT_TIMESTAMP - INTERVAL '24 hours'
LEFT JOIN public.performance_alerts pa ON pa.workspace_id = w.id 
    AND pa.resolved_at IS NULL
GROUP BY w.id, w.name;

-- Create index on materialized view
CREATE UNIQUE INDEX IF NOT EXISTS idx_workspace_performance_summary_workspace_id 
ON public.workspace_performance_summary(workspace_id);

-- Function to refresh performance summary
CREATE OR REPLACE FUNCTION public.refresh_performance_summary()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY public.workspace_performance_summary;
END;
$$;

-- 10. Final Health Check Function
CREATE OR REPLACE FUNCTION public.comprehensive_system_health_check()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    health_report JSONB;
    database_health JSONB;
    performance_health JSONB;
    security_health JSONB;
    overall_score INTEGER;
BEGIN
    -- Database health
    database_health := jsonb_build_object(
        'connection_utilization', (
            SELECT (COUNT(*)::DECIMAL / (SELECT setting::INTEGER FROM pg_settings WHERE name = 'max_connections')) * 100
            FROM pg_stat_activity WHERE state IS NOT NULL
        ),
        'avg_query_time_ms', (
            SELECT COALESCE(AVG(execution_time_ms), 0)
            FROM public.query_optimization_logs
            WHERE created_at >= CURRENT_TIMESTAMP - INTERVAL '1 hour'
        ),
        'slow_queries_count', (
            SELECT COUNT(*)
            FROM public.query_optimization_logs
            WHERE execution_time_ms > 5000
            AND created_at >= CURRENT_TIMESTAMP - INTERVAL '1 hour'
        )
    );
    
    -- Performance health
    performance_health := jsonb_build_object(
        'cache_hit_ratio', (
            SELECT CASE WHEN SUM(hit_count + miss_count) > 0 
                   THEN (SUM(hit_count)::DECIMAL / SUM(hit_count + miss_count)) * 100 
                   ELSE 100 END
            FROM public.intelligent_cache_analytics
            WHERE updated_at >= CURRENT_TIMESTAMP - INTERVAL '1 hour'
        ),
        'active_alerts_count', (
            SELECT COUNT(*)
            FROM public.performance_alerts
            WHERE resolved_at IS NULL
        ),
        'error_rate_24h', (
            SELECT COUNT(*)
            FROM public.error_analytics
            WHERE first_occurrence >= CURRENT_TIMESTAMP - INTERVAL '24 hours'
        )
    );
    
    -- Security health
    security_health := jsonb_build_object(
        'failed_auth_attempts', (
            SELECT COUNT(*)
            FROM public.security_audit_log
            WHERE action_type = 'user_authentication'
            AND success = false
            AND created_at >= CURRENT_TIMESTAMP - INTERVAL '24 hours'
        ),
        'high_risk_events', (
            SELECT COUNT(*)
            FROM public.security_audit_log
            WHERE risk_score > 70
            AND created_at >= CURRENT_TIMESTAMP - INTERVAL '24 hours'
        ),
        'blocked_users', (
            SELECT COUNT(DISTINCT user_id)
            FROM public.api_rate_limits
            WHERE is_blocked = true
        )
    );
    
    -- Calculate overall health score
    overall_score := 100;
    
    -- Deduct points based on issues
    IF (database_health->>'connection_utilization')::DECIMAL > 80 THEN
        overall_score := overall_score - 20;
    END IF;
    
    IF (database_health->>'avg_query_time_ms')::DECIMAL > 2000 THEN
        overall_score := overall_score - 15;
    END IF;
    
    IF (performance_health->>'cache_hit_ratio')::DECIMAL < 60 THEN
        overall_score := overall_score - 15;
    END IF;
    
    IF (performance_health->>'active_alerts_count')::INTEGER > 5 THEN
        overall_score := overall_score - 25;
    END IF;
    
    IF (security_health->>'high_risk_events')::INTEGER > 10 THEN
        overall_score := overall_score - 20;
    END IF;
    
    overall_score := GREATEST(0, overall_score);
    
    health_report := jsonb_build_object(
        'timestamp', CURRENT_TIMESTAMP,
        'overall_health_score', overall_score,
        'health_status', CASE 
            WHEN overall_score >= 90 THEN 'excellent'
            WHEN overall_score >= 75 THEN 'good'
            WHEN overall_score >= 60 THEN 'fair'
            WHEN overall_score >= 40 THEN 'poor'
            ELSE 'critical'
        END,
        'database_health', database_health,
        'performance_health', performance_health,
        'security_health', security_health,
        'recommendations', CASE 
            WHEN overall_score < 60 THEN '["Immediate attention required", "Review system alerts", "Consider scaling resources"]'::JSONB
            WHEN overall_score < 80 THEN '["Monitor performance closely", "Review recent changes", "Optimize slow queries"]'::JSONB
            ELSE '["System performing well", "Continue monitoring", "Regular maintenance on schedule"]'::JSONB
        END
    );
    
    RETURN health_report;
END;
$$;

-- Comments for maintenance and monitoring
COMMENT ON FUNCTION public.automated_performance_maintenance IS 'Run daily for automated system maintenance and optimization';
COMMENT ON FUNCTION public.comprehensive_system_health_check IS 'Generate comprehensive system health report for monitoring dashboards';
COMMENT ON FUNCTION public.optimize_query_performance IS 'Analyze and optimize query performance with intelligent suggestions';
COMMENT ON FUNCTION public.analyze_predictive_scaling IS 'Predict scaling needs based on usage patterns and trends';

-- Final performance optimization
ANALYZE public.query_optimization_logs;
ANALYZE public.connection_pool_metrics;
ANALYZE public.predictive_scaling_data;
ANALYZE public.error_analytics;
ANALYZE public.performance_alerts;
ANALYZE public.intelligent_cache_analytics;

-- Record completion
INSERT INTO public.system_health_metrics (metric_name, metric_value, metric_unit, tags)
VALUES (
    'enhanced_production_optimization_completed',
    1,
    'boolean',
    jsonb_build_object(
        'migration_timestamp', CURRENT_TIMESTAMP,
        'version', '20250710190000',
        'optimization_level', 'enterprise_grade',
        'features_added', jsonb_build_array(
            'intelligent_query_optimization',
            'predictive_scaling_analytics',
            'advanced_error_analytics',
            'real_time_performance_monitoring',
            'automated_cache_optimization',
            'comprehensive_health_checks'
        )
    )
);
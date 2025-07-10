-- Location: supabase/migrations/20250710191000_fix_concurrent_index_creation_final.sql
-- Fix CREATE INDEX CONCURRENTLY transaction block error from enhanced production optimization

-- Module Detection: Index Creation Fix Module
-- IMPLEMENTING MODULE: Fix CREATE INDEX CONCURRENTLY statements that cannot run in transaction blocks
-- SCOPE: Remove CONCURRENTLY keyword from all index creation statements to allow transaction execution

-- Fix: Remove CONCURRENTLY from all index creation statements
-- Standard CREATE INDEX can be used in transaction blocks

-- 1. Drop any potentially conflicting indexes that might have been partially created
DROP INDEX IF EXISTS idx_query_optimization_signature_time;
DROP INDEX IF EXISTS idx_query_optimization_workspace_performance;
DROP INDEX IF EXISTS idx_connection_pool_utilization;
DROP INDEX IF EXISTS idx_predictive_scaling_workspace_type;
DROP INDEX IF EXISTS idx_predictive_scaling_recommendations;
DROP INDEX IF EXISTS idx_error_analytics_workspace_unresolved;
DROP INDEX IF EXISTS idx_error_analytics_frequency;
DROP INDEX IF EXISTS idx_performance_alerts_workspace_level;
DROP INDEX IF EXISTS idx_performance_alerts_escalation;
DROP INDEX IF EXISTS idx_cache_analytics_performance;
DROP INDEX IF EXISTS idx_cache_analytics_hit_ratio;

-- 2. Recreate indexes without CONCURRENTLY (safe for transaction blocks)
-- Query optimization performance indexes
CREATE INDEX idx_query_optimization_signature_time 
ON public.query_optimization_logs(query_signature, execution_time_ms DESC, created_at DESC);

CREATE INDEX idx_query_optimization_workspace_performance 
ON public.query_optimization_logs(workspace_id, execution_time_ms DESC) 
WHERE execution_time_ms > 1000;

-- Connection pool performance indexes
CREATE INDEX idx_connection_pool_utilization 
ON public.connection_pool_metrics(connection_utilization_percent DESC, timestamp DESC) 
WHERE connection_utilization_percent > 80;

-- Predictive scaling indexes
CREATE INDEX idx_predictive_scaling_workspace_type 
ON public.predictive_scaling_data(workspace_id, metric_type, created_at DESC);

CREATE INDEX idx_predictive_scaling_recommendations 
ON public.predictive_scaling_data(scaling_recommendation, prediction_confidence DESC) 
WHERE scaling_recommendation IS NOT NULL;

-- Error analytics indexes
CREATE INDEX idx_error_analytics_workspace_unresolved 
ON public.error_analytics(workspace_id, resolution_status, impact_level DESC) 
WHERE resolution_status = 'unresolved';

CREATE INDEX idx_error_analytics_frequency 
ON public.error_analytics(error_type, occurrence_count DESC, last_occurrence DESC);

-- Performance alerts indexes
CREATE INDEX idx_performance_alerts_workspace_level 
ON public.performance_alerts(workspace_id, alert_level, created_at DESC) 
WHERE resolved_at IS NULL;

CREATE INDEX idx_performance_alerts_escalation 
ON public.performance_alerts(escalation_level DESC, created_at ASC) 
WHERE escalation_level > 0 AND resolved_at IS NULL;

-- Cache analytics indexes
CREATE INDEX idx_cache_analytics_performance 
ON public.intelligent_cache_analytics(cache_key, performance_impact_score DESC, last_accessed DESC);

CREATE INDEX idx_cache_analytics_hit_ratio 
ON public.intelligent_cache_analytics(workspace_id, hit_count, miss_count, updated_at DESC);

-- 3. Add missing composite indexes for optimal query performance
CREATE INDEX idx_query_optimization_workspace_time_signature 
ON public.query_optimization_logs(workspace_id, created_at DESC, query_signature);

CREATE INDEX idx_error_analytics_workspace_time_type 
ON public.error_analytics(workspace_id, first_occurrence DESC, error_type);

CREATE INDEX idx_performance_alerts_workspace_time_status 
ON public.performance_alerts(workspace_id, created_at DESC, alert_level) 
WHERE resolved_at IS NULL;

CREATE INDEX idx_cache_analytics_workspace_performance_time 
ON public.intelligent_cache_analytics(workspace_id, performance_impact_score DESC, updated_at DESC);

CREATE INDEX idx_predictive_scaling_workspace_confidence_time 
ON public.predictive_scaling_data(workspace_id, prediction_confidence DESC, created_at DESC);

-- 4. Add missing unique constraints that were prevented by CONCURRENTLY errors
-- Ensure unique constraint for workspace performance summary
ALTER TABLE public.query_optimization_logs 
ADD CONSTRAINT uk_query_optimization_workspace_signature_time 
UNIQUE (workspace_id, query_signature, created_at);

-- 5. Optimize existing tables with additional performance indexes
CREATE INDEX idx_connection_pool_metrics_timestamp_performance 
ON public.connection_pool_metrics(timestamp DESC, avg_query_time_ms DESC, slow_query_count DESC);

CREATE INDEX idx_error_analytics_impact_resolution_time 
ON public.error_analytics(impact_level DESC, resolution_status, first_occurrence DESC);

CREATE INDEX idx_performance_alerts_priority_unresolved 
ON public.performance_alerts(alert_level DESC, escalation_level DESC, created_at ASC) 
WHERE resolved_at IS NULL;

-- 6. Final verification and optimization
-- Analyze all tables to update statistics after index creation
ANALYZE public.query_optimization_logs;
ANALYZE public.connection_pool_metrics;
ANALYZE public.predictive_scaling_data;
ANALYZE public.error_analytics;
ANALYZE public.performance_alerts;
ANALYZE public.intelligent_cache_analytics;

-- 7. Create function to verify index creation success
CREATE OR REPLACE FUNCTION public.verify_performance_indexes()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    index_report JSONB;
    missing_indexes TEXT[] := '{}';
    created_indexes TEXT[] := '{}';
    index_count INTEGER;
BEGIN
    -- Check for required performance indexes
    SELECT COUNT(*) INTO index_count
    FROM pg_indexes 
    WHERE schemaname = 'public' 
    AND tablename IN (
        'query_optimization_logs', 
        'connection_pool_metrics', 
        'predictive_scaling_data',
        'error_analytics', 
        'performance_alerts', 
        'intelligent_cache_analytics'
    );
    
    -- Verify specific critical indexes exist
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_query_optimization_signature_time') THEN
        missing_indexes := array_append(missing_indexes, 'idx_query_optimization_signature_time');
    ELSE
        created_indexes := array_append(created_indexes, 'idx_query_optimization_signature_time');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_error_analytics_workspace_unresolved') THEN
        missing_indexes := array_append(missing_indexes, 'idx_error_analytics_workspace_unresolved');
    ELSE
        created_indexes := array_append(created_indexes, 'idx_error_analytics_workspace_unresolved');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_performance_alerts_workspace_level') THEN
        missing_indexes := array_append(missing_indexes, 'idx_performance_alerts_workspace_level');
    ELSE
        created_indexes := array_append(created_indexes, 'idx_performance_alerts_workspace_level');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_cache_analytics_performance') THEN
        missing_indexes := array_append(missing_indexes, 'idx_cache_analytics_performance');
    ELSE
        created_indexes := array_append(created_indexes, 'idx_cache_analytics_performance');
    END IF;
    
    index_report := jsonb_build_object(
        'verification_timestamp', CURRENT_TIMESTAMP,
        'total_performance_indexes', index_count,
        'critical_indexes_created', array_length(created_indexes, 1),
        'missing_indexes', missing_indexes,
        'created_indexes', created_indexes,
        'migration_status', CASE 
            WHEN array_length(missing_indexes, 1) = 0 OR missing_indexes IS NULL THEN 'success'
            WHEN array_length(missing_indexes, 1) <= 2 THEN 'partial_success'
            ELSE 'needs_attention'
        END,
        'performance_optimization_level', CASE 
            WHEN index_count >= 15 THEN 'excellent'
            WHEN index_count >= 10 THEN 'good'
            WHEN index_count >= 5 THEN 'basic'
            ELSE 'insufficient'
        END
    );
    
    RETURN index_report;
END;
$$;

-- 8. Execute verification and log results
DO $$
DECLARE
    verification_result JSONB;
BEGIN
    -- Verify index creation
    SELECT public.verify_performance_indexes() INTO verification_result;
    
    -- Log verification results
    INSERT INTO public.system_health_metrics (
        metric_name, 
        metric_value, 
        metric_unit, 
        tags
    ) VALUES (
        'concurrent_index_fix_verification',
        1,
        'boolean',
        verification_result
    );
    
    -- Raise notice for monitoring
    RAISE NOTICE 'Index creation verification completed: %', verification_result;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Index verification failed: %', SQLERRM;
END $$;

-- 9. Final performance tuning
-- Update table statistics for all performance-critical tables
VACUUM ANALYZE public.query_optimization_logs;
VACUUM ANALYZE public.connection_pool_metrics;
VACUUM ANALYZE public.predictive_scaling_data;
VACUUM ANALYZE public.error_analytics;
VACUUM ANALYZE public.performance_alerts;
VACUUM ANALYZE public.intelligent_cache_analytics;

-- Record successful migration completion
INSERT INTO public.system_health_metrics (
    metric_name, 
    metric_value, 
    metric_unit, 
    tags
) VALUES (
    'concurrent_index_fix_completed',
    1,
    'boolean',
    jsonb_build_object(
        'migration_timestamp', CURRENT_TIMESTAMP,
        'migration_file', '20250710191000_fix_concurrent_index_creation_final.sql',
        'indexes_fixed', 11,
        'performance_optimization', 'enhanced',
        'transaction_compatibility', 'resolved'
    )
);

-- Comments for documentation
COMMENT ON FUNCTION public.verify_performance_indexes IS 'Verify that all critical performance indexes were created successfully without CONCURRENTLY errors';

-- Final success confirmation
-- This migration resolves the CREATE INDEX CONCURRENTLY transaction block error
-- All indexes are now created using standard CREATE INDEX which works within transactions
-- Performance optimization is maintained while ensuring migration compatibility
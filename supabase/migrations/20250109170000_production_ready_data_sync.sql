-- Location: supabase/migrations/20250109170000_production_ready_data_sync.sql
-- Production Ready Data Synchronization and Performance Optimization

-- 1. Enhanced Analytics Event Tracking
CREATE OR REPLACE FUNCTION public.track_analytics_event_batch(
    events JSONB[]
)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    event_count INTEGER := 0;
    event_item JSONB;
    current_workspace_id UUID;
    current_user_id UUID := auth.uid();
BEGIN
    -- Get current workspace
    IF current_user_id IS NOT NULL THEN
        SELECT workspace_id INTO current_workspace_id
        FROM public.workspace_members
        WHERE user_id = current_user_id AND is_active = true
        ORDER BY joined_at DESC
        LIMIT 1;
    END IF;
    
    -- Process each event
    FOREACH event_item IN ARRAY events LOOP
        INSERT INTO public.analytics_events (
            workspace_id,
            user_id,
            event_name,
            event_data,
            session_id,
            platform,
            user_agent,
            created_at
        ) VALUES (
            COALESCE((event_item->>'workspace_id')::UUID, current_workspace_id),
            COALESCE((event_item->>'user_id')::UUID, current_user_id),
            event_item->>'event_name',
            COALESCE(event_item->'event_data', '{}'),
            event_item->>'session_id',
            event_item->>'platform',
            event_item->>'user_agent',
            COALESCE((event_item->>'created_at')::TIMESTAMPTZ, CURRENT_TIMESTAMP)
        );
        
        event_count := event_count + 1;
    END LOOP;
    
    RETURN event_count;
END;
$$;

-- 2. Enhanced Workspace Analytics Function
CREATE OR REPLACE FUNCTION public.get_workspace_analytics_summary(
    workspace_uuid UUID,
    start_date DATE DEFAULT CURRENT_DATE - INTERVAL '30 days',
    end_date DATE DEFAULT CURRENT_DATE
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    analytics_summary JSONB;
    revenue_metrics JSONB;
    social_metrics JSONB;
    engagement_metrics JSONB;
    product_metrics JSONB;
    user_metrics JSONB;
BEGIN
    -- Check access
    IF NOT public.is_workspace_member(workspace_uuid) THEN
        RAISE EXCEPTION 'Access denied to workspace analytics';
    END IF;
    
    -- Revenue metrics
    SELECT jsonb_build_object(
        'total_revenue', COALESCE(SUM(total_amount), 0),
        'total_orders', COUNT(*),
        'avg_order_value', COALESCE(AVG(total_amount), 0),
        'completed_orders', COUNT(*) FILTER (WHERE status = 'completed'),
        'pending_orders', COUNT(*) FILTER (WHERE status = 'pending')
    ) INTO revenue_metrics
    FROM public.orders
    WHERE workspace_id = workspace_uuid
    AND created_at::DATE BETWEEN start_date AND end_date;
    
    -- Social media metrics
    SELECT jsonb_build_object(
        'total_posts', COUNT(*),
        'published_posts', COUNT(*) FILTER (WHERE status = 'published'),
        'scheduled_posts', COUNT(*) FILTER (WHERE status = 'scheduled'),
        'platforms', COUNT(DISTINCT sma.platform)
    ) INTO social_metrics
    FROM public.social_media_posts smp
    JOIN public.social_media_accounts sma ON smp.account_id = sma.id
    WHERE smp.workspace_id = workspace_uuid
    AND smp.created_at::DATE BETWEEN start_date AND end_date;
    
    -- Engagement metrics from analytics events
    SELECT jsonb_build_object(
        'total_events', COUNT(*),
        'unique_sessions', COUNT(DISTINCT session_id),
        'page_views', COUNT(*) FILTER (WHERE event_name = 'page_view'),
        'button_clicks', COUNT(*) FILTER (WHERE event_name = 'button_click'),
        'form_submissions', COUNT(*) FILTER (WHERE event_name = 'form_submit')
    ) INTO engagement_metrics
    FROM public.analytics_events
    WHERE workspace_id = workspace_uuid
    AND created_at::DATE BETWEEN start_date AND end_date;
    
    -- Product metrics
    SELECT jsonb_build_object(
        'total_products', COUNT(*),
        'active_products', COUNT(*) FILTER (WHERE status = 'active'),
        'low_stock_products', COUNT(*) FILTER (WHERE stock_quantity <= stock_threshold),
        'out_of_stock_products', COUNT(*) FILTER (WHERE status = 'out_of_stock'),
        'total_inventory_value', COALESCE(SUM(price * stock_quantity), 0)
    ) INTO product_metrics
    FROM public.products
    WHERE workspace_id = workspace_uuid;
    
    -- User metrics
    SELECT jsonb_build_object(
        'total_members', COUNT(*),
        'active_members', COUNT(*) FILTER (WHERE is_active = true),
        'owner_count', COUNT(*) FILTER (WHERE role = 'owner'),
        'admin_count', COUNT(*) FILTER (WHERE role = 'admin'),
        'member_count', COUNT(*) FILTER (WHERE role = 'member')
    ) INTO user_metrics
    FROM public.workspace_members
    WHERE workspace_id = workspace_uuid;
    
    -- Combine all metrics
    analytics_summary := jsonb_build_object(
        'workspace_id', workspace_uuid,
        'date_range', jsonb_build_object(
            'start_date', start_date,
            'end_date', end_date
        ),
        'revenue', revenue_metrics,
        'social_media', social_metrics,
        'engagement', engagement_metrics,
        'products', product_metrics,
        'users', user_metrics,
        'generated_at', CURRENT_TIMESTAMP
    );
    
    RETURN analytics_summary;
END;
$$;

-- 3. Data Synchronization Status Tracking
CREATE TABLE public.sync_status (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    table_name TEXT NOT NULL,
    last_sync_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    sync_status TEXT DEFAULT 'pending',
    error_message TEXT,
    retry_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4. Offline Queue Management
CREATE TABLE public.offline_operations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    operation_type TEXT NOT NULL,
    table_name TEXT NOT NULL,
    operation_data JSONB NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMPTZ,
    retry_count INTEGER DEFAULT 0,
    max_retries INTEGER DEFAULT 3,
    status TEXT DEFAULT 'pending'
);

-- 5. Performance Optimization Indexes
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_analytics_events_workspace_created 
ON public.analytics_events(workspace_id, created_at DESC);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_analytics_events_session_id 
ON public.analytics_events(session_id) WHERE session_id IS NOT NULL;

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_social_media_posts_status_created 
ON public.social_media_posts(status, created_at DESC);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_products_workspace_status 
ON public.products(workspace_id, status);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_orders_workspace_status_created 
ON public.orders(workspace_id, status, created_at DESC);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_notifications_user_read 
ON public.notifications(user_id, read_at) WHERE read_at IS NULL;

-- 6. RLS Policies for new tables
ALTER TABLE public.sync_status ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.offline_operations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_sync_status" ON public.sync_status FOR ALL
USING (auth.uid() = user_id);

CREATE POLICY "users_own_offline_operations" ON public.offline_operations FOR ALL
USING (auth.uid() = user_id);

-- 7. Real-time Performance Functions
CREATE OR REPLACE FUNCTION public.get_real_time_metrics(workspace_uuid UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    metrics JSONB;
    current_hour INTEGER := EXTRACT(HOUR FROM CURRENT_TIMESTAMP);
    current_date DATE := CURRENT_DATE;
BEGIN
    -- Check access
    IF NOT public.is_workspace_member(workspace_uuid) THEN
        RAISE EXCEPTION 'Access denied to workspace metrics';
    END IF;
    
    -- Get current hour metrics
    SELECT jsonb_build_object(
        'hourly_events', COUNT(*),
        'unique_users', COUNT(DISTINCT user_id),
        'page_views', COUNT(*) FILTER (WHERE event_name = 'page_view'),
        'revenue_today', COALESCE(
            (SELECT SUM(total_amount) FROM public.orders 
             WHERE workspace_id = workspace_uuid 
             AND created_at::DATE = current_date), 0
        ),
        'orders_today', COALESCE(
            (SELECT COUNT(*) FROM public.orders 
             WHERE workspace_id = workspace_uuid 
             AND created_at::DATE = current_date), 0
        ),
        'posts_today', COALESCE(
            (SELECT COUNT(*) FROM public.social_media_posts 
             WHERE workspace_id = workspace_uuid 
             AND created_at::DATE = current_date), 0
        ),
        'unread_notifications', COALESCE(
            (SELECT COUNT(*) FROM public.notifications 
             WHERE workspace_id = workspace_uuid 
             AND read_at IS NULL), 0
        ),
        'current_hour', current_hour,
        'current_date', current_date,
        'timestamp', CURRENT_TIMESTAMP
    ) INTO metrics
    FROM public.analytics_events
    WHERE workspace_id = workspace_uuid
    AND created_at >= CURRENT_TIMESTAMP - INTERVAL '1 hour';
    
    RETURN metrics;
END;
$$;

-- 8. Batch Operation Functions
CREATE OR REPLACE FUNCTION public.batch_update_products(
    workspace_uuid UUID,
    updates JSONB[]
)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    update_count INTEGER := 0;
    update_item JSONB;
    product_id UUID;
BEGIN
    -- Check access
    IF NOT public.is_workspace_member(workspace_uuid) THEN
        RAISE EXCEPTION 'Access denied to workspace products';
    END IF;
    
    -- Process each update
    FOREACH update_item IN ARRAY updates LOOP
        product_id := (update_item->>'id')::UUID;
        
        UPDATE public.products
        SET 
            name = COALESCE(update_item->>'name', name),
            price = COALESCE((update_item->>'price')::DECIMAL, price),
            stock_quantity = COALESCE((update_item->>'stock_quantity')::INTEGER, stock_quantity),
            status = COALESCE((update_item->>'status')::public.product_status, status),
            updated_at = CURRENT_TIMESTAMP
        WHERE id = product_id AND workspace_id = workspace_uuid;
        
        IF FOUND THEN
            update_count := update_count + 1;
        END IF;
    END LOOP;
    
    RETURN update_count;
END;
$$;

-- 9. Data Export Functions
CREATE OR REPLACE FUNCTION public.export_workspace_data(
    workspace_uuid UUID,
    table_names TEXT[] DEFAULT ARRAY['analytics_events', 'social_media_posts', 'products', 'orders']
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    export_data JSONB := '{}';
    table_name TEXT;
    table_data JSONB;
BEGIN
    -- Check access
    IF NOT public.is_workspace_member(workspace_uuid) THEN
        RAISE EXCEPTION 'Access denied to workspace data export';
    END IF;
    
    -- Export each requested table
    FOREACH table_name IN ARRAY table_names LOOP
        CASE table_name
            WHEN 'analytics_events' THEN
                SELECT jsonb_agg(
                    jsonb_build_object(
                        'id', id,
                        'event_name', event_name,
                        'event_data', event_data,
                        'created_at', created_at
                    )
                ) INTO table_data
                FROM public.analytics_events
                WHERE workspace_id = workspace_uuid
                AND created_at >= CURRENT_DATE - INTERVAL '90 days';
                
            WHEN 'social_media_posts' THEN
                SELECT jsonb_agg(
                    jsonb_build_object(
                        'id', id,
                        'content', content,
                        'status', status,
                        'created_at', created_at
                    )
                ) INTO table_data
                FROM public.social_media_posts
                WHERE workspace_id = workspace_uuid;
                
            WHEN 'products' THEN
                SELECT jsonb_agg(
                    jsonb_build_object(
                        'id', id,
                        'name', name,
                        'price', price,
                        'stock_quantity', stock_quantity,
                        'status', status
                    )
                ) INTO table_data
                FROM public.products
                WHERE workspace_id = workspace_uuid;
                
            WHEN 'orders' THEN
                SELECT jsonb_agg(
                    jsonb_build_object(
                        'id', id,
                        'order_number', order_number,
                        'total_amount', total_amount,
                        'status', status,
                        'created_at', created_at
                    )
                ) INTO table_data
                FROM public.orders
                WHERE workspace_id = workspace_uuid;
                
            ELSE
                table_data := '[]';
        END CASE;
        
        export_data := jsonb_set(export_data, ARRAY[table_name], COALESCE(table_data, '[]'));
    END LOOP;
    
    -- Add metadata
    export_data := jsonb_set(export_data, ARRAY['metadata'], jsonb_build_object(
        'workspace_id', workspace_uuid,
        'exported_at', CURRENT_TIMESTAMP,
        'tables', table_names
    ));
    
    RETURN export_data;
END;
$$;

-- 10. Cleanup Functions
CREATE OR REPLACE FUNCTION public.cleanup_old_analytics_events(
    retention_days INTEGER DEFAULT 90
)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM public.analytics_events
    WHERE created_at < CURRENT_DATE - INTERVAL '1 day' * retention_days;
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    
    RETURN deleted_count;
END;
$$;

CREATE OR REPLACE FUNCTION public.cleanup_processed_offline_operations()
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM public.offline_operations
    WHERE processed_at IS NOT NULL
    AND processed_at < CURRENT_TIMESTAMP - INTERVAL '7 days';
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    
    RETURN deleted_count;
END;
$$;

-- 11. Triggers for automatic cleanup
CREATE OR REPLACE FUNCTION public.update_sync_status_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_sync_status_updated_at
    BEFORE UPDATE ON public.sync_status
    FOR EACH ROW
    EXECUTE FUNCTION public.update_sync_status_timestamp();

-- 12. Scheduled cleanup (would be set up in production environment)
-- This would typically be set up as a cron job or scheduled function
-- For demonstration, we're creating the function structure

COMMENT ON FUNCTION public.cleanup_old_analytics_events IS 'Run daily to clean up old analytics events';
COMMENT ON FUNCTION public.cleanup_processed_offline_operations IS 'Run weekly to clean up processed offline operations';

-- 13. Performance monitoring views
CREATE OR REPLACE VIEW public.performance_metrics AS
SELECT 
    'analytics_events' as table_name,
    COUNT(*) as row_count,
    COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE) as today_count,
    COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE - INTERVAL '7 days') as week_count,
    AVG(EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - created_at))) as avg_age_seconds
FROM public.analytics_events
UNION ALL
SELECT 
    'social_media_posts' as table_name,
    COUNT(*) as row_count,
    COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE) as today_count,
    COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE - INTERVAL '7 days') as week_count,
    AVG(EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - created_at))) as avg_age_seconds
FROM public.social_media_posts
UNION ALL
SELECT 
    'products' as table_name,
    COUNT(*) as row_count,
    COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE) as today_count,
    COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE - INTERVAL '7 days') as week_count,
    AVG(EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - created_at))) as avg_age_seconds
FROM public.products
UNION ALL
SELECT 
    'orders' as table_name,
    COUNT(*) as row_count,
    COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE) as today_count,
    COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE - INTERVAL '7 days') as week_count,
    AVG(EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - created_at))) as avg_age_seconds
FROM public.orders;

-- 14. Final production optimization
ANALYZE public.analytics_events;
ANALYZE public.social_media_posts;
ANALYZE public.products;
ANALYZE public.orders;
ANALYZE public.notifications;
ANALYZE public.sync_status;
ANALYZE public.offline_operations;
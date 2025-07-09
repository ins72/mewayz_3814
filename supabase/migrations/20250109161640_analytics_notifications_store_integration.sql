-- Location: supabase/migrations/20250109161640_analytics_notifications_store_integration.sql
-- Analytics, Notifications, and Store Data Integration with Supabase

-- 1. Types and Enums
CREATE TYPE public.analytics_metric_type AS ENUM (
    'revenue', 'leads', 'followers', 'engagement', 'conversions', 'sales',
    'course_completions', 'email_opens', 'click_through_rate', 'user_activity',
    'workspace_activity', 'marketplace_activity', 'social_media_activity'
);

CREATE TYPE public.notification_type AS ENUM (
    'workspace', 'social_media', 'crm', 'marketplace', 'courses', 'financial',
    'system', 'security', 'marketing', 'email_campaign', 'post_scheduled'
);

CREATE TYPE public.notification_status AS ENUM ('pending', 'sent', 'delivered', 'read', 'failed');

CREATE TYPE public.notification_priority AS ENUM ('low', 'medium', 'high', 'urgent');

CREATE TYPE public.product_status AS ENUM ('active', 'inactive', 'out_of_stock', 'discontinued');

CREATE TYPE public.order_status AS ENUM ('pending', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded');

CREATE TYPE public.social_platform AS ENUM ('instagram', 'facebook', 'linkedin', 'twitter', 'tiktok', 'youtube', 'pinterest');

-- 2. Analytics Tables
CREATE TABLE public.analytics_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    event_name TEXT NOT NULL,
    event_data JSONB DEFAULT '{}',
    session_id TEXT,
    platform TEXT,
    user_agent TEXT,
    ip_address INET,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMPTZ
);

CREATE TABLE public.analytics_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    metric_type public.analytics_metric_type NOT NULL,
    metric_name TEXT NOT NULL,
    metric_value DECIMAL(15,2) DEFAULT 0,
    metric_metadata JSONB DEFAULT '{}',
    date_bucket DATE DEFAULT CURRENT_DATE,
    hour_bucket INTEGER DEFAULT EXTRACT(HOUR FROM CURRENT_TIMESTAMP),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.analytics_dashboards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    dashboard_name TEXT NOT NULL,
    dashboard_config JSONB DEFAULT '{}',
    is_default BOOLEAN DEFAULT false,
    created_by UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Notification Tables
CREATE TABLE public.notification_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    notification_type public.notification_type NOT NULL,
    email_enabled BOOLEAN DEFAULT true,
    push_enabled BOOLEAN DEFAULT true,
    in_app_enabled BOOLEAN DEFAULT true,
    quiet_hours_enabled BOOLEAN DEFAULT false,
    quiet_hours_start TIME DEFAULT '22:00',
    quiet_hours_end TIME DEFAULT '08:00',
    timezone TEXT DEFAULT 'UTC',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, workspace_id, notification_type)
);

CREATE TABLE public.notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    notification_type public.notification_type NOT NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    data JSONB DEFAULT '{}',
    priority public.notification_priority DEFAULT 'medium',
    status public.notification_status DEFAULT 'pending',
    scheduled_for TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    sent_at TIMESTAMPTZ,
    read_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.notification_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    platform TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, token, platform)
);

-- 4. Store/Marketplace Tables
CREATE TABLE public.products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    cost_price DECIMAL(10,2),
    sku TEXT,
    category TEXT,
    tags TEXT[],
    images JSONB DEFAULT '[]',
    stock_quantity INTEGER DEFAULT 0,
    stock_threshold INTEGER DEFAULT 5,
    status public.product_status DEFAULT 'active',
    is_featured BOOLEAN DEFAULT false,
    metadata JSONB DEFAULT '{}',
    created_by UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    order_number TEXT NOT NULL,
    customer_email TEXT NOT NULL,
    customer_name TEXT NOT NULL,
    customer_phone TEXT,
    shipping_address JSONB DEFAULT '{}',
    billing_address JSONB DEFAULT '{}',
    subtotal DECIMAL(10,2) NOT NULL,
    tax_amount DECIMAL(10,2) DEFAULT 0,
    shipping_amount DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL,
    currency TEXT DEFAULT 'USD',
    status public.order_status DEFAULT 'pending',
    payment_status TEXT DEFAULT 'pending',
    payment_method TEXT,
    payment_data JSONB DEFAULT '{}',
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE,
    product_id UUID REFERENCES public.products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    product_snapshot JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 5. Social Media Analytics Tables
CREATE TABLE public.social_media_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    platform public.social_platform NOT NULL,
    account_name TEXT NOT NULL,
    account_id TEXT NOT NULL,
    access_token TEXT,
    refresh_token TEXT,
    token_expires_at TIMESTAMPTZ,
    is_active BOOLEAN DEFAULT true,
    account_metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(workspace_id, platform, account_id)
);

CREATE TABLE public.social_media_posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    account_id UUID REFERENCES public.social_media_accounts(id) ON DELETE CASCADE,
    post_id TEXT,
    content TEXT NOT NULL,
    media_urls JSONB DEFAULT '[]',
    hashtags TEXT[],
    scheduled_for TIMESTAMPTZ,
    published_at TIMESTAMPTZ,
    status TEXT DEFAULT 'draft',
    engagement_data JSONB DEFAULT '{}',
    created_by UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.social_media_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    account_id UUID REFERENCES public.social_media_accounts(id) ON DELETE CASCADE,
    metric_name TEXT NOT NULL,
    metric_value DECIMAL(15,2) DEFAULT 0,
    metric_data JSONB DEFAULT '{}',
    date_bucket DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 6. Essential Indexes
CREATE INDEX idx_analytics_events_workspace_id ON public.analytics_events(workspace_id);
CREATE INDEX idx_analytics_events_user_id ON public.analytics_events(user_id);
CREATE INDEX idx_analytics_events_created_at ON public.analytics_events(created_at);
CREATE INDEX idx_analytics_events_event_name ON public.analytics_events(event_name);

CREATE INDEX idx_analytics_metrics_workspace_id ON public.analytics_metrics(workspace_id);
CREATE INDEX idx_analytics_metrics_type ON public.analytics_metrics(metric_type);
CREATE INDEX idx_analytics_metrics_date_bucket ON public.analytics_metrics(date_bucket);
CREATE INDEX idx_analytics_metrics_hour_bucket ON public.analytics_metrics(hour_bucket);

CREATE INDEX idx_notification_settings_user_id ON public.notification_settings(user_id);
CREATE INDEX idx_notification_settings_workspace_id ON public.notification_settings(workspace_id);

CREATE INDEX idx_notifications_workspace_id ON public.notifications(workspace_id);
CREATE INDEX idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX idx_notifications_status ON public.notifications(status);
CREATE INDEX idx_notifications_scheduled_for ON public.notifications(scheduled_for);

CREATE INDEX idx_products_workspace_id ON public.products(workspace_id);
CREATE INDEX idx_products_status ON public.products(status);
CREATE INDEX idx_products_category ON public.products(category);

CREATE INDEX idx_orders_workspace_id ON public.orders(workspace_id);
CREATE INDEX idx_orders_status ON public.orders(status);
CREATE INDEX idx_orders_created_at ON public.orders(created_at);

CREATE INDEX idx_social_media_accounts_workspace_id ON public.social_media_accounts(workspace_id);
CREATE INDEX idx_social_media_posts_workspace_id ON public.social_media_posts(workspace_id);
CREATE INDEX idx_social_media_metrics_workspace_id ON public.social_media_metrics(workspace_id);

-- 7. RLS Setup
ALTER TABLE public.analytics_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.analytics_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.analytics_dashboards ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notification_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notification_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.social_media_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.social_media_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.social_media_metrics ENABLE ROW LEVEL SECURITY;

-- 8. Helper Functions
CREATE OR REPLACE FUNCTION public.track_analytics_event(
    event_name TEXT,
    event_data JSONB DEFAULT '{}',
    workspace_uuid UUID DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    event_id UUID;
    current_workspace_id UUID;
BEGIN
    -- Get workspace ID if not provided
    IF workspace_uuid IS NULL THEN
        SELECT id INTO current_workspace_id 
        FROM public.workspaces 
        WHERE owner_id = auth.uid() 
        LIMIT 1;
    ELSE
        current_workspace_id := workspace_uuid;
    END IF;
    
    -- Insert analytics event
    INSERT INTO public.analytics_events (
        workspace_id, user_id, event_name, event_data, session_id
    ) VALUES (
        current_workspace_id,
        auth.uid(),
        event_name,
        event_data,
        event_data->>'session_id'
    ) RETURNING id INTO event_id;
    
    RETURN event_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.update_analytics_metric(
    workspace_uuid UUID,
    metric_type_param public.analytics_metric_type,
    metric_name_param TEXT,
    metric_value_param DECIMAL,
    metric_metadata_param JSONB DEFAULT '{}'
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    metric_id UUID;
    current_date DATE := CURRENT_DATE;
    current_hour INTEGER := EXTRACT(HOUR FROM CURRENT_TIMESTAMP);
BEGIN
    -- Update or insert metric
    INSERT INTO public.analytics_metrics (
        workspace_id, metric_type, metric_name, metric_value, 
        metric_metadata, date_bucket, hour_bucket
    ) VALUES (
        workspace_uuid, metric_type_param, metric_name_param, 
        metric_value_param, metric_metadata_param, current_date, current_hour
    )
    ON CONFLICT (workspace_id, metric_type, metric_name, date_bucket, hour_bucket)
    DO UPDATE SET
        metric_value = EXCLUDED.metric_value,
        metric_metadata = EXCLUDED.metric_metadata,
        updated_at = CURRENT_TIMESTAMP
    RETURNING id INTO metric_id;
    
    RETURN metric_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.send_notification(
    user_uuid UUID,
    workspace_uuid UUID,
    notification_type_param public.notification_type,
    title_param TEXT,
    message_param TEXT,
    data_param JSONB DEFAULT '{}',
    priority_param public.notification_priority DEFAULT 'medium'
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    notification_id UUID;
    user_settings RECORD;
    should_send BOOLEAN := true;
    current_time TIME := CURRENT_TIME;
BEGIN
    -- Get user notification settings
    SELECT * INTO user_settings 
    FROM public.notification_settings 
    WHERE user_id = user_uuid 
    AND workspace_id = workspace_uuid 
    AND notification_type = notification_type_param;
    
    -- Check if notifications are disabled
    IF user_settings.in_app_enabled = false THEN
        should_send := false;
    END IF;
    
    -- Check quiet hours
    IF user_settings.quiet_hours_enabled = true THEN
        IF user_settings.quiet_hours_start < user_settings.quiet_hours_end THEN
            -- Same day quiet hours
            IF current_time >= user_settings.quiet_hours_start 
               AND current_time <= user_settings.quiet_hours_end THEN
                should_send := false;
            END IF;
        ELSE
            -- Overnight quiet hours
            IF current_time >= user_settings.quiet_hours_start 
               OR current_time <= user_settings.quiet_hours_end THEN
                should_send := false;
            END IF;
        END IF;
    END IF;
    
    -- Only send if allowed
    IF should_send THEN
        INSERT INTO public.notifications (
            workspace_id, user_id, notification_type, title, message, 
            data, priority, status
        ) VALUES (
            workspace_uuid, user_uuid, notification_type_param, 
            title_param, message_param, data_param, priority_param, 'pending'
        ) RETURNING id INTO notification_id;
        
        RETURN notification_id;
    END IF;
    
    RETURN NULL;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_analytics_dashboard_data(workspace_uuid UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    dashboard_data JSONB := '{}';
    revenue_data JSONB;
    social_data JSONB;
    product_data JSONB;
    notification_data JSONB;
BEGIN
    -- Get revenue metrics
    SELECT jsonb_build_object(
        'total_revenue', COALESCE(SUM(CASE WHEN metric_name = 'total_revenue' THEN metric_value END), 0),
        'total_orders', COALESCE(SUM(CASE WHEN metric_name = 'total_orders' THEN metric_value END), 0),
        'conversion_rate', COALESCE(AVG(CASE WHEN metric_name = 'conversion_rate' THEN metric_value END), 0)
    ) INTO revenue_data
    FROM public.analytics_metrics 
    WHERE workspace_id = workspace_uuid 
    AND metric_type = 'revenue' 
    AND date_bucket >= CURRENT_DATE - INTERVAL '30 days';
    
    -- Get social media metrics
    SELECT jsonb_build_object(
        'total_followers', COALESCE(SUM(CASE WHEN metric_name = 'followers' THEN metric_value END), 0),
        'total_engagement', COALESCE(SUM(CASE WHEN metric_name = 'engagement' THEN metric_value END), 0),
        'posts_count', COALESCE(SUM(CASE WHEN metric_name = 'posts_count' THEN metric_value END), 0)
    ) INTO social_data
    FROM public.social_media_metrics 
    WHERE workspace_id = workspace_uuid 
    AND date_bucket >= CURRENT_DATE - INTERVAL '30 days';
    
    -- Get product data
    SELECT jsonb_build_object(
        'total_products', COUNT(*),
        'active_products', COUNT(*) FILTER (WHERE status = 'active'),
        'low_stock_products', COUNT(*) FILTER (WHERE stock_quantity <= stock_threshold)
    ) INTO product_data
    FROM public.products 
    WHERE workspace_id = workspace_uuid;
    
    -- Get notification data
    SELECT jsonb_build_object(
        'unread_notifications', COUNT(*) FILTER (WHERE read_at IS NULL),
        'total_notifications', COUNT(*)
    ) INTO notification_data
    FROM public.notifications 
    WHERE workspace_id = workspace_uuid 
    AND created_at >= CURRENT_DATE - INTERVAL '7 days';
    
    -- Combine all data
    dashboard_data := jsonb_build_object(
        'revenue', COALESCE(revenue_data, '{}'),
        'social_media', COALESCE(social_data, '{}'),
        'products', COALESCE(product_data, '{}'),
        'notifications', COALESCE(notification_data, '{}'),
        'updated_at', CURRENT_TIMESTAMP
    );
    
    RETURN dashboard_data;
END;
$$;

-- 9. RLS Policies
CREATE POLICY "workspace_members_analytics_events" ON public.analytics_events FOR ALL
USING (public.is_workspace_member(workspace_id));

CREATE POLICY "workspace_members_analytics_metrics" ON public.analytics_metrics FOR ALL
USING (public.is_workspace_member(workspace_id));

CREATE POLICY "workspace_members_analytics_dashboards" ON public.analytics_dashboards FOR ALL
USING (public.is_workspace_member(workspace_id));

CREATE POLICY "users_own_notification_settings" ON public.notification_settings FOR ALL
USING (auth.uid() = user_id);

CREATE POLICY "users_own_notifications" ON public.notifications FOR ALL
USING (auth.uid() = user_id);

CREATE POLICY "users_own_notification_tokens" ON public.notification_tokens FOR ALL
USING (auth.uid() = user_id);

CREATE POLICY "workspace_members_products" ON public.products FOR ALL
USING (public.is_workspace_member(workspace_id));

CREATE POLICY "workspace_members_orders" ON public.orders FOR ALL
USING (public.is_workspace_member(workspace_id));

CREATE POLICY "workspace_members_order_items" ON public.order_items FOR SELECT
USING (EXISTS (
    SELECT 1 FROM public.orders o 
    WHERE o.id = order_id 
    AND public.is_workspace_member(o.workspace_id)
));

CREATE POLICY "workspace_members_social_accounts" ON public.social_media_accounts FOR ALL
USING (public.is_workspace_member(workspace_id));

CREATE POLICY "workspace_members_social_posts" ON public.social_media_posts FOR ALL
USING (public.is_workspace_member(workspace_id));

CREATE POLICY "workspace_members_social_metrics" ON public.social_media_metrics FOR ALL
USING (public.is_workspace_member(workspace_id));

-- 10. Functions for automatic timestamp updates
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add update triggers
CREATE TRIGGER update_analytics_metrics_updated_at
    BEFORE UPDATE ON public.analytics_metrics
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_notification_settings_updated_at
    BEFORE UPDATE ON public.notification_settings
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON public.products
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_orders_updated_at
    BEFORE UPDATE ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

-- 11. Mock Data for Testing
DO $$
DECLARE
    test_workspace_id UUID;
    test_user_id UUID;
    test_product_id UUID;
    test_order_id UUID;
    test_social_account_id UUID;
BEGIN
    -- Get test workspace and user
    SELECT id INTO test_workspace_id FROM public.workspaces WHERE name = 'Creative Studio';
    SELECT id INTO test_user_id FROM public.user_profiles WHERE email = 'creator@mewayz.com';
    
    IF test_workspace_id IS NOT NULL AND test_user_id IS NOT NULL THEN
        -- Create notification settings
        INSERT INTO public.notification_settings (user_id, workspace_id, notification_type, email_enabled, push_enabled, in_app_enabled)
        VALUES 
            (test_user_id, test_workspace_id, 'workspace', true, true, true),
            (test_user_id, test_workspace_id, 'social_media', true, true, true),
            (test_user_id, test_workspace_id, 'marketplace', true, true, true),
            (test_user_id, test_workspace_id, 'system', true, false, true)
        ON CONFLICT (user_id, workspace_id, notification_type) DO NOTHING;
        
        -- Create sample products
        INSERT INTO public.products (workspace_id, name, description, price, stock_quantity, status, category, created_by)
        VALUES 
            (test_workspace_id, 'Digital Marketing Course', 'Complete digital marketing course with 50+ lessons', 199.99, 100, 'active', 'courses', test_user_id),
            (test_workspace_id, 'Social Media Templates', 'Instagram and Facebook post templates', 29.99, 50, 'active', 'templates', test_user_id),
            (test_workspace_id, 'Analytics Report Template', 'Professional analytics report template', 49.99, 25, 'active', 'templates', test_user_id)
        RETURNING id INTO test_product_id;
        
        -- Create sample order
        INSERT INTO public.orders (workspace_id, order_number, customer_email, customer_name, subtotal, total_amount, status)
        VALUES (test_workspace_id, 'ORD-001', 'customer@example.com', 'John Doe', 199.99, 199.99, 'completed')
        RETURNING id INTO test_order_id;
        
        -- Create order items
        INSERT INTO public.order_items (order_id, product_id, quantity, unit_price, total_price)
        VALUES (test_order_id, test_product_id, 1, 199.99, 199.99);
        
        -- Create social media account
        INSERT INTO public.social_media_accounts (workspace_id, platform, account_name, account_id, is_active)
        VALUES (test_workspace_id, 'instagram', 'creativestudio', 'creativestudio_ig', true)
        RETURNING id INTO test_social_account_id;
        
        -- Create analytics metrics
        INSERT INTO public.analytics_metrics (workspace_id, metric_type, metric_name, metric_value, date_bucket)
        VALUES 
            (test_workspace_id, 'revenue', 'total_revenue', 1250.00, CURRENT_DATE),
            (test_workspace_id, 'revenue', 'total_orders', 15, CURRENT_DATE),
            (test_workspace_id, 'leads', 'leads_captured', 45, CURRENT_DATE),
            (test_workspace_id, 'followers', 'instagram_followers', 2500, CURRENT_DATE),
            (test_workspace_id, 'engagement', 'instagram_engagement', 4.2, CURRENT_DATE);
        
        -- Create social media metrics
        INSERT INTO public.social_media_metrics (workspace_id, account_id, metric_name, metric_value, date_bucket)
        VALUES 
            (test_workspace_id, test_social_account_id, 'followers', 2500, CURRENT_DATE),
            (test_workspace_id, test_social_account_id, 'engagement_rate', 4.2, CURRENT_DATE),
            (test_workspace_id, test_social_account_id, 'posts_count', 12, CURRENT_DATE),
            (test_workspace_id, test_social_account_id, 'reach', 15000, CURRENT_DATE);
        
        -- Create sample notifications
        INSERT INTO public.notifications (workspace_id, user_id, notification_type, title, message, priority, status)
        VALUES 
            (test_workspace_id, test_user_id, 'marketplace', 'New Order Received', 'You have received a new order #ORD-001', 'high', 'sent'),
            (test_workspace_id, test_user_id, 'social_media', 'Post Published', 'Your Instagram post has been published successfully', 'medium', 'sent'),
            (test_workspace_id, test_user_id, 'system', 'Weekly Analytics Report', 'Your weekly analytics report is ready', 'low', 'pending');
        
        -- Track sample analytics events
        PERFORM public.track_analytics_event('page_view', '{"page": "dashboard", "duration": 120}', test_workspace_id);
        PERFORM public.track_analytics_event('product_view', '{"product_id": "' || test_product_id || '"}', test_workspace_id);
        PERFORM public.track_analytics_event('order_completed', '{"order_id": "' || test_order_id || '", "value": 199.99}', test_workspace_id);
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error creating analytics test data: %', SQLERRM;
END $$;

-- 12. Cleanup function
CREATE OR REPLACE FUNCTION public.cleanup_analytics_test_data()
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
    WHERE name IN ('Creative Studio', 'Online Store');
    
    -- Delete in dependency order
    DELETE FROM public.order_items WHERE order_id IN (
        SELECT id FROM public.orders WHERE workspace_id = ANY(test_workspace_ids)
    );
    DELETE FROM public.orders WHERE workspace_id = ANY(test_workspace_ids);
    DELETE FROM public.products WHERE workspace_id = ANY(test_workspace_ids);
    DELETE FROM public.social_media_posts WHERE workspace_id = ANY(test_workspace_ids);
    DELETE FROM public.social_media_metrics WHERE workspace_id = ANY(test_workspace_ids);
    DELETE FROM public.social_media_accounts WHERE workspace_id = ANY(test_workspace_ids);
    DELETE FROM public.notifications WHERE workspace_id = ANY(test_workspace_ids);
    DELETE FROM public.notification_settings WHERE workspace_id = ANY(test_workspace_ids);
    DELETE FROM public.analytics_events WHERE workspace_id = ANY(test_workspace_ids);
    DELETE FROM public.analytics_metrics WHERE workspace_id = ANY(test_workspace_ids);
    DELETE FROM public.analytics_dashboards WHERE workspace_id = ANY(test_workspace_ids);
    DELETE FROM public.notification_tokens WHERE user_id IN (
        SELECT id FROM public.user_profiles WHERE email LIKE '%@mewayz.com'
    );
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Analytics cleanup failed: %', SQLERRM;
END;
$$;
-- Location: supabase/migrations/20250109170001_fix_concurrent_index_creation.sql
-- Fix CREATE INDEX CONCURRENTLY transaction block error

-- Remove CONCURRENTLY from all index creation statements
-- Standard CREATE INDEX can be used in transaction blocks

-- Drop any existing indexes that might have been created with CONCURRENTLY
DROP INDEX IF EXISTS idx_analytics_events_workspace_id_concurrent;
DROP INDEX IF EXISTS idx_analytics_events_user_id_concurrent;
DROP INDEX IF EXISTS idx_analytics_events_created_at_concurrent;
DROP INDEX IF EXISTS idx_analytics_events_event_name_concurrent;
DROP INDEX IF EXISTS idx_analytics_metrics_workspace_id_concurrent;
DROP INDEX IF EXISTS idx_analytics_metrics_type_concurrent;
DROP INDEX IF EXISTS idx_analytics_metrics_date_bucket_concurrent;
DROP INDEX IF EXISTS idx_analytics_metrics_hour_bucket_concurrent;
DROP INDEX IF EXISTS idx_notification_settings_user_id_concurrent;
DROP INDEX IF EXISTS idx_notification_settings_workspace_id_concurrent;
DROP INDEX IF EXISTS idx_notifications_workspace_id_concurrent;
DROP INDEX IF EXISTS idx_notifications_user_id_concurrent;
DROP INDEX IF EXISTS idx_notifications_status_concurrent;
DROP INDEX IF EXISTS idx_notifications_scheduled_for_concurrent;
DROP INDEX IF EXISTS idx_products_workspace_id_concurrent;
DROP INDEX IF EXISTS idx_products_status_concurrent;
DROP INDEX IF EXISTS idx_products_category_concurrent;
DROP INDEX IF EXISTS idx_orders_workspace_id_concurrent;
DROP INDEX IF EXISTS idx_orders_status_concurrent;
DROP INDEX IF EXISTS idx_orders_created_at_concurrent;
DROP INDEX IF EXISTS idx_social_media_accounts_workspace_id_concurrent;
DROP INDEX IF EXISTS idx_social_media_posts_workspace_id_concurrent;
DROP INDEX IF EXISTS idx_social_media_metrics_workspace_id_concurrent;

-- Add missing UNIQUE constraint for analytics_metrics
-- This ensures proper upsert behavior in update_analytics_metric function
ALTER TABLE public.analytics_metrics 
ADD CONSTRAINT uk_analytics_metrics_unique 
UNIQUE (workspace_id, metric_type, metric_name, date_bucket, hour_bucket);

-- Add missing indexes for order_items table
CREATE INDEX idx_order_items_order_id ON public.order_items(order_id);
CREATE INDEX idx_order_items_product_id ON public.order_items(product_id);

-- Add composite indexes for better query performance
CREATE INDEX idx_analytics_events_workspace_created ON public.analytics_events(workspace_id, created_at DESC);
CREATE INDEX idx_analytics_metrics_workspace_type_date ON public.analytics_metrics(workspace_id, metric_type, date_bucket DESC);
CREATE INDEX idx_notifications_user_status ON public.notifications(user_id, status, created_at DESC);
CREATE INDEX idx_social_media_posts_account_status ON public.social_media_posts(account_id, status, scheduled_for);

-- Add index for notification tokens unique constraint performance
CREATE INDEX idx_notification_tokens_user_platform ON public.notification_tokens(user_id, platform) WHERE is_active = true;

-- Add index for product search and filtering
CREATE INDEX idx_products_workspace_status_category ON public.products(workspace_id, status, category);
CREATE INDEX idx_products_workspace_featured ON public.products(workspace_id, is_featured) WHERE is_featured = true;

-- Add index for order management
CREATE INDEX idx_orders_workspace_status_created ON public.orders(workspace_id, status, created_at DESC);
CREATE INDEX idx_orders_customer_email ON public.orders(customer_email);

-- Add index for social media analytics
CREATE INDEX idx_social_media_metrics_account_date ON public.social_media_metrics(account_id, date_bucket DESC);

-- Add partial index for low stock products
CREATE INDEX idx_products_low_stock ON public.products(workspace_id, stock_quantity) 
WHERE stock_quantity <= stock_threshold AND status = 'active';

-- Add index for notification processing
CREATE INDEX idx_notifications_pending_scheduled ON public.notifications(scheduled_for, status) 
WHERE status = 'pending';

-- Add index for analytics event processing
CREATE INDEX idx_analytics_events_unprocessed ON public.analytics_events(created_at) 
WHERE processed_at IS NULL;

-- Add performance optimization for RLS policies
CREATE INDEX idx_analytics_events_workspace_user ON public.analytics_events(workspace_id, user_id);
CREATE INDEX idx_analytics_metrics_workspace_user ON public.analytics_metrics(workspace_id);
CREATE INDEX idx_products_workspace_created_by ON public.products(workspace_id, created_by);
CREATE INDEX idx_social_media_posts_workspace_created_by ON public.social_media_posts(workspace_id, created_by);
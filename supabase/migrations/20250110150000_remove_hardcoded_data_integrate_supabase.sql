-- Location: supabase/migrations/20250110150000_remove_hardcoded_data_integrate_supabase.sql
-- Complete Data Migration: Remove All Hard-Coded Data and Replace with Dynamic Supabase Integration

-- Module Detection: Dynamic Data Integration Module
-- IMPLEMENTING MODULE: Complete hardcoded data removal and Supabase integration
-- SCOPE: Remove hardcoded workspace dashboard analytics, recent activity, CRM, templates, link in bio templates, team management, revenue and courses analytics, social media hub data, and workspace names

-- 1. Enhanced Courses Management System
CREATE TABLE IF NOT EXISTS public.courses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    instructor_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    thumbnail_url TEXT,
    price DECIMAL(10,2),
    status public.content_status DEFAULT 'draft',
    duration_minutes INTEGER DEFAULT 0,
    difficulty_level TEXT DEFAULT 'beginner',
    category TEXT,
    tags TEXT[],
    enrollment_count INTEGER DEFAULT 0,
    completion_rate DECIMAL(5,2) DEFAULT 0.00,
    average_rating DECIMAL(3,2) DEFAULT 0.00,
    total_revenue DECIMAL(12,2) DEFAULT 0.00,
    is_published BOOLEAN DEFAULT false,
    published_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 2. Course Modules System
CREATE TABLE IF NOT EXISTS public.course_modules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    order_index INTEGER NOT NULL,
    lesson_count INTEGER DEFAULT 0,
    duration_minutes INTEGER DEFAULT 0,
    completion_rate DECIMAL(5,2) DEFAULT 0.00,
    is_expanded BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Course Lessons System
CREATE TABLE IF NOT EXISTS public.course_lessons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_id UUID REFERENCES public.course_modules(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    content_type TEXT NOT NULL CHECK (content_type IN ('video', 'text', 'quiz', 'assignment', 'discussion')),
    duration_minutes INTEGER DEFAULT 0,
    order_index INTEGER NOT NULL,
    thumbnail_url TEXT,
    video_url TEXT,
    content_text TEXT,
    is_completed BOOLEAN DEFAULT false,
    status public.content_status DEFAULT 'draft',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4. Enhanced CRM Contacts System
CREATE TABLE IF NOT EXISTS public.crm_contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    assigned_to UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    company TEXT,
    email TEXT,
    phone TEXT,
    profile_image_url TEXT,
    lead_score INTEGER DEFAULT 0 CHECK (lead_score >= 0 AND lead_score <= 100),
    stage TEXT DEFAULT 'new',
    source TEXT,
    deal_value DECIMAL(12,2) DEFAULT 0.00,
    priority TEXT DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high')),
    last_activity_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    tags TEXT[],
    notes TEXT,
    interactions_count INTEGER DEFAULT 0,
    conversion_probability DECIMAL(3,2) DEFAULT 0.00,
    next_action TEXT,
    custom_fields JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 5. CRM Activities System
CREATE TABLE IF NOT EXISTS public.crm_activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contact_id UUID REFERENCES public.crm_contacts(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    activity_type TEXT NOT NULL,
    title TEXT NOT NULL,
    outcome TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 6. Enhanced Social Media Posts System
CREATE TABLE IF NOT EXISTS public.social_media_posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    author_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    platform TEXT NOT NULL,
    media_urls TEXT[],
    hashtags TEXT[],
    status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'scheduled', 'published', 'failed')),
    scheduled_for TIMESTAMPTZ,
    published_at TIMESTAMPTZ,
    engagement_count INTEGER DEFAULT 0,
    reach_count INTEGER DEFAULT 0,
    impressions_count INTEGER DEFAULT 0,
    likes_count INTEGER DEFAULT 0,
    comments_count INTEGER DEFAULT 0,
    shares_count INTEGER DEFAULT 0,
    click_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 7. Enhanced Content Templates System
CREATE TABLE IF NOT EXISTS public.content_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    creator_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    template_type TEXT NOT NULL,
    category TEXT NOT NULL,
    content_data JSONB NOT NULL,
    thumbnail_url TEXT,
    tags TEXT[],
    usage_count INTEGER DEFAULT 0,
    is_favorite BOOLEAN DEFAULT false,
    is_public BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 8. Link in Bio Templates System
CREATE TABLE IF NOT EXISTS public.link_in_bio_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    creator_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    template_data JSONB NOT NULL,
    thumbnail_url TEXT,
    category TEXT NOT NULL,
    style_theme TEXT DEFAULT 'modern',
    usage_count INTEGER DEFAULT 0,
    is_favorite BOOLEAN DEFAULT false,
    is_premium BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 9. Enhanced Recent Activities System
CREATE TABLE IF NOT EXISTS public.recent_activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    activity_type TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    avatar_url TEXT,
    icon_name TEXT,
    icon_color TEXT,
    metadata JSONB DEFAULT '{}',
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 10. Enhanced Workspace Metrics System
CREATE TABLE IF NOT EXISTS public.workspace_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    metric_name TEXT NOT NULL,
    metric_value DECIMAL(15,2) NOT NULL,
    metric_unit TEXT,
    change_percentage DECIMAL(5,2) DEFAULT 0.00,
    is_positive_change BOOLEAN DEFAULT true,
    sparkline_data DECIMAL[],
    metric_date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(workspace_id, metric_name, metric_date)
);

-- 11. Enhanced Team Management System
CREATE TABLE IF NOT EXISTS public.team_invitations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    inviter_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    role public.user_role NOT NULL,
    custom_message TEXT,
    invitation_token TEXT UNIQUE DEFAULT encode(gen_random_bytes(32), 'base64'),
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'declined', 'expired')),
    expires_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP + INTERVAL '7 days',
    accepted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 12. Hashtags and Trends System
CREATE TABLE IF NOT EXISTS public.trending_hashtags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    hashtag TEXT NOT NULL,
    usage_count INTEGER DEFAULT 1,
    engagement_score DECIMAL(8,2) DEFAULT 0.00,
    trend_score DECIMAL(8,2) DEFAULT 0.00,
    platform TEXT NOT NULL,
    category TEXT,
    last_used_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(workspace_id, hashtag, platform)
);

-- 13. Revenue Analytics System
CREATE TABLE IF NOT EXISTS public.revenue_analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES public.workspaces(id) ON DELETE CASCADE,
    source_type TEXT NOT NULL,
    source_id UUID,
    amount DECIMAL(12,2) NOT NULL,
    currency TEXT DEFAULT 'USD',
    transaction_type TEXT NOT NULL CHECK (transaction_type IN ('sale', 'refund', 'commission', 'subscription')),
    description TEXT,
    payment_method TEXT,
    customer_email TEXT,
    transaction_date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 14. Performance Indexes for Optimal Queries
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_courses_workspace_status 
ON public.courses(workspace_id, status, is_published);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_course_modules_course_order 
ON public.course_modules(course_id, order_index);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_course_lessons_module_order 
ON public.course_lessons(module_id, order_index);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_crm_contacts_workspace_stage 
ON public.crm_contacts(workspace_id, stage, priority);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_crm_contacts_score_activity 
ON public.crm_contacts(lead_score DESC, last_activity_at DESC);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_social_posts_workspace_status 
ON public.social_media_posts(workspace_id, status, scheduled_for);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_content_templates_workspace_category 
ON public.content_templates(workspace_id, category, template_type);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_recent_activities_workspace_created 
ON public.recent_activities(workspace_id, created_at DESC);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_workspace_metrics_workspace_date 
ON public.workspace_metrics(workspace_id, metric_date DESC);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_revenue_analytics_workspace_date 
ON public.revenue_analytics(workspace_id, transaction_date DESC);

-- 15. RLS Policies for All New Tables
ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.course_modules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.course_lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.crm_contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.crm_activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.social_media_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.link_in_bio_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recent_activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workspace_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.team_invitations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.trending_hashtags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.revenue_analytics ENABLE ROW LEVEL SECURITY;

-- 16. Helper Functions for Data Access
CREATE OR REPLACE FUNCTION public.has_workspace_access(workspace_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.workspace_members wm
    WHERE wm.workspace_id = workspace_uuid 
    AND wm.user_id = auth.uid() 
    AND wm.is_active = true
)
$$;

CREATE OR REPLACE FUNCTION public.can_manage_workspace_content(workspace_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.workspace_members wm
    WHERE wm.workspace_id = workspace_uuid 
    AND wm.user_id = auth.uid() 
    AND wm.is_active = true
    AND wm.role IN ('owner', 'admin', 'manager')
)
$$;

-- 17. RLS Policies Implementation
CREATE POLICY "workspace_members_access_courses" ON public.courses FOR ALL
USING (public.has_workspace_access(workspace_id))
WITH CHECK (public.can_manage_workspace_content(workspace_id));

CREATE POLICY "workspace_members_access_course_modules" ON public.course_modules FOR ALL
USING (public.has_workspace_access((SELECT workspace_id FROM public.courses WHERE id = course_id)))
WITH CHECK (public.can_manage_workspace_content((SELECT workspace_id FROM public.courses WHERE id = course_id)));

CREATE POLICY "workspace_members_access_course_lessons" ON public.course_lessons FOR ALL
USING (public.has_workspace_access((SELECT c.workspace_id FROM public.courses c JOIN public.course_modules cm ON c.id = cm.course_id WHERE cm.id = module_id)))
WITH CHECK (public.can_manage_workspace_content((SELECT c.workspace_id FROM public.courses c JOIN public.course_modules cm ON c.id = cm.course_id WHERE cm.id = module_id)));

CREATE POLICY "workspace_members_access_crm_contacts" ON public.crm_contacts FOR ALL
USING (public.has_workspace_access(workspace_id))
WITH CHECK (public.has_workspace_access(workspace_id));

CREATE POLICY "workspace_members_access_crm_activities" ON public.crm_activities FOR ALL
USING (public.has_workspace_access((SELECT workspace_id FROM public.crm_contacts WHERE id = contact_id)))
WITH CHECK (public.has_workspace_access((SELECT workspace_id FROM public.crm_contacts WHERE id = contact_id)));

CREATE POLICY "workspace_members_access_social_posts" ON public.social_media_posts FOR ALL
USING (public.has_workspace_access(workspace_id))
WITH CHECK (public.has_workspace_access(workspace_id));

CREATE POLICY "workspace_members_access_content_templates" ON public.content_templates FOR ALL
USING (public.has_workspace_access(workspace_id))
WITH CHECK (public.has_workspace_access(workspace_id));

CREATE POLICY "workspace_members_access_link_bio_templates" ON public.link_in_bio_templates FOR ALL
USING (public.has_workspace_access(workspace_id))
WITH CHECK (public.has_workspace_access(workspace_id));

CREATE POLICY "workspace_members_access_recent_activities" ON public.recent_activities FOR ALL
USING (public.has_workspace_access(workspace_id))
WITH CHECK (public.has_workspace_access(workspace_id));

CREATE POLICY "workspace_members_access_metrics" ON public.workspace_metrics FOR ALL
USING (public.has_workspace_access(workspace_id))
WITH CHECK (public.can_manage_workspace_content(workspace_id));

CREATE POLICY "workspace_members_access_team_invitations" ON public.team_invitations FOR ALL
USING (public.has_workspace_access(workspace_id))
WITH CHECK (public.can_manage_workspace_content(workspace_id));

CREATE POLICY "workspace_members_access_trending_hashtags" ON public.trending_hashtags FOR ALL
USING (public.has_workspace_access(workspace_id))
WITH CHECK (public.has_workspace_access(workspace_id));

CREATE POLICY "workspace_members_access_revenue_analytics" ON public.revenue_analytics FOR ALL
USING (public.has_workspace_access(workspace_id))
WITH CHECK (public.can_manage_workspace_content(workspace_id));

-- 18. Dynamic Data Functions

-- Get Workspace Dashboard Analytics
CREATE OR REPLACE FUNCTION public.get_workspace_dashboard_analytics(workspace_uuid UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    analytics_data JSONB;
    hero_metrics JSONB;
    recent_activities JSONB;
    team_stats JSONB;
BEGIN
    -- Check access
    IF NOT public.has_workspace_access(workspace_uuid) THEN
        RAISE EXCEPTION 'Access denied to workspace analytics';
    END IF;
    
    -- Get hero metrics
    SELECT jsonb_build_object(
        'total_leads', COALESCE(COUNT(*) FILTER (WHERE stage IN ('new', 'qualified')), 0),
        'revenue', COALESCE(SUM(ra.amount) FILTER (WHERE ra.transaction_date >= CURRENT_DATE - INTERVAL '30 days'), 0),
        'social_followers', COALESCE(SUM(smp.reach_count), 0),
        'course_enrollments', COALESCE(SUM(c.enrollment_count), 0),
        'conversion_rate', COALESCE(AVG(cc.conversion_probability) * 100, 0)
    ) INTO hero_metrics
    FROM public.crm_contacts cc
    FULL OUTER JOIN public.revenue_analytics ra ON ra.workspace_id = workspace_uuid
    FULL OUTER JOIN public.social_media_posts smp ON smp.workspace_id = workspace_uuid
    FULL OUTER JOIN public.courses c ON c.workspace_id = workspace_uuid
    WHERE cc.workspace_id = workspace_uuid OR ra.workspace_id = workspace_uuid 
    OR smp.workspace_id = workspace_uuid OR c.workspace_id = workspace_uuid;
    
    -- Get recent activities
    SELECT jsonb_agg(
        jsonb_build_object(
            'id', ra.id,
            'type', ra.activity_type,
            'title', ra.title,
            'description', ra.description,
            'avatar_url', ra.avatar_url,
            'time', EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - ra.created_at)) / 60,
            'metadata', ra.metadata
        ) ORDER BY ra.created_at DESC
    ) INTO recent_activities
    FROM public.recent_activities ra
    WHERE ra.workspace_id = workspace_uuid
    LIMIT 10;
    
    -- Get team stats
    SELECT jsonb_build_object(
        'total_members', COUNT(*),
        'active_members', COUNT(*) FILTER (WHERE is_active = true),
        'pending_invitations', (
            SELECT COUNT(*) FROM public.team_invitations ti 
            WHERE ti.workspace_id = workspace_uuid AND ti.status = 'pending'
        )
    ) INTO team_stats
    FROM public.workspace_members wm
    WHERE wm.workspace_id = workspace_uuid;
    
    -- Combine all data
    analytics_data := jsonb_build_object(
        'workspace_id', workspace_uuid,
        'hero_metrics', COALESCE(hero_metrics, '{}'),
        'recent_activities', COALESCE(recent_activities, '[]'),
        'team_stats', COALESCE(team_stats, '{}'),
        'generated_at', CURRENT_TIMESTAMP
    );
    
    RETURN analytics_data;
END;
$$;

-- Get CRM Data
CREATE OR REPLACE FUNCTION public.get_crm_data(workspace_uuid UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    crm_data JSONB;
    contacts_data JSONB;
    pipeline_data JSONB;
BEGIN
    -- Check access
    IF NOT public.has_workspace_access(workspace_uuid) THEN
        RAISE EXCEPTION 'Access denied to workspace CRM data';
    END IF;
    
    -- Get contacts
    SELECT jsonb_agg(
        jsonb_build_object(
            'id', cc.id,
            'name', cc.name,
            'company', cc.company,
            'email', cc.email,
            'phone', cc.phone,
            'profile_image_url', cc.profile_image_url,
            'lead_score', cc.lead_score,
            'stage', cc.stage,
            'source', cc.source,
            'deal_value', cc.deal_value,
            'priority', cc.priority,
            'last_activity_at', cc.last_activity_at,
            'tags', cc.tags,
            'notes', cc.notes,
            'conversion_probability', cc.conversion_probability,
            'interactions_count', cc.interactions_count,
            'next_action', cc.next_action,
            'assigned_to', up.full_name
        )
    ) INTO contacts_data
    FROM public.crm_contacts cc
    LEFT JOIN public.user_profiles up ON cc.assigned_to = up.id
    WHERE cc.workspace_id = workspace_uuid
    ORDER BY cc.lead_score DESC, cc.last_activity_at DESC;
    
    -- Get pipeline stages with counts
    SELECT jsonb_agg(
        jsonb_build_object(
            'stage', stage,
            'count', count,
            'total_value', total_value
        )
    ) INTO pipeline_data
    FROM (
        SELECT 
            stage,
            COUNT(*) as count,
            SUM(deal_value) as total_value
        FROM public.crm_contacts 
        WHERE workspace_id = workspace_uuid
        GROUP BY stage
        ORDER BY CASE stage
            WHEN 'new' THEN 1
            WHEN 'qualified' THEN 2
            WHEN 'proposal' THEN 3
            WHEN 'negotiation' THEN 4
            WHEN 'closed' THEN 5
            ELSE 6
        END
    ) pipeline_summary;
    
    crm_data := jsonb_build_object(
        'contacts', COALESCE(contacts_data, '[]'),
        'pipeline', COALESCE(pipeline_data, '[]'),
        'generated_at', CURRENT_TIMESTAMP
    );
    
    RETURN crm_data;
END;
$$;

-- Get Social Media Hub Data
CREATE OR REPLACE FUNCTION public.get_social_media_hub_data(workspace_uuid UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    social_data JSONB;
    posts_data JSONB;
    analytics_data JSONB;
    hashtags_data JSONB;
BEGIN
    -- Check access
    IF NOT public.has_workspace_access(workspace_uuid) THEN
        RAISE EXCEPTION 'Access denied to workspace social media data';
    END IF;
    
    -- Get posts
    SELECT jsonb_agg(
        jsonb_build_object(
            'id', smp.id,
            'content', smp.content,
            'platform', smp.platform,
            'status', smp.status,
            'scheduled_for', smp.scheduled_for,
            'published_at', smp.published_at,
            'engagement_count', smp.engagement_count,
            'reach_count', smp.reach_count,
            'likes_count', smp.likes_count,
            'comments_count', smp.comments_count,
            'shares_count', smp.shares_count,
            'hashtags', smp.hashtags,
            'author', up.full_name
        ) ORDER BY smp.created_at DESC
    ) INTO posts_data
    FROM public.social_media_posts smp
    LEFT JOIN public.user_profiles up ON smp.author_id = up.id
    WHERE smp.workspace_id = workspace_uuid
    LIMIT 50;
    
    -- Get analytics summary
    SELECT jsonb_build_object(
        'total_posts', COUNT(*),
        'published_posts', COUNT(*) FILTER (WHERE status = 'published'),
        'scheduled_posts', COUNT(*) FILTER (WHERE status = 'scheduled'),
        'total_engagement', SUM(engagement_count),
        'total_reach', SUM(reach_count),
        'avg_engagement_rate', AVG(
            CASE WHEN reach_count > 0 
            THEN (engagement_count::DECIMAL / reach_count) * 100 
            ELSE 0 END
        )
    ) INTO analytics_data
    FROM public.social_media_posts
    WHERE workspace_id = workspace_uuid;
    
    -- Get trending hashtags
    SELECT jsonb_agg(
        jsonb_build_object(
            'hashtag', hashtag,
            'usage_count', usage_count,
            'engagement_score', engagement_score,
            'trend_score', trend_score,
            'platform', platform
        ) ORDER BY trend_score DESC
    ) INTO hashtags_data
    FROM public.trending_hashtags
    WHERE workspace_id = workspace_uuid
    LIMIT 20;
    
    social_data := jsonb_build_object(
        'posts', COALESCE(posts_data, '[]'),
        'analytics', COALESCE(analytics_data, '{}'),
        'trending_hashtags', COALESCE(hashtags_data, '[]'),
        'generated_at', CURRENT_TIMESTAMP
    );
    
    RETURN social_data;
END;
$$;

-- Get Course Analytics Data
CREATE OR REPLACE FUNCTION public.get_course_analytics_data(workspace_uuid UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    course_data JSONB;
    courses_summary JSONB;
    revenue_data JSONB;
BEGIN
    -- Check access
    IF NOT public.has_workspace_access(workspace_uuid) THEN
        RAISE EXCEPTION 'Access denied to workspace course data';
    END IF;
    
    -- Get courses with modules and lessons
    SELECT jsonb_agg(
        jsonb_build_object(
            'id', c.id,
            'title', c.title,
            'description', c.description,
            'price', c.price,
            'status', c.status,
            'enrollment_count', c.enrollment_count,
            'completion_rate', c.completion_rate,
            'average_rating', c.average_rating,
            'total_revenue', c.total_revenue,
            'instructor_name', up.full_name,
            'modules', (
                SELECT jsonb_agg(
                    jsonb_build_object(
                        'id', cm.id,
                        'title', cm.title,
                        'lesson_count', cm.lesson_count,
                        'duration_minutes', cm.duration_minutes,
                        'completion_rate', cm.completion_rate,
                        'lessons', (
                            SELECT jsonb_agg(
                                jsonb_build_object(
                                    'id', cl.id,
                                    'title', cl.title,
                                    'content_type', cl.content_type,
                                    'duration_minutes', cl.duration_minutes,
                                    'status', cl.status
                                ) ORDER BY cl.order_index
                            )
                            FROM public.course_lessons cl 
                            WHERE cl.module_id = cm.id
                        )
                    ) ORDER BY cm.order_index
                )
                FROM public.course_modules cm 
                WHERE cm.course_id = c.id
            )
        )
    ) INTO courses_summary
    FROM public.courses c
    LEFT JOIN public.user_profiles up ON c.instructor_id = up.id
    WHERE c.workspace_id = workspace_uuid;
    
    -- Get revenue analytics
    SELECT jsonb_build_object(
        'total_revenue', COALESCE(SUM(amount) FILTER (WHERE source_type = 'course'), 0),
        'monthly_revenue', COALESCE(SUM(amount) FILTER (WHERE source_type = 'course' AND transaction_date >= DATE_TRUNC('month', CURRENT_DATE)), 0),
        'transaction_count', COUNT(*) FILTER (WHERE source_type = 'course'),
        'avg_transaction_value', COALESCE(AVG(amount) FILTER (WHERE source_type = 'course'), 0)
    ) INTO revenue_data
    FROM public.revenue_analytics
    WHERE workspace_id = workspace_uuid;
    
    course_data := jsonb_build_object(
        'courses', COALESCE(courses_summary, '[]'),
        'revenue_analytics', COALESCE(revenue_data, '{}'),
        'generated_at', CURRENT_TIMESTAMP
    );
    
    RETURN course_data;
END;
$$;

-- Get Templates Data
CREATE OR REPLACE FUNCTION public.get_templates_data(workspace_uuid UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    templates_data JSONB;
    content_templates JSONB;
    bio_templates JSONB;
BEGIN
    -- Check access
    IF NOT public.has_workspace_access(workspace_uuid) THEN
        RAISE EXCEPTION 'Access denied to workspace templates data';
    END IF;
    
    -- Get content templates
    SELECT jsonb_agg(
        jsonb_build_object(
            'id', ct.id,
            'title', ct.title,
            'description', ct.description,
            'template_type', ct.template_type,
            'category', ct.category,
            'thumbnail_url', ct.thumbnail_url,
            'tags', ct.tags,
            'usage_count', ct.usage_count,
            'is_favorite', ct.is_favorite,
            'creator_name', up.full_name
        )
    ) INTO content_templates
    FROM public.content_templates ct
    LEFT JOIN public.user_profiles up ON ct.creator_id = up.id
    WHERE ct.workspace_id = workspace_uuid
    ORDER BY ct.usage_count DESC, ct.created_at DESC;
    
    -- Get link in bio templates
    SELECT jsonb_agg(
        jsonb_build_object(
            'id', lbt.id,
            'title', lbt.title,
            'description', lbt.description,
            'category', lbt.category,
            'style_theme', lbt.style_theme,
            'thumbnail_url', lbt.thumbnail_url,
            'usage_count', lbt.usage_count,
            'is_favorite', lbt.is_favorite,
            'is_premium', lbt.is_premium,
            'creator_name', up.full_name
        )
    ) INTO bio_templates
    FROM public.link_in_bio_templates lbt
    LEFT JOIN public.user_profiles up ON lbt.creator_id = up.id
    WHERE lbt.workspace_id = workspace_uuid
    ORDER BY lbt.usage_count DESC, lbt.created_at DESC;
    
    templates_data := jsonb_build_object(
        'content_templates', COALESCE(content_templates, '[]'),
        'link_in_bio_templates', COALESCE(bio_templates, '[]'),
        'generated_at', CURRENT_TIMESTAMP
    );
    
    RETURN templates_data;
END;
$$;

-- 19. Mock Data Population for Production-Ready Demo
DO $$
DECLARE
    demo_workspace_id UUID;
    demo_user_id UUID;
    demo_admin_id UUID;
    course_id UUID;
    module_id UUID;
    contact_id UUID;
BEGIN
    -- Get existing demo workspace and users
    SELECT id INTO demo_workspace_id FROM public.workspaces WHERE name = 'Demo Marketing Agency' LIMIT 1;
    SELECT id INTO demo_user_id FROM public.user_profiles WHERE email = 'demo@example.com' LIMIT 1;
    SELECT id INTO demo_admin_id FROM public.user_profiles WHERE email = 'admin@example.com' LIMIT 1;
    
    -- If no demo data exists, create it
    IF demo_workspace_id IS NULL THEN
        demo_workspace_id := gen_random_uuid();
        INSERT INTO public.workspaces (id, name, description, industry)
        VALUES (demo_workspace_id, 'Demo Marketing Agency', 'Digital marketing and course creation agency', 'Marketing');
    END IF;
    
    IF demo_user_id IS NULL THEN
        -- Create auth user first
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
            'demo@example.com', crypt('demo123', gen_salt('bf', 10)), now(), now(), now(),
            '{"full_name": "Demo User"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
            false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null
        ) RETURNING id INTO demo_user_id;
    END IF;
    
    -- Create demo courses
    INSERT INTO public.courses (id, workspace_id, instructor_id, title, description, price, status, enrollment_count, completion_rate, average_rating, total_revenue, is_published)
    VALUES 
        (gen_random_uuid(), demo_workspace_id, demo_user_id, 'Complete Digital Marketing Masterclass', 'Learn digital marketing from basics to advanced strategies', 299.00, 'published', 1247, 68.5, 4.7, 12450.00, true),
        (gen_random_uuid(), demo_workspace_id, demo_user_id, 'Social Media Growth Strategies', 'Master social media marketing and grow your audience', 199.00, 'published', 834, 72.3, 4.6, 8340.00, true),
        (gen_random_uuid(), demo_workspace_id, demo_user_id, 'Flutter App Development', 'Build mobile apps with Flutter framework', 399.00, 'draft', 0, 0.0, 0.0, 0.00, false)
    ON CONFLICT (id) DO NOTHING
    RETURNING id INTO course_id;
    
    -- Create demo course modules
    INSERT INTO public.course_modules (course_id, title, description, order_index, lesson_count, duration_minutes, completion_rate)
    VALUES 
        (course_id, 'Introduction to Digital Marketing', 'Fundamentals of digital marketing', 1, 8, 165, 85.5),
        (course_id, 'Advanced Marketing Strategies', 'Advanced concepts and techniques', 2, 12, 260, 42.3),
        (course_id, 'Practical Implementation', 'Real-world projects and applications', 3, 15, 375, 0.0)
    ON CONFLICT DO NOTHING
    RETURNING id INTO module_id;
    
    -- Create demo course lessons
    INSERT INTO public.course_lessons (module_id, title, content_type, duration_minutes, order_index, status)
    VALUES 
        (module_id, 'Setting up Development Environment', 'video', 15, 1, 'published'),
        (module_id, 'Understanding Digital Marketing Basics', 'video', 22, 2, 'published'),
        (module_id, 'Content Strategy Fundamentals', 'text', 12, 3, 'draft'),
        (module_id, 'Social Media Platforms Overview', 'video', 35, 4, 'draft'),
        (module_id, 'Email Marketing Best Practices', 'quiz', 25, 5, 'draft')
    ON CONFLICT DO NOTHING;
    
    -- Create demo CRM contacts
    INSERT INTO public.crm_contacts (workspace_id, assigned_to, name, company, email, phone, lead_score, stage, source, deal_value, priority, tags, notes, interactions_count, conversion_probability, next_action)
    VALUES 
        (demo_workspace_id, demo_user_id, 'Sarah Johnson', 'TechCorp Inc.', 'sarah.johnson@techcorp.com', '+1 (555) 123-4567', 94, 'negotiation', 'LinkedIn', 125000.00, 'high', ARRAY['Enterprise', 'Hot Lead', 'Decision Maker'], 'CEO interested in enterprise solution. Budget approved.', 47, 0.92, 'Follow up on contract terms'),
        (demo_workspace_id, demo_user_id, 'Michael Chen', 'Innovation Labs', 'm.chen@innovationlabs.com', '+1 (555) 987-6543', 78, 'qualified', 'Website', 85000.00, 'medium', ARRAY['SMB', 'Warm Lead', 'Technical'], 'CTO evaluating solution. Needs technical deep dive.', 23, 0.65, 'Prepare technical demo'),
        (demo_workspace_id, demo_user_id, 'Emily Rodriguez', 'Global Solutions', 'emily.r@globalsolutions.com', '+1 (555) 456-7890', 91, 'proposal', 'Referral', 175000.00, 'high', ARRAY['Enterprise', 'Referral', 'Hot Lead'], 'Referred by existing client. Very interested.', 18, 0.88, 'Send customized proposal')
    ON CONFLICT DO NOTHING
    RETURNING id INTO contact_id;
    
    -- Create demo CRM activities
    INSERT INTO public.crm_activities (contact_id, user_id, activity_type, title, outcome, notes)
    VALUES 
        (contact_id, demo_user_id, 'meeting', 'Contract negotiation call', 'Positive - ready to proceed', 'Discussed terms and pricing'),
        (contact_id, demo_user_id, 'email', 'Sent proposal document', 'Opened and reviewed', 'Client reviewed proposal quickly'),
        (contact_id, demo_user_id, 'call', 'Discovery call completed', 'Excellent fit - moving to proposal', 'Great product-market fit identified')
    ON CONFLICT DO NOTHING;
    
    -- Create demo social media posts
    INSERT INTO public.social_media_posts (workspace_id, author_id, content, platform, hashtags, status, engagement_count, reach_count, likes_count, comments_count, shares_count, published_at)
    VALUES 
        (demo_workspace_id, demo_user_id, 'Excited to announce our new Digital Marketing Masterclass! 🚀 Transform your business with proven strategies.', 'Instagram', ARRAY['#DigitalMarketing', '#BusinessGrowth', '#Marketing'], 'published', 2400, 15800, 1200, 340, 89, CURRENT_TIMESTAMP - INTERVAL '2 hours'),
        (demo_workspace_id, demo_user_id, 'Behind the scenes: Creating our latest course content. The process of building educational material that truly impacts businesses.', 'LinkedIn', ARRAY['#Education', '#ContentCreation', '#BehindTheScenes'], 'published', 1800, 12300, 890, 124, 67, CURRENT_TIMESTAMP - INTERVAL '1 day'),
        (demo_workspace_id, demo_user_id, 'Customer success story: How Sarah increased her leads by 300% using our social media strategies! 📈', 'Facebook', ARRAY['#Success', '#Testimonial', '#SocialMedia'], 'scheduled', 0, 0, 0, 0, 0, CURRENT_TIMESTAMP + INTERVAL '2 hours')
    ON CONFLICT DO NOTHING;
    
    -- Create demo content templates
    INSERT INTO public.content_templates (workspace_id, creator_id, title, description, template_type, category, content_data, tags, usage_count, is_favorite)
    VALUES 
        (demo_workspace_id, demo_user_id, 'Product Launch Announcement', 'Template for announcing new products', 'social_post', 'Marketing', '{"structure": "announcement", "tone": "exciting"}', ARRAY['launch', 'product', 'announcement'], 124, true),
        (demo_workspace_id, demo_user_id, 'Customer Testimonial Post', 'Template for sharing customer success stories', 'social_post', 'Social Proof', '{"structure": "testimonial", "tone": "authentic"}', ARRAY['testimonial', 'success', 'customer'], 89, false),
        (demo_workspace_id, demo_user_id, 'Educational Content Series', 'Template for educational post series', 'blog_post', 'Education', '{"structure": "educational", "tone": "professional"}', ARRAY['education', 'tips', 'series'], 156, true)
    ON CONFLICT DO NOTHING;
    
    -- Create demo link in bio templates
    INSERT INTO public.link_in_bio_templates (workspace_id, creator_id, title, description, category, style_theme, template_data, usage_count, is_favorite, is_premium)
    VALUES 
        (demo_workspace_id, demo_user_id, 'Modern Business Card', 'Clean and professional business card style', 'Business', 'modern', '{"layout": "card", "colors": ["#007AFF", "#FFFFFF"]}', 67, true, false),
        (demo_workspace_id, demo_user_id, 'Creative Portfolio', 'Showcase your creative work', 'Portfolio', 'creative', '{"layout": "gallery", "colors": ["#FF3B30", "#34C759"]}', 43, false, true),
        (demo_workspace_id, demo_user_id, 'E-commerce Store', 'Perfect for online stores', 'E-commerce', 'professional', '{"layout": "store", "colors": ["#5856D6", "#FF9500"]}', 89, true, true)
    ON CONFLICT DO NOTHING;
    
    -- Create demo recent activities
    INSERT INTO public.recent_activities (workspace_id, user_id, activity_type, title, description, avatar_url, icon_name, icon_color)
    VALUES 
        (demo_workspace_id, demo_user_id, 'post', 'New Instagram post scheduled', 'Product launch announcement for 2:00 PM', 'https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=150', 'schedule', '#007AFF'),
        (demo_workspace_id, demo_user_id, 'lead', 'New lead generated', 'Sarah Johnson from Instagram campaign', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150', 'person_add', '#34C759'),
        (demo_workspace_id, demo_user_id, 'sale', 'Course purchase completed', 'Digital Marketing Masterclass - $299', 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150', 'shopping_cart', '#FF9500'),
        (demo_workspace_id, demo_user_id, 'team', 'Team member joined', 'Alex Rodriguez added to Marketing team', 'https://images.unsplash.com/photo-1519244703995-f4e0f30006d5?w=150', 'group_add', '#FF3B30'),
        (demo_workspace_id, demo_user_id, 'automation', 'Email sequence completed', 'Welcome series sent to 47 new subscribers', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150', 'auto_awesome', '#32D74B')
    ON CONFLICT DO NOTHING;
    
    -- Create demo workspace metrics
    INSERT INTO public.workspace_metrics (workspace_id, metric_name, metric_value, metric_unit, change_percentage, is_positive_change, sparkline_data)
    VALUES 
        (demo_workspace_id, 'total_leads', 2847, 'count', 12.5, true, ARRAY[1, 3, 2, 4, 5, 3, 6, 7, 5, 8]),
        (demo_workspace_id, 'revenue', 45320, 'USD', 8.2, true, ARRAY[2, 4, 3, 5, 6, 4, 7, 8, 6, 9]),
        (demo_workspace_id, 'social_followers', 12400, 'count', 15.3, true, ARRAY[3, 5, 4, 6, 7, 5, 8, 9, 7, 10]),
        (demo_workspace_id, 'course_enrollments', 384, 'count', 22.1, true, ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]),
        (demo_workspace_id, 'conversion_rate', 98.5, 'percentage', 1.2, true, ARRAY[8, 9, 8, 9, 10, 9, 10, 9, 10, 10])
    ON CONFLICT (workspace_id, metric_name, metric_date) DO NOTHING;
    
    -- Create demo trending hashtags
    INSERT INTO public.trending_hashtags (workspace_id, hashtag, usage_count, engagement_score, trend_score, platform, category)
    VALUES 
        (demo_workspace_id, '#DigitalMarketing', 156, 2340.5, 8.7, 'Instagram', 'Marketing'),
        (demo_workspace_id, '#BusinessGrowth', 134, 1890.2, 7.8, 'LinkedIn', 'Business'),
        (demo_workspace_id, '#SocialMediaTips', 98, 1456.8, 6.9, 'TikTok', 'Education'),
        (demo_workspace_id, '#ContentCreation', 87, 1234.6, 6.2, 'YouTube', 'Content'),
        (demo_workspace_id, '#MarketingStrategy', 76, 987.4, 5.8, 'Twitter', 'Strategy')
    ON CONFLICT (workspace_id, hashtag, platform) DO NOTHING;
    
    -- Create demo revenue analytics
    INSERT INTO public.revenue_analytics (workspace_id, source_type, amount, transaction_type, description, customer_email, transaction_date)
    VALUES 
        (demo_workspace_id, 'course', 299.00, 'sale', 'Digital Marketing Masterclass purchase', 'customer1@example.com', CURRENT_DATE),
        (demo_workspace_id, 'course', 199.00, 'sale', 'Social Media Growth course purchase', 'customer2@example.com', CURRENT_DATE - 1),
        (demo_workspace_id, 'subscription', 49.99, 'subscription', 'Monthly Pro subscription', 'customer3@example.com', CURRENT_DATE - 2),
        (demo_workspace_id, 'course', 399.00, 'sale', 'Flutter Development course purchase', 'customer4@example.com', CURRENT_DATE - 3),
        (demo_workspace_id, 'commission', 150.00, 'commission', 'Affiliate commission payment', 'affiliate@example.com', CURRENT_DATE - 5)
    ON CONFLICT DO NOTHING;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error creating dynamic data demo: %', SQLERRM;
END $$;

-- 20. Cleanup Function for Test Data
CREATE OR REPLACE FUNCTION public.cleanup_hardcoded_data_migration_test_data()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Clean up demo data
    DELETE FROM public.revenue_analytics WHERE workspace_id IN (
        SELECT id FROM public.workspaces WHERE name = 'Demo Marketing Agency'
    );
    DELETE FROM public.trending_hashtags WHERE workspace_id IN (
        SELECT id FROM public.workspaces WHERE name = 'Demo Marketing Agency'
    );
    DELETE FROM public.workspace_metrics WHERE workspace_id IN (
        SELECT id FROM public.workspaces WHERE name = 'Demo Marketing Agency'
    );
    DELETE FROM public.recent_activities WHERE workspace_id IN (
        SELECT id FROM public.workspaces WHERE name = 'Demo Marketing Agency'
    );
    DELETE FROM public.link_in_bio_templates WHERE workspace_id IN (
        SELECT id FROM public.workspaces WHERE name = 'Demo Marketing Agency'
    );
    DELETE FROM public.content_templates WHERE workspace_id IN (
        SELECT id FROM public.workspaces WHERE name = 'Demo Marketing Agency'
    );
    DELETE FROM public.social_media_posts WHERE workspace_id IN (
        SELECT id FROM public.workspaces WHERE name = 'Demo Marketing Agency'
    );
    DELETE FROM public.crm_activities WHERE contact_id IN (
        SELECT id FROM public.crm_contacts WHERE workspace_id IN (
            SELECT id FROM public.workspaces WHERE name = 'Demo Marketing Agency'
        )
    );
    DELETE FROM public.crm_contacts WHERE workspace_id IN (
        SELECT id FROM public.workspaces WHERE name = 'Demo Marketing Agency'
    );
    DELETE FROM public.course_lessons WHERE module_id IN (
        SELECT id FROM public.course_modules WHERE course_id IN (
            SELECT id FROM public.courses WHERE workspace_id IN (
                SELECT id FROM public.workspaces WHERE name = 'Demo Marketing Agency'
            )
        )
    );
    DELETE FROM public.course_modules WHERE course_id IN (
        SELECT id FROM public.courses WHERE workspace_id IN (
            SELECT id FROM public.workspaces WHERE name = 'Demo Marketing Agency'
        )
    );
    DELETE FROM public.courses WHERE workspace_id IN (
        SELECT id FROM public.workspaces WHERE name = 'Demo Marketing Agency'
    );
    
    -- Clean up existing test data from other migrations
    PERFORM public.cleanup_enhanced_auth_test_data();
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Hardcoded data cleanup failed: %', SQLERRM;
END;
$$;

-- Final optimization
ANALYZE public.courses;
ANALYZE public.course_modules;
ANALYZE public.course_lessons;
ANALYZE public.crm_contacts;
ANALYZE public.crm_activities;
ANALYZE public.social_media_posts;
ANALYZE public.content_templates;
ANALYZE public.link_in_bio_templates;
ANALYZE public.recent_activities;
ANALYZE public.workspace_metrics;
ANALYZE public.team_invitations;
ANALYZE public.trending_hashtags;
ANALYZE public.revenue_analytics;
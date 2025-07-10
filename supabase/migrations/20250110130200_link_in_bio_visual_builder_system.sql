-- Migration for Link in Bio Visual Builder System with Domain Management
-- Location: supabase/migrations/20250110130200_link_in_bio_visual_builder_system.sql

-- 1. Types and Enums
CREATE TYPE public.link_page_status AS ENUM ('draft', 'published', 'archived');
CREATE TYPE public.domain_status AS ENUM ('pending', 'verified', 'failed', 'disabled');
CREATE TYPE public.component_type AS ENUM ('link_button', 'text_block', 'image', 'social_links', 'contact_form', 'video', 'divider', 'spacer');
CREATE TYPE public.button_style AS ENUM ('solid', 'outline', 'text', 'gradient', 'custom');

-- 2. Link Pages Table
CREATE TABLE public.link_pages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    slug TEXT NOT NULL,
    status public.link_page_status DEFAULT 'draft'::public.link_page_status,
    theme_settings JSONB DEFAULT '{}'::jsonb,
    seo_settings JSONB DEFAULT '{}'::jsonb,
    analytics_settings JSONB DEFAULT '{}'::jsonb,
    is_password_protected BOOLEAN DEFAULT false,
    password_hash TEXT,
    custom_css TEXT,
    custom_js TEXT,
    visit_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    published_at TIMESTAMPTZ
);

-- 3. Custom Domains Table
CREATE TABLE public.custom_domains (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    link_page_id UUID REFERENCES public.link_pages(id) ON DELETE CASCADE,
    domain_name TEXT NOT NULL UNIQUE,
    status public.domain_status DEFAULT 'pending'::public.domain_status,
    verification_token TEXT NOT NULL DEFAULT gen_random_uuid()::TEXT,
    ssl_certificate_id TEXT,
    dns_verification_record TEXT,
    last_verified_at TIMESTAMPTZ,
    verification_attempts INTEGER DEFAULT 0,
    error_message TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4. Page Components Table
CREATE TABLE public.page_components (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    link_page_id UUID REFERENCES public.link_pages(id) ON DELETE CASCADE,
    component_type public.component_type NOT NULL,
    component_data JSONB NOT NULL DEFAULT '{}'::jsonb,
    position_order INTEGER NOT NULL,
    is_visible BOOLEAN DEFAULT true,
    style_settings JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 5. Link Analytics Table
CREATE TABLE public.link_analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    link_page_id UUID REFERENCES public.link_pages(id) ON DELETE CASCADE,
    component_id UUID REFERENCES public.page_components(id) ON DELETE CASCADE,
    visitor_ip TEXT,
    user_agent TEXT,
    referrer TEXT,
    country_code TEXT,
    city TEXT,
    device_type TEXT,
    click_timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    session_id TEXT
);

-- 6. Essential Indexes
CREATE INDEX idx_link_pages_user_id ON public.link_pages(user_id);
CREATE INDEX idx_link_pages_slug ON public.link_pages(slug);
CREATE INDEX idx_link_pages_status ON public.link_pages(status);
CREATE INDEX idx_custom_domains_user_id ON public.custom_domains(user_id);
CREATE INDEX idx_custom_domains_domain_name ON public.custom_domains(domain_name);
CREATE INDEX idx_custom_domains_status ON public.custom_domains(status);
CREATE INDEX idx_page_components_link_page_id ON public.page_components(link_page_id);
CREATE INDEX idx_page_components_position_order ON public.page_components(link_page_id, position_order);
CREATE INDEX idx_link_analytics_link_page_id ON public.link_analytics(link_page_id);
CREATE INDEX idx_link_analytics_timestamp ON public.link_analytics(click_timestamp);

-- 7. RLS Setup
ALTER TABLE public.link_pages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.custom_domains ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.page_components ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.link_analytics ENABLE ROW LEVEL SECURITY;

-- 8. Helper Functions
CREATE OR REPLACE FUNCTION public.owns_link_page(page_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.link_pages lp
    WHERE lp.id = page_uuid AND lp.user_id = auth.uid()
)
$$;

CREATE OR REPLACE FUNCTION public.can_access_link_page(page_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.link_pages lp
    WHERE lp.id = page_uuid 
    AND (lp.user_id = auth.uid() OR lp.status = 'published'::public.link_page_status)
)
$$;

CREATE OR REPLACE FUNCTION public.owns_custom_domain(domain_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.custom_domains cd
    WHERE cd.id = domain_uuid AND cd.user_id = auth.uid()
)
$$;

CREATE OR REPLACE FUNCTION public.can_manage_page_component(component_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.page_components pc
    JOIN public.link_pages lp ON pc.link_page_id = lp.id
    WHERE pc.id = component_uuid AND lp.user_id = auth.uid()
)
$$;

-- 9. Trigger Functions
CREATE OR REPLACE FUNCTION public.update_link_page_timestamp()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    IF NEW.status = 'published' AND OLD.status != 'published' THEN
        NEW.published_at = CURRENT_TIMESTAMP;
    END IF;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.update_domain_timestamp()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    IF NEW.status = 'verified' AND OLD.status != 'verified' THEN
        NEW.last_verified_at = CURRENT_TIMESTAMP;
    END IF;
    RETURN NEW;
END;
$$;

-- 10. Triggers
CREATE TRIGGER update_link_pages_timestamp
    BEFORE UPDATE ON public.link_pages
    FOR EACH ROW EXECUTE FUNCTION public.update_link_page_timestamp();

CREATE TRIGGER update_custom_domains_timestamp
    BEFORE UPDATE ON public.custom_domains
    FOR EACH ROW EXECUTE FUNCTION public.update_domain_timestamp();

-- 11. RLS Policies
CREATE POLICY "users_manage_own_link_pages"
ON public.link_pages
FOR ALL
TO authenticated
USING (public.owns_link_page(id))
WITH CHECK (public.owns_link_page(id));

CREATE POLICY "public_can_view_published_pages"
ON public.link_pages
FOR SELECT
TO public
USING (status = 'published'::public.link_page_status);

CREATE POLICY "users_manage_own_domains"
ON public.custom_domains
FOR ALL
TO authenticated
USING (public.owns_custom_domain(id))
WITH CHECK (public.owns_custom_domain(id));

CREATE POLICY "users_manage_page_components"
ON public.page_components
FOR ALL
TO authenticated
USING (public.can_manage_page_component(id))
WITH CHECK (public.can_manage_page_component(id));

CREATE POLICY "public_can_view_published_components"
ON public.page_components
FOR SELECT
TO public
USING (
    EXISTS (
        SELECT 1 FROM public.link_pages lp
        WHERE lp.id = link_page_id AND lp.status = 'published'::public.link_page_status
    )
);

CREATE POLICY "users_view_own_analytics"
ON public.link_analytics
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.link_pages lp
        WHERE lp.id = link_page_id AND lp.user_id = auth.uid()
    )
);

CREATE POLICY "system_can_insert_analytics"
ON public.link_analytics
FOR INSERT
TO public
WITH CHECK (true);

-- 12. Mock Data
DO $$
DECLARE
    user1_id UUID := gen_random_uuid();
    user2_id UUID := gen_random_uuid();
    page1_id UUID := gen_random_uuid();
    page2_id UUID := gen_random_uuid();
    domain1_id UUID := gen_random_uuid();
    component1_id UUID := gen_random_uuid();
    component2_id UUID := gen_random_uuid();
BEGIN
    -- Create auth users
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (user1_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'creator@example.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Link Creator"}}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (user2_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'influencer@example.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Social Influencer"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null);

    -- Create link pages
    INSERT INTO public.link_pages (id, user_id, title, description, slug, status, theme_settings, seo_settings) VALUES
        (page1_id, user1_id, 'My Business Links', 'Find all my important business links here', 'mybusiness', 'published'::public.link_page_status,
         '{"theme": "modern", "background_color": "#ffffff", "text_color": "#333333", "accent_color": "#007bff"}'::jsonb,
         '{"meta_title": "My Business - All Links", "meta_description": "Professional business links and contact information"}'::jsonb),
        (page2_id, user2_id, 'Social Media Hub', 'Connect with me on all platforms', 'socialhub', 'published'::public.link_page_status,
         '{"theme": "gradient", "background_gradient": ["#ff6b6b", "#4ecdc4"], "text_color": "#ffffff"}'::jsonb,
         '{"meta_title": "Social Media Hub", "meta_description": "Follow me on all social platforms"}'::jsonb);

    -- Create custom domain
    INSERT INTO public.custom_domains (id, user_id, link_page_id, domain_name, status, verification_token) VALUES
        (domain1_id, user1_id, page1_id, 'links.mybusiness.com', 'verified'::public.domain_status, 'verify_token_123');

    -- Create page components
    INSERT INTO public.page_components (id, link_page_id, component_type, component_data, position_order, style_settings) VALUES
        (component1_id, page1_id, 'link_button'::public.component_type,
         '{"title": "Visit Our Website", "url": "https://mybusiness.com", "description": "Learn more about our services"}'::jsonb, 1,
         '{"button_style": "solid", "background_color": "#007bff", "text_color": "#ffffff", "border_radius": 8}'::jsonb),
        (component2_id, page1_id, 'social_links'::public.component_type,
         '{"links": [{"platform": "instagram", "url": "https://instagram.com/mybusiness", "username": "@mybusiness"}]}'::jsonb, 2,
         '{"layout": "grid", "icon_size": "medium", "show_labels": true}'::jsonb);

    -- Create analytics data
    INSERT INTO public.link_analytics (link_page_id, component_id, visitor_ip, user_agent, referrer, country_code, device_type, session_id) VALUES
        (page1_id, component1_id, '192.168.1.1', 'Mozilla/5.0', 'https://google.com', 'US', 'desktop', 'session_123'),
        (page1_id, component2_id, '192.168.1.2', 'Mozilla/5.0', 'https://instagram.com', 'CA', 'mobile', 'session_124');

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key error: %', SQLERRM;
    WHEN unique_violation THEN
        RAISE NOTICE 'Unique constraint error: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error: %', SQLERRM;
END $$;
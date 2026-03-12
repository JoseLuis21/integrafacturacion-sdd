
--
-- Name: companies; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.companies (
    id uuid NOT NULL,
    tenant_code text NOT NULL,
    tenant_schema text NOT NULL,
    rut text NOT NULL,
    rut_normalized text NOT NULL,
    legal_name text NOT NULL,
    trade_name text,
    status text DEFAULT 'onboarding'::text NOT NULL,
    onboarding_status text DEFAULT 'provisioning'::text NOT NULL,
    primary_giro text NOT NULL,
    sii_environment text DEFAULT 'certification'::text NOT NULL,
    sii_resolution_number text,
    sii_resolution_date date,
    dte_email text,
    contact_email text NOT NULL,
    billing_email text,
    phone text,
    website text,
    logo_url text,
    default_currency text DEFAULT 'CLP'::text NOT NULL,
    locale text DEFAULT 'es-CL'::text NOT NULL,
    timezone text DEFAULT 'America/Santiago'::text NOT NULL,
    created_by_user_id uuid NOT NULL,
    activated_at timestamp with time zone,
    suspended_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ck_companies_status CHECK ((status = ANY (ARRAY['onboarding'::text, 'active'::text, 'suspended'::text, 'archived'::text]))),
    CONSTRAINT ck_companies_onboarding_status CHECK ((onboarding_status = ANY (ARRAY['pending'::text, 'provisioning'::text, 'ready'::text, 'failed'::text]))),
    CONSTRAINT ck_companies_sii_environment CHECK ((sii_environment = ANY (ARRAY['certification'::text, 'production'::text])))
);


ALTER TABLE public.companies OWNER TO neondb_owner;

--
-- Name: company_branches; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.company_branches (
    id uuid NOT NULL,
    company_id uuid NOT NULL,
    branch_name text NOT NULL,
    branch_type text DEFAULT 'branch'::text NOT NULL,
    sii_branch_code text,
    is_default boolean DEFAULT false NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    email text,
    phone text,
    street text NOT NULL,
    street_number text NOT NULL,
    address_line2 text,
    commune_code text NOT NULL,
    commune_name text NOT NULL,
    city text NOT NULL,
    region_code text NOT NULL,
    region_name text NOT NULL,
    country_code text DEFAULT 'CL'::text NOT NULL,
    postal_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ck_company_branches_branch_type CHECK ((branch_type = ANY (ARRAY['main'::text, 'branch'::text]))),
    CONSTRAINT ck_company_branches_status CHECK ((status = ANY (ARRAY['active'::text, 'inactive'::text]))),
    CONSTRAINT ck_company_branches_country_code CHECK ((country_code = 'CL'::text))
);


ALTER TABLE public.company_branches OWNER TO neondb_owner;

--
-- Name: company_economic_activities; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.company_economic_activities (
    id uuid NOT NULL,
    company_id uuid NOT NULL,
    sii_activity_code text NOT NULL,
    activity_name text NOT NULL,
    is_primary boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.company_economic_activities OWNER TO neondb_owner;

--
-- Name: company_tenant_provisioning; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.company_tenant_provisioning (
    company_id uuid NOT NULL,
    tenant_schema text NOT NULL,
    provisioning_status text DEFAULT 'pending'::text NOT NULL,
    bootstrap_version text DEFAULT 'v1'::text NOT NULL,
    requested_by_user_id uuid,
    started_at timestamp with time zone,
    finished_at timestamp with time zone,
    last_error_code text,
    last_error_message text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ck_company_tenant_provisioning_status CHECK ((provisioning_status = ANY (ARRAY['pending'::text, 'provisioning'::text, 'ready'::text, 'failed'::text])))
);


ALTER TABLE public.company_tenant_provisioning OWNER TO neondb_owner;

--
-- Name: permissions; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.permissions (
    id uuid NOT NULL,
    code text NOT NULL,
    module text NOT NULL,
    action text NOT NULL,
    scope text DEFAULT 'company'::text NOT NULL,
    description text,
    is_system boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ck_permissions_scope CHECK ((scope = ANY (ARRAY['global'::text, 'company'::text])))
);


ALTER TABLE public.permissions OWNER TO neondb_owner;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.roles (
    id uuid NOT NULL,
    company_id uuid,
    name text NOT NULL,
    code text NOT NULL,
    description text,
    scope text NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    is_system boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ck_roles_scope CHECK ((scope = ANY (ARRAY['global'::text, 'company'::text]))),
    CONSTRAINT ck_roles_status CHECK ((status = ANY (ARRAY['active'::text, 'archived'::text]))),
    CONSTRAINT ck_roles_scope_company_id CHECK ((((scope = 'global'::text) AND (company_id IS NULL)) OR ((scope = 'company'::text) AND (company_id IS NOT NULL))))
);


ALTER TABLE public.roles OWNER TO neondb_owner;

--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.role_permissions (
    id uuid NOT NULL,
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO neondb_owner;

--
-- Name: user_role_assignments; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.user_role_assignments (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    role_id uuid NOT NULL,
    assigned_by_user_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_role_assignments OWNER TO neondb_owner;

--
-- Name: company_users; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.company_users (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    company_id uuid NOT NULL,
    status text DEFAULT 'invited'::text NOT NULL,
    joined_at timestamp with time zone,
    invited_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.company_users OWNER TO neondb_owner;

--
-- Name: email_verifications; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.email_verifications (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    email text NOT NULL,
    token_hash text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    consumed_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.email_verifications OWNER TO neondb_owner;

--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.password_reset_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_hash text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    used_at timestamp with time zone,
    requested_ip text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.password_reset_tokens OWNER TO neondb_owner;

--
-- Name: password_setup_tokens; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.password_setup_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_hash text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    used_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.password_setup_tokens OWNER TO neondb_owner;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.schema_migrations (
    name text NOT NULL,
    applied_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO neondb_owner;

--
-- Name: users; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    email text NOT NULL,
    email_normalized text NOT NULL,
    password_hash text,
    password_set_at timestamp with time zone,
    first_name text,
    last_name text,
    phone text,
    locale text DEFAULT 'es-CL'::text NOT NULL,
    status text NOT NULL,
    last_login_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT ck_users_status CHECK ((status = ANY (ARRAY['invited'::text, 'active'::text, 'blocked'::text, 'pending_email_verification'::text])))
);


ALTER TABLE public.users OWNER TO neondb_owner;

--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: company_branches company_branches_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.company_branches
    ADD CONSTRAINT company_branches_pkey PRIMARY KEY (id);


--
-- Name: company_economic_activities company_economic_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.company_economic_activities
    ADD CONSTRAINT company_economic_activities_pkey PRIMARY KEY (id);


--
-- Name: company_tenant_provisioning company_tenant_provisioning_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.company_tenant_provisioning
    ADD CONSTRAINT company_tenant_provisioning_pkey PRIMARY KEY (company_id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- Name: user_role_assignments user_role_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.user_role_assignments
    ADD CONSTRAINT user_role_assignments_pkey PRIMARY KEY (id);


--
-- Name: company_users company_users_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.company_users
    ADD CONSTRAINT company_users_pkey PRIMARY KEY (id);


--
-- Name: email_verifications email_verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.email_verifications
    ADD CONSTRAINT email_verifications_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (id);


--
-- Name: password_setup_tokens password_setup_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.password_setup_tokens
    ADD CONSTRAINT password_setup_tokens_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (name);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: companies ux_companies_rut_normalized; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT ux_companies_rut_normalized UNIQUE (rut_normalized);


--
-- Name: companies ux_companies_tenant_code; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT ux_companies_tenant_code UNIQUE (tenant_code);


--
-- Name: companies ux_companies_tenant_schema; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT ux_companies_tenant_schema UNIQUE (tenant_schema);


--
-- Name: company_branches ux_company_branches_company_branch_name; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.company_branches
    ADD CONSTRAINT ux_company_branches_company_branch_name UNIQUE (company_id, branch_name);


--
-- Name: company_branches ux_company_branches_company_sii_branch_code; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.company_branches
    ADD CONSTRAINT ux_company_branches_company_sii_branch_code UNIQUE (company_id, sii_branch_code);


--
-- Name: company_economic_activities ux_company_economic_activities_company_code; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.company_economic_activities
    ADD CONSTRAINT ux_company_economic_activities_company_code UNIQUE (company_id, sii_activity_code);


--
-- Name: company_tenant_provisioning ux_company_tenant_provisioning_tenant_schema; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.company_tenant_provisioning
    ADD CONSTRAINT ux_company_tenant_provisioning_tenant_schema UNIQUE (tenant_schema);


--
-- Name: permissions ux_permissions_code; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT ux_permissions_code UNIQUE (code);


--
-- Name: role_permissions ux_role_permissions_role_permission; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT ux_role_permissions_role_permission UNIQUE (role_id, permission_id);


--
-- Name: user_role_assignments ux_user_role_assignments_user_role; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.user_role_assignments
    ADD CONSTRAINT ux_user_role_assignments_user_role UNIQUE (user_id, role_id);


--
-- Name: company_users ux_company_users_user_company; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.company_users
    ADD CONSTRAINT ux_company_users_user_company UNIQUE (user_id, company_id);


--
-- Name: email_verifications ux_email_verifications_token_hash; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.email_verifications
    ADD CONSTRAINT ux_email_verifications_token_hash UNIQUE (token_hash);


--
-- Name: password_reset_tokens ux_password_reset_tokens_token_hash; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT ux_password_reset_tokens_token_hash UNIQUE (token_hash);


--
-- Name: password_setup_tokens ux_password_setup_tokens_token_hash; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.password_setup_tokens
    ADD CONSTRAINT ux_password_setup_tokens_token_hash UNIQUE (token_hash);


--
-- Name: users ux_users_email; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT ux_users_email UNIQUE (email);


--
-- Name: users ux_users_email_normalized; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT ux_users_email_normalized UNIQUE (email_normalized);


--
-- Name: ix_companies_created_by_user_id; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX ix_companies_created_by_user_id ON public.companies USING btree (created_by_user_id);


--
-- Name: ix_companies_status; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX ix_companies_status ON public.companies USING btree (status);


--
-- Name: ix_company_branches_company_id; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX ix_company_branches_company_id ON public.company_branches USING btree (company_id);


--
-- Name: ux_company_branches_company_default_true; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX ux_company_branches_company_default_true ON public.company_branches USING btree (company_id) WHERE (is_default = true);


--
-- Name: ix_company_economic_activities_company_id; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX ix_company_economic_activities_company_id ON public.company_economic_activities USING btree (company_id);


--
-- Name: ux_company_economic_activities_company_primary_true; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX ux_company_economic_activities_company_primary_true ON public.company_economic_activities USING btree (company_id) WHERE (is_primary = true);


--
-- Name: ix_company_tenant_provisioning_status; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX ix_company_tenant_provisioning_status ON public.company_tenant_provisioning USING btree (provisioning_status);


--
-- Name: ix_permissions_module; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX ix_permissions_module ON public.permissions USING btree (module);


--
-- Name: ix_permissions_scope; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX ix_permissions_scope ON public.permissions USING btree (scope);


--
-- Name: ix_roles_company_id; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX ix_roles_company_id ON public.roles USING btree (company_id);


--
-- Name: ix_roles_scope; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX ix_roles_scope ON public.roles USING btree (scope);


--
-- Name: ix_roles_status; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX ix_roles_status ON public.roles USING btree (status);


--
-- Name: ux_roles_global_code; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX ux_roles_global_code ON public.roles USING btree (code) WHERE (scope = 'global'::text);


--
-- Name: ux_roles_company_code; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX ux_roles_company_code ON public.roles USING btree (company_id, code) WHERE (scope = 'company'::text);


--
-- Name: ix_role_permissions_permission_id; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX ix_role_permissions_permission_id ON public.role_permissions USING btree (permission_id);


--
-- Name: ix_user_role_assignments_role_id; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX ix_user_role_assignments_role_id ON public.user_role_assignments USING btree (role_id);


--
-- Name: ix_company_users_company_id; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX ix_company_users_company_id ON public.company_users USING btree (company_id);


--
-- Name: ix_company_users_user_id; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX ix_company_users_user_id ON public.company_users USING btree (user_id);


--
-- Name: ix_email_verifications_user_id; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX ix_email_verifications_user_id ON public.email_verifications USING btree (user_id);


--
-- Name: ix_password_reset_tokens_user_id; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX ix_password_reset_tokens_user_id ON public.password_reset_tokens USING btree (user_id);


--
-- Name: ix_password_setup_tokens_user_id; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX ix_password_setup_tokens_user_id ON public.password_setup_tokens USING btree (user_id);


--
-- Name: companies companies_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: company_branches company_branches_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.company_branches
    ADD CONSTRAINT company_branches_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: company_economic_activities company_economic_activities_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.company_economic_activities
    ADD CONSTRAINT company_economic_activities_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: company_tenant_provisioning company_tenant_provisioning_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.company_tenant_provisioning
    ADD CONSTRAINT company_tenant_provisioning_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: company_tenant_provisioning company_tenant_provisioning_requested_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.company_tenant_provisioning
    ADD CONSTRAINT company_tenant_provisioning_requested_by_user_id_fkey FOREIGN KEY (requested_by_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: roles roles_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: user_role_assignments user_role_assignments_assigned_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.user_role_assignments
    ADD CONSTRAINT user_role_assignments_assigned_by_user_id_fkey FOREIGN KEY (assigned_by_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: user_role_assignments user_role_assignments_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.user_role_assignments
    ADD CONSTRAINT user_role_assignments_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: user_role_assignments user_role_assignments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.user_role_assignments
    ADD CONSTRAINT user_role_assignments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: company_users company_users_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.company_users
    ADD CONSTRAINT company_users_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: company_users company_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.company_users
    ADD CONSTRAINT company_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: email_verifications email_verifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.email_verifications
    ADD CONSTRAINT email_verifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: password_reset_tokens password_reset_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: password_setup_tokens password_setup_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.password_setup_tokens
    ADD CONSTRAINT password_setup_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

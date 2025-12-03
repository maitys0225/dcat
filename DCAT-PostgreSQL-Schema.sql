-- ============================================================================
-- DCAT PostgreSQL Schema Implementation
-- Version 1.0
-- Date: December 2024
-- Purpose: Implement DCAT 3 vocabulary as relational database schema
-- ============================================================================

-- ============================================================================
-- 1. CORE ENUMS AND TYPES
-- ============================================================================

-- Frequency enumeration for accrual periodicity
CREATE TYPE frequency_type AS ENUM (
    'instant',
    'daily',
    'three_times_a_week',
    'semiweekly',
    'weekly',
    'biweekly',
    'three_times_a_month',
    'monthly',
    'bimonthly',
    'quarterly',
    'semiannual',
    'annual',
    'biennial',
    'triennial',
    'irregular',
    'never'
);

-- Resource type enumeration
CREATE TYPE resource_type AS ENUM (
    'Catalog',
    'Dataset',
    'DataService',
    'DatasetSeries',
    'Distribution'
);

-- Distribution status enumeration
CREATE TYPE distribution_status AS ENUM (
    'Completed',
    'Deprecated',
    'Under Development',
    'Planned',
    'Obsolete'
);

-- Record status for catalog records
CREATE TYPE record_status AS ENUM (
    'Active',
    'Archived',
    'Deprecated',
    'Superseded'
);

-- ============================================================================
-- 2. CORE TABLES
-- ============================================================================

-- Agents (persons and organizations)
CREATE TABLE agents (
    agent_id SERIAL PRIMARY KEY,
    iri TEXT NOT NULL UNIQUE,
    name VARCHAR(500) NOT NULL,
    agent_type VARCHAR(50), -- 'Person', 'Organization'
    email VARCHAR(255),
    telephone VARCHAR(20),
    homepage_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Resources (abstract superclass for all DCAT resources)
CREATE TABLE resources (
    resource_id SERIAL PRIMARY KEY,
    iri TEXT NOT NULL UNIQUE,
    resource_type resource_type NOT NULL,
    title VARCHAR(500) NOT NULL,
    description TEXT,
    identifier VARCHAR(255),
    creator_agent_id INTEGER REFERENCES agents(agent_id),
    publisher_agent_id INTEGER REFERENCES agents(agent_id),
    issued_date DATE,
    modified_date DATE,
    language VARCHAR(5), -- ISO 639-1 code (e.g., 'en', 'es')
    access_rights_iri TEXT,
    license_iri TEXT,
    rights_statement TEXT,
    contact_point_agent_id INTEGER REFERENCES agents(agent_id),
    conformance_standard_iri TEXT,
    version VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Resource themes (many-to-many relationship)
CREATE TABLE resource_themes (
    resource_theme_id SERIAL PRIMARY KEY,
    resource_id INTEGER NOT NULL REFERENCES resources(resource_id) ON DELETE CASCADE,
    theme_iri TEXT NOT NULL,
    theme_label VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Resource keywords
CREATE TABLE resource_keywords (
    resource_keyword_id SERIAL PRIMARY KEY,
    resource_id INTEGER NOT NULL REFERENCES resources(resource_id) ON DELETE CASCADE,
    keyword VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Catalogs
CREATE TABLE catalogs (
    catalog_id SERIAL PRIMARY KEY,
    resource_id INTEGER NOT NULL UNIQUE REFERENCES resources(resource_id) ON DELETE CASCADE,
    homepage_url TEXT,
    theme_taxonomy_iri TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Datasets
CREATE TABLE datasets (
    dataset_id SERIAL PRIMARY KEY,
    resource_id INTEGER NOT NULL UNIQUE REFERENCES resources(resource_id) ON DELETE CASCADE,
    accrual_periodicity frequency_type,
    temporal_start_date DATE,
    temporal_end_date DATE,
    spatial_coverage_iri TEXT,
    spatial_resolution_meters NUMERIC(10, 2),
    temporal_resolution_duration VARCHAR(50), -- ISO 8601 duration
    was_generated_by_iri TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Dataset membership in catalogs
CREATE TABLE catalog_datasets (
    catalog_dataset_id SERIAL PRIMARY KEY,
    catalog_id INTEGER NOT NULL REFERENCES catalogs(catalog_id) ON DELETE CASCADE,
    dataset_id INTEGER NOT NULL REFERENCES datasets(dataset_id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(catalog_id, dataset_id)
);

-- Dataset Series
CREATE TABLE dataset_series (
    dataset_series_id SERIAL PRIMARY KEY,
    resource_id INTEGER NOT NULL UNIQUE REFERENCES resources(resource_id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Dataset membership in series
CREATE TABLE series_members (
    series_member_id SERIAL PRIMARY KEY,
    series_id INTEGER NOT NULL REFERENCES dataset_series(dataset_series_id) ON DELETE CASCADE,
    dataset_id INTEGER NOT NULL REFERENCES datasets(dataset_id) ON DELETE CASCADE,
    member_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(series_id, dataset_id)
);

-- Distributions
CREATE TABLE distributions (
    distribution_id SERIAL PRIMARY KEY,
    resource_id INTEGER NOT NULL UNIQUE REFERENCES resources(resource_id) ON DELETE CASCADE,
    dataset_id INTEGER NOT NULL REFERENCES datasets(dataset_id) ON DELETE CASCADE,
    access_url TEXT,
    download_url TEXT,
    format VARCHAR(100),
    media_type VARCHAR(100),
    byte_size BIGINT,
    compress_format VARCHAR(100),
    temporal_resolution_duration VARCHAR(50),
    status distribution_status DEFAULT 'Completed',
    access_service_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Data Services
CREATE TABLE data_services (
    service_id SERIAL PRIMARY KEY,
    resource_id INTEGER NOT NULL UNIQUE REFERENCES resources(resource_id) ON DELETE CASCADE,
    endpoint_url TEXT NOT NULL,
    endpoint_description_url TEXT,
    service_type VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add foreign key for distribution's access service
ALTER TABLE distributions 
ADD CONSTRAINT fk_access_service 
FOREIGN KEY (access_service_id) REFERENCES data_services(service_id) ON DELETE SET NULL;

-- Checksums (SPDX)
CREATE TABLE checksums (
    checksum_id SERIAL PRIMARY KEY,
    distribution_id INTEGER NOT NULL REFERENCES distributions(distribution_id) ON DELETE CASCADE,
    algorithm VARCHAR(50) NOT NULL, -- SHA256, SHA1, MD5, SHA512
    checksum_value TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(distribution_id, algorithm)
);

-- Catalog Records
CREATE TABLE catalog_records (
    record_id SERIAL PRIMARY KEY,
    iri TEXT NOT NULL UNIQUE,
    catalog_id INTEGER NOT NULL REFERENCES catalogs(catalog_id) ON DELETE CASCADE,
    resource_id INTEGER NOT NULL REFERENCES resources(resource_id) ON DELETE CASCADE,
    issued_date DATE NOT NULL,
    modified_date DATE NOT NULL,
    status record_status DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Version relationships
CREATE TABLE resource_versions (
    version_id SERIAL PRIMARY KEY,
    current_resource_id INTEGER NOT NULL REFERENCES resources(resource_id) ON DELETE CASCADE,
    previous_resource_id INTEGER REFERENCES resources(resource_id) ON DELETE SET NULL,
    replaces_resource_id INTEGER REFERENCES resources(resource_id) ON DELETE SET NULL,
    replaced_by_resource_id INTEGER REFERENCES resources(resource_id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Qualified Relations
CREATE TABLE qualified_relations (
    relation_id SERIAL PRIMARY KEY,
    source_resource_id INTEGER NOT NULL REFERENCES resources(resource_id) ON DELETE CASCADE,
    target_resource_id INTEGER NOT NULL REFERENCES resources(resource_id) ON DELETE CASCADE,
    relationship_type VARCHAR(100), -- derivedFrom, supplements, etc.
    relationship_iri TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(source_resource_id, target_resource_id, relationship_type)
);

-- Qualified Attribution
CREATE TABLE qualified_attributions (
    attribution_id SERIAL PRIMARY KEY,
    resource_id INTEGER NOT NULL REFERENCES resources(resource_id) ON DELETE CASCADE,
    agent_id INTEGER NOT NULL REFERENCES agents(agent_id) ON DELETE CASCADE,
    role_iri TEXT,
    role_label VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(resource_id, agent_id, role_iri)
);

-- ODRL Policies
CREATE TABLE odrl_policies (
    policy_id SERIAL PRIMARY KEY,
    resource_id INTEGER NOT NULL REFERENCES resources(resource_id) ON DELETE CASCADE,
    iri TEXT NOT NULL UNIQUE,
    policy_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Service conformance standards
CREATE TABLE service_conformance (
    conformance_id SERIAL PRIMARY KEY,
    service_id INTEGER NOT NULL REFERENCES data_services(service_id) ON DELETE CASCADE,
    standard_iri TEXT NOT NULL,
    standard_name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(service_id, standard_iri)
);

-- ============================================================================
-- 3. INDEXES
-- ============================================================================

CREATE INDEX idx_resources_iri ON resources(iri);
CREATE INDEX idx_resources_type ON resources(resource_type);
CREATE INDEX idx_resources_publisher ON resources(publisher_agent_id);
CREATE INDEX idx_resources_creator ON resources(creator_agent_id);
CREATE INDEX idx_resources_issued ON resources(issued_date);
CREATE INDEX idx_resources_modified ON resources(modified_date);

CREATE INDEX idx_datasets_resource ON datasets(resource_id);
CREATE INDEX idx_datasets_temporal ON datasets(temporal_start_date, temporal_end_date);
CREATE INDEX idx_datasets_spatial ON datasets(spatial_coverage_iri);

CREATE INDEX idx_distributions_dataset ON distributions(dataset_id);
CREATE INDEX idx_distributions_format ON distributions(format);
CREATE INDEX idx_distributions_status ON distributions(status);

CREATE INDEX idx_data_services_endpoint ON data_services(endpoint_url);

CREATE INDEX idx_catalog_records_catalog ON catalog_records(catalog_id);
CREATE INDEX idx_catalog_records_resource ON catalog_records(resource_id);

CREATE INDEX idx_themes_resource ON resource_themes(resource_id);
CREATE INDEX idx_themes_iri ON resource_themes(theme_iri);

CREATE INDEX idx_qualified_relations_source ON qualified_relations(source_resource_id);
CREATE INDEX idx_qualified_relations_target ON qualified_relations(target_resource_id);

CREATE INDEX idx_attributions_resource ON qualified_attributions(resource_id);
CREATE INDEX idx_attributions_agent ON qualified_attributions(agent_id);

-- ============================================================================
-- 4. VIEWS
-- ============================================================================

-- Complete resource information view
CREATE VIEW v_resources_complete AS
SELECT 
    r.resource_id,
    r.iri,
    r.resource_type,
    r.title,
    r.description,
    r.identifier,
    r.version,
    a_creator.name AS creator_name,
    a_publisher.name AS publisher_name,
    r.issued_date,
    r.modified_date,
    r.license_iri,
    r.access_rights_iri,
    COUNT(DISTINCT rt.theme_iri) AS theme_count,
    COUNT(DISTINCT rk.keyword) AS keyword_count,
    r.created_at,
    r.updated_at
FROM resources r
LEFT JOIN agents a_creator ON r.creator_agent_id = a_creator.agent_id
LEFT JOIN agents a_publisher ON r.publisher_agent_id = a_publisher.agent_id
LEFT JOIN resource_themes rt ON r.resource_id = rt.resource_id
LEFT JOIN resource_keywords rk ON r.resource_id = rk.resource_id
GROUP BY r.resource_id, a_creator.agent_id, a_publisher.agent_id;

-- Datasets with related information
CREATE VIEW v_datasets_with_metadata AS
SELECT 
    d.dataset_id,
    r.resource_id,
    r.iri,
    r.title,
    r.description,
    d.accrual_periodicity,
    d.temporal_start_date,
    d.temporal_end_date,
    d.spatial_coverage_iri,
    d.spatial_resolution_meters,
    d.temporal_resolution_duration,
    COUNT(DISTINCT dist.distribution_id) AS distribution_count,
    COUNT(DISTINCT sm.series_id) AS series_count,
    a_publisher.name AS publisher_name,
    r.modified_date
FROM datasets d
JOIN resources r ON d.resource_id = r.resource_id
LEFT JOIN distributions dist ON d.dataset_id = dist.dataset_id
LEFT JOIN series_members sm ON d.dataset_id = sm.dataset_id
LEFT JOIN agents a_publisher ON r.publisher_agent_id = a_publisher.agent_id
GROUP BY d.dataset_id, r.resource_id, a_publisher.agent_id;

-- Distribution details
CREATE VIEW v_distributions_full AS
SELECT 
    dist.distribution_id,
    r.iri AS distribution_iri,
    r.title AS distribution_title,
    dist.dataset_id,
    d_r.iri AS dataset_iri,
    d_r.title AS dataset_title,
    dist.access_url,
    dist.download_url,
    dist.format,
    dist.media_type,
    dist.byte_size,
    dist.status,
    svc.service_id,
    svc_r.title AS service_title,
    COUNT(DISTINCT c.checksum_id) AS checksum_count,
    dist.created_at,
    dist.updated_at
FROM distributions dist
JOIN resources r ON dist.resource_id = r.resource_id
JOIN datasets d ON dist.dataset_id = d.dataset_id
JOIN resources d_r ON d.resource_id = d_r.resource_id
LEFT JOIN data_services svc ON dist.access_service_id = svc.service_id
LEFT JOIN resources svc_r ON svc.resource_id = svc_r.resource_id
LEFT JOIN checksums c ON dist.distribution_id = c.distribution_id
GROUP BY dist.distribution_id, r.resource_id, d.dataset_id, 
         d_r.resource_id, svc.service_id, svc_r.resource_id;

-- Catalog overview
CREATE VIEW v_catalogs_overview AS
SELECT 
    c.catalog_id,
    r.iri,
    r.title,
    r.description,
    c.homepage_url,
    c.theme_taxonomy_iri,
    COUNT(DISTINCT cd.dataset_id) AS dataset_count,
    COUNT(DISTINCT svc.service_id) AS service_count,
    COUNT(DISTINCT cr.record_id) AS record_count,
    r.modified_date,
    r.created_at
FROM catalogs c
JOIN resources r ON c.resource_id = r.resource_id
LEFT JOIN catalog_datasets cd ON c.catalog_id = cd.catalog_id
LEFT JOIN data_services svc ON svc.service_id IN (
    SELECT service_id FROM data_services
)
LEFT JOIN catalog_records cr ON c.catalog_id = cr.catalog_id
GROUP BY c.catalog_id, r.resource_id;

-- Version lineage view
CREATE VIEW v_version_lineage AS
WITH RECURSIVE version_chain AS (
    -- Base case: current versions
    SELECT 
        rv.version_id,
        rv.current_resource_id,
        rv.previous_resource_id,
        1 AS depth,
        ARRAY[rv.current_resource_id] AS chain
    FROM resource_versions rv
    
    UNION ALL
    
    -- Recursive case: previous versions
    SELECT 
        vc.version_id,
        vc.current_resource_id,
        rv.previous_resource_id,
        vc.depth + 1,
        array_prepend(rv.previous_resource_id, vc.chain)
    FROM version_chain vc
    JOIN resource_versions rv ON vc.previous_resource_id = rv.current_resource_id
    WHERE vc.depth < 100
)
SELECT 
    vc.version_id,
    vc.current_resource_id,
    r_current.title AS current_version_title,
    r_current.version AS current_version_number,
    vc.chain,
    vc.depth,
    r_current.modified_date
FROM version_chain vc
JOIN resources r_current ON vc.current_resource_id = r_current.resource_id;

-- ============================================================================
-- 5. MASTER STORED PROCEDURE FOR MANAGING RESOURCES
-- ============================================================================

CREATE OR REPLACE FUNCTION upsert_resource(
    p_iri TEXT,
    p_resource_type resource_type,
    p_title VARCHAR(500),
    p_description TEXT DEFAULT NULL,
    p_identifier VARCHAR(255) DEFAULT NULL,
    p_creator_iri TEXT DEFAULT NULL,
    p_publisher_iri TEXT DEFAULT NULL,
    p_issued_date DATE DEFAULT NULL,
    p_modified_date DATE DEFAULT NULL,
    p_language VARCHAR(5) DEFAULT NULL,
    p_access_rights_iri TEXT DEFAULT NULL,
    p_license_iri TEXT DEFAULT NULL,
    p_rights_statement TEXT DEFAULT NULL,
    p_contact_point_iri TEXT DEFAULT NULL,
    p_conformance_standard_iri TEXT DEFAULT NULL,
    p_version VARCHAR(50) DEFAULT NULL,
    OUT p_resource_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_creator_agent_id INTEGER;
    v_publisher_agent_id INTEGER;
    v_contact_point_agent_id INTEGER;
    v_existing_resource_id INTEGER;
BEGIN
    -- Get or create creator agent
    IF p_creator_iri IS NOT NULL THEN
        SELECT agent_id INTO v_creator_agent_id 
        FROM agents 
        WHERE iri = p_creator_iri;
        
        IF v_creator_agent_id IS NULL THEN
            INSERT INTO agents (iri, name, agent_type)
            VALUES (p_creator_iri, p_creator_iri, NULL)
            RETURNING agent_id INTO v_creator_agent_id;
        END IF;
    END IF;

    -- Get or create publisher agent
    IF p_publisher_iri IS NOT NULL THEN
        SELECT agent_id INTO v_publisher_agent_id 
        FROM agents 
        WHERE iri = p_publisher_iri;
        
        IF v_publisher_agent_id IS NULL THEN
            INSERT INTO agents (iri, name, agent_type)
            VALUES (p_publisher_iri, p_publisher_iri, NULL)
            RETURNING agent_id INTO v_publisher_agent_id;
        END IF;
    END IF;

    -- Get or create contact point agent
    IF p_contact_point_iri IS NOT NULL THEN
        SELECT agent_id INTO v_contact_point_agent_id 
        FROM agents 
        WHERE iri = p_contact_point_iri;
        
        IF v_contact_point_agent_id IS NULL THEN
            INSERT INTO agents (iri, name, agent_type)
            VALUES (p_contact_point_iri, p_contact_point_iri, NULL)
            RETURNING agent_id INTO v_contact_point_agent_id;
        END IF;
    END IF;

    -- Check if resource exists
    SELECT resource_id INTO v_existing_resource_id 
    FROM resources 
    WHERE iri = p_iri;

    IF v_existing_resource_id IS NOT NULL THEN
        -- Update existing resource
        UPDATE resources
        SET 
            title = COALESCE(p_title, title),
            description = COALESCE(p_description, description),
            identifier = COALESCE(p_identifier, identifier),
            creator_agent_id = COALESCE(v_creator_agent_id, creator_agent_id),
            publisher_agent_id = COALESCE(v_publisher_agent_id, publisher_agent_id),
            issued_date = COALESCE(p_issued_date, issued_date),
            modified_date = COALESCE(p_modified_date, CURRENT_DATE),
            language = COALESCE(p_language, language),
            access_rights_iri = COALESCE(p_access_rights_iri, access_rights_iri),
            license_iri = COALESCE(p_license_iri, license_iri),
            rights_statement = COALESCE(p_rights_statement, rights_statement),
            contact_point_agent_id = COALESCE(v_contact_point_agent_id, contact_point_agent_id),
            conformance_standard_iri = COALESCE(p_conformance_standard_iri, conformance_standard_iri),
            version = COALESCE(p_version, version),
            updated_at = CURRENT_TIMESTAMP
        WHERE resource_id = v_existing_resource_id;
        
        p_resource_id := v_existing_resource_id;
    ELSE
        -- Insert new resource
        INSERT INTO resources (
            iri, resource_type, title, description, identifier,
            creator_agent_id, publisher_agent_id, issued_date, modified_date,
            language, access_rights_iri, license_iri, rights_statement,
            contact_point_agent_id, conformance_standard_iri, version
        ) VALUES (
            p_iri, p_resource_type, p_title, p_description, p_identifier,
            v_creator_agent_id, v_publisher_agent_id, p_issued_date, 
            COALESCE(p_modified_date, CURRENT_DATE),
            p_language, p_access_rights_iri, p_license_iri, p_rights_statement,
            v_contact_point_agent_id, p_conformance_standard_iri, p_version
        )
        RETURNING resource_id INTO p_resource_id;
    END IF;
    
    RAISE NOTICE 'Resource upserted: ID=%, IRI=%', p_resource_id, p_iri;
END;
$$;

-- ============================================================================
-- 6. DATASET MANAGEMENT PROCEDURES
-- ============================================================================

CREATE OR REPLACE FUNCTION upsert_dataset(
    p_dataset_iri TEXT,
    p_title VARCHAR(500),
    p_description TEXT DEFAULT NULL,
    p_identifier VARCHAR(255) DEFAULT NULL,
    p_publisher_iri TEXT DEFAULT NULL,
    p_accrual_periodicity frequency_type DEFAULT NULL,
    p_temporal_start_date DATE DEFAULT NULL,
    p_temporal_end_date DATE DEFAULT NULL,
    p_spatial_coverage_iri TEXT DEFAULT NULL,
    p_spatial_resolution_meters NUMERIC(10, 2) DEFAULT NULL,
    p_temporal_resolution_duration VARCHAR(50) DEFAULT NULL,
    p_language VARCHAR(5) DEFAULT NULL,
    p_license_iri TEXT DEFAULT NULL,
    OUT p_dataset_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_resource_id INTEGER;
BEGIN
    -- Upsert resource
    SELECT * INTO v_resource_id FROM upsert_resource(
        p_dataset_iri,
        'Dataset'::resource_type,
        p_title,
        p_description,
        p_identifier,
        NULL, -- creator
        p_publisher_iri,
        CURRENT_DATE,
        CURRENT_DATE,
        p_language,
        NULL, -- access_rights
        p_license_iri,
        NULL, -- rights_statement
        NULL, -- contact_point
        NULL, -- conformance_standard
        NULL  -- version
    );

    -- Insert or update dataset-specific data
    INSERT INTO datasets (
        resource_id, accrual_periodicity, temporal_start_date,
        temporal_end_date, spatial_coverage_iri, spatial_resolution_meters,
        temporal_resolution_duration
    ) VALUES (
        v_resource_id, p_accrual_periodicity, p_temporal_start_date,
        p_temporal_end_date, p_spatial_coverage_iri, p_spatial_resolution_meters,
        p_temporal_resolution_duration
    )
    ON CONFLICT (resource_id) DO UPDATE SET
        accrual_periodicity = COALESCE(p_accrual_periodicity, datasets.accrual_periodicity),
        temporal_start_date = COALESCE(p_temporal_start_date, datasets.temporal_start_date),
        temporal_end_date = COALESCE(p_temporal_end_date, datasets.temporal_end_date),
        spatial_coverage_iri = COALESCE(p_spatial_coverage_iri, datasets.spatial_coverage_iri),
        spatial_resolution_meters = COALESCE(p_spatial_resolution_meters, datasets.spatial_resolution_meters),
        temporal_resolution_duration = COALESCE(p_temporal_resolution_duration, datasets.temporal_resolution_duration),
        updated_at = CURRENT_TIMESTAMP
    RETURNING dataset_id INTO p_dataset_id;

    RAISE NOTICE 'Dataset upserted: ID=%, IRI=%', p_dataset_id, p_dataset_iri;
END;
$$;

-- ============================================================================
-- 7. DISTRIBUTION MANAGEMENT PROCEDURES
-- ============================================================================

CREATE OR REPLACE FUNCTION upsert_distribution(
    p_distribution_iri TEXT,
    p_dataset_id INTEGER,
    p_title VARCHAR(500) DEFAULT NULL,
    p_access_url TEXT DEFAULT NULL,
    p_download_url TEXT DEFAULT NULL,
    p_format VARCHAR(100) DEFAULT NULL,
    p_media_type VARCHAR(100) DEFAULT NULL,
    p_byte_size BIGINT DEFAULT NULL,
    p_checksum_algorithm VARCHAR(50) DEFAULT NULL,
    p_checksum_value TEXT DEFAULT NULL,
    p_status distribution_status DEFAULT 'Completed',
    OUT p_distribution_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_resource_id INTEGER;
    v_existing_distribution_id INTEGER;
BEGIN
    -- Upsert resource
    SELECT * INTO v_resource_id FROM upsert_resource(
        p_distribution_iri,
        'Distribution'::resource_type,
        COALESCE(p_title, 'Distribution'),
        NULL,
        NULL,
        NULL,
        NULL,
        CURRENT_DATE,
        CURRENT_DATE,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL
    );

    -- Insert or update distribution-specific data
    INSERT INTO distributions (
        resource_id, dataset_id, access_url, download_url,
        format, media_type, byte_size, status
    ) VALUES (
        v_resource_id, p_dataset_id, p_access_url, p_download_url,
        p_format, p_media_type, p_byte_size, p_status
    )
    ON CONFLICT (resource_id) DO UPDATE SET
        access_url = COALESCE(p_access_url, distributions.access_url),
        download_url = COALESCE(p_download_url, distributions.download_url),
        format = COALESCE(p_format, distributions.format),
        media_type = COALESCE(p_media_type, distributions.media_type),
        byte_size = COALESCE(p_byte_size, distributions.byte_size),
        status = COALESCE(p_status, distributions.status),
        updated_at = CURRENT_TIMESTAMP
    RETURNING distribution_id INTO p_distribution_id;

    -- Insert checksum if provided
    IF p_checksum_algorithm IS NOT NULL AND p_checksum_value IS NOT NULL THEN
        INSERT INTO checksums (distribution_id, algorithm, checksum_value)
        VALUES (p_distribution_id, p_checksum_algorithm, p_checksum_value)
        ON CONFLICT (distribution_id, algorithm) DO UPDATE SET
            checksum_value = p_checksum_value;
    END IF;

    RAISE NOTICE 'Distribution upserted: ID=%, IRI=%', p_distribution_id, p_distribution_iri;
END;
$$;

-- ============================================================================
-- 8. QUERY AND SEARCH PROCEDURES
-- ============================================================================

CREATE OR REPLACE FUNCTION search_datasets(
    p_search_term TEXT DEFAULT NULL,
    p_publisher_name TEXT DEFAULT NULL,
    p_theme_iri TEXT DEFAULT NULL,
    p_format VARCHAR(100) DEFAULT NULL,
    p_limit INTEGER DEFAULT 100
)
RETURNS TABLE (
    dataset_id INTEGER,
    dataset_iri TEXT,
    title VARCHAR(500),
    description TEXT,
    publisher_name VARCHAR(500),
    distribution_count INTEGER,
    theme_count INTEGER,
    modified_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        d.dataset_id,
        r.iri,
        r.title,
        r.description,
        ap.name,
        COALESCE(COUNT(DISTINCT dist.distribution_id), 0)::INTEGER,
        COALESCE(COUNT(DISTINCT rt.theme_iri), 0)::INTEGER,
        r.modified_date
    FROM datasets d
    JOIN resources r ON d.resource_id = r.resource_id
    LEFT JOIN agents ap ON r.publisher_agent_id = ap.agent_id
    LEFT JOIN distributions dist ON d.dataset_id = dist.dataset_id
    LEFT JOIN resource_themes rt ON r.resource_id = rt.resource_id
    WHERE 
        (p_search_term IS NULL OR 
         r.title ILIKE '%' || p_search_term || '%' OR
         r.description ILIKE '%' || p_search_term || '%')
        AND (p_publisher_name IS NULL OR ap.name ILIKE '%' || p_publisher_name || '%')
        AND (p_theme_iri IS NULL OR rt.theme_iri = p_theme_iri)
        AND (p_format IS NULL OR dist.format ILIKE '%' || p_format || '%')
    GROUP BY d.dataset_id, r.resource_id, ap.agent_id
    ORDER BY r.modified_date DESC
    LIMIT p_limit;
END;
$$;

-- ============================================================================
-- 9. AUDIT AND LOGGING
-- ============================================================================

CREATE TABLE audit_log (
    log_id SERIAL PRIMARY KEY,
    table_name VARCHAR(50),
    operation VARCHAR(10), -- INSERT, UPDATE, DELETE
    resource_id INTEGER,
    old_values JSONB,
    new_values JSONB,
    changed_by VARCHAR(255),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_audit()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO audit_log (
        table_name, operation, resource_id,
        old_values, new_values, changed_by, changed_at
    ) VALUES (
        TG_TABLE_NAME,
        TG_OP,
        CASE WHEN TG_OP = 'DELETE' THEN OLD.resource_id ELSE NEW.resource_id END,
        CASE WHEN TG_OP = 'DELETE' OR TG_OP = 'UPDATE' THEN row_to_json(OLD) ELSE NULL END,
        CASE WHEN TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN row_to_json(NEW) ELSE NULL END,
        CURRENT_USER,
        CURRENT_TIMESTAMP
    );
    RETURN CASE WHEN TG_OP = 'DELETE' THEN OLD ELSE NEW END;
END;
$$;

-- Create audit trigger for resources table
CREATE TRIGGER resources_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON resources
FOR EACH ROW EXECUTE FUNCTION log_audit();

-- ============================================================================
-- 10. EXAMPLE DATA LOADING
-- ============================================================================

-- This section demonstrates how to load DCAT data using the procedures

/*
-- Create a catalog
SELECT upsert_resource(
    'https://example.org/catalog/main',
    'Catalog'::resource_type,
    'Example Data Catalog',
    'A comprehensive data catalog',
    'CATALOG-001',
    NULL,
    'https://example.org/organization',
    '2024-01-01'::DATE,
    CURRENT_DATE,
    'en'
);

-- Create a dataset
SELECT upsert_dataset(
    'https://example.org/dataset/sales-2024',
    'Sales Data 2024',
    'Annual sales data for 2024',
    'SALES-2024-001',
    'https://example.org/organization',
    'monthly'::frequency_type,
    '2024-01-01'::DATE,
    '2024-12-31'::DATE,
    'https://sws.geonames.org/2988507/', -- USA
    NULL,
    'P1D'::VARCHAR
);

-- Create a distribution
SELECT upsert_distribution(
    'https://example.org/dist/sales-2024-csv',
    (SELECT dataset_id FROM datasets LIMIT 1),
    'CSV Format',
    'https://example.org/download/sales-2024',
    'https://example.org/download/sales-2024.csv',
    'CSV',
    'text/csv',
    5242880,
    'SHA256',
    'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
    'Completed'::distribution_status
);

-- Search for datasets
SELECT * FROM search_datasets(p_search_term := 'sales');
*/

-- ============================================================================
-- END OF SCHEMA DEFINITION
-- ============================================================================
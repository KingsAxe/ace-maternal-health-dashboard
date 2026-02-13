cat > sql/03_grants_and_roles_notes.sql <<'EOF'
-- Notes: Marketplace/shared databases are READ-ONLY in Snowflake.
-- You cannot CREATE VIEW/TABLE inside the shared DB (e.g., OBG_DB).
-- Workaround: Create objects in your own DB (e.g., ANALYTICS_DB)
-- and reference the shared DB as the source.

-- If you use a non-accountadmin role, ensure it has:
-- - USAGE on warehouse
-- - USAGE on ANALYTICS_DB and schema
-- - CREATE VIEW on ANALYTICS_DB.OBG
-- - SELECT on OBG_DB.PUBLIC.OBSTETRICS_AND_GYNECOLOGY_DATASET

-- Example (adjust role name):
-- GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE YOUR_ROLE;
-- GRANT USAGE ON DATABASE ANALYTICS_DB TO ROLE YOUR_ROLE;
-- GRANT USAGE ON SCHEMA ANALYTICS_DB.OBG TO ROLE YOUR_ROLE;
-- GRANT CREATE VIEW ON SCHEMA ANALYTICS_DB.OBG TO ROLE YOUR_ROLE;
-- GRANT SELECT ON TABLE OBG_DB.PUBLIC.OBSTETRICS_AND_GYNECOLOGY_DATASET TO ROLE YOUR_ROLE;
EOF

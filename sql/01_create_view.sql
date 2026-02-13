cat > sql/01_create_view.sql <<'EOF'
-- ACE Maternal Health Dashboard
-- Curated extract view (writeable DB/schema, not the marketplace shared DB)
-- Target: ANALYTICS_DB.OBG.VW_OBGYN_EXTRACTED

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;

-- Ensure you're writing to your own database + schema (not shared OBG_DB)
CREATE DATABASE IF NOT EXISTS ANALYTICS_DB;
CREATE SCHEMA IF NOT EXISTS ANALYTICS_DB.OBG;

-- Create/replace the view (reads from the marketplace table, writes to your DB)
CREATE OR REPLACE VIEW ANALYTICS_DB.OBG.VW_OBGYN_EXTRACTED AS
SELECT
  FILEID,
  DOCUMENTTYPE,
  COALESCE(NULLIF(TRIM(REPORTTYPE), ''), 'unknown') AS REPORTTYPE,
  COALESCE(NULLIF(TRIM(PATIENTCLASS), ''), 'Unknown') AS PATIENTCLASS,
  WORDCOUNT,

  -- Extract age when pattern appears like "31-year-old"
  TRY_TO_NUMBER(REGEXP_SUBSTR(DICTATIONNOTE, '(\\d{1,3})-year-old', 1, 1, 'e', 1)) AS EXTRACTED_AGE,

  -- Flags (note: in your sample these may be mostly 0, that's OK)
  IFF(REGEXP_LIKE(LOWER(DICTATIONNOTE), '\\bpregnan|\\bgestation|\\bgravida|\\bpara\\b'), 1, 0) AS IS_PREGNANCY_RELATED,
  IFF(REGEXP_LIKE(LOWER(DICTATIONNOTE), 'c-section|cesarean'), 1, 0) AS HAS_C_SECTION,
  IFF(REGEXP_LIKE(LOWER(DICTATIONNOTE), 'hysteroscop'), 1, 0) AS HAS_HYSTEROSCOPY,
  IFF(REGEXP_LIKE(LOWER(DICTATIONNOTE), 'd\\s*&\\s*c|dilation and curettage'), 1, 0) AS HAS_DC,
  IFF(REGEXP_LIKE(LOWER(DICTATIONNOTE), 'preeclampsia|eclampsia'), 1, 0) AS HAS_PREECLAMPSIA,
  IFF(REGEXP_LIKE(LOWER(DICTATIONNOTE), 'hemorrhage|bleeding'), 1, 0) AS HAS_BLEEDING,
  IFF(REGEXP_LIKE(LOWER(DICTATIONNOTE), 'miscarriage|fetal heartbeat is not detected'), 1, 0) AS HAS_MISCARRIAGE_SIGNAL,
  IFF(REGEXP_LIKE(LOWER(DICTATIONNOTE), 'transfer to a tertiary care center|transfer to a tertiary'), 1, 0) AS NEEDS_TERTIARY_TRANSFER,
  IFF(REGEXP_LIKE(LOWER(DICTATIONNOTE), 'no complications'), 1, 0) AS MENTIONS_NO_COMPLICATIONS

FROM OBG_DB.PUBLIC.OBSTETRICS_AND_GYNECOLOGY_DATASET;
EOF

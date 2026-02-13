cat > README.md <<'EOF'
# Maternal Care Monitoring Dashboard (Power BI + Snowflake)

This project demonstrates an end-to-end analytics workflow using **Snowflake (data source + SQL curation)** and **Power BI (data cleaning, DAX measures, interactive dashboard)**.

It is designed for a public health / MERL context where stakeholders need visibility into:
- service mix and care setting patterns
- demographic coverage (age bands)
- **data completeness** (e.g., missing age)

---

## Problem this dashboard aims to solve

Program teams often lack a fast, consistent way to inspect:
1) what kinds of maternal care records are being produced (document mix),
2) where care is happening (patient class mix: inpatient/outpatient/ambulatory),
3) whether demographic data is sufficiently captured to support equity analysis.

This dashboard provides an interactive snapshot to support monitoring, targeting discussions, and data quality improvement.

---

## Data Source

- **Snowflake Marketplace** dataset:
  **Comprehensive Obstetrics and Gynecology Medical Records Dataset**
- Source table (shared/read-only):
  `OBG_DB.PUBLIC.OBSTETRICS_AND_GYNECOLOGY_DATASET`

 Marketplace/shared databases are **read-only**, so curated objects must be created in your own database.

---

## What’s in this repo


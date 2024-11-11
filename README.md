# README 

## Overview
This Mini project  uses a research publication dataset to build a data pipeline. This involves database schema design, data transformation, analysis, and visualization.

## Objectives
- **Setup PostgreSQL**
- **Design ER Diagram and Schema**
- **Load and Transform Data**
- **Analyze Data with SQL**
- **Visualize Data**

## Project Files
- `createPubSchema.sql`: PubSchema creation script
- `createRawSchema.sql`: Raw data loading script
- `transform.sql`: Data transformation script
- `solution-raw.sql`: Initial analysis queries
- `solution-analysis.sql`: Advanced analysis queries
- `vis.sql`: Visualization queries
- `vis.pdf`: Visualization plots
- `ER.pdf`: ER diagram
- `wrapper.py`: Python script for `dblp.xml`

## Setup
1. **Install PostgreSQL**: [Download](http://www.postgresql.org/download/).
2. **Verify Installation**:
   ```bash
   createdb dblp
   psql dblp
   ```

## Usage
1. **Prepare Data**:
   ```bash
   python wrapper.py
   ```
2. **Load Data**:
   ```bash
   psql -f createRawSchema.sql dblp
   ```
3. **Transform Data**:
   ```bash
   psql -f transform.sql dblp
   ```
4. **Run Analysis**:
   Execute `solution-analysis.sql`.
5. **Visualize**:
   Use `vis.sql` and generate plots.

## Notes
- Use Python 2.7 for `wrapper.py`.
- Manage database constraints post data load.

---


# Methodology

## Unit of analysis and scope

The main table contains one row per source `job_id`. IDs are unique in this snapshot, but job URLs can repeat. Counts refer to source records and do not establish the number of unique vacancies or hires. The dataset covers six role categories and a limited set of search cities. It is not a representative census of all Indian technology employment.

The source is a 10 June 2025 snapshot. The project cannot measure hiring growth over time or identify vacancies still open today.

## Verified report structure

The imported business tables are:

| Table | Rows | Columns | Meaning |
| --- | ---: | ---: | --- |
| `indian_tech_jobs_2026` | 23,201 | 31 | Source job records after report transformations |
| `Job Skills Cleaned` | 176,390 | 5 | Cleaned skills linked to 22,657 job IDs |

Power BI also stores two automatic date tables. They are not additional job data.

Relationship: `indian_tech_jobs_2026[job_id]` (one) to `Job Skills Cleaned[Job postings]` (many), active, single-direction filtering from jobs to skills. Selecting a role filters its skill rows. Selecting a skill does not filter the parent job table through this relationship.

## Power Query transformations

### Main jobs table

1. Read the 32-column UTF-8 CSV and promote headers.
2. Assign text, numeric, boolean, and date types.
3. Apply proper case to `job_title`.
4. Remove `location` and `posted_date_raw` from the model.
5. Add `Experience Tier Sort`: Fresher = 1, Junior = 2, Mid = 3, Senior = 4, Lead/Architect = 5, unmatched = 99.

The main query does **not** remove duplicate job IDs/URLs or correct inverted experience ranges. Salary midpoint, experience tier, fresher-friendly flag, work mode, and company size already exist in the CSV.

### Skills table

The query reads the same CSV, retains job IDs and skill text, splits comma-separated skills into rows, trims/cleans text, applies proper case, removes `Not Available`, removes duplicate job–skill pairs, and normalizes selected names. `job_id` is renamed to `Job postings`.

It adds a rule-based `Skill type` classification and an `Actionable skills` mapping for selected learnable tools. SQL variants are grouped as SQL; Power BI, Excel, R, Spark, cloud, and other tool aliases are mapped to canonical labels. Unmapped skills produce blank actionable labels, which the skill chart filters out.

`Core skills` groups SQL, Excel, Power BI, Python, Pandas, and NumPy as Core. Selected other mapped tools are Additional. These are project-specific labels and do not assert universal prerequisites. The current skill chart uses actionable labels without restricting to Core.

## Measures

All **15 explicit measures** are transcribed in [measures.dax](../model/measures.dax).

| Measure | Definition |
| --- | --- |
| Job Postings orig | Distinct count of main-table `job_id` |
| Fresher Openings | Distinct job IDs where `is_fresher_friendly` is true |
| Fresher Friendly % | Count of fresher-friendly IDs divided by all IDs in context, removing the fresher flag filter from the denominator |
| Average / Median Salary (LPA) | Average / median of `salary_midpoint_lpa`, restricted to `salary_disclosed = TRUE` |
| Average / Median Minimum Experience | Average / median of `experience_min_yrs` |
| Skill Job Count / Skill Type Job Count / Actionable Skill Job Count | Distinct job IDs in the skills table under the current filters |

The salary measures exclude the 20,433 undisclosed zero values. Two records marked disclosed also have zero salary and remain included. Salary midpoint is a range summary, not an observed salary paid to a worker. The 11.9% disclosure rate limits comparability.

## Career Accessibility Score

For a role, under the remaining report filters:

```text
Fresher Friendly Score = 100 × Fresher Friendly %

Demand Score = 100 × (role posting count − minimum role posting count)
                    / (maximum role posting count − minimum role posting count)

Experience Accessibility Score =
    100 × (maximum role average minimum experience − role average minimum experience)
        / (maximum role average minimum experience − minimum role average minimum experience)

Career Accessibility Score =
    0.40 × Fresher Friendly Score
  + 0.35 × Experience Accessibility Score
  + 0.25 × Demand Score
```

The underlying DAX uses `ALL(role_category)` for the normalization population: it removes role-category filtering while preserving other relevant filters. This is a relative comparison across roles in the current context. The 40/35/25 weights are design choices and are not trained or statistically validated hiring probabilities.

`DIVIDE` returns blank if a normalization denominator is zero. DAX arithmetic can then treat blank components as zero in the weighted sum. Interpret the score at a single-role grain; a card with all roles selected would not represent a valid role-level score. Both saved slicers enforce a single selection.

## Snapshot benchmark

The independent Python calculation uses all source rows with one result per role and no extra filters:

| Role | Postings | Fresher-friendly | Disclosed salaries | Median salary (LPA) | Accessibility score |
| --- | --- | --- | --- | --- | --- |
| Data Analyst | 4,729 | 27.2% | 640 | 9.5 | 62.02 |
| Data Scientist | 6,455 | 13.6% | 757 | 17.5 | 38.10 |
| Business Analyst | 4,505 | 17.8% | 460 | 13.5 | 37.95 |
| Machine Learning Engineer | 4,004 | 19.8% | 473 | 14.0 | 31.96 |
| Python Developer | 1,586 | 13.8% | 222 | 15.0 | 22.95 |
| Data Engineer | 1,922 | 10.3% | 216 | 17.0 | 5.85 |

The Data Analyst benchmark is 4,729 postings, 1,287 fresher-friendly records, 3.307 years average minimum experience, 10.625 LPA average disclosed salary, and a 62.024 score. These values provide a useful check after refreshing the report.

## Geographic interpretation

The report's city axes use `scraped_city`, the collection/search city. This differs from `primary_city`, the parsed posting location. The profile city chart excludes `primary_city = Remote`, then takes the top 10 `scraped_city` groups; the overview work-mode chart excludes `scraped_city = Remote`. Consequently, their city populations differ. Use the visible chart context and field definitions before comparing them.

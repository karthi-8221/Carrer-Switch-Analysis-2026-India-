# Data dictionary

The 32 source fields below describe the supplied CSV. Descriptions are based on the data, column names, and inspected report usage; upstream enrichment methods are not assumed where undocumented. LPA is lakh rupees per annum (1 lakh = 100,000 rupees).

| Field | Logical type | Meaning |
| --- | --- | --- |
| `job_id` | Number | Source record identifier; unique in this snapshot, not a deduplicated vacancy ID. |
| `job_title` | Text | Job title from the source. The report applies proper case. |
| `company_name` | Text | Employer name in the source. |
| `company_rating` | Number | Source company rating; methodology is not independently verified. |
| `location` | Text | Raw location string; removed from the imported main table. |
| `scraped_city` | Text | City used for collection/search. Used on the dashboard city axes. |
| `role_category` | Text | One of the six role categories used by the slicers and comparisons. |
| `experience_raw` | Text | Original experience-range text. |
| `experience_min_yrs` | Number | Parsed minimum experience in years. Used in experience and accessibility metrics. |
| `experience_max_yrs` | Number | Parsed maximum experience in years; 90 ranges are inverted. |
| `salary_raw` | Text | Original salary text, including disclosure labels. |
| `salary_min_lpa` | Number | Minimum advertised annual salary in lakh rupees; zero can represent undisclosed. |
| `salary_max_lpa` | Number | Maximum advertised annual salary in lakh rupees; zero can represent undisclosed. |
| `salary_disclosed` | Boolean | Source boolean used by the report to include records in salary metrics. |
| `skills_required` | Text | Comma-separated source skill labels; expanded to the skills table. |
| `skills_count` | Number | Skill count supplied by the source, before report cleaning and deduplication. |
| `job_description` | Text | Source description text, often abbreviated. |
| `posted_date_raw` | Text | Relative posting-age text; removed from the imported main table. |
| `work_mode` | Text | Source work arrangement category: On-site, Hybrid, or Remote. |
| `company_size_bucket` | Text | Source employer-size category; not recalculated in the report. |
| `job_url` | Text | Source posting URL; 53 N/A markers and 2,078 repeated nonmissing URLs beyond first occurrence. |
| `data_source` | Text | Named upstream portal; all rows contain naukri.com. |
| `scraped_at` | Date | Source scrape date; all rows contain 2025-06-10. |
| `salary_tier` | Text | Salary band supplied by the dataset. |
| `experience_tier` | Text | Experience band supplied by the dataset; report adds a numeric sort key. |
| `is_senior` | Boolean | Source seniority flag; threshold was not recreated or verified. |
| `primary_city` | Text | Parsed posting location; distinct from collection city and includes localities/Remote. |
| `skill_domain` | Text | Source classification of skill domain; not rebuilt in this report. |
| `salary_midpoint_lpa` | Number | Arithmetic midpoint of minimum and maximum salary, in LPA. |
| `days_since_posted` | Number | Source estimate of posting age in days; not proof a job is still open. |
| `is_fresher_friendly` | Boolean | Source boolean. In this file it agrees exactly with minimum experience <= 1 year. |
| `salary_negotiable` | Boolean | Source boolean indicating negotiability; not used in salary filtering. |

## Fields created in the report

| Table / field | Meaning |
| --- | --- |
| Jobs / Experience Tier Sort | Ordered key for experience tiers; fallback 99 |
| Job Skills Cleaned / Job postings | Original job_id, repeated across skill rows |
| Job Skills Cleaned / Skills | Cleaned skill label |
| Job Skills Cleaned / Skill type | Rule-based category |
| Job Skills Cleaned / Actionable skills | Canonical selected tool label; blank for unmapped skills |
| Job Skills Cleaned / Core skills | Core, Additional, or blank based on the selected tool list |

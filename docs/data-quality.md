# Data and report validation

Checked against the supplied CSV and the saved PBIX model on **3 October 2026**.

## Dataset checks

| Check | Result |
| --- | --- |
| Source rows | 23201 |
| Source columns | 32 |
| Duplicate full rows | 0 |
| Duplicate job IDs | 0 |
| Missing job URLs (N/A markers) | 53 |
| Repeated nonmissing URLs beyond first occurrence | 2078 |
| Reversed experience ranges | 90 |
| Reversed salary ranges | 0 |
| Salary midpoint inconsistencies (>0.011 LPA) | 0 |
| Undisclosed zero salary midpoints | 20433 |
| Disclosed zero salary midpoints | 2 |

The source uses the text `N/A` for 53 missing job URLs. Empty cells and `N/A` markers are treated as missing by the audit script. The remaining 23,148 URL-bearing rows contain 21,070 distinct URLs.

### Material limitations

- **Repeated URLs:** `job_id` is unique but does not establish a unique vacancy. The 2,078 repeated URLs may reflect repeat collection or overlapping searches. A deduplication policy needs to define which role, city, and salary record to retain before changing the data.
- **Experience ranges:** 90 records have minimum experience greater than maximum experience. The report uses the source minimum as supplied. Corrections could change experience metrics and accessibility scores.
- **Salary coverage:** only 2,768 records (11.93%) disclose a salary. The salary measures correctly filter on disclosure; 2 zero midpoints marked disclosed remain in their inputs.
- **Dates:** every row carries 10 June 2025 as the scrape date. The filename's 2026 label does not establish current coverage.
- **City fields:** collection city and parsed primary city differ. Avoid treating the two fields as interchangeable.

The raw dataset is unchanged so the report can be reproduced. These findings are not silently corrected or omitted.

## Report check: posting card

The supplied report binds its Job Postings card to **Count of `Job Skills Cleaned[Job postings]`**, which counts expanded skill rows. For the saved Data Analyst selection, that corresponds to **35,814 skill rows**, versus **4,729 job records**.

The correct existing measure is `Job Skills Cleaned[Job Postings orig]`, defined as `DISTINCTCOUNT('indian_tech_jobs_2026'[job_id])`. This measure also includes jobs without cleaned skills. The skill chart already uses a distinct-job measure and should keep that behavior.

## Verification scope

CSV counts, range checks, source hash, embedded model metadata, relationships, visual bindings, and all 15 DAX measures were inspected. Snapshot scores and salary statistics were independently reproduced from the CSV. Native Power BI rendering and the final card correction status are recorded in the completion notes below.

## Publication status — 5 October 2026

The repository includes the original supplied PBIX and CSV without changes. File hashes were checked against the supplied files, the saved visual bindings were inspected again, and the included audit script was rerun before publication.

The Job Postings card correction is **pending**. In Power BI Desktop, select that card and replace its current count field with the existing `Job Skills Cleaned[Job Postings orig]` measure. With Data Analyst selected and no additional filters, the expected job-record count is **4,729**. Save the report after verifying the replacement across roles.

User-supplied screenshots of both report pages are included in `screenshots/` and embedded in the README. Both previews show Business Analyst selected. They are static captures; native slicer interactions and the pending correction in the downloadable PBIX have not been reverified.

The profile screenshot's Job Postings card shows **4.399K**, while the overview screenshot's total and the independently verified Business Analyst dataset count are **4,505**. These previews therefore do not establish that the posting-count issue has been resolved.

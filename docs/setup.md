# Open and refresh the report

1. Download the repository as a ZIP and extract it, or clone it.
2. Open `powerbi/Tech Trends for Freshers.pbix` in Power BI Desktop. It contains imported data for the saved report.
3. To refresh on another machine, open **Transform data** and update the CSV source path in **both** queries: `indian_tech_jobs_2026` and `Job Skills Cleaned`.
4. Each query currently refers to `D:\Datasets\indian_tech_jobs_2026.csv`. Point it to the extracted repository's `data/indian_tech_jobs_2026.csv` using the Source step or Advanced Editor. The exact original query expressions are in `model/power-query/`.
5. Apply the changes and refresh. Both queries must read the same CSV version.
6. Select Data Analyst and check: 4,729 job postings, about 27.22% fresher-friendly, about 3.31 years minimum experience, about 10.62 LPA average disclosed salary, and about 62.02 accessibility score. The source report's job-count binding requires the correction described in `data-quality.md`.

The CSV snapshot has 23,201 rows and 32 columns. The imported jobs table has 31 columns after removing two columns and adding a sort key. The cleaned skills table has 176,390 rows.

## Refresh portability

The supplied PBIX stores an absolute local source path in two independent queries. Moving the file does not update those paths. A later model refactor could use one shared file-path parameter and a referenced base query. The included query exports document the current model rather than claiming that refactor is already applied.

## Access and publishing

The PBIX is a downloadable local report. The GitHub repository does not provide an interactive browser-hosted Power BI report. Power BI Service publishing requires the report owner's account and a deliberate sharing choice.

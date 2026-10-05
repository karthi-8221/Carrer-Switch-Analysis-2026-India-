let
  Source = Csv.Document(File.Contents("D:\Datasets\indian_tech_jobs_2026.csv"), [Delimiter = ",", Columns = 32, Encoding = 65001, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"job_id", Int64.Type}, {"job_title", type text}, {"company_name", type text}, {"company_rating", type number}, {"location", type text}, {"scraped_city", type text}, {"role_category", type text}, {"experience_raw", type text}, {"experience_min_yrs", Int64.Type}, {"experience_max_yrs", Int64.Type}, {"salary_raw", type text}, {"salary_min_lpa", type number}, {"salary_max_lpa", type number}, {"salary_disclosed", type logical}, {"skills_required", type text}, {"skills_count", Int64.Type}, {"job_description", type text}, {"posted_date_raw", type text}, {"work_mode", type text}, {"company_size_bucket", type text}, {"job_url", type text}, {"data_source", type text}, {"scraped_at", type date}, {"salary_tier", type text}, {"experience_tier", type text}, {"is_senior", type logical}, {"primary_city", type text}, {"skill_domain", type text}, {"salary_midpoint_lpa", type number}, {"days_since_posted", Int64.Type}, {"is_fresher_friendly", type logical}, {"salary_negotiable", type logical}}, "en-US"),
    #"Capitalized Each Word" = Table.TransformColumns(#"Changed column type",{{"job_title", Text.Proper, type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Capitalized Each Word",{"location", "posted_date_raw"}),
    #"Added Custom" = Table.AddColumn(#"Removed Columns", "Experience Tier Sort", each if [experience_tier] = "Fresher" then 1
else if [experience_tier] = "Junior (0-2 Yrs)" then 2
else if [experience_tier] = "Mid (3-5 Yrs)" then 3
else if [experience_tier] = "Senior (6-8 Yrs)" then 4
else if [experience_tier] = "Lead/Architect (9+ Yrs)" then 5
else 99)
in
    #"Added Custom"

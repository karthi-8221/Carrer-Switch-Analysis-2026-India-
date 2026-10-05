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
else 99),
    #"Reordered Columns" = Table.ReorderColumns(#"Added Custom",{"job_id", "skills_required", "job_title", "company_name", "company_rating", "scraped_city", "role_category", "experience_raw", "experience_min_yrs", "experience_max_yrs", "salary_raw", "salary_min_lpa", "salary_max_lpa", "salary_disclosed", "skills_count", "job_description", "work_mode", "company_size_bucket", "job_url", "data_source", "scraped_at", "salary_tier", "experience_tier", "is_senior", "primary_city", "skill_domain", "salary_midpoint_lpa", "days_since_posted", "is_fresher_friendly", "salary_negotiable", "Experience Tier Sort"}),
    #"Removed Other Columns" = Table.SelectColumns(#"Reordered Columns",{"skills_required", "job_id"}),
    #"Reordered Columns1" = Table.ReorderColumns(#"Removed Other Columns",{"job_id", "skills_required"}),
    #"Split Column by Delimiter" = Table.ExpandListColumn(Table.TransformColumns(#"Reordered Columns1", {{"skills_required", Splitter.SplitTextByDelimiter(",", QuoteStyle.Csv), let itemType = (type nullable text) meta [Serialized.Text = true] in type {itemType}}}), "skills_required"),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"skills_required", type text}}),
    #"Trimmed Text" = Table.TransformColumns(#"Changed Type",{{"skills_required", Text.Trim, type text}}),
    #"Capitalized Each Word1" = Table.TransformColumns(#"Trimmed Text",{{"skills_required", Text.Proper, type text}}),
    #"Filtered Rows" = Table.SelectRows(#"Capitalized Each Word1", each ([skills_required] <> "Not Available")),
    #"Removed Duplicates" = Table.Distinct(#"Filtered Rows"),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Duplicates",{{"skills_required", "Skills"}}),
    #"Filtered Rows1" = Table.SelectRows(#"Renamed Columns", each true),
    #"Cleaned Text" = Table.TransformColumns(#"Filtered Rows1",{{"Skills", Text.Clean, type text}}),
    #"Trimmed Text1" = Table.TransformColumns(#"Cleaned Text",{{"Skills", Text.Trim, type text}}),
    #"Replaced Value" = Table.ReplaceValue(#"Trimmed Text1","python","Python",Replacer.ReplaceText,{"Skills"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value","sql","SQL",Replacer.ReplaceText,{"Skills"}),
    #"Replaced Value2" = Table.ReplaceValue(#"Replaced Value1","Sql","SQL",Replacer.ReplaceText,{"Skills"}),
    #"Replaced Value3" = Table.ReplaceValue(#"Replaced Value2","excel","Excel",Replacer.ReplaceText,{"Skills"}),
    #"Replaced Value4" = Table.ReplaceValue(#"Replaced Value3","tableau","Tableau",Replacer.ReplaceText,{"Skills"}),
    #"Replaced Value5" = Table.ReplaceValue(#"Replaced Value4","Power Bi","Power BI",Replacer.ReplaceText,{"Skills"}),
    #"Replaced Value6" = Table.ReplaceValue(#"Replaced Value5","power bi","Power BI",Replacer.ReplaceText,{"Skills"}),
    #"Replaced Value7" = Table.ReplaceValue(#"Replaced Value6","pandas","Pandas",Replacer.ReplaceText,{"Skills"}),
    #"Replaced Value8" = Table.ReplaceValue(#"Replaced Value7","numpy","NumPy",Replacer.ReplaceText,{"Skills"}),
    #"Removed Duplicates1" = Table.Distinct(#"Replaced Value8"),
    #"Added Custom1" = Table.AddColumn(#"Removed Duplicates1", "Skill type", each if [Skills] = "Python" then "Programming"
else if [Skills] = "R" then "Programming"
else if [Skills] = "JavaScript" then "Programming"
else if [Skills] = "Coding" then "Programming"
else if [Skills] = "Development" then "Programming"

else if [Skills] = "SQL" then "Database"
else if [Skills] = "MySQL" then "Database"
else if [Skills] = "PostgreSQL" then "Database"
else if [Skills] = "MongoDB" then "Database"

else if [Skills] = "Power BI" then "Visualization"
else if [Skills] = "Tableau" then "Visualization"
else if [Skills] = "Excel" then "Spreadsheet"
else if [Skills] = "Data Visualization" then "Visualization"

else if [Skills] = "Pandas" then "Python/Data Science"
else if [Skills] = "NumPy" then "Python/Data Science"
else if [Skills] = "Numpy" then "Python/Data Science"

else if [Skills] = "Machine Learning" then "Machine Learning"
else if [Skills] = "Deep Learning" then "Machine Learning"
else if [Skills] = "Scikit-learn" then "Machine Learning"
else if [Skills] = "Scikit Learn" then "Machine Learning"
else if [Skills] = "TensorFlow" then "Machine Learning"
else if [Skills] = "Keras" then "Machine Learning"
else if [Skills] = "PyTorch" then "Machine Learning"

else if [Skills] = "Artificial Intelligence" then "AI/GenAI"
else if [Skills] = "AI" then "AI/GenAI"
else if [Skills] = "Generative AI" then "AI/GenAI"
else if [Skills] = "Natural Language Processing" then "AI/NLP"

else if [Skills] = "Data Analysis" then "Analytics"
else if [Skills] = "Data Analytics" then "Analytics"
else if [Skills] = "Analytics" then "Analytics"
else if [Skills] = "Business Analytics" then "Analytics"
else if [Skills] = "Analytical" then "Analytics"
else if [Skills] = "Business Analysis" then "Analytics"

else if [Skills] = "AWS" then "Cloud"
else if [Skills] = "GCP" then "Cloud"
else if [Skills] = "Cloud" then "Cloud"

else if [Skills] = "Data Engineering" then "Data Engineering"
else if [Skills] = "PySpark" then "Data Engineering"
else if [Skills] = "Data Processing" then "Data Engineering"

else if [Skills] = "Data Management" then "Data Management"
else if [Skills] = "Data Modeling" then "Data Management"
else if [Skills] = "Data Quality" then "Data Management"

else if [Skills] = "Statistics" then "Statistics"
else if [Skills] = "Statistical Modeling" then "Statistics"

else if [Skills] = "Project Management" then "Business/Methodology"
else if [Skills] = "Agile" then "Business/Methodology"
else if [Skills] = "Business Analyst" then "Business/Methodology"
else if [Skills] = "Consulting" then "Business/Methodology"
else if [Skills] = "Management" then "Business/Methodology"

else if [Skills] = "Computer Science" then "Knowledge"
else if [Skills] = "Data Science" then "Data Science"

else if [Skills] = "Automation" then "Automation"

else if [Skills] = "Data" then "Data/General"
else if [Skills] = "Gcp" then "Cloud"
else if [Skills] = "Aws" then "Cloud"
else if [Skills] = "Microsoft Azure" then "Cloud"
else if [Skills] = "PySpark" then "Data Engineering"
else if [Skills] = "Spark" then "Data Engineering"
else if [Skills] = "JavaScript" then "Programming"
else if [Skills] = "Java" then "Programming"
else if [Skills] = "C++" then "Programming"
else if [Skills] = "Git" then "Development Tools"
else if [Skills] = "Ai" then "AI/GenAI"
else if [Skills] = "AI" then "AI/GenAI"
else if [Skills] = "Generative AI" then "AI/GenAI"
else if [Skills] = "Business Intelligence" then "Analytics"
else if [Skills] = "SAP" then "Business/Enterprise"
else if [Skills] = "Backend" then "Programming"
else if [Skills] = "Data Warehousing" then "Data Engineering"
else if [Skills] = "Oracle" then "Database"
else if [Skills] = "Performance Tuning" then "Development"
else if [Skills] = "Analysis" then "Analytics"
else if [Skills] = "Debugging" then "Development"
else if [Skills] = "Architecture" then "Development"
else if [Skills] = "Troubleshooting" then "Development"
else if [Skills] = "Compliance" then "Business/Domain"
else if [Skills] = "Process Improvement" then "Business/Methodology"
else if [Skills] = "Workflow" then "Business/Methodology"
else if [Skills] = "Operations" then "Business/Operations"
else if [Skills] = "Monitoring" then "Development/Operations"
else "Other"),
    #"Renamed Columns1" = Table.RenameColumns(#"Added Custom1",{{"job_id", "Job postings"}}),
    #"Added Custom2" = Table.AddColumn(#"Renamed Columns1", "Actionable Skill", each let
    Skill = Text.Lower(Text.Trim([Skills]))
in
    if List.Contains(
        {
            "python",
            "pandas",
            "numpy",
            "sql",
            "power bi",
            "excel",
            "tableau",
            "r",
            "pyspark",
            "spark",
            "scikit-learn",
            "tensorflow",
            "pytorch",
            "databricks",
            "airflow",
            "dbt",
            "aws",
            "azure",
            "gcp"
        },
        Skill
    )
    then [Skills]
    else null),
    #"Removed Columns1" = Table.RemoveColumns(#"Added Custom2",{"Actionable Skill"}),
    #"Added Custom3" = Table.AddColumn(#"Removed Columns1", "Actionable skills", each let
    Skill = Text.Lower(Text.Trim([Skills]))
in
    if List.Contains({"python"}, Skill) then "Python"
    else if List.Contains({"pandas"}, Skill) then "Pandas"
    else if List.Contains({"numpy", "numPy"}, Skill) then "NumPy"
    else if List.Contains({"sql", "sql server", "mysql", "postgresql", "postgres"}) then "SQL"
    else if List.Contains({"power bi", "powerbi"}) then "Power BI"
    else if List.Contains({"excel", "microsoft excel", "ms excel"}) then "Excel"
    else if List.Contains({"tableau"}) then "Tableau"
    else if List.Contains({"r", "r program", "r programming"}) then "R"
    else if List.Contains({"pyspark"}) then "PySpark"
    else if List.Contains({"spark", "apache spark"}) then "Spark"
    else if List.Contains({"scikit-learn", "scikit learn", "sklearn"}) then "Scikit-Learn"
    else if List.Contains({"tensorflow"}) then "TensorFlow"
    else if List.Contains({"pytorch"}) then "PyTorch"
    else if List.Contains({"databricks"}) then "Databricks"
    else if List.Contains({"airflow", "apache airflow"}) then "Airflow"
    else if List.Contains({"dbt"}) then "dbt"
    else if List.Contains({"aws", "amazon web services"}) then "AWS"
    else if List.Contains({"azure", "microsoft azure"}) then "Azure"
    else if List.Contains({"gcp", "google cloud", "google cloud platform"}) then "GCP"
    else null),
    #"Removed Columns2" = Table.RemoveColumns(#"Added Custom3",{"Actionable skills"}),
    #"Added Custom4" = Table.AddColumn(#"Removed Columns2", "Actionable skills", each let
    Skill = Text.Lower(Text.Trim([Skills]))
in
    if List.Contains({"python"}, Skill) then "Python"
    else if List.Contains({"pandas"}, Skill) then "Pandas"
    else if List.Contains({"numpy", "numPy"}, Skill) then "NumPy"
    else if List.Contains({"sql", "sql server", "mysql", "postgresql", "postgres"}) then "SQL"
    else if List.Contains({"power bi", "powerbi"}) then "Power BI"
    else if List.Contains({"excel", "microsoft excel", "ms excel"}) then "Excel"
    else if List.Contains({"tableau"}) then "Tableau"
    else if List.Contains({"r", "r program", "r programming"}) then "R"
    else if List.Contains({"pyspark"}) then "PySpark"
    else if List.Contains({"spark", "apache spark"}) then "Spark"
    else if List.Contains({"scikit-learn", "scikit learn", "sklearn"}) then "Scikit-Learn"
    else if List.Contains({"tensorflow"}) then "TensorFlow"
    else if List.Contains({"pytorch"}) then "PyTorch"
    else if List.Contains({"databricks"}) then "Databricks"
    else if List.Contains({"airflow", "apache airflow"}) then "Airflow"
    else if List.Contains({"dbt"}) then "dbt"
    else if List.Contains({"aws", "amazon web services"}) then "AWS"
    else if List.Contains({"azure", "microsoft azure"}) then "Azure"
    else if List.Contains({"gcp", "google cloud", "google cloud platform"}) then "GCP"
    else null),
    #"Removed Columns3" = Table.RemoveColumns(#"Added Custom4",{"Actionable skills"}),
    #"Added Custom5" = Table.AddColumn(#"Removed Columns3", "Actionable skills", each let
    Skill = if [Skills] = null then "" else Text.Lower(Text.Trim([Skills]))
in
    if Skill = "python" then "Python"
    else if Skill = "pandas" then "Pandas"
    else if Skill = "numpy" then "NumPy"
    else if List.Contains({"sql", "sql server", "mysql", "postgresql", "postgres"}, Skill) then "SQL"
    else if List.Contains({"power bi", "powerbi"}, Skill) then "Power BI"
    else if List.Contains({"excel", "microsoft excel", "ms excel"}, Skill) then "Excel"
    else if Skill = "tableau" then "Tableau"
    else if List.Contains({"r", "r program", "r programming"}, Skill) then "R"
    else if Skill = "pyspark" then "PySpark"
    else if List.Contains({"spark", "apache spark"}, Skill) then "Spark"
    else if List.Contains({"scikit-learn", "scikit learn", "sklearn"}, Skill) then "Scikit-Learn"
    else if Skill = "tensorflow" then "TensorFlow"
    else if Skill = "pytorch" then "PyTorch"
    else if Skill = "databricks" then "Databricks"
    else if List.Contains({"airflow", "apache airflow"}, Skill) then "Airflow"
    else if Skill = "dbt" then "dbt"
    else if List.Contains({"aws", "amazon web services"}, Skill) then "AWS"
    else if List.Contains({"azure", "microsoft azure"}, Skill) then "Azure"
    else if List.Contains({"gcp", "google cloud", "google cloud platform"}, Skill) then "GCP"
    else null),
    #"Added Custom6" = Table.AddColumn(#"Added Custom5", "Core skills", each let
    Skill = [Actionable skills]
in
    if List.Contains(
        {
            "SQL",
            "Excel",
            "Power BI",
            "Python",
            "Pandas",
            "NumPy"
        },
        Skill
    )
    then "Core"
    else if List.Contains(
        {
            "Tableau",
            "R",
            "PySpark",
            "Spark",
            "Scikit-Learn",
            "TensorFlow",
            "PyTorch",
            "Databricks",
            "Airflow",
            "dbt",
            "AWS",
            "Azure",
            "GCP"
        },
        Skill
    )
    then "Additional"
    else null)
in
    #"Added Custom6"

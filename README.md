# 📊 Tech Career Trends in India 2026

An interactive Power BI dashboard analyzing technology job postings in India to help career switchers understand **role demand, salary, experience requirements, skills, locations, work modes, and hiring patterns**.

The project analyzes **23,201 technology job postings across 32 attributes** and transforms raw job-posting data into an interactive career exploration tool.

---

## 🎯 Project Objective

Choosing a technology career can be difficult when information about job demand, required skills, salary, and experience is scattered across different job portals.

This project aims to answer practical questions such as:

- Which technology roles have the highest demand?
- Where are technology jobs concentrated?
- What skills are employers looking for?
- How does salary change with experience?
- Which roles are more accessible to career switchers?
- How many opportunities are marked as fresher-friendly?
- Which work modes are common across major technology cities?
- What types of companies are hiring for different roles?

The goal is to turn job-market data into a **career exploration dashboard** rather than simply presenting descriptive charts.

---

## 📈 Dashboard

The dashboard consists of two interactive pages.

### 1. Tech Career Market Overview

Provides a market-level view of the technology job landscape.

Key visuals include:

- **Work Mode by Top Tech Cities**
  - Compares Hybrid, On-site, and Remote opportunities across major cities.

- **Hiring Distribution by Company Size**
  - Shows how hiring is distributed across Large, Mid-sized, and Small/Startup companies.

- **Career Opportunity Quadrant**
  - Compares roles using median minimum experience, median salary, and fresher-friendly openings.

- **Career Accessibility Score by Role**
  - Provides a comparative view of role accessibility using the project's defined accessibility metric.

### 2. Career Switcher Profile

Allows users to select a technology role and explore its market profile.

The page provides:

- Career Accessibility Score
- Average Salary
- Job Postings
- Average Minimum Experience
- Fresher Friendly %
- Average Salary by Experience Level
- Actionable Skills for the Selected Role
- Top 10 Cities by Job Demand

The role slicer allows the user to explore the characteristics of different technology careers interactively.

---

## 🗂️ Dataset

The project uses the:

`indian_tech_jobs_2026`

dataset containing:

| Attribute | Value |
|---|---:|
| Job postings | 23,201 |
| Columns | 32 |
| Geographic scope | India |
| Data type | Technology job postings |

Important fields include:

- `job_title`
- `role_category`
- `company_name`
- `primary_city`
- `experience_min_yrs`
- `experience_max_yrs`
- `salary_min_lpa`
- `salary_max_lpa`
- `salary_midpoint_lpa`
- `salary_disclosed`
- `skills_required`
- `work_mode`
- `company_size_bucket`
- `experience_tier`
- `is_fresher_friendly`

---

## 🧹 Data Preparation

The data was cleaned and transformed using **Power Query** before visualization.

Key preparation steps included:

- Removing duplicate job records
- Trimming and standardizing text fields
- Standardizing role categories
- Cleaning location information
- Converting salary and experience fields into numeric values
- Creating salary midpoint values
- Creating experience tiers
- Creating fresher-friendly indicators
- Standardizing work-mode categories
- Preparing company-size categories

---

## 🧩 Skill Data Modeling

The original `skills_required` field contained multiple skills within a single job record.

For example:

```text
Python, SQL, Pandas, Power BI

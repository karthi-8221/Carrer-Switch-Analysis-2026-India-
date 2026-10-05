"""Reproduce dataset checks and role metrics with the Python standard library.

Run from any directory: python scripts/audit_dataset.py [path/to/dataset.csv]
The input file is never modified. Results are emitted as JSON.
"""
import csv
import hashlib
import json
import statistics
import sys
from collections import Counter, defaultdict
from pathlib import Path

EXPECTED_COLUMNS = 'job_id job_title company_name company_rating location scraped_city role_category experience_raw experience_min_yrs experience_max_yrs salary_raw salary_min_lpa salary_max_lpa salary_disclosed skills_required skills_count job_description posted_date_raw work_mode company_size_bucket job_url data_source scraped_at salary_tier experience_tier is_senior primary_city skill_domain salary_midpoint_lpa days_since_posted is_fresher_friendly salary_negotiable'.split()

def audit(path):
    with path.open(encoding='utf-8-sig', newline='') as stream:
        reader = csv.DictReader(stream)
        columns = reader.fieldnames
        rows = list(reader)
    if columns != EXPECTED_COLUMNS:
        raise ValueError('CSV schema differs from the documented 32-column source.')
    if not rows:
        raise ValueError('CSV has no data rows.')
    def number(row, field):
        return float(row[field])
    def flag(row, field):
        value = row[field].strip().lower()
        if value not in {'true', 'false'}:
            raise ValueError(f'Invalid boolean in {field}: {value}')
        return value == 'true'
    disclosed = [r for r in rows if flag(r, 'salary_disclosed')]
    ids = [r['job_id'] for r in rows]
    # The source encodes 53 missing URLs as the literal text "N/A".
    urls = [r['job_url'].strip() for r in rows if r['job_url'].strip().lower() not in {'', 'n/a', 'nan'}]
    role_groups = defaultdict(list)
    for row in rows:
        role_groups[row['role_category']].append(row)
    roles = []
    for role, group in sorted(role_groups.items()):
        salaries = [number(r, 'salary_midpoint_lpa') for r in group if flag(r, 'salary_disclosed')]
        roles.append({
            'role': role, 'postings': len(group),
            'fresher_openings': sum(flag(r, 'is_fresher_friendly') for r in group),
            'fresher_friendly_pct': 100 * sum(flag(r, 'is_fresher_friendly') for r in group) / len(group),
            'average_minimum_experience': statistics.mean(number(r, 'experience_min_yrs') for r in group),
            'median_minimum_experience': statistics.median(number(r, 'experience_min_yrs') for r in group),
            'salary_disclosed_postings': len(salaries),
            'average_salary_lpa': statistics.mean(salaries) if salaries else None,
            'median_salary_lpa': statistics.median(salaries) if salaries else None,
        })
    low_demand, high_demand = min(r['postings'] for r in roles), max(r['postings'] for r in roles)
    low_exp = min(r['average_minimum_experience'] for r in roles)
    high_exp = max(r['average_minimum_experience'] for r in roles)
    for r in roles:
        r['demand_score'] = 100 * (r['postings'] - low_demand) / (high_demand - low_demand) if high_demand != low_demand else None
        r['experience_accessibility_score'] = 100 * (high_exp - r['average_minimum_experience']) / (high_exp - low_exp) if high_exp != low_exp else None
        # DAX treats BLANK components as zero when added to numeric components.
        r['career_accessibility_score'] = .4 * r['fresher_friendly_pct'] + .35 * (r['experience_accessibility_score'] or 0) + .25 * (r['demand_score'] or 0)
    salary_values = [number(r, 'salary_midpoint_lpa') for r in disclosed]
    return {
        'sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
        'rows': len(rows), 'columns': len(columns),
        'duplicate_full_rows': len(rows) - len({tuple(r[c] for c in columns) for r in rows}),
        'duplicate_job_ids': len(ids) - len(set(ids)),
        'missing_job_urls': len(rows) - len(urls),
        'repeated_nonblank_urls_beyond_first': len(urls) - len(set(urls)),
        'distinct_nonblank_urls': len(set(urls)),
        'reversed_experience_ranges': sum(number(r, 'experience_min_yrs') > number(r, 'experience_max_yrs') for r in rows),
        'reversed_salary_ranges': sum(number(r, 'salary_min_lpa') > number(r, 'salary_max_lpa') for r in rows),
        'salary_midpoint_mismatches': sum(abs(number(r, 'salary_midpoint_lpa') - (number(r, 'salary_min_lpa') + number(r, 'salary_max_lpa')) / 2) > .011 for r in rows),
        'salary_disclosed_postings': len(disclosed),
        'salary_disclosed_pct': len(disclosed) / len(rows) * 100,
        'disclosed_zero_salary_postings': sum(number(r, 'salary_midpoint_lpa') == 0 for r in disclosed),
        'undisclosed_zero_salary_postings': sum(not flag(r, 'salary_disclosed') and number(r, 'salary_midpoint_lpa') == 0 for r in rows),
        'fresher_openings': sum(flag(r, 'is_fresher_friendly') for r in rows),
        'fresher_friendly_pct': 100 * sum(flag(r, 'is_fresher_friendly') for r in rows) / len(rows),
        'fresher_flag_disagreements_with_minimum_experience_le_1': sum(flag(r, 'is_fresher_friendly') != (number(r, 'experience_min_yrs') <= 1) for r in rows),
        'average_disclosed_salary_lpa': statistics.mean(salary_values),
        'median_disclosed_salary_lpa': statistics.median(salary_values),
        'scraped_at': dict(Counter(r['scraped_at'] for r in rows)),
        'data_sources': dict(Counter(r['data_source'] for r in rows)),
        'work_modes': dict(Counter(r['work_mode'] for r in rows)),
        'scraped_cities': dict(Counter(r['scraped_city'] for r in rows)),
        'primary_cities': dict(Counter(r['primary_city'] for r in rows)),
        'roles': roles,
    }

if __name__ == '__main__':
    source = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parents[1] / 'data' / 'indian_tech_jobs_2026.csv'
    print(json.dumps(audit(source), indent=2, allow_nan=False))

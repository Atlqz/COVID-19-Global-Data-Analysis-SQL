# Data Dictionary: COVID-19 Dataset (Our World in Data)

This document describes the actual schema used in the `CovidDeaths` and `CovidVaccinations` tables. The data spans from **January 1, 2020** through **February 28, 2026** across **200+ countries and territories**.

---

## Table 1: CovidDeaths

*Primary table containing daily case counts, death statistics, and population data.*

| Column Name | Data Type | Description | Example Value |
|-------------|-----------|-------------|---------------|
| `iso_code` | nvarchar(255) | 3-letter ISO country code | `MYS`, `USA`, `GBR` |
| `continent` | nvarchar(255) | Geographic continent | `Asia`, `Europe`, `NULL` (for aggregates) |
| `country` | nvarchar(255) | Country or territory name | `Malaysia`, `United States` |
| `date` | datetime | Observation date (YYYY-MM-DD) | `2021-08-15` |
| `population` | float | Total population estimate | `32300000` |
| `total_cases` | float | Cumulative confirmed COVID-19 cases | `2450000` |
| `new_cases` | float | Daily new confirmed cases | `15420` |
| `new_cases_smoothed` | nvarchar(255) | 7-day rolling average of new cases | `12800.5` |
| `total_cases_per_million` | float | Total cases per million population | `75832.5` |
| `new_cases_per_million` | float | Daily new cases per million population | `477.3` |
| `new_cases_smoothed_per_million` | nvarchar(255) | Smoothed new cases per million | `396.8` |
| `total_deaths` | float | Cumulative confirmed COVID-19 deaths | `32450` |
| `new_deaths` | float | Daily new confirmed deaths | `245` |
| `new_deaths_smoothed` | nvarchar(255) | 7-day rolling average of new deaths | `198.2` |
| `total_deaths_per_million` | float | Total deaths per million population | `1004.2` |
| `new_deaths_per_million` | float | Daily new deaths per million population | `7.6` |
| `new_deaths_smoothed_per_million` | nvarchar(255) | Smoothed new deaths per million | `6.1` |
| `excess_mortality` | nvarchar(255) | Excess mortality (% change from baseline) | `12.5` |
| `excess_mortality_cumulative` | nvarchar(255) | Cumulative excess mortality | `85000` |
| `excess_mortality_cumulative_absolute` | nvarchar(255) | Absolute excess deaths count | `85234` |
| `excess_mortality_cumulative_per_million` | nvarchar(255) | Cumulative excess deaths per million | `2638.5` |
| `hosp_patients` | nvarchar(255) | Number of COVID-19 patients hospitalized | `4200` |
| `hosp_patients_per_million` | nvarchar(255) | Hospitalized patients per million | `130.0` |
| `weekly_hosp_admissions` | nvarchar(255) | Weekly new hospital admissions | `1850` |
| `weekly_hosp_admissions_per_million` | nvarchar(255) | Weekly admissions per million | `57.3` |
| `icu_patients` | nvarchar(255) | Number of COVID-19 patients in ICU | `850` |
| `icu_patients_per_million` | nvarchar(255) | ICU patients per million population | `26.3` |
| `weekly_icu_admissions` | nvarchar(255) | Weekly new ICU admissions | `320` |
| `weekly_icu_admissions_per_million` | nvarchar(255) | Weekly ICU admissions per million | `9.9` |

### Notes on CovidDeaths Table
- **NULL values** are common for early pandemic dates when testing/reporting infrastructure was limited
- **continent = NULL** typically indicates aggregated rows (e.g., `World`, `Europe`, `Asia` as a grouping label)
- **excess_mortality** columns contain significant gaps and should be used cautiously
- Hospitalization and ICU data is sparse for many low-income countries

---

## Table 2: CovidVaccinations

*Supplementary table containing vaccination rollout data, testing statistics, and demographic indicators.*

| Column Name | Data Type | Description | Example Value |
|-------------|-----------|-------------|---------------|
| `iso_code` | nvarchar(255) | 3-letter ISO country code | `MYS`, `USA`, `GBR` |
| `continent` | nvarchar(255) | Geographic continent | `Asia`, `Europe` |
| `country` | nvarchar(255) | Country or territory name | `Malaysia` |
| `date` | datetime | Observation date (YYYY-MM-DD) | `2021-08-15` |
| `total_tests` | nvarchar(255) | Cumulative COVID-19 tests conducted | `34500000` |
| `new_tests` | nvarchar(255) | Daily new tests conducted | `125000` |
| `total_tests_per_thousand` | nvarchar(255) | Total tests per 1,000 population | `1068.1` |
| `new_tests_per_thousand` | nvarchar(255) | Daily new tests per 1,000 population | `3.87` |
| `new_tests_smoothed` | nvarchar(255) | 7-day rolling average of new tests | `118500` |
| `new_tests_smoothed_per_thousand` | nvarchar(255) | Smoothed new tests per 1,000 | `3.67` |
| `positive_rate` | nvarchar(255) | Test positivity rate (7-day average) | `0.052` |
| `tests_per_case` | nvarchar(255) | Tests conducted per confirmed case | `19.2` |
| `total_vaccinations` | nvarchar(255) | Cumulative vaccine doses administered | `68000000` |
| `people_vaccinated` | nvarchar(255) | People who received at least one dose | `25000000` |
| `people_fully_vaccinated` | nvarchar(255) | People who completed initial protocol | `23500000` |
| `total_boosters` | nvarchar(255) | Total booster doses administered | `18000000` |
| `new_vaccinations` | nvarchar(255) | Daily new vaccine doses administered | `85000` |
| `new_vaccinations_smoothed` | nvarchar(255) | 7-day rolling average of new vaccinations | `79200` |
| `total_vaccinations_per_hundred` | nvarchar(255) | Total doses per 100 population | `210.5` |
| `people_vaccinated_per_hundred` | nvarchar(255) | People with ≥1 dose per 100 population | `77.4` |
| `people_fully_vaccinated_per_hundred` | nvarchar(255) | Fully vaccinated per 100 population | `72.8` |
| `total_boosters_per_hundred` | nvarchar(255) | Boosters per 100 population | `55.7` |
| `new_vaccinations_smoothed_per_million` | nvarchar(255) | Smoothed new vaccinations per million | `2452` |
| `new_people_vaccinated_smoothed` | nvarchar(255) | Smoothed new people receiving first dose | `42000` |
| `new_people_vaccinated_smoothed_per_hundred` | nvarchar(255) | New first-dose recipients per 100 | `0.13` |
| `population_density` | nvarchar(255) | People per square kilometer | `98.5` |
| `median_age` | nvarchar(255) | Median age of population (years) | `29.2` |
| `life_expectancy` | nvarchar(255) | Life expectancy at birth (years) | `75.4` |
| `gdp_per_capita` | nvarchar(255) | GDP per capita (USD, PPP adjusted) | `12478.9` |
| `extreme_poverty` | nvarchar(255) | Percentage living in extreme poverty | `2.5` |
| `diabetes_prevalence` | nvarchar(255) | Diabetes prevalence (% of population) | `11.4` |
| `handwashing_facilities` | float | Access to handwashing facilities (%) | `85.3` |
| `hospital_beds_per_thousand` | nvarchar(255) | Hospital beds per 1,000 population | `1.9` |
| `human_development_index` | nvarchar(255) | UN Human Development Index (0-1) | `0.81` |

### Notes on CovidVaccinations Table
- **Vaccination data** begins in **December 2020** for most countries; earlier dates contain NULL values
- **total_vaccinations** may exceed population × 3 in countries with extensive booster campaigns (2023-2026)
- **nvarchar(255)** numeric columns require casting, use `TRY_CONVERT(float, column_name)` or `CAST(column_name AS float)`
- **gdp_per_capita** and demographic indicators are **static** (latest available pre-pandemic estimates)
- **handwashing_facilities** is the only float column in this table, all other numeric values stored as nvarchar(255)
- **positive_rate** > 0.05 (5%) typically indicates insufficient testing coverage

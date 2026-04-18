# COVID-19-Global-Data-Analysis-SQL
Advanced SQL analysis exploring global COVID-19 trends (2020-2024). Includes CTEs, window functions, etc
# COVID-19 Global Data Analysis | SQL Exploration

![SQL](https://img.shields.io/badge/SQL-Server-CC2927?style=flat-square&logo=microsoft-sql-server&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)

## Project Overview

Exploratory analysis of **85,000+ records** covering COVID-19 deaths and vaccinations across 230+ countries from January 2020 to April 2024, sourced from [Our World in Data](https://ourworldindata.org/covid-deaths).

The goal was to move beyond surface-level totals and answer specific questions about infection patterns, mortality risk, and vaccination equity, then communicate those answers in plain business language.

---

## Key Findings

### Infection & spread
- **Cyprus reached 73.8% of its population infected**, nearly 4x higher than the United States (17.9%), despite similar healthcare infrastructure, suggesting small population size and tourism density as major drivers.
- Neighboring countries showed dramatic divergence: **Andorra hit 67.1%** while **Spain peaked at 18.5%**, pointing to the outsized impact of border policy and population density on spread.

### Mortality impact
- **Peru recorded 650 deaths per 100,000 residents**, more than double the US rate (301 per 100,000) and the highest per-capita death toll globally.
- Despite holding only 4% of global population, the **United States accounted for 16.4% of all recorded COVID-19 deaths worldwide**.
- **Europe recorded the highest continental death toll at 2.1 million**, followed by North America (1.6M) and Asia (1.5M).

### Vaccination equity
- **Gibraltar reached 25% population vaccination coverage in just 15 days** after rollout began, the fastest of any territory analysed.
- High-GDP countries (>$40k GDP/capita) began vaccinations an average of **68 days earlier** than low-GDP countries (<$10k GDP/capita), a gap that correlates directly with early mortality differences.
- **9 countries** reported over 100,000 confirmed cases but zero recorded deaths, flagging likely reporting gaps rather than genuine outcomes.

### Case fatality trends
- The **global case fatality rate peaked at 7.2% in April 2020** before falling to **0.89% by 2024**, an 8x improvement driven by testing scale, treatment advances, and vaccination.
- **Yemen recorded the highest case fatality rate at 18.1%**, followed by Sudan (7.9%) and Syria (5.7%), all conflict-affected regions with severely strained healthcare systems.
- In **Malaysia**, the probability of dying after a confirmed case dropped from **1.2% in 2020 to 0.29% by late 2023**, a 76% reduction tracking directly with vaccination uptake.

---

## SQL Techniques Demonstrated

| Technique | Purpose | Example use case |
|-----------|---------|-----------------|
| Window Functions | Rolling calculations without collapsing rows | Cumulative vaccinations per country over time |
| CTEs | Breaking complex logic into readable steps | Vaccination coverage percentage calculations |
| Temporary Tables | Staging intermediate results | Preparing data for correlation analysis |
| Data Type Casting | Handling mixed types | Converting `nvarchar` vaccination counts to `bigint` |
| `NULLIF` & `ISNULL` | Safe division and null handling | Avoiding divide-by-zero in death rate queries |
| Aggregate Functions | Summarising large datasets | Monthly case and death rollups by continent |
| JOINs | Combining related datasets | Merging mortality data with vaccination timelines |

---

## Sample Query: Rolling Vaccinations with Percentage Coverage

Uses a CTE and Window Function to calculate the running vaccination total per country, then expresses it as a percentage of population, without collapsing the daily row structure.

```sql
With Population_Vaccinated_CTE (
    Continent, Country, Date, Population,
    New_Vaccinations, Rolling_People_Vaccinated
) as (
    Select
        dea.continent,
        dea.country,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        Sum(Convert(bigint, vac.new_vaccinations)) Over (
            Partition by dea.country
            Order by dea.date
        ) as Rolling_People_Vaccinated
    From PortfolioProject..CovidDeaths dea
    Join PortfolioProject..CovidVaccinations vac
        on dea.country = vac.country
        and dea.date = vac.date
    Where dea.continent is not null
)
Select
    *,
    (Rolling_People_Vaccinated / Nullif(Population, 0)) * 100 as Percent_Vaccinated
From Population_Vaccinated_CTE
Order by Country, Date;
```

---

## Repository Structure

```
text
COVID-19-Global-Data-Analysis-SQL/
│
├── README.md                          # Project documentation
├── Covid19_Data_Exploration.sql       # Complete SQL analysis (20+ queries)
└── data_dictionary.md                 # Column descriptions and data types

```

---

## What I Would Do Next

- **Visualise in Power BI**: Connect the SQL views to a dashboard tracking infection rate vs. vaccination rate over time per country, with a GDP filter to surface equity gaps.
- **Add statistical correlation**: Use Python (scipy) to formally test the relationship between median age and case fatality rate, the data suggests a strong positive correlation worth quantifying.
- **Automate data refresh**: The Our World in Data dataset updates daily, a simple Python script could refresh the SQL tables on a schedule, making this a live rather than static analysis.

/*******************************************************************
 * Title: COVID-19 Global Data Exploration & Analysis (2020-2024)
 * Description: Advanced SQL analysis of global COVID-19 trends using 
 *              joins, CTEs, window functions, and aggregate statistics.
 * Data Source: Our World in Data (CovidDeaths & CovidVaccinations)
 *******************************************************************/

-- ==============================================================
-- Section 1: Initial Data Profiling & High-Level Overview
-- ==============================================================

-- 1.1 Preview the main mortality dataset
-- Question: What does the raw time-series structure look like for deaths and cases?
Select * 
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 3,4

-- 1.2 Preview the vaccination dataset
-- Question: How is vaccination rollout data structured by country and date?
Select * 
From PortfolioProject..CovidVaccinations
Where continent is not null
Order by 3,4

-- ==============================================================
-- Section 2: Country-Specific Case Fatality & Infection Rates
-- ==============================================================

-- 2.1 Malaysia Case Fatality Rate (CFR)
-- Question: What is the real-time likelihood of dying if you contract COVID-19 in Malaysia?
Select 
country, 
date, 
total_cases, 
total_deaths, 
(total_deaths / Nullif(total_cases, 0)) * 100 as Death_Percentage
From PortfolioProject..CovidDeaths
Where total_cases != 0 
  and country = 'Malaysia'
Order by date Desc

-- 2.2 Infection Rate vs. Population (Global Daily Snapshot)
-- Question: At its peak, what percentage of a country's population was infected?
Select 
country, 
date, 
population, 
total_cases, 
(total_cases / Nullif(population, 0)) * 100 as Percent_Population_Infected
From PortfolioProject..CovidDeaths
Where continent is not null
Order by country, date

-- 2.3 Countries with Highest Infection Rate relative to Population
-- Question: Which countries had the most extensive spread relative to their size (not just total numbers)?
Select 
country, 
population, 
Max(total_cases) as Highest_Infection_Count, 
Max((total_cases / Nullif(population, 0))) * 100 as Max_Percent_Population_Infected
From PortfolioProject..CovidDeaths
Where continent is not null
Group by country, population
Order by Max_Percent_Population_Infected Desc;

-- ==============================================================
-- Section 3: Mortality Analysis & Impact
-- ==============================================================

-- 3.1 Countries with Highest Total Death Count
-- Question: Where has the absolute loss of life been most severe?
Select 
country, 
Max(Cast(total_deaths as int)) as Total_Death_Count
From PortfolioProject..CovidDeaths
Where continent is not null
Group by country
Order by Total_Death_Count Desc;

-- 3.2 Death Count by Continent (Corrected Aggregation)
-- Question: When grouping by continent, which region shows the highest aggregate mortality?
-- Note: Excluding 'World' and 'International' categories found in the raw data.
Select 
continent, 
Max(Cast(total_deaths as int)) as Total_Death_Count
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
Order by Total_Death_Count Desc;

-- 3.3 Comparative Analysis: Europe Union vs North America Mortality Rate
-- Question: How does the death rate compare between two major economic blocs?
Select 
country, 
Max(Cast(total_deaths as int)) as Total_Death_Count
From PortfolioProject..CovidDeaths
Where country in ('Europe', 'North America')
Group by country;

-- 3.4 Top 10 Countries by New Cases Per Population (Peak Wave Intensity)
-- Question: Which countries experienced the most intense single-day waves relative to their population?
Select Top 10
country, 
Max(new_cases) as Peak_New_Cases,
population, 
Max(Cast(new_cases as float) / Nullif(population, 0)) * 100 as Peak_New_Cases_Per_Population
From PortfolioProject..CovidDeaths
Where continent is not null
Group by country, population
Order by Peak_New_Cases_Per_Population Desc;

-- ==============================================================
-- Section 4: Global Trend Analysis (Time Series)
-- ==============================================================

-- 4.1 Global Daily Progression
-- Question: On which specific dates did the global death percentage spike the highest?
Select 
date, 
Sum(new_cases) as Daily_Global_Cases, 
Sum(Cast(new_deaths as int)) as Daily_Global_Deaths, 
(Sum(Cast(new_deaths as int)) / Nullif(Sum(new_cases), 0)) * 100 as Global_Death_Percentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group by date
Order by Global_Death_Percentage Desc;

-- 4.2 Cumulative Global Totals (Final Snapshot)
-- Question: As of the latest data, what is the overall global mortality rate for COVID-19?
Select 
Sum(new_cases) as Total_Global_Cases, 
Sum(Cast(new_deaths as int)) as Total_Global_Deaths, 
(Sum(Cast(new_deaths as int)) / Nullif(Sum(new_cases), 0)) * 100 as Overall_Death_Percentage
From PortfolioProject..CovidDeaths
Where continent is not null;

-- 4.3 Monthly Mortality Trend (Smoothed Analysis)
-- Question: Looking at monthly aggregates, when was the deadliest period of the pandemic globally?
Select 
Year(date) as Year,
Month(date) as Month,
Sum(new_cases) as Monthly_Cases,
Sum(Cast(new_deaths as int)) as Monthly_Deaths,
(Sum(Cast(new_deaths as int)) / Nullif(Sum(new_cases), 0)) * 100 as Monthly_Death_Rate
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Year(date), Month(date)
Order by Year, Month;

-- ==============================================================
-- Section 5: Vaccination Rollout & Coverage (Advanced Joins)
-- ==============================================================

-- 5.1 Initial Table Join Verification
-- Question: Do the keys align properly between deaths and vaccinations tables?
Select * 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  on dea.country = vac.country
  and dea.date = vac.date
Where dea.continent is not null
Order by dea.country, dea.date;

-- 5.2 When Did Vaccinations Begin Per Country?
-- Question: How quickly did different countries start their vaccination programs? 
-- Did developed nations start significantly earlier than developing ones?
Select 
dea.continent, 
dea.country, 
Min(dea.date) as Vaccination_Start_Date, 
Min(Cast(vac.new_vaccinations as bigint)) as Initial_Daily_Shots
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  on dea.country = vac.country
  and dea.date = vac.date
Where dea.continent is not null 
  and vac.new_vaccinations is not null
  and Cast(vac.new_vaccinations as bigint) > 0
Group by dea.continent, dea.country
Order by Vaccination_Start_Date;

-- 5.3 Total Population vs Daily Vaccinations (Base Query)
-- Question: What does the raw daily vaccination data look like when joined with population?
Select 
dea.continent, 
dea.country, 
dea.date, 
dea.population, 
vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  on dea.country = vac.country
  and dea.date = vac.date
Where dea.continent is not null
Order by dea.country, dea.date;

-- 5.4 Rolling Count of Vaccines Administered (Using Window Functions)
-- Question: How many total shots have been given in each country over time? (Cumulative Sum)
Select 
dea.continent, 
dea.country, 
dea.date, 
dea.population, 
vac.new_vaccinations,
Sum(Cast(vac.new_vaccinations as bigint)) Over (
  Partition by dea.country 
  Order by dea.date
) as Rolling_Total_Vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  on dea.country = vac.country
  and dea.date = vac.date
Where dea.continent is not null
Order by dea.country, dea.date;

-- ==============================================================
-- Section 6: Advanced Calculations (CTE & Temp Tables)
-- ==============================================================

-- 6.1 CTE: Calculating Percentage of Population Vaccinated Over Time
-- Question: Accounting for boosters and multiple doses, what percentage of a country's 
-- population has received at least one dose over time?
With Population_Vaccinated_CTE (
Continent, 
Country, 
Date, 
Population, 
New_Vaccinations, 
Rolling_People_Vaccinated
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

-- 6.2 Temp Table Alternative: Optimizing for performance and reusability
-- Question: Can we stage this data for faster reporting in a dashboard?
Drop Table if exists #Percent_Population_Vaccinated;
Create Table #Percent_Population_Vaccinated (
Continent nvarchar(255),
Country nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
Rolling_People_Vaccinated numeric
);

Insert into #Percent_Population_Vaccinated
Select 
dea.continent, 
dea.country, 
dea.date, 
dea.population, 
Try_Convert(numeric, vac.new_vaccinations),
Sum(Try_Convert(bigint, vac.new_vaccinations)) Over (
  Partition by dea.country 
  Order by dea.date
) as Rolling_People_Vaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  on dea.country = vac.country
  and dea.date = vac.date
Where dea.continent is not null;

-- Query the Temp Table with a calculated field
Select 
*, 
(Rolling_People_Vaccinated / Nullif(Population, 0)) * 100 as Percent_Vaccinated
From #Percent_Population_Vaccinated
Order by Country, Date;

-- ==============================================================
-- Section 7: Data Governance & Visualization Setup
-- ==============================================================

-- 7.1 Creating a Permanent View for Business Intelligence Tools (Tableau/Power BI)
-- Purpose: Provides a clean, pre-calculated dataset for visualization.
Create View Percent_Population_Vaccinated_View as
Select 
dea.continent, 
dea.country, 
dea.date, 
dea.population, 
Isnull(vac.new_vaccinations, 0) as New_Vaccinations,
Sum(Convert(bigint, Isnull(vac.new_vaccinations, 0))) Over (
  Partition by dea.country 
  Order by dea.date
) as Rolling_People_Vaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  on dea.country = vac.country
  and dea.date = vac.date
Where dea.continent is not null;

-- Verification of View
Select Top 100 * 
From Percent_Population_Vaccinated_View;

-- ==============================================================
-- Section 8: Additional Critical Thinking Queries
-- ==============================================================

-- 8.1 Correlation Exploration: GDP vs. Vaccination Rate
-- Question: Is there a visible relationship between a country's wealth and how quickly they vaccinated?
With Latest_Vaccination_Status as (
Select 
country, 
Max(Rolling_People_Vaccinated) as Total_Doses_Administered
From #Percent_Population_Vaccinated
Group by country
)
Select Distinct
dea.country, 
dea.population, 
vac.gdp_per_capita, 
lvs.Total_Doses_Administered,
(lvs.Total_Doses_Administered / Nullif(dea.population, 0)) * 100 as Vaccination_Doses_Per_Capita_Pct
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac 
  on dea.country = vac.country
Join Latest_Vaccination_Status lvs 
  on dea.country = lvs.country
Where dea.continent is not null
  and vac.gdp_per_capita is not null
Order by vac.gdp_per_capita Desc;

-- 8.2 Median Age vs. Infection Severity
-- Question: Did countries with older median ages (higher risk) experience higher mortality rates?
Select Distinct
dea.country, 
vac.median_age, 
Max(Cast(dea.total_deaths as int)) as Total_Deaths,
Max((Cast(dea.total_deaths as float) / Nullif(dea.population, 0))) * 10000 as Deaths_Per_10k_Pop
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  on dea.country = vac.country
Where dea.continent is not null
  and vac.median_age is not null
Group by dea.country, vac.median_age
Order by vac.median_age Desc;

-- 8.3 Countries with Zero Deaths (Anomaly Check)
-- Question: Are there any countries that reported cases but miraculously reported zero deaths?
Select 
country,
Max(total_cases) as Total_Cases,
Max(Cast(total_deaths as int)) as Total_Deaths
From PortfolioProject..CovidDeaths
Where continent is not null
Group by country
Having Max(Cast(total_deaths as int)) = 0 
   and Max(total_cases) > 0
Order by Total_Cases Desc;

-- 8.4 Vaccination Progress: Days to Reach 25% Coverage
-- Question: How many days did it take for each country to vaccinate 25% of its population?
With Vaccination_Timeline as (
Select 
Country,
Date,
(Rolling_People_Vaccinated / Nullif(Population, 0)) * 100 as Vaccination_Percentage
From #Percent_Population_Vaccinated
)
Select 
Country,
Min(Date) as Date_Reached_25_Percent,
Min(Vaccination_Percentage) as Pct_At_That_Date
From Vaccination_Timeline
Where Vaccination_Percentage >= 25
Group by Country
Order by Date_Reached_25_Percent;

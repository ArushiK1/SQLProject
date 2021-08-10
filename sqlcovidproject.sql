SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM project2.covid_deaths
ORDER BY 1,3;

-- looking at total cases vs total deaths
-- Shows the chances of dying if you contract covid in your country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases), Population
FROM project2.covid_deaths
WHERE Location like '%india%'
ORDER BY 1,3;

-- Total cases vs population
-- Shows what % of population has gotton covid

SELECT Location, date, total_cases, Population, (total_cases/population)*100 as infectedPopulation
FROM project2.covid_deaths
WHERE Location like '%india%'
ORDER BY 1,3;

-- Countries with highest infection rate compared to population

SELECT Location, date, MAX(total_cases) AS highest, Population, MAX((total_cases/population))*100 as PercentagePopulationInfected
FROM project2.covid_deaths
GROUP BY Location, Population;

-- Showing countries with highest death counts per population

SELECT Location, MAX(CAST(total_deaths AS SIGNED))
FROM project2.covid_deaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY total_deaths DESC;

-- breaking things down by continent

SELECT continent, MAX(CAST(total_deaths AS SIGNED))
FROM project2.covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_deaths DESC;

-- showing the continents with the highest death count per population

SELECT continent, MAX(CAST(total_deaths AS SIGNED))
FROM project2.covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_deaths DESC;

-- GLOBAL NUMBERS

SELECT date, SUM(new_cases), SUM(CAST(new_deaths AS SIGNED)), SUM(CAST(new_deaths AS SIGNED))/SUM(new_cases)*100
FROM project2.covid_deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 2;

-- Total cases
SELECT SUM(new_cases), SUM(CAST(new_deaths AS SIGNED)), SUM(CAST(new_deaths AS SIGNED))/SUM(new_cases)*100
FROM project2.covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

SELECT * FROM project2.covid_vaccine
ORDER BY 3;

-- Joining both tables

-- SELECT *
-- FROM project2.covid_deaths dea
-- JOIN project2.covid_vaccine vac
 --	ON dea.location = vac.location
  --  AND dea.date = vac.date
    
-- total population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER(PARTITION BY dea.Location ORDER BY dea.location, dea.date)
AS RollingPeopleVaccinated
FROM project2.covid_deaths dea
JOIN project2.covid_vaccine vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;

-- CTE

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccination, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER(PARTITION BY dea.Location ORDER BY dea.location, dea.date)
AS RollingPeopleVaccinated
FROM project2.covid_deaths dea
JOIN project2.covid_vaccine vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac;


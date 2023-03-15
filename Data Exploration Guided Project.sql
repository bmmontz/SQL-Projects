SELECT *
FROM TSQLV4..CovidDeaths

SELECT *
FROM TSQLV4..CovidVaccinations

--Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM TSQLV4..CovidDeaths
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying from contracting Covid in your country
SELECT location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
FROM TSQLV4..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2

--Looking at Total Cases vs Population
--Shows what percentage of the Population contracted Covid
SELECT location, date ,population, total_cases, (total_cases/population)*100 AS PopulationInfectedPercentage
FROM TSQLV4..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2

--Looking at Countries with highest infection rate compared to Population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PopulationInfectedPercentage
FROM TSQLV4..CovidDeaths
--WHERE location LIKE '%states%'
GROUP BY location, population
ORDER BY PopulationInfectedPercentage DESC

--Showing Countries with Highest Death Count per Population
SELECT location, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM TSQLV4..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

--BREAKING THINGS DOWN BY CONTINENT
SELECT continent, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM TSQLV4..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC
--Query above did not add Canada Deaths to North America

SELECT location, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM TSQLV4..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

SELECT continent, MAX(cast(Total_deaths AS INT)) AS TotalDeathCount
FROM TSQLV4..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null 
GROUP BY continent
ORDER BY TotalDeathCount desc

-- GLOBAL NUMBERS

SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS INT)) AS total_deaths, SUM(cast(new_deaths AS INT))/SUM(New_Cases)*100 AS DeathPercentage
FROM TSQLV4..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM TSQLV4..CovidDeaths dea
JOIN TSQLV4..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3



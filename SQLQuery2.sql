select *
from Portfolio..CovidDeaths	
order by 3,4

--Select * 
--from Portfolio..CovidVaccinations
--order by 3,4

select Location, date, total_cases, new_cases, total_deaths, population
from Portfolio..CovidDeaths
order by 1,2

-- Total Cases vs Total Deaths
select Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
from Portfolio..CovidDeaths
where Location =  'India'
order by 1,2

-- Percentage of population that got covid
select Location, date, population, total_cases, total_deaths, (total_cases/population) * 100 as PercentPopulationInfected
from Portfolio..CovidDeaths
where Location =  'India'
order by 1,2

-- Countries with highest infection rate

select Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population)) * 100 as PercentPopulationInfected
from Portfolio..CovidDeaths
group by population, Location
order by PercentPopulationInfected desc

-- Countries with highest death rate

select Location, population, Max(cast(total_deaths as int)) as HighestDeathCount,Max((total_deaths/total_cases)) * 100 as DeathRate
from Portfolio..CovidDeaths
group by Location, population
order by DeathRate desc

-- Total deaths by continent

select location, Max(cast(total_deaths as int)) as TotalDeathCount
from Portfolio..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc


--Global Death Rate
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Portfolio..CovidDeaths
where continent is not null 
order by 1,2

--Total Population vs Vaccinations

/*select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(convert(int, vac.new_vaccinations)) over
	(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from Portfolio..CovidDeaths dea
join Portfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3 */

-- CTE

with PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(convert(int, vac.new_vaccinations)) over
	(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from Portfolio..CovidDeaths dea
join Portfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)	
select *, (RollingPeopleVaccinated / population) * 100
from PopvsVac
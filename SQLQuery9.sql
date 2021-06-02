select *
from CovidAnalysis..CovidDeaths
order by 3,4

select location, date, new_cases, total_deaths, population
from CovidAnalysis..CovidDeaths
order by 1,2


-- Total Cases vs total deaths
-- Shows likelihood of dying if you contact covid in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathRate
from CovidAnalysis..CovidDeaths
where location like '%states%'
order by 1,2

-- Total cases vs total population
-- Shows what percentage of population got covid
select location, date, population, total_cases, (total_cases/population)*100 as DeathRate
from CovidAnalysis..CovidDeaths
--where location like '%india%'
order by 5

-- Loking at Countries  with Highest Infection Rate compared to Population
select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)*100) as PercentPopulationInfected
from CovidAnalysis..CovidDeaths
Group BY location, population
ORDER BY PercentPopulationInfected desc

-- Showing countries with Highest Death Count per population
select location, population, MAX(cast(total_deaths as int)) as HighestDeathsCount, MAX((total_deaths/population)*100) as PercentPopulationdied
from CovidAnalysis..CovidDeaths
where continent is not null
Group BY location, population
ORDER BY HighestDeathsCount desc

-- Lets break things down by continent
select location, MAX(cast(total_deaths as int)) as HighestDeathsCount, MAX((total_deaths/population)*100) as PercentPopulationdied
from CovidAnalysis..CovidDeaths
where continent is null
Group BY location
ORDER BY PercentPopulationdied desc


--Looking at total Population vs Vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidAnalysis..CovidDeaths dea
join CovidAnalysis..CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null and vac.new_vaccinations is not null
order by 2,3


-- Use CTE

with PopvsVac(Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
	select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
		sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	from CovidAnalysis..CovidDeaths dea
	join CovidAnalysis..CovidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
	where dea.continent is not null and vac.new_vaccinations is not null
	--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac


--Create Temp Table

drop table if exists #PercentPopVac
create table #PercentPopVac
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
RollingPeopleVaccinated numeric

)

Insert into #PercentPopVac
	select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
		sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	from CovidAnalysis..CovidDeaths dea
	join CovidAnalysis..CovidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
	where dea.continent is not null and vac.new_vaccinations is not null
	--order by 2,3

select *,(RollingPeopleVaccinated/population)*100
from #PercentPopVac


-- Creating view to store data for later visualization
create view PercentPopVac22 as
	select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
		sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	from CovidAnalysis..CovidDeaths dea
	join CovidAnalysis..CovidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
	where dea.continent is not null and vac.new_vaccinations is not null
	--order by 2,3


select * from PercentPopVac22
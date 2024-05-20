

select * from CovidDeaths
where continent is not null
order by 3,4

select * from CovidVaccinations
where continent is not null
order by 3,4

-- select dataa that we are going to be using

select 
location, date,population, total_cases, new_cases, total_deaths,  
(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like '%state%'
and continent is not null
order by 1,2


select distinct location from CovidDeaths
and continent is not null
order by 1

-- total cases vs population
-- % of population got covid

select 
location, date, total_cases,population,  
(total_cases/population) * 100  as PercentageOfPopulationInfected
from CovidDeaths
where location like '%state%'
and continent is not null
order by 1,2

-- looking at countries with highest infection rate compared to population
select 
location ,population, max(total_cases) as HighestInfectionCount,
Max((total_cases/population)) * 100  as PercentageOfPopulationInfected
from CovidDeaths
--where location like '%state%'
group by location ,population
order by PercentageOfPopulationInfected desc

-- showing the countries with highest death count per population

select 
location , max (cast (Total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%state%'
where continent is not null
group by location ,population
order by TotalDeathCount desc

-------LET's break thinks by continent

--- Showing te continest with highest death count per population

select 
continent , max (cast (Total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%state%'
where continent is not null
group by continent
order by TotalDeathCount desc


select 
continent , max (cast (Total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%state%'
where continent is  null
group by continent
order by TotalDeathCount desc

---------------------------------------------

select 
location , max (cast (Total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%state%'
where continent is  null
group by location
order by TotalDeathCount desc

-- Global numbers

select 
date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths , 
(sum(cast(new_deaths as int)) /sum(new_cases)) * 100  as DeathPercentage
from CovidDeaths
--where location like '%state%'
where continent is not null
group by date
order by 1,2

---------

select 
 sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths , 
(sum(cast(new_deaths as int)) /sum(new_cases)) * 100  as DeathPercentage
from CovidDeaths
--where location like '%state%'
where continent is not null
--group by date
order by 1,2

---------------------------------CovidVaccinations------------------------------
select * from PortfolioProject..CovidDeaths
select * from PortfolioProject..CovidVaccinations



select D.continent,D.location, D.date, D.population, V.new_vaccinations,
sum(convert(int, V.new_vaccinations)) over (partition by D.location order by D.location,D.date)  as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths D join PortfolioProject..CovidVaccinations V
on D.location=V.location
and D.date=V.date
where D.continent is not null
order by 2,3

-------- USE CTE

with PopVsVacc (continent, location,date , population,new_vaccinations, RollingPeopleVaccinated)
as
(
select D.continent,D.location, D.date, D.population, V.new_vaccinations,
sum(convert(int, V.new_vaccinations)) over (partition by D.location order by D.location,D.date)  as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths D join PortfolioProject..CovidVaccinations V
on D.location=V.location
and D.date=V.date
where D.continent is not null
--order by 2,3
)

select *, (RollingPeopleVaccinated/population)*100 from PopVsVacc

-----------USE TEMP TABLE---------

DROP TABLE if exists #PercentPopulationVaccinated;

CREATE TABLE #PercentPopulationVaccinated
(
Continent  nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
);


insert into #PercentPopulationVaccinated

select D.continent,D.location, D.date, D.population, V.new_vaccinations,
sum(convert(int, V.new_vaccinations)) over (partition by D.location order by D.location,D.date)  as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths D join PortfolioProject..CovidVaccinations V
on D.location=V.location
and D.date=V.date
--where D.continent is not null
--order by 2,3


select *, (RollingPeopleVaccinated/population)*100 from #PercentPopulationVaccinated;


--- CREATE VIEW to store data for later visualizatins


create view PercentPopulationVaccinated as
select D.continent,D.location, D.date, D.population, V.new_vaccinations,
sum(convert(int, V.new_vaccinations)) over (partition by D.location order by D.location,D.date)  as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths D join PortfolioProject..CovidVaccinations V
on D.location=V.location
and D.date=V.date
where D.continent is not null
--order by 2,3

select * from PercentPopulationVaccinated;

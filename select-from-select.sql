/*
Bigger than Russia
1.
List each country name where the population is larger than that of 'Russia'.

world(name, continent, area, population, gdp)
*/

SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia')

/*
Richer than UK
2.
Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
Per Capita GDP
*/

SELECT name
FROM world
WHERE continent = 'Europe' 
AND gdp/population > (SELECT gdp/population FROM world WHERE name = 'United Kingdom')

/*
Neighbours of Argentina and Australia
3.
List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the 
country.
*/

SELECT name, continent
FROM world 
WHERE continent IN (SELECT continent FROM world WHERE name = 'Argentina' OR name = 'Australia') 
ORDER BY name

/*
Between Canada and Poland
4.
Which country has a population that is more than Canada but less than Poland? Show the name and the population.
*/

SELECT name, populationFROM world
WHERE population > (SELECT population FROM world WHERE name = 'Canada') AND population < (SELECT population FROM world WHERE name = 'Poland')

/*
Percentages of Germany
5.
Germany (population 80 million) has the largest population of the countries in Europe. Austria (population 8.5 million) has 11% of the population of Germany.
Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.

The format should be Name, Percentage for example:

name	percentage
Albania	3%
Andorra	0%
Austria	11%
...	...
Decimal places
Percent symbol %
*/

SELECT name, CONCAT(round(100*population/(SELECT population FROM world WHERE name = 'Germany')),'%') as percentage
FROM world
WHERE continent = 'Europe'

/*
To get a well rounded view of the important features of SQL you should move on to the next tutorial concerning aggregates.
To gain an absurdly detailed view of one insignificant feature of the language, read on.

We can use the word ALL to allow >= or > or < or <=to act over a list. For example, you can find the largest country in the world, by population with this query:
*/

SELECT name
FROM world
WHERE population >= ALL(SELECT population
                        FROM world
                        WHERE population>0)
/*
You need the condition population>0 in the sub-query as some countries have null for population.

Bigger than every country in Europe
6.
Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)
*/

SELECT name
FROM world
WHERE continent <> 'Europe'AND
gdp > (SELECT MAX(gdp) FROM world WHERE continent = 'Europe')


/*
We can refer to values in the outer SELECT within the inner SELECT. We can name the tables so that we can tell the difference between the inner and outer versions.

Largest in each continent
7.
Find the largest country (by area) in each continent, show the continent, the name and the area:
*/


SELECT continent, name, area 
FROM world x
WHERE area >= ALL
  (SELECT area 
    FROM world y
    WHERE y.continent=x.continent
    AND area>0)

/*
The above example is known as a correlated or synchronized sub-query.

Using correlated subqueries
First country of each continent (alphabetically)
8.
List each continent and the name of the country that comes first alphabetically.
*/

SELECT continent,name
FROM world a
WHERE name <= ALL( SELECT name FROM world b WHERE a.continent = b.continent)

/*
Difficult Questions That Utilize Techniques Not Covered In Prior Sections
9.
Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population.
*/

SELECT name,continent,population
FROM world a
WHERE 25000000 >= ALL(SELECT population FROM world b where a.continent = b.continent)

/*
10.
Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents.
*/

SELECT name,continentFROM world a
WHERE population >= ALL ( SELECT population*3 FROM world b WHERE a.continent = b.continent AND a.name <> b.name)
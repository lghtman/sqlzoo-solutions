-- 1. How many stops are in the database?
SELECT COUNT(id)
  FROM stops
  
-- 2. Find the id value for the stop 'Craiglockhart' 
SELECT id
  FROM stops
 WHERE name = 'Craiglockhart'

-- 3. Give the id and the name for the stops on the '4' 'LRT' service. 
SELECT stops.id
       , stops.name
  FROM stops
       INNER JOIN route
       ON stops.id = route.stop
 WHERE route.num = 4
       AND route.company = 'LRT'

/* 4. The query shown gives the number of routes that visit either London Road (149)
or Craiglockhart (53). Run the query and notice the two services that link these stops 
have a count of 2. Add a HAVING clause to restrict the output to these two routes. */
  SELECT company
         , num
         , COUNT(*)
    FROM route 
   WHERE stop = 149 
         OR stop = 53
GROUP BY company
         , num
  HAVING COUNT(*) = 2

/* 5. Execute the self join shown and observe that b.stop gives all the places 
you can get to from Craiglockhart, without changing routes. Change the query so 
that it shows the services from Craiglockhart to London Road. */
SELECT routeA.company
       , routeA.num
       , routeA.stop
       , routeB.stop
  FROM route routeA
       INNER JOIN route routeB
       ON (a.company = routeB.company 
          AND routeA.num = routeB.num)
 WHERE routeA.stop = 53
       AND routeB.stop = 149

-- 6. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown.
SELECT routeA.company
       , routeA.num
       , stopsA.name
       , stopsB.name
  FROM route routeA 
       INNER JOIN route routeB
       ON (routeA.company = routeB.company 
          AND routeA.num = routeB.num)
       INNER JOIN stops stopsA
       ON (routeA.stop = stopsA.id)
       INNER JOIN stops stopsB 
       ON (routeB.stop = stopsB.id) 
 WHERE stopsA.name = 'Craiglockhart'
       AND stopsB.name = 'London Road'

-- 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith') 
SELECT DISTINCT routeA.company
       , routeA.num
  FROM route routeA
       INNER JOIN route routeB
       ON (routeA.num = routeB.num
          AND routeA.company = routeB.company)
 WHERE routeA.stop = 115
       AND routeB.stop = 137
 

-- 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross' 
SELECT DISTINCT routeA.company
       , routeA.num
  FROM route routeA
       INNER JOIN route routeB
       ON (routeA.num = routeB.num
          AND routeA.company = routeB.company)
       INNER JOIN stops stopsA
       ON routeA.stop = stopsA.id
       INNER JOIN stops stopsB
       ON routeB.stop = stopsB.id
 WHERE stopsA.name = 'Craiglockhart'
       AND stopsB.name = 'Tollcross'

/* 9. Give a distinct list of the stops which may be reached from 'Craiglockhart' 
by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. 
Include the company and bus no. of the relevant services. */
SELECT DISTINCT stopsB.name
       , routeA.company
       , routeA.num
  FROM route routeA
       INNER JOIN route routeB
       ON (routeA.num = routeB.num
          AND routeA.company = routeB.company)
       INNER JOIN stops stopsA
       ON routeA.stop = stopsA.id
       INNER JOIN stops stopsB
       ON routeB.stop = stopsB.id
 WHERE stopsA.name = 'Craiglockhart'

/* 10. Find the routes involving two buses that can go from Craiglockhart to Sighthill.
Show the bus no. and company for the first bus, the name of the stop for the transfer,
and the bus no. and company for the second bus. */
SELECT DISTINCT depart.num
       , depart.company
       , stops.name
       , arrive.num
       , arrive.company

  /* subquery returns all the places you can reach from Craiglockhart
  along with bus num and company to get there */
  FROM (SELECT routeA.company  
               , routeA.num
               , routeB.stop
          FROM route routeA
               INNER JOIN route routeB
               ON (routeA.num = routeB.num
                  AND routeA.company = routeB.company) 
         WHERE routeA.stop = (SELECT id
                                FROM stops
                               WHERE name = 'Craiglockhart')
       ) depart
        
  /* subquery returns all the places you can leave from to reach
  Sighthill along with bus num and company */
  INNER JOIN (SELECT routeC.company
              , routeC.num
              , routeD.stop
                FROM route routeC
                     INNER JOIN route routeD
                     ON (routeC.num = routeD.num
                        AND routeC.company = routeD.company)
               WHERE routeC.stop = (SELECT id
                                      FROM stops
                                     WHERE name = 'Sighthill')
             ) arrive

  -- join the subqueries to find transfer points between routes
  ON (depart.stop = arrive.stop)

  -- join stops table 
  INNER JOIN stops
  ON (depart.stop = stops.id)



         



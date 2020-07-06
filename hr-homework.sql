
--8
SELECT countries.region_id, region_name, country_name
FROM countries, regions
WHERE countries.region_id = regions.region_id
  AND region_name = 'Europe';
  

SELECT countries.region_id, region_name, country_name
FROM countries JOIN regions ON (countries.region_id = regions.region_id)
WHERE region_name = 'Europe';


--9
SELECT countries.region_id, region_name, country_name, city
FROM countries, regions, locations
WHERE countries.region_id = regions.region_id
  AND countries.country_id = locations.country_id
  AND region_name = 'Europe';


SELECT countries.region_id, region_name, country_name, city
FROM countries JOIN regions ON(countries.region_id = regions.region_id)
               JOIN locations ON (countries.country_id = locations.country_id)
where region_name = 'Europe';



--10

SELECT regions.region_id, region_name, country_name, city, department_name
FROM countries JOIN regions ON(countries.region_id = regions.region_id)
               JOIN locations ON (countries.country_id = locations.country_id)
               JOIN departments ON (departments.location_id = locations.location_id)
WHERE region_name = 'Europe';


SELECT regions.region_id, region_name, country_name, city, department_name
FROM countries, regions, locations, departments
WHERE countries.region_id = regions.region_id
  AND countries.country_id = locations.country_id
  AND departments.location_id = locations.location_id
  AND region_name = 'Europe';
  
  
  
--11
SELECT regions.region_id, region_name, country_name, city, department_name
FROM countries JOIN regions ON(countries.region_id = regions.region_id)
               JOIN locations ON (countries.country_id = locations.country_id)
               JOIN departments ON (departments.location_id = locations.location_id)
WHERE region_name = 'Europe';


SELECT regions.region_id, region_name, country_name, city, department_name, first_name || last_name name
FROM countries, regions, locations, departments, employees
WHERE countries.region_id = regions.region_id
  AND countries.country_id = locations.country_id
  AND departments.location_id = locations.location_id
  AND departments.department_id = employees.department_id
  AND region_name = 'Europe';
  
  
SELECT regions.region_id, region_name, country_name, city, department_name, first_name || last_name name
FROM countries JOIN regions ON(countries.region_id = regions.region_id)
               JOIN locations ON (countries.country_id = locations.country_id)
               JOIN departments ON (departments.location_id = locations.location_id)
               JOIN employees ON (departments.department_id = employees.department_id)
WHERE region_name = 'Europe';



--12

SELECT employees.employee_id, first_name || last_name name, jobs.job_id, job_title
FROM jobs, employees
WHERE jobs.job_id = employees.job_id;


SELECT employees.employee_id, first_name || last_name name, jobs.job_id, job_title
FROM jobs JOIN employees ON(jobs.job_id = employees.job_id);




--13
SELECT e.manager_id mgr_id, (m.first_name || m.last_name),(e.first_name || e.last_name) name, e.job_id, job_title
FROM employees e, employees m, jobs
WHERE m.employee_id = e.manager_id
  AND jobs.job_id = e.job_id;
  
  
  
SELECT e.manager_id mgr_id, (m.first_name || m.last_name),(e.first_name || e.last_name) name, e.job_id, job_title
FROM employees e JOIN employees m ON (m.employee_id = e.manager_id)
                 JOIN jobs ON(jobs.job_id = e.job_id);
  
  


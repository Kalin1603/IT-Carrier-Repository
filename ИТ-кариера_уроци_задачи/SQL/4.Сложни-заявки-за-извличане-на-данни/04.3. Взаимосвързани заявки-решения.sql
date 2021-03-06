USE soft_uni;

-- 01. Най-висока заплата по длъжности
SELECT DISTINCT e.job_title, e.salary FROM employees e 
WHERE e.salary = 
  (SELECT es.salary FROM employees es
   WHERE es.job_title = e.job_title
   ORDER BY es.salary DESC LIMIT 1)
ORDER BY e.salary DESC, e.job_title

-- 02. Най-ниско платени служители по отдели
SELECT DISTINCT e.first_name, e.last_name, e.salary
  (SELECT d.name from departments d 
   WHERE d.department_id = e.department_id) as department
FROM employees e 
WHERE e.salary = 
  (SELECT es.salary FROM employees es
   WHERE d.department_id = es.department_id
   ORDER BY es.salary ASC LIMIT 1)
ORDER BY e.salary, e.first_name, e.last_name

-- 03. Мениджъри с същото презиме (1)
SELECT m.first_name, m.last_name FROM employees m 
WHERE (m.employee_id, m.middle_name) IN 
  (SELECT manager_id, middle_name FROM employees) 
ORDER BY m.first_name, m.last_name

-- 03. Мениджъри с същото презиме (2)
SELECT m.first_name, m.last_name FROM employees m 
WHERE m.employee_id IN (SELECT DISTINCT manager_id FROM employees)
  AND EXISTS (SELECT 1 FROM employees e
              WHERE e.manager_id = m.employee_id 
			    AND e.middle_name = m.middle_name)
ORDER BY m.first_name, m.last_name

-- 04. Мениджъри с по-ниска заплата
SELECT m.first_name, m.last_name
FROM employees m 
WHERE m.employee_id IN (SELECT DISTINCT manager_id FROM employees)
  AND m.salary < ANY (SELECT salary FROM employees WHERE manager_id = m.employee_id)
  
-- 05. Мениджъри с точно 5 подчинени
SELECT e.first_name, e.last_name
FROM employees e 
WHERE e.employee_id IN (SELECT DISTINCT manager_id FROM employees)
  AND EXISTS (SELECT 1 FROM employees WHERE manager_id = e.employee_id LIMIT 4,1)
  AND NOT EXISTS (SELECT 1 FROM employees WHERE manager_id = e.employee_id LIMIT 5,1)
ORDER BY e.first_name, e.last_name

USE geography;

-- 06. Планините в България
SELECT mountain_range,  
       (SELECT peak_name FROM peaks WHERE mountain_id = m.id ORDER by elevation DESC LIMIT 1) peak_name,
       (SELECT elevation FROM peaks WHERE mountain_id = m.id ORDER by elevation DESC LIMIT 1) elevation
 FROM mountains m  
 WHERE id IN (SELECT mountain_id FROM mountains_countries WHERE country_code = 'BG')
 ORDER BY elevation DESC

-- 07. Неописаните планини в България 
SELECT mountain_range from mountains m  
 WHERE id IN (SELECT mountain_id FROM mountains_countries WHERE country_code = 'BG')
   AND NOT EXISTS (SELECT 1 FROM peaks WHERE mountain_id = m.id)


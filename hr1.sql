desc employees;

-- [1]
select employee_id
, concat(first_name, ' ', last_name) as name
, salary
, job_id
, hire_date
, manager_id
from employees;

-- [2] HR 부서에서 예산 편성 문제로 급여 정보 보고서를 작성하려고 한다. 사원정보
-- (EMPLOYEES) 테이블에서 급여가 $7,000~$10,000 범위 이외인 사람의 성과 이름(Name으로 별칭) 및 급여를 급여가 작은 순서로 출력하시오.
SELECT concat(first_name, ' ', last_name) as 'Name'
, salary
FROM employees
#WHERE salary < 7000 
#OR salary > 10000
WHERE salary not between 7000 and 10000
ORDER BY salary asc;

-- [3] 사원의 이름(last_name) 중에 ‘e’ 및 ‘o’ 글자가 포함된 사원을 출력하시오. 이때 머리글은 ‘e and o Name’라고 출력하시오.
SELECT concat(first_name, ' ', last_name)
FROM employees
WHERE last_name LIKE '%e%' OR last_name LIKE '%o%';

desc employees;
show tables;
desc jobs;

-- [4] HR 부서에서는 급여(salary)와 수당율(commission_pct)에 대한 지출 보고서를 작성하려고 한다. 이에 수당을 받는 모든 사원의 성과 이름(Name으로 별칭), 급여, 업무, 수당율, 연봉 출력을 출력하시오. 이때 급여가 큰 순서대로 정렬하되, 급여가 같으면 수당율이 큰 순서대로 정렬하시오.
SELECT concat(e.first_name, ' ', e.last_name) as 'Name'
, e.salary
, e.commission_pct, e.salary * 12*(1+e.commission_pct) as 'Annual Salary'
FROM employees as e
WHERE commission_pct IS NOT NULL
ORDER by 'Annual Salary' desc, commission_pct desc;

select job_id
from employees;

-- [5] 사원들의 업무별 전체 급여 평균이 $10,000보다 큰 경우를 조회하여 업무, 급여 평균을 출력하시오. 단 업무에 사원(CLERK)이 포함된 경우는 제외하고 전체 급여 평균이 높은 순서대로 출력하시오.
SELECT job_id, avg(salary)
FROM employees as e 
WHERE job_id not LIKE '%clerk%'
GROUP BY job_id
HAVING AVG(salary)> 10000
order by avg(salary) desc;

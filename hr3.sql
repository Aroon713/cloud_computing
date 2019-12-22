-- [1] HR 스키마에 있는 Employees, Departments 테이블의 구조를 파악한 후 사원수가 5명 이상인 부서의 부서명과 사원수를 출력하시오. 이때 사원수가 많은 순으로 정렬하시오.
	-- employees, departments
desc employees;
desc departments;

select d.department_name, count(d.department_id)
from employees as e
join  departments as d 
on e.department_id = d.department_id
group by d.department_id
having count(d.department_id) >= 5
order by count(d.department_id) desc;


-- [2] 각 사원의 급여에 따른 급여 등급을 보고하려고 한다. 급여 등급은 JOB_GRADES 테이블에 표시된다. 해당 테이블의 구조를 살펴본 후 사원의 성과 이름(Name으로 별칭), 업무, 부서명, 입사일, 급여, 급여등급을 출력하시오.
	-- employees, departments, job_grades
desc job_grades;

desc employees;
select *
from job_grades;

select concat(e.first_name, ' ', e.last_name) as 'Name'
, e.job_id
, d.department_name
, e.hire_date
, e.salary
, g.grade_level
from employees as e 
INNER JOIN departments as d ON e.department_id=d.department_id
, job_grades as g
WHERE e.salary between g.lowest_sal and highest_sal
order by e.salary desc
;

-- [3] 사원의 급여 정보 중 업무별 최소 급여를 받고 있는 사원의 성과 이름(Nam으로 별칭), 업무, 급여, 입사일을 출력하시오.
select concat(e1.first_name, ' ', e1.last_name) as 'Name'
, e1.job_id
, e1.salary
, e1.hire_date
from employees as e1 
INNER JOIN (select min(e2.salary) as minsal, e2.job_id
from employees as e2
group by e2.job_id) as A
on e1.salary = A.minsal and e1.job_id = A.job_id
order by e1.salary asc, Name asc
;

select concat(e1.first_name, ' ', e1.last_name) as 'Name'
, e1.job_id
, e1.salary
, e1.hire_date
from employees as e1 
WHERE salary in (select min(e2.salary)
from employees as e2
group by e2.job_id)
order by e1.salary, Name asc
;

-- 오답 -> 급여는 최소 값이지만 사람이름이 매칭이 안됨
select concat(e.first_name, ' ', e.last_name) as 'Name'
, e.job_id
, min(e.salary)
, e.hire_date
-- , e.department_id
from employees as e
group by e.department_id
HAVING e.department_id is not null;


-- [4] 소속 부서의 평균 급여보다 많은 급여를 받는 사원에 대하여 사원의 성과 이름(Name으로 별칭), 급여, 부서번호, 업무를 출력하시오
select concat(e.first_name, ' ', e.last_name) as 'Name'
, e.salary
, A.AVG_Salary
, e.department_id
, e.job_id
from employees as e
,(
	select avg(e.salary) as AVG_Salary, e.department_id
	from employees as e
	group by e.department_id
	HAVING e.department_id) as A
WHERE e.salary > A.AVG_Salary and e.department_id = A.department_id
;
					
-- [5] 사원정보(Employees) 테이블에 JOB_ID는 사원의 현재 업무를 뜻하고, JOB_HISTORY에 JOB_ID는 사원의 이전 업무를 뜻한다. 이 두 테이블을 교차해보면 업무가 변경된 사원의 정보도 볼 수 있지만 이전에 한번 했던 같은 업무를 그대로 하고 있는 사원의 정보도 볼 수 있다. 이전에 한번 했던 같은 업무를 보고 있는 사원의 사번과 업무를 출력하시오.
-- 위 결과를 이용하여 출력된 176번 사원의 업무 이력의 변경 날짜 이력을 조회하시오.
desc employees;
desc job_history;
select *
from job_history;

select e.employee_id
	,e.job_id
	from employees as e INNER JOIN job_history as h
    ON e.employee_id = h.employee_id
    where e.job_id = h.job_id
;

-- 내 답
select e.employee_id
,h.job_id
,h.start_date
,h.end_date
from employees as e INNER JOIN job_history as h
ON e.employee_id = h.employee_id
where e.employee_id = 176
;
-- 강사님 답
select employee_id
,job_id
,NULL AS start_date
,NULL AS end_date
from employees 
where employee_id = 176
union 
select employee_id
,job_id
,start_date
,end_date
from job_history 
where employee_id = 176
;


/*
select e.employee_id
, h.job_id
, h.start_date
, h.end_date
from employees as e
INNER JOIN job_history as h
ON e.employee_id = h.employee_id
,	(
    select e.employee_id
	,e.job_id
	from employees as e INNER JOIN job_history as h
    ON e.employee_id = h.employee_id
    where e.job_id = h.job_id
    ) as A
	where e.employee_id = 176
;
*/
/*
수정 필요
select A.employee_id
, A.start_date
, A.end_date
from employees as e1
, job_history as h1
,(
	select e.employee_id
	,e.job_id
	,h.start_date
    ,h.end_date
	from employees as e
	, job_history as h
	where e.job_id = h.job_id) as A
where e1.employee_id = A.employee_id and e1.employee_id=176;
*/
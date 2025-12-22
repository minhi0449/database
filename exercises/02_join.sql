
/*
	INNER JOIN:   [A ∩ B] - A와 B 모두 존재하는 행
	LEFT JOIN:    [A + (A ∩ B)] - A의 모든 행 + 조건에 맞는 B
	RIGHT JOIN:   [B + (A ∩ B)] - B의 모든 행 + 조건에 맞는 A
	FULL JOIN:    [A ∪ B] - A와 B의 모든 행
	CROSS JOIN:   [A × B] - A와 B의 모든 조합
	SELF JOIN:    [A = A] - 동일 테이블을 자신과 조인
*/

-- ------------------------------------------------------------
-- 1. INNER JOIN: [A ∩ B]
-- 두 테이블에서 `emp_no` 가 일치하는 데이터만 반환환

select e.emp_no, e.first_name, d.dept_no
from employees e
inner join dept_emp d on e.emp_no = d.emp_no
limit 5;

-- 2. LEFT JOIN – 왼쪽 테이블 전체 + 오른쪽 매칭된 값
SELECT e.emp_no, e.first_name, e.last_name, de.dept_no
FROM employees e
LEFT JOIN dept_emp de ON e.emp_no = de.emp_no
LIMIT 5;



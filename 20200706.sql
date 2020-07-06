
OUTER JOIN < == > INNER JOIN

INNER JOIN : 조인 조건을 만족하는 (조인에 성공하는) 데이터 조회
OUTER JOIN : 조인 조건을 만족하지 않더라도 (조인에 실패하더라도 ) 기준이 되는 테이블 쪽의
             데이터(컬럼)은 조회가 되도록 하는 조인 방식
             
OUTER JOIN : 
    LEFT OUTER JOIN  : 조인 키워드의 왼쪽에 위치하는 테이블을 기준삼아 OUTER JOIN 시행            
    RIGHT OUTER JOIN : 조인 키워드의 오른쪽에 위치하는 테이블을 기준삼아 OUTER JOIN 시행
    FULL OUTER JOIN  : LEFT OUTER + RIGHT OUTER - 중복되는것 한번 제외     --쓰는 경우는 드물다.
    
    
ANSI-SQL
FROM 테이블1 LEFT OUTER JOIN 테이블2 ON (조인 조건)

ORACLE-SQL : 데이터가 없는데 나와야하는 테이블의 컬럼   --부족하니까 채워준다는 느낌
FROM 테이블1, 테이블2
WHERE 테이블1.컬럼 = 테이블2.컬럼(+)





ANSI-SQL OUTER
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

OARCLE-SQL OUTER
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e , emp m 
WHERE e.mgr = m.empno (+);




OUTER JOIN 시 조인조건 (ON 절에 기술)과 일반 조건(WHERE 절에 기술)적용시 주의 사항
: OUTER JOIN 을 사용하는데 WHERE 절에 별도의 다른 조건을 기술할 경우 원하는 결과가 안나올 수 있다.
  ==> OUTER JOIN의 결과가 무시
  
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno )
WHERE m.deptno = 10;
  
위의 쿼리는 OUTER JOIN 을 적용하지 않은 아래 쿼리와 동일한 결과를 나타낸다.

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno )
WHERE m.deptno = 10;
  
==> 쓰려면 ON절에다 적용하자



SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e , emp m
WHERE e.mgr = m.empno (+) 
  AND m.deptno (+) = 10;    -- +를 붙인 테이블에 해당하는 컬럼들은 모두 + 붙여줘야 한다.






RIGHT OUTER JOIN : 기준 테이블이 오른쪽

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);


FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);  :14건
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno); :21건


FULL OUTER JOIN : LEFT OUTER + RIGHT OUTER - 중복

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

--ORACLE SQL에서는 FULL OUTER 문법을 제공하지 않음



SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)

UNION

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)

MINUS

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);





SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)

UNION

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)

INTERSECT

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);


-------------------------------------------------------------
--배운것중 중요한것 3개 뽑자면?
WHERE : 행을 제한
JOIN 
GROUP FUNCTION


시도 : 서울특별시, 충청남도
시군구 : 강남구, 청주시
스토어 구분




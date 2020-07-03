--복습
GROUP 함수의 특징
1. NULL은 그룹함수 연산에서 제외가 된다
부서번호별 사원의 sal, comm 컬럼의 총 합 구하기


SELECT deptno, SUM(sal) + SUM(comm), SUM(sal + comm)
FROM emp
GROUP BY deptno;



NULL 처리의 효율
SELECT deptno, SUM(sal) + NVL(SUM(comm) , 0),  --이게 더 좋음
               SUM(sal) + SUM(NVL(comm , 0)) 
               FROM emp
GROUP BY deptno;



---칠거지악 3번  조건문 3중첩 이상하지마라~~~




실습1]

SELECT *
FROM emp;


SELECT MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp;



SELECT deptno ,MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno;




SELECT DECODE (deptno, 30, 'ACCOUNTING', 
                       20, 'RESEARCH', 
                       10, 'SALES', 
                       40, 'OPERATING', 
                       'DDIT') dname,
      max_sal, min_sal, avg_sal, sum_sal, cnt_sal, mgr_sal, cnt_all
FROM (SELECT  deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal)sum_sal, 
              COUNT(sal) cnt_sal, COUNT(mgr) mgr_sal, COUNT(*) cnt_all
     FROM emp
     GROUP BY deptno) v;
     
     
SELECT DECODE(deptno, 30, 'ACCOUNTING', 
                      20, 'RESEARCH', 
                      10, 'SALES', 
                      40, 'OPERATING', 
                       'DDIT') dname, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal)sum_sal, 
              COUNT(sal) cnt_sal, COUNT(mgr) mgr_sal, COUNT(*) cnt_all
FROM emp
GROUP BY deptno;



SELECT DECODE(deptno, 30, 'ACCOUNTING', 
                      20, 'RESEARCH', 
                      10, 'SALES', 
                      40, 'OPERATING', 
                       'DDIT') dname, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal)sum_sal, 
              COUNT(sal) cnt_sal, COUNT(mgr) mgr_sal, COUNT(*) cnt_all
FROM emp
GROUP BY DECODE(deptno, 30, 'ACCOUNTING', 
                      20, 'RESEARCH', 
                      10, 'SALES', 
                      40, 'OPERATING', 
                       'DDIT');
          


[실습4]
SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM'); --가공한 컬럼으로도 그룹지을 수 이음
     

[실습5]
SELECT TO_CHAR(hiredate, 'YYYY') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY'); --가공한 컬럼으로도 그룹지을 수 이음


[실습6]
SELECT COUNT(*) cnt
FROM dept;


[실습7]
SELECT COUNT(*) cnt
FROM(SELECT deptno
     FROM emp
     GROUP BY deptno);



SELECT COUNT(COUNT(deptno)) cnt
FROM emp
GROUP BY deptno

--칠거지악 5번, IN-LINE-VIEW 가 정말 필요한건지 확인하자. 가급적 쓰지맙시다.



--------------------------------------------------------------
JOIN : 컬럼을 확장하는 방법 (데이터를 연결한다)
       다른 테이블의 컬럼을 가져온다
       
RDBMS가 중복을 최소화하는 구조이기 때문에
하나의 테이블에 데이터를 전부 담지않고, 목적에 맞게 설계한 테이블에
데이터가 분산이 된다.
하지만 데이터를 조회할 때 다른 테이블의 데이터를 연결하여 컬럼을 가져올 수 있다.

SELECT empno, ename, deptno, 'RESEARCH'
FROM emp
WHERE empno = 7369;


ANSI-SQL : American National Standard Institute .... SQL
ORACLE-SQL 문법

JOIN : ANSI-SQL
       ORACLE-SQL의 차이가 다소 발생     --둘중 선택 회사마다 다름
       
       
ANSI-SQL join
NATURAL JOIN : 조인하고자 하는 테이블간 컬럼명이 동일할 경우 해당 컬럼으로
               행을 연결
               컬럼 이름 뿐 아니라 데이터 타입도 동일해야함.

문법:
SELECT 컬럼...
FROM 테이블1 NATURAL JOIN 테이블2


--emp,dept 두 테이블의 공통된 이름을 갖는 컬럼 : deptno


SELECT empno, ename , emp.deptno, dname   --동일한 이름의 컬럼이 있을때, 한정자를 사용해서 emp.  , --단 JOIN으로 기준이되는 컬럼은 한정자 사용불가
FROM emp NATURAL JOIN dept;
--조인 조건으로 사용된 컬럼은 테이블 한정자를 붙이면 에러 (ANSI-SQL)


위의 쿼리를 ORACLE 버전으로 변경
오라클에서는 조인 조건을 WHERE 절에 기술
행을 제한하는 조건, 조인조건 -> WHERE절에 기술


SELECT emp.*, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno; --오라클에서는 조건으로 사용된 컬럼에 한정자를 사용한다.



--지금배우는 2개는 잘 안씀
ANSI-SQL : JOIN WITH USING
조인 테이블간 동일한 이름의 컬럼이 복수개인데
이름이 같은 컬럼중 일부로만 조인하고 싶을 때 사용

SELECT *
FROM emp JOIN dept USING (deptno);


--위의 쿼리 ORACLE 조인으로 변경하면??
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;



ANSI-SQL : JOIN WITH ON
위에서 배운 NATURAL JOIN, JOIN WITH USING의 경우 조인 테이블의 조인컬럼이
이름이 같아야한다는 제약 조건이 있음
설계상 두 테이블의 컬럼이름이 다를 수도 있음. 컬럼 이름이 다를경우
개발자가 직접 조인 조건을 기술할 수 있ㄷ록 제공해주는 문법



--이거 하나면 ANTI SQL 끝
SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);



SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;



SELF-JOIN : 동일한 테이블끼리 조인할 때 지칭하는 명칭
            (별도의 키워드가 아니다)

--사원번호, 사원이름, 사원의 상사 사원번호, 상사의 이름?

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno);
--KING의 경우 상사가 없기떄문에 조인에 실패한다 - 총 행의수는 13건

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;



--사원중 사원의 번호가 7369~7698인 사원만 대상으로 
--해당 사원의 사원번호, 이름, 상사의 사원번호, 상사의 이름


SELECT e.empno, e.ename, e.mgr, m.ename  
FROM emp e, emp m
WHERE e.empno BETWEEN 7369 AND 7698
  AND e.mgr = m.empno;





--외우는게 아닌 논리적으로만 생각해보자
NON-EQUI-JOIN : 조인 조건이 =이 아닌 조인

!= 값이 다르면 연결을 해라

SELECT *
FROM emp;

SELECT *
FROM salgrade;


SELECT emp.*, grade 
FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal;

--빠지는값없이 연달아 이어지는걸 선분이력이라고 함 (salgrade table)




[실습1]
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
ORDER BY dname;



SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.deptno IN(10,30);




--프로그래머스 사이트, 코딩테스트연습 SQL 고득점 kit : mySQL

과제: 노마드 코더 (유투버) - 누구나 코딩을 할 수 있다? 5가지 팩폭 드림 https://www.youtube.com/watch?v=ThGbP9wgkz8&t=1s
                        - https://www.youtube.com/watch?v=U-lmrnJIcSA

join 0_2~0_4 3문제

SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND sal > 2500;


SELECT empno, ename, sal, emp.deptno, dname
FROM emp , dept
WHERE emp.deptno = dept.deptno
  AND sal >2500
  AND empno > 7600;


SELECT empno,ename,sal, emp.deptno,dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND sal > 2500
  AND empno > 7600
  AND dname in ('RESEARCH');
  

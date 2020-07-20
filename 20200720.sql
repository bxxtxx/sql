





SELECT DECODE(GROUPING(job), 0 , job, 1, '총계') job, SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

    /*
    job 컬럼이 소계계산으로 사용되어 null값이 나온것인지 알려면
    GROUPING 함수를 사용해야 정확한 값을 알 수 있다.
    */


GROUPING(column) : 0, 1
0 : 컬럼이 소계 계산에 사용되지 않았다.  (GROUP BY 컬럼으로 사용됨)
1 : 컬럼이 소계 계산에 사용되었다.




NVL 함수를 사용하지 않고 GROUPING 함수를 사용해야하는 이유

SELECT job, mgr, GROUPING(job), GROUPING(mgr), SUM(sal)
FROM emp
GROUP BY ROLLUP(job,mgr);





SELECT DECODE(GROUPING(job), 0 , job, 1, '총') job, 
       DECODE(GROUPING(deptno), 0 , TO_CHAR(deptno), 1, DECODE(GROUPING(job), 0 , '소계', 1, '계')) deptno
FROM emp
GROUP BY ROLLUP (job, deptno);




SELECT DECODE(GROUPING(job), 0 , job, 1, '총') job, 
       DECODE(GROUPING(deptno) + GROUPING(job), 0 , TO_CHAR(deptno), 1, '소계', '계') deptno
FROM emp
GROUP BY ROLLUP (job, deptno);




SELECT deptno, job, SUM(sal) + NVL(SUM(comm),0) sal
FROM emp
GROUP BY ROLLUP (deptno, job);


SELECT *
FROM emp
ORDER BY deptno;




SELECT dname, job, sal
FROM dept RIGHT OUTER JOIN 
    (SELECT deptno, job, SUM(sal) + NVL(SUM(comm),0) sal
     FROM emp
     GROUP BY ROLLUP (deptno, job)) a ON (dept.deptno = a.deptno);


SELECT dname, job,SUM(sal)
FROM dept JOIN emp ON (dept.deptno = emp.deptno)
GROUP BY ROLLUP (dname, job);


SELECT (SELECT dname FROM dept WHERE dept.deptno = emp.deptno) dname, job, SUM(sal) + NVL(SUM(comm),0) sal
     FROM emp
     GROUP BY ROLLUP (deptno, job);





SELECT DECODE(GROUPING(dname), 0, dname, 1, '총')dname, 
       DECODE(GROUPING(dname) + GROUPING(job), 0, job,1, '소계','계')job , 
       SUM(sal)
FROM dept JOIN emp ON (dept.deptno = emp.deptno)
GROUP BY ROLLUP (dname, job);




---------------------------------------------------------------------
확장된 GROUP BY
1. ROLLUP (O) 
    -- 컬럼 기술에 방향성이 존재
    -- GROUP BY ROLLUP (job, deptno) != GROUP BY ROLLUP (deptno, job) 
    
    -- 단점: 개발자가 필요가 없는 서브 그룹을 임의로 제거할 수 없다.
    
2. GROUPING SETS (O) -- 필요한 서브그룹을 임의로 지정하는 형태
    -- 복수의 GROUP BY 를 하나로 합쳐서 결과를 돌려주는 형태 
   GROUP BY GROUPING SETS(col1, col2)
   
   GROUP BY col1
   UNION ALL
   GROUP BY col2
   
    -- GROUPING SETS 의 경우 ROLLUP 과는 다르게 컬럼 나열순서가 데이터 자체에 영향을 미치지 않음
    
    
    
    
   복수 컬럼으로 GROUP BY 
   GROUP BY col1, col2
   UNION ALL
   GROUP BY col1
   ==> GROUPING SETS ((col1, col2), col1)
    

3. CUBE (X) -- 실 생활에는 잘 안쓰임. 하지만 시험에는 잘나옴



GROUPING SETS 실습



SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal_sum
FROM emp
GROUP BY GROUPING SETS(job, deptno);



SELECT job, (null)deptno, SUM(sal + NVL(comm, 0)) sal_sum
FROM emp
GROUP BY job

UNION ALL

SELECT null, deptno, SUM(sal + NVL(comm, 0)) sal_sum
FROM emp
GROUP BY  deptno;





SELECT job, deptno, mgr, SUM(sal+ NVL(comm, 0)) sal_sum
FROM emp
GROUP BY GROUPING SETS((job, deptno), mgr);





3. CUBE
GROUP BY를 확장한 구문
CUBE절에 나열한 모든 가능한 조합으로 서브그룹을 생성
GROUP BY CUBE (job, deptno)

GROUP BY job, deptno
GROUP BY job
GROUP BY      deptno
GROUP BY 

SELECT job, deptno, SUM(sal + NVL(comm, 0))
FROM emp
GROUP BY CUBE(job, deptno);


CUBE 의 경우 기술한 컬럼으로 모든 가능한 조합으로 서브그룹을 생성한다.
가능한 서브그룹은 2^기술한컬럼개수
기술한 컬럼이 3개만 넘어도 생성되는 서브그룹의 개수가 8개가 넘기 때문에
실제 필요하지 않은 서브그룹이 포함될 가능성이 높다 
    ==> ROLLUP, GROUPING SETS 보다 활용성이 떨어진다.

-------------------------------------------------------------------------
중요한내용은 아님
GROUP BY job, ROLLUP (deptno), CUBE(mgr)
==> 내가 필요로하는 서브그룹은 GROUPING SETS를 통해 정의하면 간단하게 작성 가능.





GROUP BY job, ROLLUP (deptno), CUBE(mgr)

ROLLUP (deptno) : GROUP BY deptno
                  GROUP BY ''
CUBE(mgr) : GROUP BY mgr
            GROUP BY ''


GROUP BY job, deptno, mgr
GROUP BY job, deptno
GROUP BY job,         mgr
GROUP BY job



SELECT job, deptno, mgr, SUM(sal)
FROM emp
GROUP BY job, ROLLUP (deptno), CUBE(mgr);


SELECT job, deptno, mgr, SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY job, ROLLUP(job, deptno), cube(mgr);


1. 서브그룹

job     deptno mgr
job     deptno
job            mgr
job



CREATE TABLE emp_test AS
SELECT *
FROM emp;


ALTER TABLE emp_test add (dname VARCHAR2(14));


SELECT *
FROM emp_test;


WHERE 절이 존재하지않음 ==> 모든 행에 대해서 업데이트를 실행
UPDATE emp_test SET dname = (SELECT dname FROM dept WHERE dept.deptno = emp_test.deptno);


CREATE TABLE dept_test AS
SELECT *
FROM dept;


ALTER TABLE dept_test ADD (empcnt NUMBER(8));



UPDATE dept_test SET empcnt = (SELECT COUNT(*)
                               FROM emp
                               WHERE dept_test.deptno = emp.deptno
                               GROUP BY deptno);


SELECT *
FROM dept_test;


SELECT  mgr , job,  SUM(sal)
FROM emp
GROUP BY ROLLUP(job, mgr);


SELECT  mgr , job,  SUM(sal)
FROM emp
GROUP BY GROUPING SETS(job, (job, mgr));




CREATE TABLE dept_free AS
SELECT *
FROM dept;


SELECT *
FROM dept_free;

















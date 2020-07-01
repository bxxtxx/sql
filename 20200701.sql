

DECODE : 조건에 따라 반환 값이 다라지는 함수
         ==> 비교, JAVA (IF), SQL - case와 비슷
         단, 비교 연산이 ( = ) 만 가능
         CASE의 WHEN 절에 기술할 수 있는 코드는 참 거짓 판단할 수 있는 코드면 가능
         ex : sal > 1000
         이것과 다르게 DECODE 함수에서는 sal = 1000, sal = 2000 등 비교만 가능
         

DECODE는 가변인자(인자의 갯수가 정해지지 않음, 상황에 따라 늘어날 수도 있다.)를 갖는 함수
문법 : DECODE(기준값[col | expression], 비교값1, 반환값1,  
                                       비교값2, 반환값2,
                                       비교값3, 반환값3, 
                                       .
                                       .
                                       옵션[기준값이 비교값중에 일치하는 값이 없을 때 기본적으로 변환할 값])
==> java
if(기준값 == 비교값1){return 반환값1}
else if(기준값 == 비교값2){return 반환값2}
else if(기준값 == 비교값3){return 반환값3}
.
.
else
    마지막 인자가 있을경우 마지막 인자를 반환하고
    마지막 인자가 없을경우 null을 반환
    


SELECT empno, ename, deptno,
      DECODE(deptno, 10, 'ACCOUNTING',20,'RESEARCH',30,'SALES',40,'OPERATION','DDIT') dname
FROM emp;


SELECT ename, job, sal,
      DECODE(job,'SALESMAN', sal * 1.05, 'MANAGER', sal * 1.10, 'PRESIDENT', sal * 1.20, sal * 1 ) bonus
FROM emp;




--위의 문제처럼 job에 따라 sal를 인상을 한다 단, 추가조건으로 manager이면서 소속번호가 30번이면 , sal * 15

SELECT ename, job, sal, deptno,
      CASE
        WHEN job = 'SALESMAN' THEN sal *1.05
        WHEN job = 'MANAGER' AND deptno = 30 THEN sal *1.50
        WHEN job = 'MANAGER' THEN sal *1.10
        WHEN job = 'PRESIDENT' THEN sal *1.20
        ELSE sal * 1
      END bonus
FROM emp;




SELECT ename, job, sal, deptno,
      CASE
        WHEN job = 'SALESMAN' THEN sal *1.05
        WHEN job = 'MANAGER' THEN 
                                  CASE
                                     WHEN deptno = 30 THEN sal * 1.50
                                     ELSE sal * 1.10
                                  END
        WHEN job = 'PRESIDENT' THEN sal *1.20
        ELSE sal * 1
      END bonus
FROM emp;




SELECT ename, job, sal, deptno,
      DECODE(job, 'SALESMAN', sal *1.05,
                  'MANAGER' , DECODE(deptno, 30, sal * 1.50, 
                                                 sal * 1.10),
                  'PRESIDENT' ,sal *1.20,
                   sal * 1)bonus
FROM emp;



SELECT empno, ename, hiredate,
    CASE
        WHEN MOD(TO_CHAR(SYSDATE,'YYYY'), 2) = 0 THEN 
                                                    CASE
                                                         WHEN MOD(TO_CHAR(hiredate,'YYYY'), 2) = 1 THEN '검강검진 비대상자'
                                                         ELSE'검강검진 대상자'
                                                    END
        ELSE
            CASE
                 WHEN MOD(TO_CHAR(hiredate,'YYYY'), 2) = 0 THEN '검강검진 비대상자'
                 ELSE'검강검진 대상자'
            END
    END contact_to_doctor
FROM emp;


contact_to_doctor
SELECT userid, usernm, alias, reg_dt, 
    DECODE((MOD(TO_CHAR(reg_dt,'YYYY'), 2)),
            MOD(TO_CHAR(SYSDATE,'YYYY'), 2 ), '건강검진 대상자',
                                             '건강검진 비대상자')contact_to_doctor
FROM users;



-----참고 : 통곡의 벽
java : 배열, 객체(Class), thread.....
SQL : GROUP함수


DELETE emp
WHERE empno = 9999;
COMMIT;


---------------------------------------------------------------------

그룹함수 : 여러개의 행을 입력으로 받아서 하나의 행으로 결과를 리턴하는 함수

SUM : 합계
COUNT : 행의 수
AVG : 평균
MAX : 그룹에서 가장 큰 값
MIN : 그룹에서 가장 작은 값

사용방법
SELECT 행들을 묶을 기준, 행들을 묶을 기준2, 그룹함수
FROM 테이블
[WHERE]
GROUP BY 행들을 묶을 기준, 행들을 묶을 기준2


SELECT *
FROM emp;


--부서번호별 sal 컬럼의 합
--부서번호가 같은 행들은 하나의 행으로 만든다

SELECT deptno, SUM(sal)
FROM emp
--WHERE ename NOT IN('SMITH')
GROUP BY deptno;

--부서번호별 가장 큰 값을 받는 사람의 급여
--부서번호별 가장 작은
--부서번호별 급여 평균액수
--부서번호별 급여가 존재하는 사람의 수 (sal 컬럼이 NULL이 아닌 행의 수)
-- * : 그 그룹의 행수     //이게 일반적
SELECT deptno , MAX(sal), COUNT(sal), COUNT(*),COUNT(comm)
FROM emp
GROUP BY deptno;


그룹함수의 특징 : 
1. null값을 무시
30번부서의 사원 6명은 comm값이 null

SELECT deptno, SUM(comm)
FROM emp
GROUP BY deptno;

2. GROUP BY를 적용 여러행을 하나의 행으로 묶게 되면
   SELECT 절에 기술할 수 있는 컬럼이 제한됨;
   ==> SELECT절에 기술되는 일반 컬럼들은 (그룸함수를 적용하지 않은)
       반드시 GROUP BY 절에 기술 되어야 한다.
       * 단 그룹핑에 영향을 주지 않는 고정된 상수, 함수는 기술하는것이 가능하다
   
SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno;

SELECT deptno, 10, SYSDATE ,SUM(sal)
FROM emp
GROUP BY deptno;



3. 일반함수를 WHERE절에서 사용하는게 가능
   WHERE UPPER('smith') == 'SMITH';
   그룹함수의 경우 WHERE 절에서 사용하는게 불가능
   하지만 HAVING 절에 기술하여 동일한 결과를 나타낼 수 있다
   
--SUM(sal) 값이 9000보다 큰 행들만 조회하고 싶은 경우

SELECT deptno, SUM(sal)
FROM emp
--WHERE SUM(sal) > 9000
WHERE deptno = 10
GROUP BY deptno;



SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno
HAVING SUM(sal) > 9000;

--위의 쿼리를 having 절 없이

SELECT deptno,k
FROM(SELECT deptno, SUM(sal) k
     FROM emp
     GROUP BY deptno)
WHERE k> 9000;





--SELECT 쿼리 문법 총정리
SELECT
FROM
WHRER
GROUP BY
HAVING
ORDER BY

GROUP BY 절에 행을 그룹핑할 기준을 작성
EX : 부서번호벼로 그룹을 만들경우
     GROUP BY deptno
     
전체행을 기준으로 그루핑을 하려면 GROUP BY 절에 어떤 커럼을 기술해야 할까?
emp테이블에 등록된 14명의 사원 전체의 급여 합계를 구하려면? ==>결과는 1개의 행;
==> GROUP BY 절을 기술하지 않는다.


SELECT SUM(sal)
FROM emp;

--** GROUP BY 절에 기술한 커럼을 SELECT 절에 기술하지 않은 경우 ??
SELECT SUM(sal)
FROM emp
GROUP BY deptno;


--그룹함수의 제한사항
--부서번호별 가장 높은 급여를 받는 사람의 급여액, 그래서 그 사람이 누군데???
--(서브쿼리, 분석함수를 통해 구할 수 있음...)

SELECT deptno, MAX(sal)
FROM emp
GROUP BY deptno;




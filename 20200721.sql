

확장된 GROUP BY
-- 서브그룹을 자동으로 생성
   만약 이런 구문이 없다면 개발자가 직접 SELECT 쿼리를 여러개 작성해서
   UNION ALL 을 시행 -> 동일한 테이블을 여러번 조회 -> 성능 저하
   

1. ROLLUP
    1-1. ROLLUP 절에 기술한 컬럼을 오른쪽에서부터 지워나가며 서브그룹을 생성
    1-2. 생성되는 서브 그룹 : ROLLUP 절에 기술한 컬럼 개수 + 1
    1-3. ROLLUP 절에 기술한 컬럼의 순서가 결과에 영향을 미친다.

2. GROUPING SETS
    2-1. 사용자가 원하는 서브그룹을 직접 지정하는 형태
    2-2. 컬럼 기술의 순서는 결과 집합에 영향을 미치지 않음 (집합)

3. CUBE
    3-1. CUBE 절에 기술한 컬럼의 가능한 모든 조합으로 서브 그룹을 생성
    3-2. 잘 안쓴다..... 서브그룹이 너무 많이 생성됨
        2^(CUBE절에 기술한 컬럼개수)

--------------------------------------------------------------------------


syb_a2]
SELECT *
FROM dept_test;


ALTER TABLE dept_test DROP COLUMN empcnt;

INSERT INTO dept_test VALUES (99,'ddit1', 'daejeon');

INSERT INTO dept_test VALUES (98,'ddit2', 'daejeon');



3. 부서중에 직원이 속하지 않은 부서를 삭제
    1. 비상호 연관
    2. 상호연관
서브쿼리를 사용하여 삭제대상 40 98 99

DELETE dept_test
WHERE NOT EXISTS (SELECT 'x'
                  FROM emp
                  WHERE dept_test.deptno = emp.deptno
                  GROUP BY deptno); --상호

DELETE dept_test
WHERE deptno NOT IN (SELECT deptno
                     FROM emp
                     GROUP BY deptno);   --비상호
                     
                     

DELETE dept_test
WHERE deptno NOT IN (SELECT deptno
                     FROM emp
                     WHERE dept_test.deptno = emp.deptno); --상호

                     

syb_a3]

UPDATE emp_test a SET sal = sal + 200
WHERE sal < (SELECT AVG(sal)
             FROM emp_test b
             WHERE a.deptno = b.deptno);                                       
                                                          





※중복제거
SELECT DISTINCT deptno
FROM emp; --중복을 제거한다는것 자체가 사실 쿼리를 잘못짯을 가능성이 높다. 하지만 내가 필요하면 써보자. 쓰지말자



----------------------------------------------------------------------------------------------

WITH --매우 좋아보이지만, 한 쿼리에서 중복적으로 쿼리가 등장하는것은 잘못 작성된 쿼리일 가능성이 높음.
: 쿼리 블럭을 생성하고 같이 실행되는 SQL에서
  해당 쿼리블럭을 반복적으로 사용할 때 성능 향상 효과를 기대할 수 있다.
  WITH 절에 기술된 쿼리 블럭은 메모리에 한번만 올리기 때문에
  쿼리에서 반복적으로 사용 하더라도 실제 데이터를 가져오는 작업은 한번만 발생
  
  그래도 WTIH 절로 해결하기보다 쿼리를 다른 방식으로 작성 할 수 없는지 먼저 고려해볼것을 추천
  
  *회사의 DB를 다른 외부인에게 오픈할 수 없기 때문에, 외부인에게 도움을 구하고자 할 때
   테이블을 대신할 목적으로 많이 사용

사용방법 : 쿼리 블럭은 콤마를 통해 여러개를 동시에 선언하는것도 가능
WITH 쿼리블럭이름 AS (

    SELECT 쿼리
)
SELECT *
FROM 쿼리블럭이름;

--------------------------------------------------------------------------------
계층쿼리
'202007'
1. 2020년 7월의 일수 구하기

SELECT *
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202007','YYYYMM')),'DD');


LEVEL  --행의 번호정도로 생각하자





'202007'

SELECT MIN(DECODE(d,1,day)), MIN(DECODE(d,2,day)), MIN(DECODE(d,3,day)), MIN(DECODE(d,4,day)), 
                      MIN(DECODE(d,5,day)), MIN(DECODE(d,6,day)), MIN(DECODE(d,7,day))
FROM (SELECT TO_DATE('202007','YYYYMM') + LEVEL - 1 day, 
             TO_CHAR(TO_DATE('202007','YYYYMM') + LEVEL - 1,'D') d,
             (LEVEL + TO_CHAR(TO_DATE('202007','YYYYMM'), 'D') - 2) temp
      FROM dual
      CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202007','YYYYMM')),'DD'))
GROUP BY TRUNC(temp/7)
ORDER BY TRUNC(temp/7);







SELECT MIN(DECODE(d,1,day)) sun,  MIN(DECODE(d,2,day)) mon,  MIN(DECODE(d,3,day)) tue,  
       MIN(DECODE(d,4,day)) wed,  MIN(DECODE(d,5,day)) thu,  MIN(DECODE(d,6,day)) fri,  MIN(DECODE(d,7,day)) sat
FROM(SELECT TO_DATE(:yyyymm,'YYYYMM') + LEVEL - 1 day , 
            TO_CHAR((TO_DATE(:yyyymm,'YYYYMM') + LEVEL - 1), 'D') d,
           (TO_CHAR((TO_DATE(:yyyymm,'YYYYMM')), 'D') + level - 2) temp
     FROM dual
     CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),'DD')) a
GROUP BY TRUNC(temp/7)
ORDER BY TRUNC(temp/7);



--MAX, MIN, SUM ==> MIN 이 좋아
SELECT MAX(DECODE(dt, '01', sum, 0)) jan, MAX(DECODE(dt, '02', sum, 0)) feb, MAX(DECODE(dt, '03', sum, 0)) mar,
       MAX(DECODE(dt, '04', sum, 0)) apr, MAX(DECODE(dt, '05', sum, 0)) may, MAX(DECODE(dt, '06', sum, 0)) jun
FROM(SELECT TO_CHAR(dt, 'MM') dt, SUM(sales) sum
     FROM sales
     GROUP BY  TO_CHAR(dt, 'MM')) a;





SELECT MIN(DECODE(d,1,day)) sun, MIN(DECODE(d,2,day)) mon, MIN(DECODE(d,3,day)) tue, MIN(DECODE(d,4,day)) wed,
       MIN(DECODE(d,5,day)) thu, MIN(DECODE(d,6,day)) fri, MIN(DECODE(d,0,day)) sat
FROM
    (SELECT TO_DATE(:YYYYMM,'YYYYMM') + LEVEL - TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM'),'D') day, 
            TRUNC((LEVEL-1)/7) tr,
            MOD(LEVEL, 7) d
            FROM dual
            CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')),'DD') 
                          + 7 - TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')),'D')
                          + TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM'),'D') - 1 )
GROUP BY tr
ORDER BY tr;

-----------------------------------------------

1. db에 대한 연겅 정보가 필요 (포트)

미리 정의된 포트
http  : 80
https : 443
ftp   : 21


ORACLE : 1521
TOMCAT : 8080
mySQL  : 3306


127.0.0.1 : localhost

SpringToolSuite4 // drive 설정


SELECT *
FROM dept;

-----------------------------------------------------------------------------

CREATE TABLE mem_test (

    mem_no NUMBER(8),
    mem_name VARCHAR2(14),
    mem_phone   NUMBER(11),
    mem_email VARCHAR2(20),
    
    CONSTRAINTS pk_member PRIMARY KEY (mem_no)
    
);









SELECT MIN(DECODE(d,1,day)) sun,  MIN(DECODE(d,2,day)) mon,  MIN(DECODE(d,3,day)) tue,  
       MIN(DECODE(d,4,day)) wed,  MIN(DECODE(d,5,day)) thu,  MIN(DECODE(d,6,day)) fri,  MIN(DECODE(d,7,day)) sat
FROM(SELECT TO_DATE(:yyyymm,'YYYYMM') + LEVEL - 1 day , 
            TO_CHAR((TO_DATE(:yyyymm,'YYYYMM') + LEVEL - 1), 'D') d,
            TO_CHAR((TO_DATE(:yyyymm,'YYYYMM') + LEVEL), 'iw') iw
     FROM dual
     CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),'DD')) a
GROUP BY iw
ORDER BY sat;












































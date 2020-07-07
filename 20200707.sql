--시도, 시군구별, 햄버거 도시발전지수 ==> key 버거킹 맥도날드 /롯데리아
--한 행에 다음과 같이 컬럼이 구성되면 공식을 쉽게 적용할 수 있다.

--시도, 시군구, kfc개수, 버거킹, 맥도날드 개수, 롯데리아 개수

--주어진 것 : 점포 하나 하나의 주소
--1. 시도, 시군구 프렌차이즈 별로 GROUP BY  * 4

--   1-1. 시도, 시군구, kfc 개수
--   1-2. 시도, 시군구, 버거킹 개수
--   1-3. 시도, 시군구, 맥도날드 개수
--   1-4. 시도, 시군구, 롯데리아 개수

--   1-1~1-4 4개의 데이터셋을 이용해서 컬럼 확장이 가능 ==> join
--   시도, 시군구 같은 데이터 끼리 조인



--2. 시도, 시군구, 프렌차이즈 별ㄹ GROUP BY * 2
--   2-1. 시도, 시군구, 분자 프렌차이즈 합 개수
--   2-2. 시도, 시군구, 분모 프렌차이즈 (롯데리아) 합 개수

--   2-1~2-2. 2개의 데이터 셋을 이용해서 컬럼 확장 ==> join
--   시도, 시군구 같은 데이터 끼리 조인





--3. 모든 프렌차이즈를 한번만 읽고서 처리하는 방법
--   3-1. fastfood 테이블의 한 행은 하나의 프렌차이즈에 속함
--   3-2. 가상의 컬럼을 4개 생성
--        3-2-1 해당 row가 kfc면 1
--        3-2-1 해당 row가 맥도날드면 1
--        3-2-1 해당 row가 버거킹면 1
--        3-2-1 해당 row가 롯데리아면 1
--        3-2 과정에서 생성된 컬럼 4개중에 값이 존재하는 컬럼은 하나만 존재함
--            (하나의 행은 하나의 프렌차이즈의 주소를 나타내는 정보)
--   3-3. 시도, 시군구 별로 3.2 과정에서 생성한 컬럼을 더하면 우리가 구하고자 하는
--        프렌차이즈별 건수가 된다.



SELECT sido, sigungu, ROUND((NVL(SUM(DECODE(gb, 'KFC', 1)),0) +
                       NVL(SUM(DECODE(gb, '버거킹', 1)),0) + 
                       NVL(SUM(DECODE(gb, '맥도날드', 1)),0)) /
                       NVL(SUM(DECODE(gb, '롯데리아', 1)),1),2) score
FROM fastfood
GROUP BY sido, sigungu
ORDER BY score DESC;




SELECT storecategory
FROM burgerstore
GROUP BY storecategory;





--순위, 햄버거발전지수 시도, 햄버거발전지수 시군구, 햄버거 발전지수, 근로소득 시도, 근로소득 시군구, 1인당 근로소득액


SELECT burger.*, tax.sido, tax.sigungu, tax.tax
FROM (SELECT ROWNUM rn, sido, sigungu, score
        FROM(SELECT sido, sigungu, ROUND((NVL(SUM(DECODE(gb, 'KFC', 1)),0) + NVL(SUM(DECODE(gb, '버거킹', 1)),0) + NVL(SUM(DECODE(gb, '맥도날드', 1)),0)) /NVL(SUM(DECODE(gb, '롯데리아', 1)),1),2) score
             FROM fastfood
             GROUP BY sido, sigungu
             ORDER BY score DESC)) burger,
        
        (SELECT ROWNUM rn, sido, sigungu, tax
        FROM(SELECT sido, sigungu, ROUND((sal/people),2) tax
             FROM tax
             ORDER BY tax DESC)) tax
WHERE burger.rn(+) = tax.rn
ORDER BY tax.rn;


---------------------------------------------------------------------
CROSS JOIN : 테이블간 조인 조건을 기술하지 않는 형태로
             두 테이블의 행간 모든 가능한 조합으로 조인이 되는 형태
크로스 조인의 조회 결과를 필요로 하는 시스템은 거의 없음
* SQL의 중간 단계에서 필요한 경우는 존재

SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d;


SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e JOIN dept d ON (1=1);


SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e CROSS JOIN dept d;



SELECT *
FROM cycle;


SELECt * 
FROM customer, product;


--------------------------------------------------------------
subquery : SQL 내부에서 사용된 SQL (Main 쿼리에서 사용된 쿼리)
사용위치에 따른 분류 --머리아프게 외울필요는 없음
1. SELECT 절 : scalar(단일의) subquery
2. FROM 절 : INLINE - VIEW
3. WHERE 절 : subquery

반환하는 행, 컬럼 수에 따라
1. 단일행, 단일컬럼
2. 단일행, 복수컬럼
3. 다중행, 단일컬럼
4. 다중행, 복수컬럼

서브쿼리에서 메인쿼리의 커럼을 사용유무에 따른 분류
1. 서브쿼리에서 메인쿼리의 컬럼 사용 : correlated subquery  ==> 상호 연관 서브쿼리
                     ==> 서브쿼리를 단독으로 실행하는것이 불가능
2. 서브쿼리에서 메인쿼리의 컬럼 미사용 : non correlated subquery  ==> 비상호 연관 서브쿼리
                     ==> 서브쿼리를 단독으로 실행하는것이 가능



subquery : 쿼리안에 쿼리가!
SMITH 사원이 속한부서에 속하는 사원들은 누가 있을까??
1. smith가 속한 부서의 번호를 확인하는 쿼리
2. 1번에서 확인한 부서번호로 해당 부서에 속하는 사원들을 조회하는 쿼리



1.
SELECT deptno
FROM emp
WHERE ename = 'SMITH';


SELECT *
FROM emp
WHERE deptno = '20';


SMITH가 현재 상황에서 속한 부서는 20번인데
나중에 30번 부서로 부서전배가 이뤄지면
2번에서 작성한 쿼리가 수정이 되어야한다.

WHERE deptno = '20'; ==> WHERE deptno = '30';


우리가 원하는 것은 고정된 부서번호로 사원 정보를 조회 하는 것이 아니라
SMITH가 속한 부서를 통해 데어터를 조회 ==> SMITH가 속한 부서가 바뀌더라도
쿼리를 수정하지 않도록 하는 것

위에서 작성한 쿼리를 하나로 합칠 수 있다.
==>장점: SMITH의 부서번호가 변경 되더라도 우리가 원하는 데이터 셋을
         쿼리 수정 없이 조회할 수 있다 ==> 코드변경이 필요없다 ==> 유지보수가 편하다
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH'); 




1. 스카라 서브쿼리 : SELECT 절에 사용된 서브쿼리
  *제약사항 : 반드시 서브쿼리가 하나의 행, 하나의 컬럼을 반환해야한다

스칼라 서브쿼리가 다중행 복수컬럼을 리턴하는 경우 (X)
SELECT  empno, ename, (SELECT deptno, dname FROM dept)
FROM emp;


스칼라 서브쿼리가 단일행 복수컬럼을 리턴하는 경우 (X)
SELECT  empno, ename, (SELECT deptno, dname FROM dept WHERE deptno = 10)
FROM emp;


스칼라 서브쿼리가 단일행 단일컬럼 리턴하는 경우 (O)
SELECT  empno, ename, (SELECT deptno FROM dept WHERE deptno = 10) deptno,
                      (SELECT dname FROM dept WHERE deptno = 10) dname
FROM emp;



메인쿼리의 컬럼을 사용하는 스칼라 서브쿼리
SELECT  empno, ename, (SELECT deptno FROM dept WHERE deptno = emp.deptno) deptno
FROM emp;

SELECT e.empno, e.ename, e.mgr, (SELECT m.ename FROM emp m WHERE e.mgr = m.empno) mgr_name
FROM emp e;


IN-LINE-VIEW : 그동안 많이 사용



SUBQUERY : WHERE 절에서 사용 된 것
--SMITH가 속한 부서에 속하는 사원들 조회
--WHERE 절에서 서브 쿼리 사용시 주의점 : 연산자와 서브쿼리의 반환 행수를 주의 - 체크를 잘하자
 = 연산자를 사용시 서브쿼리에서 여러개의 행(값)을 리턴하면 논리적으로 맞지가 않다.
IN 연산자 사용시 서브쿼리에서 리턴하는 여러개 행(값)과 비교가 가능


SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename IN ('SMITH','ALLEN'));               ----X 


SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename IN ('SMITH','ALLEN'));               ----O




[실습1]
SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);

[실습2]
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);







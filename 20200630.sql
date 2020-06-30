
날짜관련 오라클 내장함수
내장함수 : 탑재가 되어있다.
          오라클에서 제공해주는 함수 (많이 사용하니까, 개발자가 별도로 개발하지 않도록)
          

* MONTHS_BETWEEN(date1, date2) : 두 날짜 사이의 개월수를 반환  -- *: 활용도
***** ADD_MONTHS (date1, NUMBER) : DATE1 날짜에 NUMBER 만큼의 개월수를 더하고,
                                   뺀 날짜를 반환
***NEXT_DAY(date1, 주간요일(1~7)) : date1 이후에 등장하는 첫번째 주간요일의 날짜 반환
                                   20200630, 6 ==> 20200703
***LAST_DAY(date1): date1 날짜가 속한 월의 마지막 날짜를 반환
                    20200605 ==> 20200630
                    모든 날의 첫 번째 날짜는 1일로 정해져 있음
                    하지만 달의 마지막 날짜는 다른 경우가 있다.
                    윤년의 경우 2월달이 29일



SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD'),
       MONTHS_BETWEEN(SYSDATE, hiredate)
FROM emp;




SELECT ADD_MONTHS(SYSDATE, 5)aft5,
       ADD_MONTHS(SYSDATE, -5)bef5
FROM dual;



NEXT_DAY : 해당 날짜 이후에 등장하는 첫번째 주간요일의 날짜
SELECT NEXT_DAY(SYSDATE, 7)
FROM dual;


LAST_DAY : 해당 일자가 속한 월의 마지막 일자를 반환

SELECT LAST_DAY(TO_DATE('2020/06/05','YYYY/MM/DD'))
FROM dual;



LAST_DAY는 있지만 FIRST_DAY는 없다 ==> 모든 월의 첫번째 날짜는 동일(1일)
SYSDATE : 20200630 ==> 20200601 로 하고싶다?


1.SYSDATE를 문자로 변경하는 포맷은 YYYYMM
2.1번의 결과에다가 문자열 결합을 통해 '01' 문자를 뒤에 붙여준다.

SELECT TO_DATE(CONCAT(TO_CHAR(SYSDATE, 'YYYYMM'),'01'),'YYYY/MM/DD') first_day
FROM dual;


TO_DATE('201602', 'YYYYMM') --다른 데이터는 가장 작은 값으로 들어간다.

SELECT :day param, MOD(TO_CHAR((LAST_DAY(TO_DATE(CONCAT(:day, '01'), 'YYYYMMDD'))),'YYYYMMDD'), 100) dy
FROM dual;







실행계획 : SQL의 DBMS가 요청받은 SQL을 처리하기위해 세운 절차
          SQL 자체에는 로직이 없다. (어떻게 처리해라??가 없다. java랑 다른점) 
실행계획 보는 방법: 
1.실행계획을 생성
    EXPLAIN PLAN FOR
    실행계획을 보고자 하는 SQL

2.실행계획을 보는 단계
    SELECT *
    FROM TABLE (dbms_xplan.display); --dbms_xplan 패키지안에 display 함수를 사용
    
    
empno 컬럼은 number 타입이지만 형변환이 어떻게 일어 났는지 확인하기 위하여 
의도적으로 문자열 상수 비교를 진행

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);



★★실행계획을 읽는 방법:
1. 위에서 아래로
2. 단, 자식 노드가 있으면 자식 노드부터 읽는다.
   자식노드 : 들여쓰기가 된 노드

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |         --* 는 특별한 정보를 제공할것이 있다.
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369)  --문자열이 숫자로 묵시적으로 형변환이 되었다. --14개중에 7369인 값만 걸러서 보낸다
 
Note
-----
   - dynamic sampling used for this statement (level=2)





EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);




Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter(TO_CHAR("EMPNO")='7369')  
 
Note
-----
   - dynamic sampling used for this statement (level=2)





EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7300 + '69' ; 

SELECT *
FROM TABLE(dbms_xplan.display);


--칠거지악 7번을 확인하자




--SELECT LAST_DAY('2019/01/01')
--FROM dual;

--SELECT ROUND('3.141592', 0)
--FROM dual;

--SELECT ename || 3
--FROM emp;


6,000,000 <===> 6000000
국제화 : i18n - 국가별로 형식이 다르다
    날짜
        한국: YYYY-MM-DD
        미국: MM-DD-YYYY
    숫자
        한국: 9,000,000.00
        독일: 9.000.000,00



sal(NUMBER) 컬럼의 값을 문자열 포멧팅 적용

SELECT ename, sal, TO_CHAR(sal, 'L9,999.00')
FROM emp;


SELECT ename, sal, TO_NUMBER(TO_CHAR(sal, 'L9,999.00'),'L9,999.00')
FROM emp;





NULL과 관련된 함수 : NULL값을 다른값으로 치환하거나, 강제로 NULL을 만드는 것

1.NVL (exprl, expr2)  --null value

    if( expr1 == null) return expr2;
    else return expr1;
    
    
SELECT empno, sal, comm, NVL(comm, 0),
       sal + NVL(comm,0)
FROM emp;
    
    
    
2.NVL2 (expr1, expr2, expr3) 

    if(expr1 != null) return expr2;
    else return expr3


SELECT empno, sal, comm, NVL2(comm, comm ,0),
       sal + NVL2(comm, comm ,0)
FROM emp;



3.NULLIF (expr1, expr2) : null 값을 생성하는 목적
    
    if(expr1 == expr2) return null;
    else return expr1;


SELECT ename, sal, comm, NULLIF(sal,3000)
FROM emp;



4.COALESCE (expr1, expr2.......) : 인자중에 가장 처음으로 null값이 아닌 값을 갖는 인자를 반환

COALESCE(NULL,NULL,30,NULL,50) ==> 30

if(expr1 != null) return expr1;
else COALESCE(expr2, ......);



SELECT COALESCE(NULL,NULL,30,NULL,50)
FROM dual;





NULL처리 실습
emp테이블에 14명의 사원이 존재, 한명을 추가(INSERT)


INSERT INTO emp (empno, ename, hiredate) VALUES (9999, 'brown', NULL);


조회컬럼 : ename, mgr, mgr컬럼값이 널이면 111로 치환한값, 아니면 mgr, hiredate, hiredate가 null이면 sysdate, 아니면 hiredate 

SELECT ename, mgr, NVL(mgr, 111), hiredate, NVL(hiredate, SYSDATE)
FROM emp;


메타(꾸며주다) 인지 : 무엇을 모르는지 아는 것


SELECT COALESCE (mgr, 30)
FROM emp;


실습]
SELECT empno, ename, mgr, NVL(mgr, 9999) mgr_n, NVL2(mgr,mgr,9999) mgr_n_1, coalesce(mgr, 9999) mgr_n_2
FROM emp;


SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE)
FROM users
WHERE userid NOT IN('brown');




-------------------------------------------------------------------------------

SQL 조건문

CASE
    WHEN 조건문 (참, 거짓을 판단할 수 있는 문장) THEN 반환할 값
    WHEN 조건문 (참, 거짓을 판단할 수 있는 문장) THEN 반환할 값2
    WHEN 조건문 (참, 거짓을 판단할 수 있는 문장) THEN 반환할 값3
    ELSE 모든 WHEN 절을 만족시키지 못할 때 반환할 기본 값
END ==>하나의 컬럼으로 취급


emp테이블에 저장된 job 컬럼의 값을 기준으로 급여(sal)를 인상시키려고 한다.
sal컬럼과 함께 인상된 sal 컬럼값을 비교

만약
job = salesman  sal * 1.05
job = manager  sal * 1.10
job = president sal * 1.20
나머지는 그대로



SELECT ename, job, sal, 
       CASE
        WHEN job = 'SALESMAN' THEN sal * 1.05
        WHEN job = 'MANAGER' THEN sal * 1.10
        WHEN job = 'PRESIDENT' THEN sal * 1.20
        ELSE sal 
       END sal_inc
FROM emp;


SELECT empno, ename, 
      CASE
       WHEN deptno = 10 THEN 'ACCOUNTING'
       WHEN deptno = 20 THEN 'RESEARCH'
       WHEN deptno = 30 THEN 'SALES'
       WHEN deptno = 40 THEN 'OPERATIONS'
       ELSE 'DDIT'
      END dname
FROM emp;


--decode 읽어오기, 예제도 해보자 - 이게되면 con1번 decode로 풀어보기




















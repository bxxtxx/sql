

expression : 컬럼값을 가공하거나, 존재하지 않는 새로운 상수값(정해진 값)을 표현하는 것
             연산을 통해 새로운 커럼을 조회할 수 있다.
             연산을 하더라도 해당 sql 조회 결과에만 나올 뿐이고 실제 테이블의 데이터에는
             영향을 주지 않는다.
             SELECT 구문은 테이블의 데이터에 영향을 주지 않음

SELECT * 
FROM emp;


SELECT *
FROM dept;


SELECT sal /100,500
FROM emp;

----------------------------------------------------------------
날짜에 사칙연산 : 수학적으로 정의가 되어 있지 않음
SQL 에서는 날짜데이터 +-정수를 하게되면 ===> 정수를 일수 취급한다.

"2020년 6월 25일" + 5 : 2020년 6월 25일부터 5일 이후 날짜 



데이터 베이스에서 주로 사용하는 데이터 타입 : 문자, 숫자, 날짜
SELECT *
FROM emp;

    테이블의 컬럼구성 정보 확인 : DESC 테이블명 (DESCRIBE 테이블명)
    DESC emp;

SELECT hiredate, hiredate+5, hiredate-5
FROM emp;




users 테이블의 컬럼 타입을 확인하고
reg_dt 컬럼 값에 5일 뒤 날짜를 새로운 컬럼으로 표현
조회 컬럼 : userid, reg_dt, reg_dt 5일뒤

DESC users;
SELECT userid, reg_dt, reg_dt+5
FROM users;

---------------------------------------------------------------------


NULL : 아직 모르는 값, 할당되지 않은 값
NULL과 숫자타입의 0은 다르다
NULL과 문자타입의 공백은 다르다

NULL의 중요한 특징 
    NULL을 피연산자로 하는 연산의 결과는 항상 NULL
    ex: NULL + 500 = NULL
    
ALIAS : 컬럼이나, EXPRESSION에 새로운 이름을 부여
적용 방법: 컬럼, EXPRESSION [AS] 별칭명
별칭을 소문자로 적용하고 싶은경우, 공백을 : 별칭명을 더블 쿼테이션으로 묶는다

emp테이블에서 sal 컬럼과 comm 커럼의 합을 새로운 컬럼으로표현

SELECT empno, ename, sal, comm as "cinnn", sal+ comm AS sal_plus_comm
FROM emp;


실습↓----------------------------------------------------------------

SELECT prod_id AS id, prod_name AS name
FROM prod;

SELECT lprod_gu AS gu, lprod_nm AS nm
FROM lprod;

SELECT buyer_id AS 바이어아이디, buyer_name AS 이름
FROM buyer;

---------------------------------------------------------------------


literal : 값 자체
literal 표기법 : 값을 표현하는 방법

ex: test 라는 문자열을 표기하는 방법
    java: System.out,println("test");        java에서는 더블 쿼테이션으로 문자열을 표기한다.
    sql: 'test'                              sql에서는 싱글 쿼테이션으로 문자열을 표기
    
    
    
    
번외// 
int small = 10;

java 대입 연산자 :        =
pl/sql 대입연산자 :      :=

언어마다 연산자 표기, literal 표기법이 다르기 때문에 해당 언어에서 지정하는 방식을 잘 따라야 한다.



문자열 연산 : 결합
일상생활에서 문자열 결합 연산자가 존재??
java에서 문자열 결합연산자 : +
sql에서 문자열 결합 연산자 : ||
sql에서 문자열 결합 함수 : CONCAT(문자열1, 문자열2) ==> 문자열1||문자열2
                        두개의 문자열을 인자로 받아서 결합결과를 리턴



users 테이블의 userid 컬럼과 usernm 컬럼을 결합

SELECT userid || usernm, CONCAT(userid,usernm) id_name
FROM users;



임의 문자열 결합 (sal + 500, '아이디 :' || userid)

SELECT '아이디 :'||userid id, 500 || 'test'
FROM users;




실습문제
SELECT 'SELECT * FROM '||table_name ||';' QUERY
FROM user_tables;

SELECT CONCAT(CONCAT('SELECT * FROM ',table_name) , ';') QUERY
FROM user_tables;

---------------------------------------------------------------------

WHERE 절: 테이블에서 조회할 행의 조건을 기술
          WHERE 절에 기술한 조건이 참일 때 해당 행을 조회한다.
          SQL에서 가장 어려운 부분, 많은 응용이 발생하는 부분
          
          
          
SELECT *
FROM users
WHERE userid = 'brown';

SELECT *
FROM emp
WHERE deptno >=30 ;

SQL에서 DATE 리터럴 표기법 : 'RR/MM/DD'
    단 서버 설정마다 표기법이 다르다
    한국 : yy/mm/dd
    미국 : mm/dd/yy

    '12/11/01' ==> 국가별로 다르게 해석이 가능하기 떄문에 DATE 리터럴 보다는
    문자열을 DATE 타입으로 변경해주는 함수를 주로 사용!!
    TO_DATE('날짜문자열', '첫번째 인자의 형식')

SELECT *
FROM emp
WHERE hiredate >= '82/01/01';

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01','yyyy/mm/dd');

SELECT *
FROM NLS_SESSION_PARAMETERS;                   참고만!

---------------------------------------------------------------------
BETWEEN AND : 두 값 사이에 위치한 값을 참으로 인식
사용방법 : 비교값 BETWEEN 시작값 AND 종료값
비교값이 시작값과 종료값을 포함하여 사이에 있으면 참으로 인식

SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;


SELECT *
FROM emp
WHERE sal >=1000 AND sal <=2000;



SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01', 'YYYY/MM/DD')
                   AND TO_DATE('1983/01/01', 'YYYY/MM/DD');
                   
                   

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD')
  AND hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD');
  
  
---------------------------------------------------------------------

IN 연산자 : 비교값이 나열된 값에 포함될 떄 참으로 인식
사용방법 : 비교값 IN (비교대상 값 1, 비교대상 값 2, 비교대상 값 3)
                   

사원의 소속 부서가 10번 혹은 20번인 사원을 조회하는 SQL을 IN연산자로 작성

SELECT *
FROM emp
WHERE deptno IN(10,20);
                   

SELECT *
FROM emp
WHERE ename IN('SMITH','JONES','SCOTT','KING','FORD');


---------------------------------------------------------------------

SELECT userid 아이디, usernm 이름, alias 별명
FROM users
WHERE userid IN ('brown', 'cony', 'sally');



SELECT mem_id, mem_name
FROM member
WHERE mem_name like '이%';


SELECT *
FROM emp
WHERE comm IS NOT NULL;


SELECT *
FROM emp
WHERE comm NOT IN (300,500) OR comm is NULL;


SELECT *
FROM emp
WHERE job = 'SALESMAN' 
  AND hiredate >= TO_DATE('19810601','yyyymmdd'); 
                   
            
SELECT *
FROM emp
WHERE deptno != 10
  AND hiredate >= TO_DATE('19810601','yyyymmdd');
                   
                   
SELECT *
FROM emp
WHERE deptno NOT IN (10)
  AND hiredate >= TO_DATE('19810601','yyyymmdd');
  
  
SELECT *
FROM emp
WHERE deptno IN (20, 30)
  AND hiredate >= TO_DATE('19810601','yyyymmdd');
  
  
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR hiredate >= TO_DATE('19810601','yyyymmdd'); 
   
   
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno like '78%' 
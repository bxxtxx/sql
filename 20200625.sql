

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








엔터티 타입 : 테이블
엔터티 : 행


컬럼이 정말 많을떄 -> 수직분할을 하기도함 = 1:1

-------------------------------------------------

정규화

함수종속성 : 어떤 속성군의 값이 정해지면 다른 속성군의 값이 정해지는것
--> 이것만잘 알면 123정규형 까지 문제없음


2정규형 : 식별자가 복합일때만 --> 부분


3정규형 : 일반 컬럼이 다른 일반 컬럼에 종속이될때

* 업데이트를 고려해서 모델링을 하자.


2020.07.29 - 모델링 이론 시험~! 4지선다 객관식



-----------------------------------------------------------

PL / SQL
Procedural Language : 절차적 언어
SQL 언어에 절차적 문법을 추가한 oracle의 언어
SQL은 집합적이지만 실생활에서 발생하는 요구사항을 처리 하기 위해서는
절차적 처리가 필요할 때가 있음.
(복잡한 로직일때 ex - 연말정산 계산)


PL/SQL 블록의 기본구조 - block 
 
 DECLARE : 선언부 
   - 상수, 변수를 선언, 선언이 필요 없을 경우 생략가능
     java와 다르게 지역변수를 선언할 수 없음
     
 BEGIN : 실행부
   - 로직을 서술하는 부분
 EXCEPTION 예외 처리부
   - 예외 발생시 예외 처리 기술 (생략가능)
 
 


화면 출력기능을 활성화 하는 설정
(oracle 접속후 최초 1회만 실행하면 접속종료시까지 유지)

SET SERVEROUTPUT ON;


간단한 PL/SQL 익명 블럭
dept테이블에서 10번 부서의 deptno, dname 두개의 컬럼 값을 조회하고
변수에 담아 화면 출력

java 변수선언 : 변수타입 변수명 = 10;
pl/sql 변수선언 : 변수명 변수타입 := 10;

DECLARE 
    deptno NUMBER(2);
    dname VARCHAR2(14);
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;

    DBMS_OUTPUT.PUT_LINE('deptno: ' || deptno || ', dname : ' || dname); --println    


END;
/


변수 참조 타입
deptno NUMBER(2) ==> deptno dept.deptno%TYPE;
테이블 컬럼 타입 변경이 생겨도, 코드는 수정할 필요가 없어진다
==> 유지보수가 편해진다.






DECLARE 
    deptno dept.deptno%TYPE;
    dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;

    DBMS_OUTPUT.PUT_LINE('deptno: ' || deptno || ', dname : ' || dname); --println    


END;
/


printdept 라는 이름의 프로시저를 생성
인자 : 없음
로직 : dept 테이블에서 10번부서의 부서이름과 부서위치를 로그로 출력

view와 비교
1. view 생성
2. SELECT *
   FROM 생성한 뷰
   
프로시져 절차
1. 프로시져 생성 (CREATE OR REPLACE....)
2. 프로시져 실행 (EXEC 프로시져명)

CREATE OR REPLACE PROCEDURE printdept IS
    --선언부
    deptno dept.deptno%TYPE;
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT deptno, loc ,dname INTO deptno, loc,dname
    FROM dept
    WHERE deptno = 10;

    DBMS_OUTPUT.PUT_LINE('deptno: ' || deptno || ', dname : ' || dname || ', loc : ' || loc); --println    

END;
/

 
프로시져 실행 : exec 프로시져 이름;

EXEC printdept;

printdept 프로시져를 수정
1. 인자를 받게끔 수정(X ==> 부서번호를 인자로 받는다)
2. 받은 인자에 해당하는 부서이름과, 위치 정보를 화면에 출력하도록 수정


java 메소드 : public String 함수명(인자타입1, 인자명1, 인자타입2, 인자명2)
pl/sql 인자 : 프로시져명(인자명1 IN 인자타입1, 인자명2 IN 인자타입2)
             인자명을 : p_접두어를 주로 사용
             변수명은 : v_접두어를 주로 사용
             

CREATE OR REPLACE PROCEDURE printdept(p_deptno IN dept.deptno%TYPE) IS
    --선언부
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    SELECT deptno, loc ,dname INTO v_deptno, v_loc,v_dname
    FROM dept
    WHERE deptno = p_deptno;

    DBMS_OUTPUT.PUT_LINE('deptno: ' || v_deptno || ', dname : ' || v_dname || ', loc : ' || v_loc); --println    

END;
/


EXEC printdept(30);






CREATE OR REPLACE PROCEDURE printemp (p_empno IN emp.empno%TYPE) IS

    v_ename emp.ename%TYPE;
    v_dname dept.dname%TYPE;
    
BEGIN

    SELECT ename, dname INTO v_ename, v_dname
    FROM emp JOIN dept ON (emp.deptno = dept.deptno)
    WHERE empno = p_empno;

    DBMS_OUTPUT.PUT_LINE('ename : ' || v_ename || ' dname : ' || v_dname);

END;
/


EXEC printemp(7654);




CREATE OR REPLACE PROCEDURE registdept_test (p_deptno IN dept.deptno%TYPE, 
                                             p_dname  IN dept.dname%TYPE, 
                                             p_loc    IN dept.loc%TYPE) IS
BEGIN
    INSERT INTO dept_test VALUES(p_deptno, p_dname, p_loc);
END;
/


EXEC registdept_test(45,'ex','ample');


SELECT *
FROM dept_test;






CREATE OR REPLACE PROCEDURE UPDATEdept_test (p_deptno IN dept.deptno%TYPE, 
                                             p_dname  IN dept.dname%TYPE, 
                                             p_loc    IN dept.loc%TYPE) IS
BEGIN
   
   UPDATE dept_test SET dname = p_dname, loc = p_loc
   WHERE deptno = p_deptno;
   
   COMMIT;
END;
/

EXEC UPDATEdept_test(45,'AA','BBABAB');


SELECT *
FROM dept_test;





지금까지 배운 변수 선언
변수명 변수타입
변수명 참조타입(dept.deptno%TYPE)
==> 스칼라 변수, 변수하나에 하나의 값만 할당 가능
    변수 하나에 여러개의 값을 넣을 수 있는 자료형
    배열 ==> list, map, set


변수 ==> 컬럼의 값
컬럼 ====다음====> 행
행 전체를 담을 수 있는 변수


※복합변수
1. 특정 테이블의 행의 모든 컬럼을 담을 수 있는 행 참조변수 : 테이블명%ROWTYPE
2. RECORD TYPE : 사용자 정의 타입
   행의 정보를 담을 수 있는것은 ROWTYPE과 동일, 사용자가 원하는 컬럼에 대해서만 정의 가능
   
3. TABLE TYPE : 복수개의 행을 담을 수 있는 타입
컬럼 => 행 => 복수행


%ROWTYPE
선언 : 변수명 테이블명%ROWTYPE
컬럼 접근방법 : 변수명.컬럼명


dept 테이블의 10번 부서 정보 3가지 컬럼을 %ROWTYPE 으로 받아 화면에 출력


DECLARE
    v_dept_row dept%ROWTYPE;
    
BEGIN
    SELECT * INTO v_dept_row
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row.dname);
END;
/




SET SERVEROUTPUT ON;





DECLARE
    sample dept%ROWTYPE;
    
BEGIN
    SELECT * INTO sample
    FROM dept
    WHERE deptno = 20;
    
    DBMS_OUTPUT.PUT_LINE(sample.dname);

END;
/



CREATE OR REPLACE PROCEDURE sample_pcd (p_deptno IN dept.deptno%TYPE) IS

    v_dept dept%ROWTYPE;

BEGIN
    SELECT * INTO v_dept
    FROM dept
    WHERE deptno = p_deptno;
    
    DBMS_OUTPUT.PUT_LINE(v_dept.loc);

END;
/

EXEC sample_pcd(20);



















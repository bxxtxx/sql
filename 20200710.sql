

UPDATE상수값으로 업데이트 ==> 서브쿼리 사용가능

SELECT *
FROM emp;

INSERT INTO emp (empno, ename, job) VALUES (9999, 'brown', 'RANGER') ;

방금 입력한 9999번 사번번호를 갖는 사원의 deptno와 job 컬럼의 값을
Smith 사원의 deptno와 job으로 업데이트

UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH'),
                 job  = (SELECT job FROM emp WHERE ename = 'SMITH')
WHERE empno = 9999;  --그렇게 바람직한 구문은 아님 : 비효율적

==> UPDATE쿼리를 1개 실행할 때, 안쪽 SELECT 쿼리가 2개가 포함됬음 ==> 비효율적이였음 . 비권장
    고정된 값을 업데이트 하는게 아니라, 다른 테이블에 있는 값을 통해서 업데이트 할 때
    비효율이 존재
    ==> MERGE 구문을 통해 보다 효율적으로 업데이트가 가능
    
---------------------------------------------------------------------------------------

DELETE : 테이블의 행을 삭제할 때 사용하는 SQL
         특정 컬럼만 삭제한는 것 : UPDATE
         DELETE 구문은 행 자체를 삭제
         
1. 어떤 테이블에서 삭제할지
2. 테이블의 어떤 행을 삭제할지

문법 : 
DELETE [FROM] 테이블명
WHERE 삭제할 행을 선택하는 조건;


UPDATE쿼리 실습시 9999번 사원을 등록 함, 해당사원을 삭제하는 쿼리를 작성

DELETE emp
WHERE empno > 9000;


SELECT *
FROM emp;

DELETE 쿼리도 SELECT 쿼리 작성시 사용한 WHERE절과 동일
서브쿼리 사용 가능

사원중에 mgr가 7698인 사원들만 삭제

DELETE emp
WHERE mgr = (SELECT *
             FROM emp
             WHERE mgr = 7698);


DBMS의 경우 데이터의 복구를 위해서
DML 구문을 실행할 때 마다 로그를 생성
대량의 데이터를 지울 때는 로그 기록도 부하가 되기 때문에
개발환경에서는 테이블의 모든 데이터를 지우는 경우에 한해서
TRUNCATE TABLE 테이블명; 명령을 통해 --danger

로그를 남기지 않고 빠르게 삭제가 가능하다
단, 로그가 없기 때문에 복구가 불가능하다.

emp 테이블을 이용해서 새로운 테이블을 생성

CREATE TABLE emp_copy AS
SELECT *
FROM emp;


SELECT *
FROM emp_copy;

DELETE emp_copy;            --위아래 같은의미
TRUNCATE TABLE emp_copy;


SELECT *
FROM emp_copy;


--※참고 메모리에서 진행된 작업은 바로 파일시스템에 저장되지않고 로그파일로 기록에 남다가 추후 정리된다.
--      DELETE의 경우 log가 남아 파일시스템의 파일이 사라지더라도 복구가 가능하지만
--      TRUNCATE의 경우 log마저 삭제하여 복구 영영 불가능, 하지만 그만큼 로그를 관리하지않기때문에 속도면에서 빠르다.

--      메모리에서는 용량이 한정적이라 LFU 알고리즘으로 메모리를 관리. 


------------------------------------------------------------------DML은 여기까지!~!

--참고 DDL, DCL의 경우 ROLLBACK 불가 : 자동으로 commit이 됨


--ORACLE 에서는 조회를 이력 메세지를 기준으로 가져온다. : commit => 이력메세지 추가


LEVEL2 : repeatable read;
선행 트랜잭션에서 읽은 데이터를
후행 트랜잭션에서 수정하지 못하게끔 막아
선행 트랜잭션 안에서
항상 동일한 데이터가 조회 되도록 보장하는 레벨



==트랜잭션 시작

SELECT *
FROM dept
WHERE deptno = 99;

99번 부서의 부서명,loc 정보를 유지하고 싶음
다른 특랜잭션에서 수정하지 못하도록 막고 싶음


후행 트랜잭션에서 업데이트, 커밋? 
후행은 데이터를 수정가능
==트랜잭션 끝






==트랜잭션 시작

SELECT *
FROM dept
WHERE deptno = 99
FOR UPDATE;   --기존에 존재하는 테이블에 대해서 loc을 걸었다.


후행 트랜잭션에서 업데이트, 커밋? 
후행은 수정이 불가능 (선행의 TCL을 기다리는 상태가 된다)


--후에 선행에서 rollback or commit 이 이루어져야만 후행이 데이터를 수정가능

==트랜잭션 끝


--단, 후행 트랜잭션에서 신규 입력이 가능하다. 
--phantom read 현상 : 기존에 없던 데이터가 조회되는 현상


phantom read :
LV2에서는 테이블에 존재하는 데이터에 대해 후행 트랜잭션에서 신규로 입력하는 데이터를 막을 수 없다.
즉, 선행트랜잭션에서 처음 읽은 데이터와 후행트랜잭션에서 신규입력 후 커밋한 이후에 조회한 데이터가
불일치 할 수 있다.

(없던 데이터가 갑자기 생성되는 현상)

--?? : 팬텀리드가 그럼 업무쪽에선 어떤 악영향을 끼칠수도 있는걸까 ?
--?? : 여러 개발자가 함께 작업하는 서버관련해선 ?


------------------------------------------------------------------------
LEVEL3
: SERIALIZABLE READ : 직렬화
후행 트랜잭션이 데이터를 입력, 수정, 삭제하더라도 
선행트랜잭션에서는 트랜잭션 시작 시점의 데이터가 보이도록 보장

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 

==> 팬텀리드 현상이 없어짐




------------------------------------------------------------------------SQL PART1 끝!

DML (Data Manipulation Language) : 데이터를 다루는 SQL (조작)
SELECT , INSERT , DELETE, UPDATE


DDL (Data Definition Language) : 데이터를 정의하는 SQL
자동커밋 : 롤백이 안됨
ex : 테이블 생성 DDL 실행 ==> 롤백이 불가
     ==> 테이블 삭제 DDL 실행

데이터가 들어갈 공간(table) 생성, 삭제
컬럼 추가
각종 객체 생성, 수정, 삭제

--getClass???

테이블 삭제
문법
DROP 객체 종류 객체이름;
DROP TABLE emp_copy;   --아까만듬
삭제한 테이블과 관련된 데이터는 삭제
[나중에 배울 내용 제약조건] 이런 것들도 다같이 삭제
테이블과 관련된 내용은 삭제;   


삭제된 테이블이기 떄문에 에러
SELECT *
FROM emp_copy;



DML 문과 DDL 문을 혼합해서 사용 할 경우 발생할 수 있는 문제점
==> 의도와 다르게 DML 문에 대해서 COMMIT 이 될 수 있다.

SELECT *
FROM emp;


INSERT INTO emp (empno, ename) VALUES(9999,'brown');

SELECT COUNT(*)
FROM emp;

DROP TABLE batch;
[COMMIT]    --자동커밋 실무에서도 자주 하는 실수

ROLLBACK;

SELECT COUNT(*)
FROM emp;




테이블 생성
문법
CREATE TABLE 테이블명(
    컬럼명1 컬럼1타입,
    컬럼명2 컬럼2타입,
    컬럼명3 컬럼3타입,
      .
      .
      .
    컬럼명n 컬럼n타입 DEFAULT 기본값
);

ranger라는 이름의 테이블을 생성

CREATE TABLE ranger(

    ranger_no NUMBER,
    ranger_nm VARCHAR2(50),
    reg_dt DATE DEFAULT SYSDATE
);


INSERT INTO ranger (ranger_no, ranger_nm) VALUES(100, 'brown');

SELECT *
FROM ranger;


--NUMBER도 한번 확인해보자


---------------------------------------------------------
데이터의 무결성 : 잘못된 데이터가 들어가는 것을 방지하는 성격
ex : 1. 사원 테이블에 중복된 사원번호가 등록되는것을 방지
     2. 반드시 입력이 되어야 되는 컬럼의 값을 확인

==> 파일시스템이 갖을 수 없는 성격

오라클에서 제공하는 데이터 무결성을 지키기 위해 제공되는
제약조건 5가지 (정확히는 4가지)
1. NOT NULL 
   해당 컬럼에 값이 NULL로 들어오는 것을 제약, 방지
   (ex, emp 테이블의 empno 컬럼) --사실 CHECK에 포함되는 내용

2. UNIQUE
   전체 행중에 해당 컬럼의 값이 중복이 되면 안된다.
   (ex. emp 테이블에서 empno 컬럼이 중복되면 안된다.)
   단, NULL에대한 중복은 허용한다.  
  
3. PRIMARY KEY = UNIQUE + NOT NULL

4. FOREIGN KEY 
   연관된 테이블에 해당 데이터가 존재해야만 입력이 가능
   emp테이블과 dept테이블은 deptno 컬럼으로 연결이 되어있음
   emp테이블에 데이터를 입력할 때 dept테이블에 존재하지 않는
   deptno 값을 입력하는 것을 방지

5. CHECK 제약조건
   컬럼에 들어오는 값을 정해진 로직에 따라서 제어
   ex, 어떤 테이블에 성별 컬럼이 존재하면
       남성 = M,  여성 = F
       M, F 두가지 값만 저장될 수 있도록 제어
       
       C 성별을 입력하면 ?? 시스템 요구사항을 정의할 때
       정의하지 않은 값이기 때문에 추후 문제가 될 수도 있다.




제약조건 생성 방법
1. 테이블 생성시, 컬럼 옆에 기술하는 경우
    * 상대적으로 세세하게 제어하는것은 불가능
    
2. 테이블 생성시, 모든 컬럼을 기술하고 나서
   제약조건만 별도로 기술
   1번 방법보다 세세하게 제어하는게 가능
   
3. 테이블 생성이후, 객체 수정 명령을 통해서
   제약 조건을 추가




1번방법으로 PRIMARY KEY 생성

dept 테이블과 동일한 컬럼명, 타입으로 dept_test라는 테이블 이름으로 생성
1. dept테이블 컬럼의 구성 정보 확인

DESC dept;

CREATE TABLE dept_test(
    
    deptno NUMBER(2) PRIMARY KEY,
    
    dname VARCHAR(13),
    
    loc VARCHAR(13)
);


SELECT *
FROM dept_test;


PRIMARY KEY 제약조건 확인
UNIQUE + NOT NULL




1. NULL값 입력 테스트
PRIMARY KEY 제약조건에 의해 deptno 컬럼에는 null 값이 들어갈 수 없다.
INSERT INTO dept_test VALUES (null, 'ddit', 'daejeon');


2. 값 중복 테스트
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (99, 'ddit2', 'daejeon2');

첫번째 INSERT 구문에의해 99번 부서는 dept_tset 테이블에존재
deptno 컬럼의 값이 99번인 데이터가 이미 존재하기 때문에
중복 데이터로 입력이 불가능



현 시점에서 dept 테이블에는 deptno 컬럼에 PRIMARY KEY 제약이 걸려 있지 않은 상황
DESC dept;

SELECT *
FROM dept;
이미 존재하는 10번 부서 추가로 등록

INSERT INTO dept VALUES (10, 'ddit', 'daejeon');



테이블 생성시 제약조건 명을 설정
비설정시 : ORA-00001: unique constraint (BXXTXX.SYS_C007090) violated

DROP TABLE dept_test;


컬럼명 컬럼 타입 CONSTRAINT 제약조건이름 제약조건타입(ex: PRIMARY KEY)

PRIMARY KEY 제약조건 명명규칙 : PK_테이블명


CREATE TABLE dept_test(
    
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
    
    dname VARCHAR(13),
    
    loc VARCHAR(13)
);

INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (99, 'ddit2', 'daejeon2');

설정시 : ORA-00001: unique constraint (BXXTXX.PK_DEPT_TEST) violated

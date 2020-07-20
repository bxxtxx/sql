


오라클 객체 (object)
table - 데이터 저장 공간
  . ddl 생성, 수정, 삭제

view - sql(쿼리다) 논리적인 데이터 정의, 실체가 없다
       view 구성하는 테이블의 데이터가 변경되면 view 결과도 달라지더라
       

sequence - 중복되지 않는 정수값을 반환해주는 객체
           유일한 값이 필요할 때 사용할 수 있는 객체
           nextval , currval

index - 테이블의 일부 컬럼을 기준으로 미리 정렬해 놓은 데이터
        ==> 테이블 없이 단독적으로 생성 불가, 특정 테이블에 종속
            table 삭제를 하면 관련 인덱스도 같이 삭제

            
            


block : 데이터 베이스가 데이터를 읽어들일때 최소의 단위 8k ~ 64kbyte

DB 구저에서 중요한 전제 조건
1. DB에서 I/O의 기준은 행단위가 아니라 BLOCK 단위
   한 건의 데이터를 조회하더라도, 해당행이 존재하는 block 전체를 읽는다

    데이터 접근 방식
    1. table full access
       multi block io ==> 읽어야 할 블럭을 여러개 한번에 읽어 들이는 방식
                          (일반적으로 8~16 block)
       사용자가 원하는 데이터의 결과가 table의 모든 데이터를 다 읽어야만 하는 경우
       ==> 인덱스보다 여러 블럭을 한번에 많이 조회하는 table full access 방식이 유리 할 수 있다.
       ex: 
       전제 조건은 mgr, sal, comm 컬럼으로 인덱스가 없을 때
       mgr, sal, comm 정보를 table에서만 획득이 가능할 때
       SELECT COUNT(mgr), SUM(sal), SUM(comm), AVG(sal)
       FROM emp;
       
       
                          
    2. index 접근, index 접근후 table access
       single block io ==> 읽어야할 행이 있는 데이터 block만 읽어서 처리하는 방식
       소수의 몇건 데이터를 사용자가 조회할 경우, 그리고 조건에 맞는 인덱스가 존재할 경우
       빠르게 응답을 받을 수 있다.
       
       하지만 single block io가 빈번하게 일어나면 multi block io보다 오히려 느리다.
   

2. extent, 공간할당 기준 - 약간 sequence랑 비슷한듯



현재 상태
인덱스 : IDX_NU_emp_01 (empno)

emp테이블의 job 컬럼을 기준으로 2번째 non -unique 인덱스 생성


CREATE INDEX IDX_NU_emp_02 ON emp (job);



현재 상태
인덱스 : IDX_NU_emp_01 (empno)
        IDX_NU_emp_02 (job)
        

EXPLAIN PLAN FOR      
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);



인덱스 추가 생성

emp 테이블의 job, ename 컬럼으로 복합 non-unique index 생성
id_nu_emp_03
CREATE INDEX idx_nu_emp_03 ON emp (job, ename);



현재 상태
인덱스 : IDX_NU_emp_01 (empno)
        IDX_NU_emp_02 (job)
        IDX_NU_emp_03 (job, ename)
  
  
EXPLAIN PLAN FOR       
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';
  
        
SELECT *
FROM TABLE(dbms_xplan.display);






현재 상태
인덱스 : IDX_NU_emp_01 (empno)
        IDX_NU_emp_02 (job)
        IDX_NU_emp_03 (job, ename)
  
  
EXPLAIN PLAN FOR       
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE '%C';
  
        
SELECT *
FROM TABLE(dbms_xplan.display);



인덱스 추가
emp 테이블에 ename, job 컬럼을 기준으로 non-unique 인덱스 생성 (idx_nu_emp_04)
CREATE INDEX idx_nu_emp_04 ON emp (ename, job);


현재 상태
인덱스 : IDX_NU_emp_01 (empno)
        IDX_NU_emp_02 (job)
        IDX_NU_emp_03 (job, ename) ==> 삭제
        idx_nu_emp_04 (ename, job) : 복합컬럼 인덱스의 컬럼순서가 미치는 영향
        
        

DROP INDEX IDX_NU_emp_03;


EXPLAIN PLAN FOR       
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';
  
        
SELECT *
FROM TABLE(dbms_xplan.display);



ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE emp ADD CONSTRAINT fk_emp FOREIGN KEY (deptno)
                                      REFERENCES dept (deptno);

접근방식 : emp 1. table full access, 2.인덱스 * 4 : 방법 5가지 존재
          dept 1. table full_access, 2. 인덱스 * 1 : 방법 2가지
          가능한 경우의 수가 10가지
          방향성 emp, dept를 먼저 처리할지 : 20가지
          
EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.empno = 7788;
  
  
SELECT *
FROM TABLE(dbms_xplan.display);




EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
  
SELECT *
FROM TABLE(dbms_xplan.display);




CREATE TABLE dept_test2 AS
SELECT *
FROM dept
WHERE 1=1;



CREATE UNIQUE INDEX idx_u_dept_test2_01 ON dept_test2 (deptno);

CREATE INDEX idx_dept_test2_02 ON dept_test2 (dname);

CREATE INDEX idx_dept_test2_03 ON dept_test2 (deptno, dname); 

DROP INDEX idx_u_dept_test2_01;
DROP INDEX idx_dept_test2_02;
DROP INDEX idx_dept_test2_03;


-- optimizer : 실행계획 해주는애                rule based optimizer  : oracle 10 이전                      cost based optimizer : oracle 10 이후

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 30;

SELECT *
FROM TABLE(dbms_xplan.display);

----empno : 유니크


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE ename = 'SMITH';

---ename

SELECT *
FROM TABLE(dbms_xplan.display);


DROP INDEX idx_nu_emp_04;


EXPLAIN PLAN FOR 
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.deptno = 10
  AND emp.empno LIKE 7369 || '&';
  
SELECT *
FROM TABLE(dbms_xplan.display);
  
CREATE INDEX idx_emp_01 ON emp (deptno,empno);
CREATE INDEX idx_emp_02 ON emp (empno,deptno);

DROP INDEX idx_emp_01;
DROP INDEX idx_emp_02;
 
---empno, deptno 아무거나 묶어서 써보자 
 
 
 
 
EXPLAIN PLAN FOR 
SELECT *
FROM emp
WHERE sal BETWEEN 0 AND 1500
  AND deptno = 10;

-- (deptno, sal)  

SELECT *
FROM TABLE(dbms_xplan.display);

CREATE INDEX idx_emp_01 ON emp (deptno,sal, empno);
CREATE INDEX idx_emp_02 ON emp (sal,deptno);

DROP INDEX idx_emp_01;










EXPLAIN PLAN FOR 
SELECT B.*
FROM EMP A, EMP B
WHERE A.mgr = B.empno
  AND A.deptno = 20;
  
  
SELECT *
FROM TABLE(dbms_xplan.display);
  
CREATE INDEX idx_emp_01 ON emp (mgr,empno);

CREATE INDEX idx_emp_02 ON emp (sal,deptno);

DROP INDEX idx_emp_01;
DROP INDEX idx_emp_02;  
  

  
  
  
  
  
  
  
EXPLAIN PLAN FOR
SELECT deptno, To_CHAR(hiredate, 'yyyymm'), COUNT(*) cnt
FROM emp
GROUP BY deptno, To_CHAR(hiredate, 'yyyymm');
  
SELECT *
FROM TABLE(dbms_xplan.display);


CREATE INDEX idx_emp_01 ON emp (deptno);
CREATE INDEX idx_emp_02 ON emp (deptno,To_CHAR(hiredate, 'yyyymm'));

DROP INDEX idx_emp_02;
  




1. empno(=)
2. ename(=)
3. deptno(=), empno (LIKE)
4. deptno(=), sal(between)
5. deptno(=), 
    empno(=) !!
6. deptno, hiredate 컬럼으로 구성된 인덱스가 있을경우, table 접근이 필요없음



1] empno
2] ename
3] deptno, empno
4] deptno, sal
5] deptno, hiredate





1] empno
2] ename
3] deptno, empno, sal, hiredate



emp테이블에 데이터가 5천만건
10,20,30 데이터는 각각 50건씩만 존재 ==> 인덱스가 유리
40번 데이터 4850건 ==>table full access






SYNONYM : 오라클 객체에 별칭을 생성
bxxtxx.v_emp => v_emp

생성 방법
CREATE [PUBLIC] SYNONYM 시노님이름 FOR 원본 객체이름;
PUBLIC : 모든사용자가 사용할 수 있는 시노님
         권한이 있어야 생성가능
         
PRIVATE [DEFAULT] : 해당 사용자만 사용할 수 있는 시노님

삭제 방법
DROP SYNONYM 시노님이름;









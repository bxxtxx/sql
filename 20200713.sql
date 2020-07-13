
DROP TABLE dept_test;
CREATE TABLE dept_test(
    
    deptno NUMBER(2) 
    
    dname VARCHAR(13),
    
    loc VARCHAR(13)
);



DROP TABLE emp_test;

CREATE TABLE emp_test(

    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test (deptno)
    
    CONSTRAINT pk_emp_test PRIMARY KEY (empno)
);



-----------------------------------------------------------


제약조건 생성 방법
1. 테이블 생성시, 컬럼 옆에 기술하는 경우
    * 상대적으로 세세하게 제어하는것은 불가능        --7/10
    
2. 테이블 생성시, 모든 컬럼을 기술하고 나서        
   제약조건만 별도로 기술
   1번 방법보다 세세하게 제어하는게 가능
   
3. 테이블 생성이후, 객체 수정 명령을 통해서
   제약 조건을 추가



2:


dept_test 테이블의 deptno컬럼을 대상으로 PRIMARY KEY 제약 조건 생성

CREATE TABLE dept_test(
    
    deptno NUMBER(2), 
    
    dname VARCHAR(13),
    
    loc VARCHAR(13),
    
    CONSTRAINT pk_dept_test PRIMARY KEY (deptno)
    
);




SELECT *
FROM dept_test;


INSERT INTO dept_test VALUES (11, 'dt', 'daeh');

INSERT INTO dept_test VALUES (11, 'apple', 'cc');



NOT NULL 제약조건 : 컬럼 레벨에 기술, 테이블 기술없음, 테이블 수정시 변경 가능
INSERT INTO dept_test VALUES (12, 'apple', null);




CREATE TABLE dept_test(
    
    deptno NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,
    
    dname VARCHAR(13) NOT NULL,
    
    loc VARCHAR(13)
);


INSERT INTO dept_test VALUES (12, 'apple', null);
INSERT INTO dept_test VALUES (13, null, 'dada');




UNIQUE 제약조건 : 해당 컬럼의 값이 다른 행에 나오지 않도록 (중복되지 않도록)
                 데이터 무결성을 지켜주는 조건
                 (ex : 사번, 학번)

수업시간 UNIQUE 제약조건 명명규칙 : UK_테이블명_해당컬럼명

CREATE TABLE dept_test(
    
    deptno NUMBER(2),
    
    dname VARCHAR(13),
    
    loc VARCHAR(13),
    
    CONSTRAINT uk_dept_test_dname  UNIQUE (dname, loc)   
 /* dname과 loc를 결합해서 중복되는 데이터가 없음 가능
       다음 두개는 중복
       ddit , daejeon
       ddit , daejeon
    
    
       다음 두개는 가능
       ddit , daejeon
       ddit , 대전*/
    
);

INSERT INTO dept_test VALUES (11, 'ddit', 'aa');

INSERT INTO dept_test VALUES (12, 'ddit', 'a');

SELECT *
FROM dept_test;







FOREIGN KEY : 참조키
한 테이블의 컬럼 값이 참조하는 테이블의 컬럼 값중에 
존재하는 값만 입력되도록 제어하는 제약조건

즉 FOREIGN KEY 경우 두개의 테이블간의 제약조건

* 참조 되는 테이블의 컬럼에는 (dept_test.deptno) 인덱스가 생성되어 있어야한다.
  자세한 내용은 INDEX 편에서 다시 확인 ★
  
  
DROP TABLE dept_test;


CREATE TABLE dept_test(
    
    deptno NUMBER(2), 
    
    dname VARCHAR(13),
    
    loc VARCHAR(13),
    CONSTRAINT pk_dept_test PRIMARY KEY (deptno)
);


테스트 데이터 준비

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');

dept_test 테이블의 deptno 컬럼을 참조하는 emp_test 테이블 생성

DESC emp;


CREATE TABLE emp_test(

    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test (deptno),
    
    CONSTRAINT pk_emp_test PRIMARY KEY (empno)
);

1. dept_test 테이블에는 부서번호가 1번인 부서가 존재
2. emp_test 테이블의 deptno 컬럼으로 dept_test.deptno 컬럼을 참조
   ==> emp_test 테이블의 deptno컬럼에는 dept_test.deptno 컬럼에 존재하는 값만 입력하는 것이 가능



dept_test 테이블에 존재하는 부서번호로 emp_test 테이블에 입력하는 경우

INSERT INTO emp_test VALUES (9999,'brown', 1);


SELECT *
FROM emp_test;

dept_test 테이블에 존재하지 않는 부서번호로 emp_test 테이블에 입력하는 경우 ==> 에러

INSERT INTO emp_test VALUES (9998,'cony', 2);




FK 제약조건을 테이블 컬럼 기술이후에 별도로 기술하는 경우
CONSTRAINT 제약조건명 제약조건 타입 (대상 컬럼) REFERENCES 참조테이블(참조테이블 컬럼명)
명명규칙 : FK_타겟테이블명_참조테이블명[IDX]


CREATE TABLE emp_test(

    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) 
                                     REFERENCES dept_test (deptno)
);

dept_test 테이블에 존재하는 부서번호로 emp_test 테이블에 입력하는 경우

INSERT INTO emp_test VALUES (9999,'brown', 1);


SELECT *
FROM emp_test;

dept_test 테이블에 존재하지 않는 부서번호로 emp_test 테이블에 입력하는 경우 ==> 에러

INSERT INTO emp_test VALUES (9998,'cony', 2);


참조되고 있는 부모쪽 데이터를 삭제하는 경우
dept_test 테이블에 1번 부서가 존재하고
emp_test테이블의 brown 사원이 1번 부서에 속한상태에서
1번 부서를 삭제하는 경우
FK의 기본설정에서는 참조하는 데이터가 없어 질수 없기 떄문에 에러 발생

DELETE dept_test
WHERE deptno = 1;


FK 생성시 옵션
0. DEFAULT - 무결성이 위배되는 경우 에러
1. ON DELETE CASCADE : 부모 데이터를 삭제하게되면, 참조하고 있는 자식들의 데이터를 같이 삭제
   (dept_test의 1번부서를 삭제하면 1번부서에 소속된 brown 사원도 삭제)
2. ON DELETE SET NULL : 부모 데이터를 삭제하게 되면, 참조하고 있는 자식들의 해당 컬럼 데이터를 NULL로 수정
   

CREATE TABLE emp_test(

    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test (deptno),
    
    CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno)
                                     REFERENCES dept_test (deptno) ON DELETE CASCADE
);


INSERT INTO emp_test VALUES (9999,'brwon', 1);


DROP TABLE emp_test;





CREATE TABLE emp_test(

    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test (deptno),
    
    CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno)
                                     REFERENCES dept_test (deptno) ON DELETE SET NULL
);


INSERT INTO emp_test VALUES (9999,'brwon', 1)

DELETE dept_test
WHERE deptno = 1;


SELECT *
FROM emp_test;










CHECK 제약조건 : 컬럼에 입력되는 값을 검증하는 제약조건
    ex: salary 컬럼이 음수가 입력되는 것은 부자연스러움
        성별 컬럼에 남, 여가 아닌 값이 들어오는것은 데이터가 잘못된 것
        직원 구분이 정직원, 임시직 두개만 존재할 때 다른값이 들어오면 논리적으로 어긋남


CREATE TABLE emp_test(

    empno NUMBER(4),
    ename VARCHAR2(10),
    sal NUMBER(7,2) CONSTRAINT sal_no_zero CHECK (sal > 0)
    
);
INSERT INTO emp_test VALUES(4244, 'tom', -5);

--------------------------------------------------------------------------------------------- 짐까지 테이블 생성 + [제약조건포함]
----------------------------------------------: CTAS
----------------------------------------------CREATE TABLE 테이블명 AS
----------------------------------------------SELECT ........

CREATE TABLE member_20200713 AS
SELECT *
FROM member;


member 테이블에 작업

CTAS 명령을 이용하여 EMP 테이블의 모든 데이터를 바탕으로 EMP_TEST 테이블 생성
DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;


SELECT *
FROM emp_test;






CREATE TABLE emp_test2 AS --빠르게 틀만 만들고 싶을때 사용가능
SELECT *
FROM emp
WHERE 1 != 1;


SELECT *
FROM emp_test2;


생성된 테이블 변경
컬럼 작업
1. 존재하지 않았던 새로운 컬럼 추가
   ** 테이블의 컬럼 기술순서를 제어하는 것은 불가능
   ** 신규로 추가하는 컬럼의 경우 컬럼순서가 항상 테이블의 마지막
   ** 설계를 할 때 컬럼순서에 충분히 고려, 누락된 컬럼이 없는지도 고려


2. 존재하는 컬럼 삭제
   ** 제약조건 (특히 FK) 주의

3. 존재하는 컬럼 변경
   * 컬럼명 변경 ==> FK와 관계없이 알아서 적용해줌
   * 그 외적인 부분에서는 사실상 불가능하다고 생각하면 편함
     (데이터가 이미 들어가 있는 테이블의 경우)
     1. 컬럼 사이즈 변경
     2. 컬럼 타입 변경
   ==> 설계시 충분한 고려
   
   

제약 조건 작업
1. 제약조건 추가
2. 제약조건 삭제
3. 제약조건 비활성화/활성화



DROP TABLE emp_test;

CREATE TABLE emp_test(

    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
);

테이블 수정
ALTER TABLE 테이블명 ......

1. 신규 컬럼 추가 (add)
ALTER TABLE emp_test ADD (hp VARCHAR2(11));

2.  컬럼 수정 (modify)
      ** 데이터가 존재하지 않을 때는 비교적 자유롭게 수정 가능
    ALTER TABLE emp_test MODIFY (hp VARCHAR2(5));
    ALTER TABLE emp_test MODIFY (hp NUMBER);

    컬럼 기본값 설정
    ALTER TABLE emp_test MODIFY (hp DEFAULT 123);
    INSERT INTO emp_test (empno, ename, deptno) VALUES (9999,'brown', null);

    
    컬럼명칭 변경 (RENAME COLUMN 현재컬럼명 TO 변경할 컬럼명)
    ALTER TABLE emp_test RENAME COLUMN hp TO cell;
    
    
    컬럼 삭제 (DROP or DROP COLUMN)
    ALTER TABLE emp_test DROP(cell);
    ALTER TABLE emp_test DROP COLUMN cell;               --동적인 부분이라 사실 2번은 잘 안해 


3. 제약 조건 추가, 삭제 (ADD, DROP)
            +
   테이블 레벨의 제약조건 생성

ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 제약조건 타입 대상컬럼



CREATE TABLE emp_test(

    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
    

);

테이블 수정을 통해서 emp_test 테이블의 empno 컬럼에 primary key 제약족너 추가

ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);

제약 조건 삭제 (DROP)
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;






제약조건 활성화 비활성화
제약조건은 DROP은 제약조건 자체를 삭제하는 행위
제약조건 비활성화는 재약조건 자체는 남겨두지만, 사용하지는않는 형태
때가되면 다시 활성화하여 데이터 무결성에 대한 부분을 강제할 수 있음.


DROP TABLE emp_test;

CREATE TABLE emp_test(

    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
    

);

테이블 수정명령을 통해 emp_test 테이블의 empno 컬럼으로 PRIMARY KEY 제약생성
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);


제약조건을 활성화 / 비활성화 (ENABLE, DISABLE)
ALTER TABLE emp_test DISABLE CONSTRAINT pk_emp_test;

pk_emp_test가 비활성화 되었기 때문에 empno 컬럼에 중복되는 값 입력이 가능핟,

INSERT INTO emp_test VALUES (9999, 'brown', null);
INSERT INTO emp_test VALUES (9999, 'cony', null);


ALTER TABLE emp_test ENABLE CONSTRAINT pk_emp_test;









※참고 
DICTIONARY
SELECT *
FROM user_tables;

SELECT *
FROM user_constraints
WHERE constraint_type = 'P';


SELECT *
FROM user_cons_columns
WHERE table_name = 'CYCLE'
  AND constraint_name = 'PK_CYCLE';


SELECT *
FROM user_tab_comments; --java의 주석과 같다



SELECT *
FROM user_col_comments; --java의 주석과 같다



테이블, 컬럼 주석 달기
COMMENT ON TABLE 테이블명 IS '주석';
COMMENT ON TABLE 테이블명.컬럼명 IS '주석';


SELECT *
FROM emp_test;


COMMENT ON TABLE emp_test IS '사원_복제';
COMMENT ON COLUMN emp_test.empno IS '사원';
COMMENT ON COLUMN emp_test.ename IS '사원이름';
COMMENT ON COLUMN emp_test.deptno IS '소속부서번호';


SELECT *
FROM user_col_comments
WHERE table_name = 'EMP_TEST';






SELECT * 
FROM user_col_comments;

SELECT a.table_name, table_type, a.comments tab_comment, b.column_name, b.comments col_comment
FROM user_tab_comments a JOIN user_col_comments b ON (a.table_name = b.table_name)
WHERE a.table_name IN ('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY');


SELECT *
FROM dept;

ALTER TABLE emp ADD CONSTRAINTS pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINTS pk_dept PRIMARY KEY (deptno);
ALTER TABLE emp ADD CONSTRAINTS fk_emp FOREIGN KEY (deptno)
                                       REFERENCES dept (deptno);




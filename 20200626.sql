
SQL에서는 키워드는 대소문자를 가리지 않는다
단, 데이터는 대소문자를 가리기때문에 주의할 것


WHERE 절에서 사용 가능한 연산자 : LIKE
사용용도 : 문자의 일부분으로 검색을 하고 싶을 때 사용
        ex: ename 컬럼의 값이 S로 시작하는 사원들을 조회
사용방법 : 컬럼 LIKE '패턴문자열'
마스킹 문자열 : 1. % : 문자가 없거나, 어떤 문자든 여러개의 문자열
                 'S%' S로 시작하는 모든 문자열
              2. _ : 어떤 문자든 딱 하나의 문자를 의미
                 'S_' S로 시작하고 두번째 문자가 어떤 문자든 하나의 문자가 오는 2자리 문자열
                 'S____' : S로 시작하고 문자열의 길이가 5글자인 문자열
                 

emp 테이블에서 ename 커럼의 값이 S로 시작하는 사원들만 조회
SELECT *
FROM emp
WHERE ename LIKE 'S%';


SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

UPDATE member set mem_name = '신이환'
WHERE mem_id = 'c001';


SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';


-------------------------------------------------------------------

NULL 비교 : = 연산자로 비교 불가 ==> IS
NULL을 = 비교하여 조회


SELECT empno, ename, comm
FROM emp
WHERE comm = NULL;


NULL값에 대한 비교는 =이 아니라 IS 연산자를 사용한다.
SELECT empno, ename, comm
FROM emp
WHERE comm is NULL;


WHERE6]

SELECT *
FROM emp
WHERE comm is not NULL;

-------------------------------------------------------------------

논리연산자 AND OR NOT
AND : 참 거짓 판단식1 AND 참 거짓 판단식2 ==> 식 두개를 동시에 만족하는 행만 참
      일반적으로 AND 조건이 많이 붙으면 조회되는 행의 수가 줄어든다.
OR : 참 거짓 판단식1 AND 참 거짓 판단식2 ==> 식 두개 중 하나라도 만족하는 행만 참

NOT : 조건을 반대로 해석하는 부정형 연산
      NOT IN
      IS NOT NULL

emp테이블에서 mgr컬럼 값이 7698이면서 sal 컬럼의 값이 1000보다 큰 사원 조회

SELECT *
FROM emp
WHERE mgr = 7698
  AND sal > 1000;


mgr컬럼값이 7698 이거나, sal 값이 1000보다 크거나 두개의 조건을 하나라도 만족하는 행을 조회
SELECT *
FROM emp
WHERE mgr = 7698
   OR sal > 1000;




SELECT *
FROM emp
WHERE mgr NOT IN(7698,7839);


mgr 사번지 7698이 아니고, 7839가 아니고, NULL이 아닌 직원들을 조회
SELECT *
FROM emp
WHERE mgr NOT IN(7698,7839,NULL);


mgr IN(7698,7839,NULL) ==> mgr = 7698 OR mgr = 7839 OR mgr = NULL

mgr NOT IN(7698,7839,NULL) ==> mgr != 7698 AND mgr != 7839 AND mgr != NULL


mgr IN (7698, 7839) ==> OR
mgr = 7698 OR mgr = 7839

mgr NOT IN (7698, 7839)
!(mgr = 7698 OR mgr = 7839) ==> mgr!= 7698 AND mgr!=7839 

****mgr 컬럼에 NULL값이 있을 경우 비교 연산으로 NULL 비교가 불가하기 떄문에 NULL을 갖는 행은 무시가 된다.




-------------------------------------------------------------------

WHERE7]

SELECT *
FROM emp
WHERE job = 'SALESMAN' 
  AND hiredate >= TO_DATE('19810601','yyyymmdd');
  

WHERE8]

SELECT *
FROM emp
WHERE deptno != 10 
  AND hiredate >= TO_DATE('19810601','yyyymmdd');
  

WHERE9]

SELECT *
FROM emp
WHERE deptno NOT IN(10)
  AND hiredate >= TO_DATE('19810601','yyyymmdd');
  
WHERE10]

SELECT *
FROM emp
WHERE deptno IN(20,30)
  AND hiredate >= TO_DATE('19810601','yyyymmdd');
  
  
WWHERE11]

SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR hiredate >= TO_DATE('19810601','yyyymmdd');


WHERE12]

SELECT *
FROM emp
WHERE job = 'SALESMAN' 
   OR empno like '78%'; -- 형변환 : 명시적, 묵시적


SELECT *
FROM emp
WHERE job = 'SALESMAN' 
   OR (empno >= 7800 AND empno < 7900);

-------------------------------------------------------------------


연산자 우선순위

+, -, *, /
*, / > + ,-


SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno like '78%' AND hiredate >= TO_DATE('06011981','mmddyyyy');




-------------------------------------------------------------------

SELECT   3
FROM     1
WHERE    2    --ORACLE에서 실제 실행순서
ORDER BY 4
-------------------------------------------------------------------


정렬
RDBMS 집합적인 사상을 따른다
집합에는 순서가 업다 (1, 3, 5) == {3, 1, 5}
집합에는 중복이 없다 (1, 3, 5, 1) == {3, 1, 5};


정렬방법: ORDER BY 절을 통해 정렬 기준 컬럼을 명시
         컬럼뒤에 [ASC | DESC] 을 기술하여 오름차순, 내림차순을 지정할 수 있다
1. ORDER BY 컬럼
2. ORDER BY 별칭
3. ORDER BY SELECT절에 나열된 컬럼의 인덱스 번호

SELECT *
FROM emp
ORDER BY ename;

SELECT *
FROM emp
ORDER BY ename desc;

SELECT *
FROM emp
ORDER BY ename, mgr, sal desc;


SELECT empno, ename, sal, sal * 12 salary
FROM emp
ORDER BY salary; --별칭사용


SELECT empno, ename, sal, sal * 12 salary
FROM emp
ORDER BY 2; --컬럼 인덱스 번호로 나열 - 지양합시다



SELECT *
FROM dept
ORDER BY dname;

SELECT *
FROM dept
ORDER BY loc desc;


SELECT *
FROM emp
WHERE comm > 0
ORDER BY comm desc, empno desc;
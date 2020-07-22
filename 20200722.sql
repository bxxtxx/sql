



mybatis
SELECT : 결과가 1건이냐, 복수냐

    1건 : sqlSession.selectOne ("namespace.sqlid", [인자]) --> overloading
         리턴타입 : resultType
    복수: sqlSession.selectList("namespace.sqlid", [인자]) --> overloading
         리턴타입 : List<resultType>
         

java : java 파일
resource : java 파일이아닌데 운영할 때 필요한애들 xml, html 등등
----------------------------------------------------------
test/java : 개발과정에 사용하는 테스트 코드

셋다 폴더 패키지 아님

다 한 공간에 잇으면 배포에 문제가 생길 수 있으므로 분리를 해둔다

--------------------------------------------------------------------

EmpDao 운영코드 작성
-- 테스트 할 수 있는 코드

src/test/java
운영코드Test
EmpDaoTest


junit
test Case
--------------------------------------------------------------------

오라클 계층쿼리 : 하나의 테이블에서 (혹은 인라인 뷰)에서 
                특정 행을 기준으로 다른 행을 찾아가는 문법

조인 : 테이블 - 테이블
계층쿼리 : 행 - 행

1. 시작점(행)을 설정
2. 시작점(행)과 다른행을 연결시킬 조건을 기술


1. 시작점 : mgr이 없는 King
2. 연결 조건 : King을 mgr컬럼으로 하는 사원;



SELECT LPAD('기준문자열', 15, '*')
FROM dual;


SELECT LPAD(' ', (LEVEL-1) * 6) || ename tree, LEVEL
FROM emp
START WITH mgr IS NULL --empno = 7839, ename = 'KING', 
CONNECT BY PRIOR empno = mgr;  --처음으로 읽는 값(PRIOR , 즉 empno)가 mgr과 같으면
**prior 키워드는 connect by 키워드와 떨어져서 사용해도 무관
**prior 키워드는 현재 읽고 있는 행을 지칭하는 키워드


SELECT LPAD(' ', (LEVEL-1) * 6) || ename tree, LEVEL
FROM emp
START WITH ename = 'BLAKE'
CONNECT BY PRIOR empno = mgr ;  



SELECT LPAD(' ', (LEVEL-1) * 6) || ename tree, LEVEL
FROM emp
START WITH ename = 'SMITH'
CONNECT BY PRIOR mgr = empno AND PRIOR hiredate < hiredate;




SELECT LPAD(' ', (LEVEL-1) * 10) || deptnm tree, level
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;



h-3]
SELECT deptcd,LPAD(' ', (LEVEL-1) * 10) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;
















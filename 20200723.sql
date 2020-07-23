

계층쿼리
    테이블(데이터셋)의 행과 행사이의 연관관계를 추적하는 쿼리
    ex : emp테이블 해당사원의 mgr 컬럼을 통해 상급자 추적 가능
        1. 상급자 직원을 다른 테이블로 관리하지 않음
            1-1. 상급자 구조가 계층이 변경되도 테이블의 구조는 변경 할 필요가 없다.
            
        2. JOIN : 테이블 간 연결
              FROM emp, dept
              WHERE emp.deptno = dept.deptno
            
           계층쿼리 : 행과 행 사이의 연결 (자기 참조)
              Prior : 현재 읽고 있는 행을 지칭
              X : 앞으로 읽을 행
            
        

h_4] 

SELECT LPAD(' ', (LEVEL - 1)* 4) || s_id s_id , value
FROM h_sum
START WITH  ps_id IS NULL
CONNECT BY PRIOR s_id = ps_id;




h_5] 

SELECT LPAD(' ', (LEVEL - 1) * 6) ||org_cd org_cd, no_emp
FROM no_emp
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;



SELECT LPAD(' ', (LEVEL - 1) * 6) ||org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = '기획파트'
CONNECT BY PRIOR parent_org_cd = org_cd;






가지치기 (pruning branch)
SELECT 쿼리의 실행순서 : FROM -> WHERE -> SELECT -> ORDER BY
계층 쿼리의 SELECT 쿼리 순서 : FROM -> START WITH, CONNECT BY -> WHERE 

계층쿼리에서 조회할 행의 조건을 기술할 수 있는 부분이 두곳 존재
1. CONNECT BY : 다음 행으로 연결할지, 말지를 결정
2. WHERE : START WITH CONNECT BY 에 의해 조회된 행을 대상으로 적용;




SELECT LPAD(' ', (LEVEL - 1) * 6) || deptnm deptnm , deptcd
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptnm != '정보기획부' ;




SELECT LPAD(' ', (LEVEL - 1) * 6) || deptnm deptnm , deptcd
FROM dept_h
WHERE  deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd ;







계층쿼리에서 사용할 수 있는 특수함수
CONNECT_BY_ROOT(col) : 최상위 행의 col(컬럼)의값
SYS_CONNECT_BY_PATH(col, 구분자) : 계층의 순회경로를 표현   --LTRIM 이랑 거의 쌍으로 같이 쓰임
CONNECT_BY_ISLEAF : 해당 행이 LEAF NODE 인지(1) 아닌지(0)를 반환




SELECT LPAD(' ', (LEVEL - 1) * 6) || deptnm deptnm , 
       /*CONNECT_BY_ROOT(deptnm)*/
       LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'),'-'),
       CONNECT_BY_ISLEAF
        
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd ;



h_6]
SELECT seq, LPAD(' ', (LEVEL - 1) * 6) || title title
FROM board_test
START WITH seq IN (SELECT seq
                  FROM board_test
                  WHERE parent_seq IS NULL)
CONNECT BY PRIOR seq = parent_seq;








SELECT title , seq
FROM (SELECT CONNECT_BY_ROOT(seq) gn, seq, LPAD(' ', (LEVEL - 1) * 6) || title title
     FROM board_test
     START WITH seq IN (SELECT seq
                      FROM board_test
                      WHERE parent_seq IS NULL)
    CONNECT BY PRIOR seq = parent_seq)
ORDER BY gn DESC, seq ;



SELECT seq, seq - parent_seq ,LPAD(' ', (LEVEL - 1) * 6) || title title
FROM board_test
START WITH seq IN (SELECT seq
                  FROM board_test
                  WHERE parent_seq IS NULL)
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq-parent_seq, seq DESC;






--SIBLINGS 를 쓰면 계층은 유지를 해준다.

-------------------------------------------------------------------------



SELECT a.ename, a.sal, a.deptno, b.lv
FROM 
(SELECT ROWNUM rn, a.*
 FROM 
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC) a ) a,
 
(SELECT ROWNUM rn, a.lv
FROM 
(SELECT b.deptno, a.lv
    FROM 
    (SELECT LEVEL lv
     FROM dual
     CONNECT BY LEVEL <= (SELECT COUNT(*) FROM emp) ) a,
    (SELECT deptno, COUNT(*) cnt
     FROM emp
     GROUP BY deptno) b
    WHERE a.lv <= b.cnt
    ORDER BY b.deptno, a.lv ) a )b
WHERE a.rn = b.rn;




SELECT ename, sal, deptno, 
       RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) rank
FROM emp;


윈도우 함수를 사용하면 행간 연산이 가능해짐
--> 일반적으로 풀리지 않는 쿼리를 간단하게 만들 수 있다.
**모든 DBMS가 동일한 윈도우 함수를 제공하지는 않음

문법 : 윈도우함수 OVER ([PARTITION BY 컬럼] [ORDER BY 컬럼] [WINDOWING])
PARTITION BY : 행들을 묶을 그룹 (그룹함수의 GROUP BY)
ORDER BY : 묶여진 행들간 순서 (RANK - 순위의 경우 순서를 설정하는 기준이 된다)
WINDOWING : 파티션 안에서 특정 행들에 대해서만 연산을 하고 싶을 때 범위를 지정





순위 관련함수
1. RANK() : 동일 값일 때는 동일 순위 부여, 후순위 중복자만큼 건너 띄고 부여
            1등이 2명이면 후순위는 3등
2. DENSE_RANK() : 동일 값일 때는 동일 순위 부여, 후순위는 이어서 부여
                  1등이 2명이여도 후순위는 2등
                  
3. ROW_NUMBER() : 중복되는 값이 없이 순위 부여 (ROWNUM과 유사)






SELECT ename, sal, deptno, 
       RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) rank,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_dense_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_row_rumber
FROM emp;



----------------------------------------------------------------


no_ana2]
SELECT empno, ename, deptno, (SELECT COUNT(*)
                              FROM emp b
                              WHERE a.deptno = b.deptno
                              GROUP BY deptno) cnt
FROM emp a
ORDER BY cnt;



집계 윈도우 함수 : SUM , MAX, MIN, AVG, COUNT
SELECT empno, ename, deptno, COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;





SELECT empno, ename, sal, deptno, ROUND((SELECT AVG(sal)
                                   FROM emp b
                                   WHERE a.deptno = b.deptno
                                   GROUP BY a.deptno),2) avg_sal
FROM emp a
ORDER BY a.deptno;


SELECT empno, ename, sal, deptno, ROUND(AVG(sal) OVER (PARTITION BY deptno),2) avg
FROM emp;


SELECT empno, ename, sal, deptno, MAX(sal) OVER (PARTITION BY deptno) max
FROM emp;



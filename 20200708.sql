
1. GROUP BY (여러개의 행을 하나의 행으로 묶는 행위)
2. JOIN
3. subquery~~~~~~~~~~~!!
    1. 사용위치
    2. 반환하는 행, 컬럼의 개수
    3. 상호연관 / 비상호연관
        -> 메인쿼리의 컬럼을 서브쿼리에서 사용하는지(참조하는지) 유무에 따른 분류
        : 비상호연관 서브쿼리의 경우 단독으로 실행 가능
        : 상호연관서브 쿼리의 경우 실행하기 위해서 메인쿼리의 컬럼을 사용하기 때문에
          단독으로 실행이 불가능
          
          
sub2 : 사원들의 급여 평균보다 높은 급여를 받는 직원

SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
        
        
사원이 속한 부서의 급여 평균보다 높은 급여를 받는 사원정보 조회

SELECT *
FROM emp e
WHERE sal > (SELECT AVG(sal)
             FROM emp m
             WHERE m.deptno = e.deptno);          --한정자 주의합시다
             


SMITH , WARD 사원이 속한 부서에 속한 직원정보 조회

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM  emp 
                 WHERE ename IN('SMITH', 'WARD'));

단일 비교는 =
복수행(단일컬럼) 비교는 IN
----------------------------------------------------------------------
셤
NULL과 IN, NULL 과 NOT IN


SELECT *
FROM emp
WHERE mgr IN (7902, null);
==> mgr = 7902 OR mgr = null
==> 데이터가 나오긴 함


WHERE mgr NOT IN (7902, null);
==> mgr != 7902 AND mgr != null    --우측식이 항상 false

----------------------------------------------------------------------

pairwise, non-pairwise(지금까지 했던것들임)
한행의 컬럼 값을 하나씩 비교하는 것 : non-pairwise
한행의 복수 컬럼을 비교하는 것 : pairwise
SELECT *
FROM emp
WHERE job IN ('MANAGER', 'CLERK');



SELECT *
FROM emp
WHERE (mgr , deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499,7782));

SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN (7499,7782))
  AND deptno IN (SELECT deptno
              FROM emp
              WHERE empno IN (7499,7782));
                 
pairwise --많이 쓰이지는 않은데 어쩌다 이걸 쓰지않으면 값이 제대로 안나올때가 있다.
7698 30
7839 10

non pairwise
7698 30
7698 10
7839 30
7839 10



상호 연관쿼리는 쿼리실행순서가 정해져있다, main -> sub
비상호 연관쿼리는 쿼리실행순서가 정해져 있지않다, main -> sub , sub -> main


실습4]
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');


SELECT *
FROM dept
WHERE deptno NOT IN(SELECT deptno
                    FROM emp
                    WHERE emp.deptno = dept.deptno);



실습5]
SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1 );



실습6]
SELECT *
FROM cycle
WHERE pid IN (SELECT pid
              FROM cycle 
              WHERE cid = 2)
  AND cid = 1;
  
  
SELECT cycle.cid, (SELECT cnm FROM customer WHERE customer.cid = cycle.cid) cnm, pid, 
                  (SELECT pnm FROM product  WHERE product.pid = cycle.pid) pnm, day, cnt
FROM cycle
WHERE cid = 1
  AND pid IN (SELECT pid
              FROM cycle 
              WHERE cid = 2);
  


SELECT NVL(buy_date, TO_DATE('20050125','YYYYMMDD')) buy_date, buy_prod, prod_id, prod_name, NVL(buy_qty,0) buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON 
(prod_id = buy_prod AND  buy_date = TO_DATE('20050125', 'YYYYMMDD'));



SELECT product.pid, pnm, NVL(cid, 1)cid, NVL(day, 0)day, NVL(cnt,1)cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cid = 1);

















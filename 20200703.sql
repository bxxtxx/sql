 
 
--erd 다이어그램 사용  
SELECT lprod_gu ,lprod_nm, prod_id,prod_name
FROM prod, lprod
WHERE prod.prod_lgu = lprod.lprod_gu;



SELECT lprod_gu ,lprod_nm, prod_id,prod_name
FROM prod JOIN lprod ON (prod.prod_lgu = lprod.lprod_gu);


  
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod, buyer
WHERE prod_buyer = buyer_id;



SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod JOIN buyer ON (prod_buyer = buyer_id);


SELECT mem_id, mem_name, prod_id, prod_name,cart_qty
FROM member, cart, prod
WHERE mem_id = cart_member
  AND cart_prod = prod_id;
  
  
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM cart JOIN member ON (mem_id = cart_member)
          JOIN prod ON(cart_prod = prod_id);
  
  
  

--

--4
SELECT customer.cid, cnm, pid, day, cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
  AND customer.cnm IN('brown', 'sally');

SELECT customer.cid, cnm, pid, day, cnt
FROM customer JOIN cycle ON (customer.cid = cycle.cid)
WHERE customer.cnm IN('brown', 'sally');



--5 //사실 select에서 한정자를 붙이는게 좋다. 하지만 너무 남발하면 길어지니까, 무게는 붙이는쪽. 하지만 너무 복잡해지면 X 그때그때 판단하자
SELECT customer.cid, cnm, product.pid, pnm ,day, cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
  AND product.pid = cycle.pid
  AND customer.cnm IN ('brown', 'sally');
  
  
SELECT customer.cid, cnm, product.pid, pnm , day, cnt
FROM cycle JOIN  customer ON(customer.cid = cycle.cid)
           JOIN  product  ON(product.pid = cycle.pid)
WHERE customer.cnm IN ('brown', 'sally');


--6
SELECT customer.cid, cnm, product.pid, pnm  , SUM(cnt)
FROM cycle JOIN  customer ON(customer.cid = cycle.cid)
           JOIN  product  ON(product.pid = cycle.pid)
GROUP BY customer.cid, cnm, product.pid, pnm;
  
  
SELECT customer.cid, cnm, product.pid, pnm  , SUM(cnt)
FROM cycle, customer, product
WHERE customer.cid = cycle.cid
  AND product.pid = cycle.pid
GROUP BY customer.cid, cnm, product.pid, pnm;


---------IN LINE VIEW + 그룹함수를 통해 오히려 효율이 더 좋아질 수도 있다. 참고참고

--7
SELECT product.pid, pnm, SUM(cnt)
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY product.pid, pnm;


SELECT product.pid , pnm, SUM(cnt)
FROM cycle JOIN product ON(cycle.pid = product.pid)
GROUP BY product.pid, pnm;

--------------------------------------------------

--SYSTEM 계정에서 해야함. 쿼리 하고 새 계정 추가 및 접속으로 합시다.
SELECT *
FROM DBA_USERS;


ALTER USER hr IDENTIFIED BY java;

ALTER USER hr ACCOUNT UNLOCK;


----------------------------------------------------

조인 성공 여부로 데이터 조회를 결정하는 구분방법
INNER JOIN : 조인에 성공하는 데이터만 조회하는 조인방법
OUTER JOIN : 조인에 실패 하더라도, 개발자가 지정한 기준이 되는 테이블의
             데이터는 나오도록 하는 조인
OUTER <==> INNER JOIN

--일상적으론 잘 안쓰는데 필요할때가 분명히 온다.

--복습 - 사원의 관리자 이름을 알고싶다. 조회 커럼: 사원사번, 사원이름, 사원관리자 사번, 사원관리자 이름

--동일한 테이블끼리 조인 되었기 때문에 : SELF-JOIN
--조인 조건을 만족하는 데이터만 조회 되었기때문에 : INNER JOIN

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e , emp m
WHERE e.mgr = m.empno;

--King 경우 president기 때문에 mgr 커럼의 값이 null -> 조인에 실패
--==> king 데이터는 조회되지 않음 (총 14건의 데이터중 13건의 데이터만 조인 성공)


OUTER 조인을 이용하여 조인 테이블중 기준이 되는 테이블울 선택하면
조인에 실패하더라도 기준 테이블의 데이터는 조회 되도록 할 수 있다.
LEFT/RIGHT

ANSI-SAL
테이블1 JOIN 테이블2 ON (.......)
테이블1 LEFT OUTER JOIN 테이블2 ON (.......)

위 쿼리는
테이블2 RIGHT OUTER JOIN 테이블1 ON (.......)


SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

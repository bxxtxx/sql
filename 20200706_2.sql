
SELECT *
FROM fastfood;

--순위, 시도, 시군구, 구분, 도시발전지수 ((버거킹 + KFC + 맥도날드 )/ 롯데리아) = 소수점 두자리






SELECT ROWNUM 순위, data.*
FROM(SELECT SIDO, SIGUNGU, ROUND(etc / DECODE(lotte, 0 , 0.1, lotte), 2) 도시발전지수
    FROM (SELECT SIDO, SIGUNGU, count( DECODE (GB, '롯데리아', 1, null)) lotte , 
                                count( DECODE (GB, '버거킹', 1, 'KFC', 1, '맥도날드', 1, null)) etc
          FROM fastfood
          GROUP BY SIDO, SIGUNGU)
    ORDER BY 도시발전지수 DESC)data;
    
    

---------------------------------------------------------------------------------
1. 시도, 시군구, 프렌차이즈별 kfc, 맥도날드, 버거킹, 롯데리아 건수세기
  1-1 : 프렌차이즈별로 SELECT 쿼리 분리 한 경우
      ==> OUTER
      ==> 기준 테이블을 무성ㅅ으로?
  1-2 : kfc, 맥도날드, 버거킹 1개의 SQL로, 롯데리아 1개
  1-3 : 모든 프렌차이즈를 SELECT 쿼리 하나로 카운팅 한 경우
    
    
1-1  
SELECT *
FROM
(SELECT sido, sigungu, COUNT(*) kfc
FROM fastfood
WHERE gb = 'KFC'
GROUP BY sido, sigungu) k,
    
    
 
(SELECT sido, sigungu, COUNT(*) bk
FROM fastfood
WHERE gb = '버거킹'
GROUP BY sido, sigungu)b,
    
   
 
(SELECT sido, sigungu, COUNT(*) mac
FROM fastfood
WHERE gb = '맥도날드'
GROUP BY sido, sigungu) m

WHERE 조인조건



1-2

SELECT m.sido, m.sigungu, m.m, d.d
FROM
(SELECT sido, sigungu, count(*) m
FROM fastfood
WHERE gb IN ('KFC', '버거킹', '맥도날드')
GROUP BY sido, sigungu) m,


(SELECT sido, sigungu, count(*) d
FROM fastfood
WHERE gb IN ('롯데리아')
GROUP BY sido, sigungu) d
   
   
WHERE m.sido = d.sido
  AND m.sigungu = d.sigungu;
  
  
1.3
SELECT sido, sigungu, ROUND((NVL(SUM(DECODE(gb, 'KFC', 1)),0)  +
                             NVL(SUM(DECODE(gb, '맥도날드', 1)),0) +
                             NVL(SUM(DECODE(gb, '버거킹', 1)),0))/
                             NVL(SUM(DECODE(gb, '롯데리아', 1)),1),2) score
FROM fastfood
WHERE gb IN ('KFC', '맥도날드','버거킹','롯데리아')
GROUP BY sido, sigungu
ORDER BY score DESC;
  
  



SELECT storecategory
FROM burgerstore;



트렌젝션, 싱글 더블쿼테이션은 모다?


SELECT sido, sigungu, ROUND((NVL(SUM(DECODE(storecategory, 'KFC', 1)),0)  +
                             NVL(SUM(DECODE(storecategory, 'BURGER KING', 1)),0) +
                             NVL(SUM(DECODE(storecategory, 'MACDONALD', 1)),0))/
                             NVL(SUM(DECODE(storecategory, 'LOTTERIA', 1)),1),2) score
FROM burgerstore
WHERE storecategory IN ('KFC', 'MACDONALD','BURGER KING','LOTTERIA')
GROUP BY sido, sigungu
ORDER BY score DESC;



[실습 1]
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod = prod.prod_id AND buy_date = TO_DATE('20050125', 'YYYYMMDD'));



[실습 2]
SELECT NVL(buy_date,TO_DATE('20050125','YYYYMMDD'))buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod = prod.prod_id AND buy_date = TO_DATE('20050125', 'YYYYMMDD'));



[실습 3]
SELECT NVL(buy_date,TO_DATE('20050125','YYYYMMDD'))buy_date, buy_prod, prod_id, prod_name, NVL(buy_qty,0)buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod = prod.prod_id AND buy_date = TO_DATE('20050125', 'YYYYMMDD'));


[실습 4]

SELECT product.pid, pnm, NVL(cid,1)cid, NVL(day,0)day, NVL(cnt,0)cnt
FROM cycle RIGHT JOIN product ON(cycle.pid = product.pid AND cid = 1);


[실습 5]

SELECT a.*
FROM (SELECT product.pid, pnm, NVL(cid,1)cid ,NVL(day,0)day, NVL(cnt,0)cnt
      FROM cycle RIGHT OUTER JOIN product ON (cycle.pid = product.pid AND cid = 1)) a
      JOIN customer ON (a.cid = customer.cid);
          



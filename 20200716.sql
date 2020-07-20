실행계획

개발자가 SQL 을 dbms에 요청을 하더라도
1. 오라클 서버가 항상 최적의 실행계획을 선택할 수는 없음
   = (응답성이 중요하기 때문  : OLPT (Online Transaction Processing))  : 그때그때 빠르게, 대다수가 일케쓰임
    <=> 전체 처리 시간이 중요 : OLAP - Online Analytical Processing   : 은행이자에서 자주 쓰임 
         => 실행계획을 세우는데 30분 이상 소요되기도 함
       
2. 항상 실행계획을 세우지 않음
   만약에 동일한 SQL이 이미 실행된적이 있으면 해당 SQL의 실행계획을 새롭게 세우지 않고
   Shared pool(메모리)에 존재하는 실행계획을 재사용
   
   동일한 SQL : 문자가 완벽하게동일한 SQL
               실행결과가 같다고 해서 동일한 SQL이 아님
               대소문자를 가리고, 공백도 문자로 취급됨
               ex: SELECT * FROM emp;
                   select * FROm emp;  두개의 SQL은 서로 다르게 인식
                   
SELECT /* plan_test */ *
FROM emp
WHERE empno = 7698;


select /* plan_test */ *
FROM emp
WHERE empno = 7698;


SELECT /* plan_test */ *
FROM emp
WHERE empno = 7369;    --이곳도 다른 SQL로 인식 :: 그래서 우리가 바인딩 변수를 사용합니다~~~~~~~ / DBMS적 측면





DCL : DATA Control Language - 시스템 권한 또는 객체 권한을 부여/ 회수

부여
GRANT 권한명 | 롤명 TO 사용자;
회수
REVOKE 권한명 | 롤명 FROM 사용자;









 

DATA DICTIONARY
오라클 서버가 사용자 정보를 관리하기 위해 저장한 데이터를 볼수 있는 view

CATEGORY( 접두어 )
USER_ : 해당 사용자가 소유한 객체 조회
ALL_ : 해당 사용자가 소유한 객체 + 권한을 부여받은 객체 조회
DBA_ : 데이터베이스에 설치된 모든 객체 (DBA 권한이 있는 사용자만 가능 - system
v$ : 성능, 모니터와 관련된 특수 view




SELECT *
FROM dictionary;













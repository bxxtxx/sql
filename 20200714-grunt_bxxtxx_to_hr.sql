
hr 계정으로 접속하여 테스트
v_emp view는 bxxtxx 계정이 hr계정에게 SELECT 권한을 주었기 때문에
정상적으로 조회가능

SELECT *
FROM bxxtxx.v_emp;



emp테이블의 select 권한을 hr에게 준적이 없기 떄문에 에러

SELECT *
FROM bxxtxx.emp;




VIEW : SQL
v_emp 정의

1. emp 테이블에 신규 사원을 입력 (기존 15건, 추가되서 16건)
2. SELECT *
   FROM v_emp; 결과가 몇 건 일가?   --view는 실체가없이 sql 그 자체라서 16개가 조회될거야 





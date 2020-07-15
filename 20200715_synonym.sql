
SELECT *
FROM bxxtxx.v_emp;


sem.v_emp => v_emp  시노님을 생성

CREATE SYNONYM v_emp FOR bxxtxx.v_emp;


SELECT *
FROM v_emp;
CREATE  or replace SEQUENCE IPC_RECEIPT_NUMBER_SEQ
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;
  
  CREATE SEQUENCE IPC_TEMP_RECEIPT_NUMBER_SEQ
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;


CREATE OR REPLACE PACKAGE IPC_AR_RECEIPT_GENERATOR as
    FUNCTION generate_receipt_number RETURN VARCHAR;
    FUNCTION generate_temp_receipt_number RETURN NUMBER;
END IPC_AR_RECEIPT_GENERATOR;


CREATE OR REPLACE PACKAGE BODY IPC_AR_RECEIPT_GENERATOR AS  
   
   FUNCTION generate_receipt_number 
        RETURN varchar IS v_receipt_number varchar(20);
   BEGIN 
      select LPAD(IPC_RECEIPT_NUMBER_SEQ.NEXTVAL,9,0) into v_receipt_number
        from dual;
        return v_receipt_number;
   END generate_receipt_number; 
   
   FUNCTION generate_temp_receipt_number 
        RETURN NUMBER IS v_temp_receipt_number NUMBER;
   BEGIN 
           -- TEMPORARY VALUE, WITH SEQUENCE
     -- select IPC_TEMP_RECEIPT_NUMBER_SEQ.NEXTVAL into v_temp_receipt_number
      --  from dual;
        select LPAD(round(dbms_random.value(1,10000)),5,0) into v_temp_receipt_number
            from dual;
        return v_temp_receipt_number;
   END generate_temp_receipt_number; 
END IPC_AR_RECEIPT_GENERATOR; 
/

SELECT IPC_AR_RECEIPT_GENERATOR.generate_temp_receipt_number
FROM dual;

SELECT *
FROM AR_cASH_RECEIPTS_ALL
WHERE RECEIPT_NUMBER LIKE '%000000020%';

select LPAD(round(dbms_random.value(1,10000)),5,0)
from dual;
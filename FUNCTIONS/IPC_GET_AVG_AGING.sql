CREATE OR REPLACE FUNCTION APPS.IPC_GET_AVG_AGING( P_LAST_MOVEMENT_DATE IN VARCHAR2,
                                                                                                 P_LAST_PURCHASE_DATE IN VARCHAR2,
                                                                                                 P_DATE IN VARCHAR2)
RETURN NUMBER IS v_aging NUMBER;
BEGIN
   
        SELECT   CASE 
                            WHEN  TO_DATE(P_LAST_MOVEMENT_DATE) IS NULL THEN TO_DATE(P_DATE) - TO_DATE(P_LAST_PURCHASE_DATE)
                            ELSE  TO_DATE(P_DATE) - TO_DATE(P_LAST_MOVEMENT_DATE)
                        END INTO v_aging
        from dual;
        RETURN v_aging;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                RETURN 0;
END;
/




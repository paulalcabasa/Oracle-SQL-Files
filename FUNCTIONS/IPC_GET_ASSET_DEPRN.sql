CREATE OR REPLACE FUNCTION APPS.IPC_GET_ASSET_DEPRN ( P_DATE IN VARCHAR2,
                                                                                     P_ASSET_ID IN NUMBER,
                                                                                     P_COL IN VARCHAR2 ) 
RETURN NUMBER IS v_aging NUMBER;

BEGIN
      
        
        RETURN v_return_val;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                RETURN 0;
END;
/

CREATE OR REPLACE FUNCTION APPS.IPC_GET_ITEM_PRICE(P_INVENTORY_ITEM_ID IN NUMBER,
                                                                                                  P_ORGANIZATION_ID IN NUMBER)
RETURN NUMBER IS v_price NUMBER;
BEGIN
   
        select me.price into v_price
        from apps.ipc_wsp_parts_pricelist me
        where 1 = 1
            and me.inventory_item_id = P_INVENTORY_ITEM_ID
            and me.organization_id  = P_ORGANIZATION_ID
        ;
        RETURN v_price;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                RETURN 0;
END;
/




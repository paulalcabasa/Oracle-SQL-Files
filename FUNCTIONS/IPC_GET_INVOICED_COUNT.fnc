CREATE OR REPLACE FUNCTION APPS.IPC_GET_INVOICED_COUNT(P_INVENTORY_ITEM_ID  IN NUMBER,
                                                                                                 P_ORGANIZATION_ID IN NUMBER,
                                                                                                 P_AS_OF IN VARCHAR2)
RETURN NUMBER IS v_invoiced_count NUMBER;
BEGIN
   
    select count(customer_trx_id) into v_invoiced_count from (
                SELECT rctla.inventory_item_id,
                                                rctla.warehouse_id,
                                                rctla.customer_trx_id
                                FROM ra_customer_trx_lines_all rctla,
                                           ra_customer_trx_all rcta
                                WHERE 1 = 1
                                            and rctla.customer_trx_id = rcta.customer_trx_id
--                                            and rctla.inventory_item_id = 373240
--                                            and rctla.warehouse_id = 121
                                            and rctla.inventory_item_id = P_INVENTORY_ITEM_ID
                                            and rctla.warehouse_id = P_ORGANIZATION_ID
                                            and to_date(rcta.trx_date) = P_AS_OF
                                GROUP BY 
                                                rctla.inventory_item_id,
                                                rctla.warehouse_id,
                                                rctla.customer_trx_id);
        RETURN v_invoiced_count;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                RETURN 0;
END;
/




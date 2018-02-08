select  a.organization_id,
           c.organization_code,
           b.inventory_item_id,
           b.segment1,
           b.description,
           a.transaction_uom_code,
           a.lot_number,
           d.serial_number,
           d.status_id
    from mtl_onhand_quantities_detail a,
         mtl_system_items b,
         mtl_parameters c,
         mtl_serial_numbers d,
         fnd_lookup_values_vl e
    where a.organization_id = b.organization_id
    and a.inventory_item_id = b.inventory_item_id    
    and b.organization_id = c.organization_id 
    and a.organization_id = d.current_organization_id
    and a.inventory_item_id = d.inventory_item_id
    and a.lot_number = d.lot_number
    and d.current_status = e.lookup_code
    and e.lookup_type = 'SERIAL_NUM_STATUS'
    and e.meaning = 'Resides in stores'
    and c.organization_code = 'IVS'     -- change to NYK
--    and subinventory_code = 'FG'         
--    and a.lot_number = '4X2 LSA-70'     --'4X2 LSA-71'
--    and d.serial_number in ('D0F332', 'D0F333')
    order by a.lot_number;

/* FINISHED GOODS QUERY */
SELECT msib.inventory_item_id,
             msib.attribute9 model,
             msib.attribute8 color ,
             msib.inventory_item_status_code,
             msib.segment1 part_no,
             sum(beg_bal_tbl.transaction_quantity) beginning_stock,
             count(buy_off_tbl.inventory_item_id) buy_off_count,
             count(tagged_units_tbl.inventory_item_id) tagged_units_count
FROM mtl_system_items_b msib
           -- BEGINNING STOCK TABLE
           LEFT JOIN (SELECT   msib2.attribute9 model,
                                            msib2.attribute8 color,
                                            moq.transaction_quantity,
                                            msib2.inventory_item_id,
                                            msib2.organization_id
--                                            max(moq.date_received)           
                            FROM mtl_onhand_quantities moq 
                                        INNER JOIN mtl_system_items_b  msib2
                                            ON msib2.organization_id = moq.organization_id
                                            AND moq.inventory_item_id = msib2.inventory_item_id
                            WHERE 1 = 1 
                                
                                        AND moq.organization_id = 121 
                                        AND moq.subinventory_code = 'VSS'
                                        AND to_date(date_received) < :p_as_of) beg_bal_tbl
           ON beg_bal_tbl.inventory_item_id = msib.inventory_item_id
           AND  beg_bal_tbl.organization_id = msib.organization_id
           -- BUY OFF TABLE
           LEFT JOIN (SELECT inventory_item_id,
                                          buyoff_date,
                                          organization_id,
                                          attribute15
                               FROM (
                                        SELECT 
                                              msib.inventory_item_id,
                                               MSN.ATTRIBUTE15,
                                               MSIB.ORGANIZATION_ID,
                                           CASE
                                              WHEN REGEXP_LIKE (msn.attribute5, '^[0-9]{2}-\w{3}-[0-9]{2}$')
                                              THEN
                                                 TO_CHAR (msn.attribute5, 'MM/DD/YYYY')
                                              WHEN REGEXP_LIKE (msn.attribute5, '^[0-9]{2}-\w{3}-[0-9]{4}$')
                                              THEN
                                                 TO_CHAR (msn.attribute5, 'MM/DD/YYYY')
                                              WHEN REGEXP_LIKE (msn.attribute5, '^[0-9]{4}/[0-9]{2}/[0-9]{2}')
                                              THEN
                                                 TO_CHAR (TO_DATE (msn.attribute5, 'YYYY/MM/DD HH24:MI:SS'),
                                                          'MM/DD/YYYY')
                                              ELSE
                                                 NULL
                                           END buyoff_date
                                      FROM MTL_SYSTEM_ITEMS_B MSIB, MTL_SERIAL_NUMBERS MSN
                                    WHERE 1 = 1
                                            AND MSN.INVENTORY_ITEM_ID = MSIB.INVENTORY_ITEM_ID
                                            AND MSN.CURRENT_ORGANIZATION_ID = MSIB.ORGANIZATION_ID
                                            AND msn.current_status in (3,4)    
                                            AND msn.c_attribute30 is null
                                            AND msib.organization_id = 121
                                            AND msib.item_type = 'FG'
                                          )
                                          WHERE 1 = 1
                                                        AND TO_DATE (buyoff_date, 'MM/DD/YYYY') = :P_AS_OF
                                                        AND attribute15 IS NULL) buy_off_tbl
           ON buy_off_tbl.inventory_item_id = msib.inventory_item_id
           AND buy_off_tbl.organization_id = msib.organization_id
           LEFT JOIN (SELECT 
                                      msib.inventory_item_id,
                                      msib.organization_id
                              FROM IPC_SALES_ORDER_V so
                                   LEFT JOIN mtl_serial_numbers msn
                                      ON so.serial_number = msn.serial_number
                                   LEFT JOIN mtl_system_items_b msib
                                      ON msn.inventory_item_id = msib.inventory_item_id
                                         AND msn.current_organization_id = msib.organization_id
                             WHERE 1 = 1
                                           AND so.SERIAL_NUMBER IS NOT NULL 
                                           AND so.RELEASED_FLAG = 'N'
                                           AND TO_DATE(msn.d_attribute20) = :P_AS_OF) tagged_units_tbl
            ON tagged_units_tbl.inventory_item_id = msib.inventory_item_id
            AND tagged_units_tbl.organization_id = msib.organization_id
WHERE 1 = 1
              AND msib.organization_id = 121
              AND msib.item_type = 'FG'
--              AND msib.inventory_item_id = 156259
              AND UPPER(msib.inventory_item_status_code) = 'ACTIVE'
GROUP BY
                msib.inventory_item_id,
                msib.attribute9,
                msib.attribute8,
                msib.inventory_item_status_code,
                msib.segment1;  

/* Beginning Stock */
SELECT    moq.inventory_item_id, 
                msib.segment1 part_no,
                msib.attribute9 model,
                msib.attribute8 color,
                sum(moq.transaction_quantity) quantity,
                max(moq.date_received)           
FROM mtl_onhand_quantities moq 
            INNER JOIN mtl_system_items_b  msib
                ON msib.organization_id = moq.organization_id
                AND moq.inventory_item_id = msib.inventory_item_id
WHERE 1 = 1 
            AND msib.inventory_item_id = 156256
            AND moq.organization_id = 121 
            AND moq.subinventory_code = 'VSS'
                          AND msib.item_type = 'FG'

              AND UPPER(msib.inventory_item_status_code) = 'ACTIVE'
            AND TO_DATE(date_received) < :P_as_of
GROUP BY
            moq.inventory_item_id,
            msib.attribute9,
            msib.attribute8,
            msib.segment1;

/* Buyoff Query */
SELECT * FROM (SELECT MSIB.INVENTORY_ITEM_ID,MSN.LOT_NUMBER,
                           MSIB.ATTRIBUTE9   SALES_MODEL,
                           MSN.SERIAL_NUMBER cs_no,
                           MSIB.ATTRIBUTE11  series,
                           msib.attribute11 || ' ' ||msn.attribute3 engine,
                           msib.attribute19 || ' ' ||msn.attribute7 aircon,
                           MSIB.ATTRIBUTE17  fuel_type,
                           MSIB.ATTRIBUTE18  cylinder,
                           MSIB.ATTRIBUTE16  piston_disp,
                           MSN.ATTRIBUTE2    chassis_no,
                           MSIB.ATTRIBUTE14  gvw,
                           MSIB.ATTRIBUTE8   color,
                           MSN.ATTRIBUTE4    body_no,
                           MSN.ATTRIBUTE15,
                           CASE
                              WHEN REGEXP_LIKE (msn.attribute5, '^[0-9]{2}-\w{3}-[0-9]{2}$')
                              THEN
                                 TO_CHAR (msn.attribute5, 'MM/DD/YYYY')
                              WHEN REGEXP_LIKE (msn.attribute5, '^[0-9]{2}-\w{3}-[0-9]{4}$')
                              THEN
                                 TO_CHAR (msn.attribute5, 'MM/DD/YYYY')
                              WHEN REGEXP_LIKE (msn.attribute5, '^[0-9]{4}/[0-9]{2}/[0-9]{2}')
                              THEN
                                 TO_CHAR (TO_DATE (msn.attribute5, 'YYYY/MM/DD HH24:MI:SS'),
                                          'MM/DD/YYYY')
                              ELSE
                                 NULL
                           END
                              buyoff_date,
                           msn.attribute15   mr_date
                      FROM MTL_SYSTEM_ITEMS_B MSIB, MTL_SERIAL_NUMBERS MSN
                    WHERE 1 = 1
                           AND MSN.INVENTORY_ITEM_ID = MSIB.INVENTORY_ITEM_ID
                           AND MSN.CURRENT_ORGANIZATION_ID = MSIB.ORGANIZATION_ID
                           AND msn.current_status in (3,4)    
                           AND msn.c_attribute30 is null
                           AND msib.item_type = 'FG')
                          WHERE 1 = 1
--                                AND SALES_MODEL = '010NPS75H-22'
--                          AND inventory_item_id = 373240
                           AND TO_DATE (buyoff_date, 'MM/DD/YYYY') = :P_AS_OF
----                          AND TO_DATE (buyoff_date, 'MM/DD/YYYY') <= :P_AS_OF
--                                AND TO_DATE (buyoff_date, 'MM/DD/YYYY') BETWEEN :P_START_DATE AND :P_END_DATE
                            AND attribute15 IS NULL;
                            
                            select *
                            from mtl_onhand_quantities_detail;
                            
/* Main Item Query */
SELECT -- msib.inventory_item_id,
             msib.segment1 part_no,
             msib.attribute9 model,
             msib.attribute8 color, 
             msib.inventory_item_id,
             (select sum(transaction_quantity)
             from mtl_onhand_quantities_detail
             where inventory_item_id = msib.inventory_item_id 
                        AND msib.organization_id = organization_id
                        AND TO_DATE(date_received) < :P_AS_OF) beginning_stock,
             (select count(msn_buyoff.serial_number)
             from mtl_serial_numbers msn_buyoff
             where msn_buyoff.inventory_item_id = msib.inventory_item_id
                AND msn_buyoff.current_organization_id = msib.organization_id
                AND msn_buyoff.current_status in (3,4)    
                AND msn_buyoff.c_attribute30 is null
                AND msib.organization_id IN (88)
                AND msib.item_type = 'FG'
                AND CASE 
                            WHEN REGEXP_LIKE (msn_buyoff.attribute5, '^[0-9]{2}-\w{3}-[0-9]{2}$')
                                THEN TO_CHAR (msn_buyoff.attribute5, 'MM/DD/YYYY')
                            WHEN REGEXP_LIKE (msn_buyoff.attribute5, '^[0-9]{2}-\w{3}-[0-9]{4}$')
                                THEN TO_CHAR (msn_buyoff.attribute5, 'MM/DD/YYYY')
                            WHEN REGEXP_LIKE (msn_buyoff.attribute5, '^[0-9]{4}/[0-9]{2}/[0-9]{2}')
                                THEN TO_CHAR (TO_DATE (msn_buyoff.attribute5, 'YYYY/MM/DD HH24:MI:SS'), 'MM/DD/YYYY')
                            ELSE
                                NULL
                        END = :P_AS_OF) buy_off,
--            sum(moqd.transaction_quantity) beginning_stock
--             msn_buy_off.serial_number
             (SELECT count(inventory_item_id) 
                FROM MTL_SERIAL_NUMBERS 
                WHERE RESERVATION_ID IS NOT NULL
                             AND inventory_item_id = msib.inventory_item_id
                             AND TO_DATE(d_attribute20) = :P_AS_OF
                             ) tagged_units,
              APPS.IPC_GET_INVOICED_COUNT(msib.inventory_item_id,msib.organization_id,:P_AS_OF) invoiced
--                count(invoices_tbl.customer_trx_id) invoiced
--             sum(case when msn_tagged.serial_number is not null then 1 else 0 end ) tagged_units
FROM mtl_system_items_b msib
--           LEFT JOIN mtl_onhand_quantities_detail moqd
--                ON moqd.organization_id = msib.organization_id
--                AND moqd.inventory_item_id = msib.inventory_item_id
              
--           LEFT JOIN mtl_serial_numbers msn_buy_off
--                ON msn_buy_off.inventory_item_id = msib.inventory_item_id
--                AND msn_buy_off.current_organization_id = msib.organization_id
--                AND msn_buy_off.current_status in (3,4)    
--                AND msn_buy_off.c_attribute30 is null
--                AND msib.organization_id = 121
--                AND msib.item_type = 'FG'
--                AND CASE 
--                            WHEN REGEXP_LIKE (msn_buy_off.attribute5, '^[0-9]{2}-\w{3}-[0-9]{2}$')
--                                THEN TO_CHAR (msn_buy_off.attribute5, 'MM/DD/YYYY')
--                            WHEN REGEXP_LIKE (msn_buy_off.attribute5, '^[0-9]{2}-\w{3}-[0-9]{4}$')
--                                THEN TO_CHAR (msn_buy_off.attribute5, 'MM/DD/YYYY')
--                            WHEN REGEXP_LIKE (msn_buy_off.attribute5, '^[0-9]{4}/[0-9]{2}/[0-9]{2}')
--                                THEN TO_CHAR (TO_DATE (msn_buy_off.attribute5, 'YYYY/MM/DD HH24:MI:SS'), 'MM/DD/YYYY')
--                            ELSE
--                                NULL
--                        END = :P_AS_OF
--                LEFT JOIN (SELECT * FROM mtl_serial_numbers WHERE reservation_id IS NOT NULL) msn_tagged 
--                        ON msn_tagged.current_organization_id = msib.organization_id
--                        AND msn_tagged.inventory_item_id = msib.inventory_item_id
                      
                        
--               LEFT JOIN (SELECT inventory_item_id, curr__ent_organization_id,d_attribute20 FROM mtl_serial_numbers 
--                                where 1 = 1 -- ON msn_tagged.inventory_item_id = msib.inventory_item_id
--                  --  AND msn_tagged.current_organization_id = msib.organization_id
--                    AND current_organization_id = 121
--                    and inventory_item_id = 373240
--                   -- AND msib.item_type = 'FG'
--                    AND reservation_id IS NOT NULL) msn_tag
--                    ON msn_tag.current_organization_id = msib.organization_id
--                    AND msib.inventory_item_id = msn_tag.inventory_item_id
--                     AND msib.item_type = 'FG'
--                    AND TO_DATE(msn_tag.d_attribute20) = :P_AS_OF
--                LEFT JOIN (SELECT rctla.inventory_item_id,
--                                           rctla.warehouse_id,
--                                           rctla.customer_trx_id
--                                FROM ra_customer_trx_lines_all rctla,
--                                           ra_customer_trx_all rcta
--                                WHERE 1 = 1
--                                            and rctla.customer_trx_id = rcta.customer_trx_id
--                                            -- and inventory_item_id = 373240
--                                GROUP BY rctla.inventory_item_id,
--                                                rctla.warehouse_id,
--                                                rctla.customer_trx_id) invoices_tbl
--               ON invoices_tbl.inventory_item_id = msib.inventory_item_id
--               AND invoices_tbl.warehouse_id = msib.organization_id
--                --  AND msn_buy_off.inventory_item_id = invoices_tbl.inventory_item_id
--               AND invoices_tbl.warehouse_id = 121
                
WHERE 1 = 1
            AND msib.organization_id = 121 
            AND msib.item_type = 'FG'
            and msib.segment1 = '150TFR86DRA1P-T.SIL'
--            AND msib.inventory_item_id = 373240
            AND UPPER(msib.inventory_item_status_code) = 'ACTIVE'
--              AND moqd.organization_id = 121 
--                AND moqd.subinventory_code = 'VSS'
--                AND msib.item_type = 'FG'
--                AND UPPER(msib.inventory_item_status_code) = 'ACTIVE'
                
--            AND msib.inventory_item_id = 
--GROUP  BY
--     --        msib.inventory_item_id,
--            msib.segment1,
--            msib.attribute9,
--            msib.attribute8
--            moqd.transaction_quantity
--            moqd.transaction_quantity,
--            msn_buy_off.serial_number;
;
SELECT *
FROM MTL_SERIAL_NUMBERS;

SELECT *
FROM mtl_serial_numbers
WHERE INVENTORY_ITEM_ID = 373240
AND CURRENT_ORGANIZATION_ID = 121
AND RESERVATION_ID IS NOT NULL;

SELECT SUM(TRANSACTION_QUANTITY)
FROM MTL_MATERIAL_TRANSACTIONS
WHERE INVENTORY_ITEM_ID = 373240;

SELECT *
FROM IPC_SALES_ORDER_V;

select inventory_item_id,
           warehouse_id,
           customer_trx_id
from ra_customer_trx_lines_all
where inventory_item_id = 373240
group by inventory_item_id,
                warehouse_id,
                customer_trx_id;


SELECT *
FROM MTL_SERIAL_NUMBERS
WHERE RESERVATION_ID IS NOT NULL
and inventory_item_id = 373240
;
select *

from mtl_onhand_quantities moqd, mtl_system_items_b msib
where 1 = 1
                and moqd.organization_id = msib
                .organization_id
                AND moqd.inventory_item_id = msib.inventory_item_id
                AND moqd.organization_id = 121 
                AND moqd.subinventory_code = 'VSS'
                AND msib.item_type = 'FG'
                AND UPPER(msib.inventory_item_status_code) = 'ACTIVE'
                and msib.inventory_item_id = 373240;
                
--                AND TO_DATE(moqd.date_received) < :P_AS_OF
;


select distinct a.organization_id,
           c.organization_code,
           b.inventory_item_id,
           b.segment1,
           b.description,
           a.transaction_uom_code,
           a.lot_number,
           d.serial_number,
           d.status_id
    from mtl_onhand_quantities_detail a,
         mtl_system_items b,
         mtl_parameters c,
         mtl_serial_numbers d,
         fnd_lookup_values_vl e
    where a.organization_id = b.organization_id
    and a.inventory_item_id = b.inventory_item_id    
    and b.organization_id = c.organization_id 
    and a.organization_id = d.current_organization_id
    and a.inventory_item_id = d.inventory_item_id
    and a.lot_number = d.lot_number
    and d.current_status = e.lookup_code
    and e.lookup_type = 'SERIAL_NUM_STATUS'
    and e.meaning = 'Resides in stores'
    and c.organization_code = 'IVP'     -- change to NYK
    and subinventory_code = 'FG'         
    and a.lot_number = '4X2 LSA-70'     --'4X2 LSA-71'
--    and d.serial_number in ('D0F332', 'D0F333')
    order by a.lot_number;
    
    select *
    from mtl_onhand_quantities_detail
    where inventory_item_id = 373240;
    
    SELECT *
    FROM MTL_RESERVATIONS;
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
--                          ON msn_tagged.current_organization_id = msib.organization_id
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
--            and msib.segment1 = '150TFR86DRA1P-T.SIL'
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


SELECT  msib.inventory_item_id,
            msib.segment1 part_no,
            msib.attribute9 sales_model,
            msib.attribute8 color,
            msn_tagged.serial_number,
            moqd.onhand_quantities_id
--            sum(moqd.transaction_quantity)
FROM mtl_system_items_b msib 
           LEFT JOIN mtl_onhand_quantities_detail moqd
                ON msib.organization_id = moqd.organization_id
                AND msib.inventory_item_id = moqd.inventory_item_id
           LEFT JOIN (SELECT * FROM mtl_serial_numbers WHERE reservation_id IS NOT NULL) msn_tagged 
                ON msib.organization_id = msn_tagged.current_organization_id
                AND msib.inventory_item_id = msn_tagged.inventory_item_id  
                        
WHERE 1 = 1
            AND msib.organization_id = 121 
            AND msib.item_type = 'FG'
--            AND msib.segment1 = '150TFR86DRA1P-T.SIL'
            AND msib.inventory_item_id = 144139
            AND UPPER(msib.inventory_item_status_code) = 'ACTIVE'
            ;
group by 
inventory_item_id,
             part_no,
             sales_model,
             color;

select *
from mtl_material_transaction
where inventory_item_id = 144139;

SELECT    distinct msib.inventory_item_id,
                msib.segment1 part_no,
                msib.attribute9 sales_model,
                msib.attribute8 color,
                sum(moqd.transaction_quantity)
FROM mtl_system_items_b msib,
            mtl_onhand_quantities_detail moqd,
            mtl_system_items_b msib_tagged,
            mtl_serial_numbers msn_tagged 
                 
WHERE 1 = 1
            AND moqd.organization_id = msib.organization_id
            AND moqd.inventory_item_id = msib.inventory_item_id
            
 
--            
            AND msib_tagged.inventory_item_id = msib.inventory_item_id
            AND msib_tagged.organization_id = msib.organization_id
            
             AND msn_tagged.current_organization_id = msib_tagged.organization_id
            AND msn_tagged.inventory_item_id = msib_tagged.inventory_item_id 
            
            AND msn_tagged.reservation_id IS NOT NULL
            AND msib.organization_id = 121 
            AND msib.item_type = 'FG'
            AND msib.inventory_item_id = 144139
            AND UPPER(msib.inventory_item_status_code) = 'ACTIVE'
GROUP BY 
            msib.inventory_item_id,
            msib.segment1,
            msib.attribute9,
            msib.attribute8,
            msib.inventory_item_id;
 



SELECT --inventory_item_id,
          --   part_no,
             sales_model,
             color,
             sum(beg_stock) beg_stock,
             sum(tagged) tagged,
             sum(buyoff) buyoff,
             sum(invoiced) invoiced
FROM (
           -- BEGINNING STOCK 
           SELECT     
                        msib.inventory_item_id,
                        msib.segment1 part_no,
                        msib.attribute9 sales_model,
                        msib.attribute8 color,
                        sum(moqd.transaction_quantity) beg_stock,
                        0 tagged,
                        0 buyoff,
                        0 invoiced
            FROM mtl_system_items_b msib,
                        mtl_onhand_quantities_detail moqd    
            WHERE 1 = 1
                        AND moqd.organization_id = msib.organization_id
                        AND moqd.inventory_item_id = msib.inventory_item_id           
                        AND msib.organization_id = 121 
                        AND msib.item_type = 'FG'
                        AND TO_DATE(date_received) < :P_AS_OF
            --            AND msib.inventory_item_id = 144139
                        AND UPPER(msib.inventory_item_status_code) = 'ACTIVE'
            GROUP BY 
                        msib.inventory_item_id,
                        msib.segment1,
                        msib.attribute9,
                        msib.attribute8,
                        msib.inventory_item_id
            UNION
            -- TAGGED UNITS
            SELECT    msib_tagged.inventory_item_id,
                            msib_tagged.segment1 part_no,
                            msib_tagged.attribute9 sales_model,
                            msib_tagged.attribute8 color,
                            0 beg_stock,
                            count(msn_tagged.serial_number) tagged,
                            0 buyoff,
                            0 invoiced
            FROM 
                        mtl_system_items_b msib_tagged,
                        mtl_serial_numbers msn_tagged 
            WHERE 1 = 1
                        AND msn_tagged.current_organization_id = msib_tagged.organization_id
                        AND msn_tagged.inventory_item_id = msib_tagged.inventory_item_id             
                        AND msn_tagged.reservation_id IS NOT NULL
                        AND msib_tagged.organization_id = 121 
                        AND msib_tagged.item_type = 'FG'
                        AND TO_DATE(msn_tagged.d_attribute20) = :P_AS_OF
            --            AND msib_tagged.inventory_item_id = 144139
                        AND UPPER(msib_tagged.inventory_item_status_code) = 'ACTIVE'
            GROUP BY 
                        msib_tagged.inventory_item_id,
                        msib_tagged.segment1,
                        msib_tagged.attribute9,
                        msib_tagged.attribute8,
                        msib_tagged.inventory_item_id
            UNION
            -- BUY OFF
            SELECT msib.inventory_item_id,
                            msib.segment1 part_no,
                            msib.attribute9 sales_model,
                            msib.attribute8 color,
                            0 beg_stock,
                            0 tagged,
                            count(msn_buyoff.inventory_item_id) buyoff,
                            0 invoiced
             FROM mtl_serial_numbers msn_buyoff,
                      mtl_system_items_b msib
                   
             WHERE msn_buyoff.inventory_item_id = msib.inventory_item_id
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
                        END = :P_AS_OF
               GROUP BY 
                        msib.inventory_item_id,
                        msib.segment1 ,
                        msib.attribute9 ,
                        msib.attribute8 
            UNION 
            -- INVOICED
               SELECT inventory_item_id,
                            part_no,
                            sales_model,
                            color,
                            0 beg_stock,
                            0 tagged,
                            0 buyoff,
                            count(customer_trx_id) invoiced
                FROM (
                SELECT msib.inventory_item_id,
                            msib.segment1 part_no,
                            msib.attribute9 sales_model,
                            msib.attribute8 color,
--                            rctla.inventory_item_id,
                            rctla.warehouse_id,
                            rctla.customer_trx_id
                      FROM ra_customer_trx_lines_all rctla,
                                           ra_customer_trx_all rcta,
                                           mtl_system_items_b msib
                                WHERE 1 = 1
                                            AND rctla.customer_trx_id = rcta.customer_trx_id
--                                            and rctla.inventory_item_id = 373240
--                                            and rctla.warehouse_id = 121
                                            AND rctla.inventory_item_id = msib.inventory_item_id
                                            AND rctla.warehouse_id = msib.organization_id
                                            AND msib.organization_id IN (88)
                                            AND msib.item_type = 'FG'
                                            AND to_date(rcta.trx_date) = :P_AS_OF
                                GROUP BY 
                                                msib.inventory_item_id,
                                                msib.segment1,
                                                msib.attribute9,
                                                msib.attribute8,
                                                rctla.inventory_item_id,
                                                rctla.warehouse_id,
                                                rctla.customer_trx_id    
                    )
                    GROUP BY  inventory_item_id,
                                        part_no,
                                        sales_model,
                                        color
            )
GROUP BY ROLLUP
          ( 
           
            sales_model,
            color) 
            ;
            
select *
from dbs_picklist_interface
where request_number = '1917638';


           
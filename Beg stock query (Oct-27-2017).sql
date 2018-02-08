SELECT inventory_item_id,
            part_no,
            sales_model,
            color,
            BEG_STOCK + BUYOFF - INVOICED beg_stock,
            0 tagged,
            0 buyoff,
            0 invoiced
FROM (SELECT
                        inventory_item_id,
                        part_no,
                        sales_model,
                        color,
                        NVL(sum(beg_stock),0) beg_stock,
                        0 tagged,
                        NVL(sum(buyoff),0) buyoff,
                        NVL(sum(invoiced),0) invoiced
                FROM (
                           -- BEGINNING STOCK 
                           SELECT 
                                        msib.inventory_item_id,
                                        msib.segment1 part_no,
                                        nvl(msib.attribute9,msib.segment1) sales_model,
                                        msib.attribute8 color,
                                        sum(mmt.transaction_quantity) beg_stock,
                                        0 tagged,
                                        0 buyoff,
                                        0 invoiced
                            FROM mtl_material_transactions mmt 
                                    INNER JOIN mtl_transaction_types mtt
                                        ON mtt.transaction_type_id = mmt.transaction_type_id
                                    INNER JOIN mtl_system_items_b msib
                                        ON msib.inventory_item_id = mmt.inventory_item_id
                                        AND msib.organization_id = mmt.organization_id
                            WHERE 1 = 1
                                        and mmt.organization_id IN (121,107)
                                        and mmt.SUBINVENTORY_code IN ('VSS','STG')
                                        and UPPER(msib.inventory_item_status_code) = 'ACTIVE'
                                        and trunc(mmt.transaction_date) <= add_months(TO_DATE(:P_AS_OF), -2)
                            GROUP BY 
                                       msib.inventory_item_id,
                                        msib.segment1,
                                        msib.attribute9,
                                        msib.segment1,
                                        msib.attribute8
                           
                            UNION ALL
                            -- BUY OFF
                            SELECT   inventory_item_id,
                                     part_no,
                                     nvl(sales_model,part_no) sales_model,
                                     color,
                                     0 beg_stock,
                                     0 tagged,
                                     count(cs_no) buyoff,
                                     0 invoiced
                            FROM (SELECT MSN.LOT_NUMBER,
                                       MSIB.INVENTORY_ITEM_ID,
                                       MSIB.SEGMENT1 PART_NO,
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
                                  AND TO_DATE (buyoff_date, 'MM/DD/YYYY') BETWEEN TO_DATE(ADD_MONTHS((LAST_DAY(:P_AS_OF)+1),-2)) AND TO_DATE(ADD_MONTHS(:P_AS_OF,-1))
                                  AND attribute15 IS NULL
                            GROUP BY
                                inventory_item_id,
                                part_no,
                                sales_model,
                                color
                            UNION ALL
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
                                  SELECT  msib.inventory_item_id,
                                          msib.segment1 part_no,
                                          nvl(msib.attribute9,msib.segment1) sales_model,
                                          msib.attribute8 color,
                                          rctla.warehouse_id,
                                          rctla.customer_trx_id
                                  FROM ra_customer_trx_lines_all rctla
                                        INNER JOIN ra_customer_trx_all rcta
                                            ON rctla.customer_trx_id = rcta.customer_trx_id
                                        INNER JOIN mtl_system_items_b msib
                                            ON  rctla.inventory_item_id = msib.inventory_item_id
                                            AND rctla.warehouse_id = msib.organization_id
                                         LEFT  JOIN ipc_ar_invoices_with_cm cm
                                            ON rcta.customer_trx_id = cm.orig_trx_id
                                  WHERE 1 = 1
                                              AND rcta.cust_trx_type_id = 1002
                                              AND cm.orig_trx_id IS NULL
                                              AND msib.organization_id IN (121,107)
                                              AND msib.item_type = 'FG'
                                              AND to_date(rcta.trx_date) BETWEEN TO_DATE(ADD_MONTHS((LAST_DAY(:P_AS_OF)+1),-2)) AND TO_DATE(ADD_MONTHS(:P_AS_OF,-1))
                                  GROUP BY 
                                      msib.inventory_item_id,
                                      msib.segment1,
                                      msib.attribute9,
                                      msib.attribute8,
                                      rctla.inventory_item_id,
                                      rctla.warehouse_id,
                                      rctla.customer_trx_id    
                                )
             GROUP BY
              inventory_item_id,
              part_no,
              sales_model,
              color             
          ) 
           GROUP BY
              inventory_item_id,
              part_no,
              sales_model,
              color                                  
      );

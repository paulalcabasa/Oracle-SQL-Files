SELECT *
  FROM (  SELECT hp.party_name customer_name,
                 hcaa.account_name,
                 hcaa.account_number,
                 hcsua.location,
                 regexp_replace(hl.address1,'DEALERS-PARTS|DEALERS-VEHICLE|DEALERS-FLEET','') || ' ' || hl.address2 || ' ' || hl.address3
                 address,
                 hcsua.tax_reference,
                 rcta.trx_number invoice_no,
                 rcta.trx_date invoice_date,
                 rtt.name term,
                 msn.attribute1 csr,
                 msn.attribute12 csr_or,
                 CASE 
                        WHEN rcta.attribute5 IS NOT NULL
                        THEN TO_CHAR(TO_DATE(rcta.attribute5,'YYYY/MM/DD HH24:MI:SS'),'MM/DD/YYYY')
                        ELSE NULL
                 end pull_out_date,
                CASE
                    WHEN REGEXP_LIKE (msn.attribute5,
                    '^[0-9]{2}-\w{3}-[0-9]{2}$' --     DD-MON-YY
                    )
                    THEN TO_CHAR (msn.attribute5, 'MM/DD/YYYY')
                    WHEN REGEXP_LIKE (msn.attribute5,
                    '^[0-9]{2}-\w{3}-[0-9]{4}$'  -- DD-MON-YYYY
                    )
                    THEN TO_CHAR (msn.attribute5, 'MM/DD/YYYY')
                    WHEN REGEXP_LIKE (msn.attribute5,
                    '^[0-9]{4}/[0-9]{2}/[0-9]{2}' -- YYYY/MM/DD
                    )
                    THEN TO_CHAR (TO_DATE (msn.attribute5,
                    'YYYY/MM/DD HH24:MI:SS'
                    ),
                    'MM/DD/YYYY'
                    )
                    WHEN REGEXP_LIKE (msn.attribute5,
                    '^[0-9]{2}/[0-9]{2}/[0-9]{4}' -- MM/DD/YYYY
                    )
                    THEN TO_CHAR (TO_DATE (msn.attribute5,
                    'MM/DD/YYYY'
                    ),
                    'MM/DD/YYYY'
                    )
                    ELSE TO_CHAR(to_Date(msn.attribute5, 'MM/DD/YYYY'),'MM/DD/YYYY')
                END buyoff_date,
                 MAX (rctla.quantity_invoiced) quantity,
                 SUM (
                    CASE
                       WHEN rctla.line_recoverable != 0
                       THEN
                          rctla.line_recoverable
                       ELSE
                          0
                    END)
                    gross,
                 CASE
                    WHEN rcta.cust_trx_type_id = 1002
                    THEN
                       CASE
                          WHEN SUM (
                                  DECODE (rctla.interface_line_attribute11,
                                          '0', 0,
                                          rctla.line_recoverable)) > 0
                          THEN
                             0
                          ELSE
                             SUM (
                                DECODE (rctla.interface_line_attribute11,
                                        '0', 0,
                                        rctla.line_recoverable))
                       END
                    WHEN rcta.cust_trx_type_id IN (3081, 6081)
                    THEN
                       CASE
                          WHEN SUM (
                                  DECODE (rctla.interface_line_attribute11,
                                          '0', 0,
                                          rctla.line_recoverable)) < 0
                          THEN
                             0
                          ELSE
                             SUM (
                                DECODE (rctla.interface_line_attribute11,
                                        '0', 0,
                                        rctla.extended_amount))
                       END
                 END
                    discount,
                 SUM (rctla.tax_recoverable) tax,
                 rcta.interface_header_attribute1 so_num,
                 rcta.purchase_order,
                 wnd.delivery_id dr_num,
                 msib.segment1 model,
                 msib.attribute9 sales_model,
                 msn.lot_number,
                 msn.attribute2 chassis_number,
                 msn.attribute3 engine_number,
                 msib.attribute8 body_color,
                 msib.attribute17 fuel_type,
                 msn.attribute6 key_no,
                 msib.attribute13 tire_brand,
                 msib.attribute12 battery,
                 msn.serial_number cs_no,
                 msib.attribute21 year_model,
                 we.wip_entity_name job_order_no,
                 mmt.trx_source_line_id ,
                  msn.last_transaction_id,
                   mmt.transaction_id
            --            credit_invoices.trx_number credit_invoice
            FROM -- INVOICE
                 ra_customer_trx_all rcta
                 INNER JOIN ra_customer_trx_lines_all rctla
                    ON rctla.customer_trx_id = rcta.customer_trx_id
                 INNER JOIN ra_cust_trx_types_all rctta
                    ON rctta.cust_trx_type_id = rcta.cust_trx_type_id
             
                 -- CUSTOMER DATA
                 INNER JOIN hz_cust_accounts_all hcaa
                    ON hcaa.cust_account_id = rcta.bill_to_customer_id
                 INNER JOIN hz_cust_site_uses_all hcsua
                    ON     hcsua.site_use_id = rcta.bill_to_site_use_id
                       AND hcsua.status = 'A'
                       AND hcsua.site_use_code = 'BILL_TO'
                 INNER JOIN hz_parties hp
                    ON hp.party_id = hcaa.party_id
                 INNER JOIN hz_cust_acct_sites_all hcasa
                    ON hcsua.cust_acct_site_id = hcasa.cust_acct_site_id
                 INNER JOIN hz_party_sites hps
                    ON hps.party_site_id = hcasa.party_site_id
                 INNER JOIN hz_locations hl
                    ON hl.location_id = hps.location_id
                 -- TERMS
                 LEFT JOIN ra_terms_tl rtt
                    ON rtt.term_id = rcta.term_id
                 -- SALES ORDER
                 LEFT JOIN oe_order_headers_all ooha
                    ON TO_CHAR (rcta.interface_header_attribute1) =
                          TO_CHAR (ooha.order_number)
                 INNER JOIN oe_order_lines_all oola
                    ON oola.header_id = ooha.header_id
                       AND oola.line_number = rctla.sales_order_line
                 LEFT JOIN wsh_delivery_details wdd
                    ON oola.line_id = wdd.source_line_id
                 LEFT JOIN wsh_delivery_assignments wda
                    ON wdd.delivery_detail_id = wda.delivery_detail_id
                 LEFT JOIN wsh_new_deliveries wnd
                    ON wda.delivery_id = wnd.delivery_id
                 -- MATERIAL TRANSACTIONS
                 LEFT JOIN (SELECT mmts.*
                              FROM    mtl_material_transactions mmts
                                   LEFT JOIN
                                      mtl_transaction_types mtt
                                   ON mmts.transaction_type_id =
                                         mtt.transaction_type_id
                             WHERE 1 = 1
                                   AND mtt.transaction_type_name IN
                                          ('Sales order issue',
                                           'Sales Order Pick')) mmt
                    ON mmt.trx_source_line_id = oola.line_id
                      AND mmt.trx_source_delivery_id = wnd.delivery_id
                 LEFT JOIN mtl_serial_numbers msn
                    ON msn.last_transaction_id = mmt.transaction_id
                 LEFT JOIN mtl_system_items_b msib
                    ON msn.inventory_item_id = msib.inventory_item_id
                     AND msib.organization_id = msn.current_organization_id
                LEFT JOIN wip_entities we
                    ON msn.original_wip_entity_id = we.wip_entity_id
           WHERE 1 = 1 -- filter
                 
        GROUP BY hp.party_name,
                 hcaa.account_name,
                 hcaa.account_number,
                 hcsua.location,
                 hl.address1,hl.address2,hl.address3,
                 hcsua.tax_reference,
                 rcta.trx_number,
                 rcta.trx_date,
                 rtt.name,
                 msib.segment1,
                 msib.attribute9,
                 msn.attribute1,
                 rcta.attribute5,
                 rcta.attribute3,
                 rcta.interface_header_attribute1,
                 rcta.purchase_order,
                 wnd.delivery_id,
                 msib.description,
                 msn.lot_number,
                 msn.attribute2,
                 msn.attribute3,
                 msn.attribute12,
                 msib.attribute8,
                 msib.attribute17,
                 msn.attribute6,
                 msib.attribute13,
                 msib.attribute12,
                 msn.serial_number,
                 msib.attribute21,
                 msn.attribute5,
                rcta.cust_trx_type_id,
                mmt.trx_source_line_id,
                msn.last_transaction_id,
                mmt.transaction_id,
                we.wip_entity_name
       )
 WHERE 1 = 1 
               AND gross <> 0
               AND invoice_no like '403%'
               AND invoice_date Between 
                       TO_DATE(:P_INVOICED_START,'YYYY/MM/DD HH24:MI:SS') AND 
                       TO_DATE(:P_INVOICED_END,'YYYY/MM/DD HH24:MI:SS');
 
 -- new query for sales order
 SELECT customer_name,
       account_name,
       account_number,
       location,
       address,
       tax_reference,
       invoice_no,
       invoice_date,
       term,
       csr,
       csr_or,
       pull_out_date,
       buyoff_date,
       quantity,
       CASE 
            WHEN manual_override > 0 THEN
                line_amount + manual_override
             ELSE line_amount
       end gross,
       discount,
       tax,
       so_num,
       purchase_order,
       dr_num,
       inventory_item_id,
      (select aa.attribute9 
         from mtl_system_items aa,
              mtl_parameters bb
        where aa.inventory_item_id = a.inventory_item_id
          and aa.organization_id = bb.organization_id
          and bb.organization_code = 'IVS') sales_model,
       model,
       lot_number,
       chassis_number,
       engine_number,
       body_color,
       fuel_type,
       key_no,
       tire_brand,
       battery,
       cs_no,
       year_model,
       job_order_no, 
       trx_source_line_id,
       last_transaction_id,
       transaction_id
  FROM (SELECT hp.party_name customer_name,
                 hcaa.account_name,
                 hcaa.account_number,
                 hcsua.location,
                 regexp_replace(hl.address1,'DEALERS-PARTS|DEALERS-VEHICLE|DEALERS-FLEET','') || ' ' || hl.address2 || ' ' || hl.address3
                 address,
                 hcsua.tax_reference,
                 rcta.trx_number invoice_no,
                 rcta.trx_date invoice_date,
                 rtt.name term,
                 msn.attribute1 csr,
                 msn.attribute12 csr_or,
                 CASE 
                        WHEN rcta.attribute5 IS NOT NULL
                        THEN TO_CHAR(TO_DATE(rcta.attribute5,'YYYY/MM/DD HH24:MI:SS'),'MM/DD/YYYY')
                        ELSE NULL
                 end pull_out_date,
                CASE
                    WHEN REGEXP_LIKE (msn.attribute5,
                    '^[0-9]{2}-\w{3}-[0-9]{2}$' --     DD-MON-YY
                    )
                    THEN TO_CHAR (msn.attribute5, 'MM/DD/YYYY')
                    WHEN REGEXP_LIKE (msn.attribute5,
                    '^[0-9]{2}-\w{3}-[0-9]{4}$'  -- DD-MON-YYYY
                    )
                    THEN TO_CHAR (msn.attribute5, 'MM/DD/YYYY')
                    WHEN REGEXP_LIKE (msn.attribute5,
                    '^[0-9]{4}/[0-9]{2}/[0-9]{2}' -- YYYY/MM/DD
                    )
                    THEN TO_CHAR (TO_DATE (msn.attribute5,
                    'YYYY/MM/DD HH24:MI:SS'
                    ),
                    'MM/DD/YYYY'
                    )
                    WHEN REGEXP_LIKE (msn.attribute5,
                    '^[0-9]{2}/[0-9]{2}/[0-9]{4}' -- MM/DD/YYYY
                    )
                    THEN TO_CHAR (TO_DATE (msn.attribute5,
                    'MM/DD/YYYY'
                    ),
                    'MM/DD/YYYY'
                    )
                    ELSE TO_CHAR(to_Date(msn.attribute5, 'MM/DD/YYYY'),'MM/DD/YYYY')
                END buyoff_date,
                MAX (rctla.quantity_invoiced) quantity,
                SUM (        
                    CASE
                        WHEN rctla.interface_line_attribute11 != 0 THEN
                            rctla.line_recoverable
                        ELSE
                            0
                        END
                ) manual_override,
                SUM (              
                        CASE
                            WHEN rctla.interface_line_attribute11 = 0
                            THEN rctla.line_recoverable
                            ELSE 0
                            END
                ) line_amount,
                 CASE
                    WHEN rcta.cust_trx_type_id = 1002
                    THEN
                       CASE
                          WHEN SUM (
                                  DECODE (rctla.interface_line_attribute11,
                                          '0', 0,
                                          rctla.line_recoverable)) > 0
                          THEN
                             0
                          ELSE
                             SUM (
                                DECODE (rctla.interface_line_attribute11,
                                        '0', 0,
                                        rctla.line_recoverable))
                       END
                    WHEN rcta.cust_trx_type_id IN (3081, 6081)
                    THEN
                       CASE
                          WHEN SUM (
                                  DECODE (rctla.interface_line_attribute11,
                                          '0', 0,
                                          rctla.line_recoverable)) < 0
                          THEN
                             0
                          ELSE
                             SUM (
                                DECODE (rctla.interface_line_attribute11,
                                        '0', 0,
                                        rctla.line_recoverable))
                       END
                 END
                    discount,
                 SUM (rctla.tax_recoverable) tax,
                 rcta.interface_header_attribute1 so_num,
                 rcta.purchase_order,
                 wnd.delivery_id dr_num,
                 msib.inventory_item_id, --
                 msib.segment1 model,
                 msn.lot_number,
                 msn.attribute2 chassis_number,
                 msn.attribute3 engine_number,
                 msib.attribute8 body_color,
                 msib.attribute17 fuel_type,
                 msn.attribute6 key_no,
                 msib.attribute13 tire_brand,
                 msib.attribute12 battery,
                 msn.serial_number cs_no,
                 msib.attribute21 year_model,
                 we.wip_entity_name job_order_no,
                 mmt.trx_source_line_id ,
                 msn.last_transaction_id,
                 mmt.transaction_id
            --            credit_invoices.trx_number credit_invoice
            FROM -- INVOICE
                 ra_customer_trx_all rcta
                 INNER JOIN ra_customer_trx_lines_all rctla
                    ON rctla.customer_trx_id = rcta.customer_trx_id
                 INNER JOIN ra_cust_trx_types_all rctta
                    ON rctta.cust_trx_type_id = rcta.cust_trx_type_id             
                 -- CUSTOMER DATA
                 INNER JOIN hz_cust_accounts_all hcaa
                    ON hcaa.cust_account_id = rcta.bill_to_customer_id
                 INNER JOIN hz_cust_site_uses_all hcsua
                    ON     hcsua.site_use_id = rcta.bill_to_site_use_id
                       AND hcsua.status = 'A'
                       AND hcsua.site_use_code = 'BILL_TO'
                 INNER JOIN hz_parties hp
                    ON hp.party_id = hcaa.party_id
                 INNER JOIN hz_cust_acct_sites_all hcasa
                    ON hcsua.cust_acct_site_id = hcasa.cust_acct_site_id
                 INNER JOIN hz_party_sites hps
                    ON hps.party_site_id = hcasa.party_site_id
                 INNER JOIN hz_locations hl
                    ON hl.location_id = hps.location_id
                 -- TERMS
                 LEFT JOIN ra_terms_tl rtt
                    ON rtt.term_id = rcta.term_id
                 -- SALES ORDER
                 LEFT JOIN oe_order_headers_all ooha
                    ON TO_CHAR (rcta.interface_header_attribute1) =
                          TO_CHAR (ooha.order_number)
                 INNER JOIN oe_order_lines_all oola
                    ON oola.header_id = ooha.header_id
                       AND oola.line_number = rctla.sales_order_line
                 LEFT JOIN wsh_delivery_details wdd
                    ON oola.line_id = wdd.source_line_id
                 LEFT JOIN wsh_delivery_assignments wda
                    ON wdd.delivery_detail_id = wda.delivery_detail_id
                 LEFT JOIN wsh_new_deliveries wnd
                    ON wda.delivery_id = wnd.delivery_id
                 -- MATERIAL TRANSACTIONS
                 LEFT JOIN (SELECT mmts.*
                              FROM    mtl_material_transactions mmts
                                   LEFT JOIN
                                      mtl_transaction_types mtt
                                   ON mmts.transaction_type_id =
                                         mtt.transaction_type_id
                             WHERE 1 = 1
                                   AND mtt.transaction_type_name IN
                                          ('Sales order issue',
                                           'Sales Order Pick')) mmt
                    ON mmt.trx_source_line_id = oola.line_id
                      AND mmt.trx_source_delivery_id = wnd.delivery_id
                 LEFT JOIN mtl_serial_numbers msn
                    ON msn.last_transaction_id = mmt.transaction_id
                 LEFT JOIN mtl_system_items_b msib
                    ON msn.inventory_item_id = msib.inventory_item_id
                     AND msib.organization_id = msn.current_organization_id
                LEFT JOIN wip_entities we
                    ON msn.original_wip_entity_id = we.wip_entity_id
           WHERE 1 = 1 -- filter                 
        GROUP BY hp.party_name,
                 hcaa.account_name,
                 hcaa.account_number,
                 hcsua.location,
                 hl.address1,hl.address2,hl.address3,
                 hcsua.tax_reference,
                 rcta.trx_number,
                 rcta.trx_date,
                 rtt.name,
                 msn.attribute1,
                 rcta.attribute5,
                 rcta.attribute3,
                 rcta.interface_header_attribute1,
                 rcta.purchase_order,
                 wnd.delivery_id,
                 msib.inventory_item_id, --
                 msib.segment1,
                 msn.lot_number,
                 msn.attribute2,
                 msn.attribute3,
                 msn.attribute12,
                 msib.attribute8,
                 msib.attribute17,
                 msn.attribute6,
                 msib.attribute13,
                 msib.attribute12,
                 msn.serial_number,
                 msib.attribute21,
                 msn.attribute5,
                rcta.cust_trx_type_id,
                mmt.trx_source_line_id,
                msn.last_transaction_id,
                mmt.transaction_id,
                we.wip_entity_name       ) a
WHERE 1 = 1 
               AND line_amount <> 0
               AND invoice_no like '403%'
         --       and invoice_no = '40300017516'; with manual override
     --          AND invoice_no = '40300004148' with discount
          --      and invoice_no = '40300006190'; -- with  cm
               AND invoice_date Between 
                       TO_DATE(:P_INVOICED_START,'YYYY/MM/DD HH24:MI:SS') AND 
                       TO_DATE(:P_INVOICED_END,'YYYY/MM/DD HH24:MI:SS');
;                      
                

select *
from ipc_ar_invoices_with_cm;       
                       select *
                       from ra_customer_trx_All
                       where trx_number = '40300004153';
                       
                       select interface_line_attribute11,
                                    line_recoverabl
                       from ra_customer_trx_lines_all
                       where customer_trx_id = 144414;
/* Formatted on 26/7/2017 11:14:43 AM (QP5 v5.163.1008.3004) */
  SELECT acct,
         order_type,
         mdl_grp,
         series,
         customer_name,
         customer_number,
         account_name,
         description,
         item_no,
         dr_no,
         item_cost,
         quantity_invoiced,
         SUM (sales_amt) sales_amt,
         exchange_rate,
         trx_number,
         so_number,
         organization_id,
         invoiced_date,
         transaction_type,
         purchase_group,
         pruduct_code1,
         country_of_origin,
         product_code2,
         item_categories,
         po_number,
         inventory_class,
         ship_date,
         unit_price,
         remarks1,
         remarks2,
         (SELECT ffv.description
            FROM FND_FLEX_VALUES_VL ffv
           --where description = 'Fast Moving Parts'
           WHERE     enabled_flag <> 'N'
                 AND FLEX_VALUE_SET_ID = 1016411
                 AND ffv.flex_value_meaning = inventory_class)
            class_description,
         CASE
            WHEN acct = 'Dealers-Parts' THEN 1
            WHEN acct = 'Fleet Accounts-Parts' THEN 2
            WHEN acct = 'Parts-Wholesale' THEN 3
            WHEN acct = 'IPC Teammembers' THEN 4
            WHEN acct = 'Powertrain' THEN 5
            WHEN acct = 'Export Customer' THEN 6
            WHEN acct = 'Dealers-Fleet' THEN 7
            ELSE 8
         END
            POSITION
    FROM (  SELECT --a.line_id
                   b.acct,
                   a.order_type,
                   a.mdl_grp,
                   a.customer_name,
                   a.customer_number,
                   a.account_name,
                   a.description,
                   a.item_no,
                   a.line_number,
                   a.dr_no,
                   a.item_cost,
                   a.quantity_invoiced,
                   a.series,
                   a.inventory_class,
                   a.unit_price,
                   -- ,sum(a.sales_amt) sales_amt
                   CASE
                      WHEN a.exchange_rate IS NOT NULL
                      THEN
                         a.exchange_rate * SUM (a.sales_amt)
                      ELSE
                         SUM (a.sales_amt)
                   END
                      sales_amt,
                   a.exchange_rate-- ,a.extended_price
                   ,
                   a.trx_number,
                   a.so_number,
                   a.organization_id,
                   a.trx_date invoiced_date,
                   a.transaction_type,
                   a.purchase_group,
                   a.pruduct_code1,
                   a.country_of_origin,
                   a.product_code2,
                   c.item_categories,
                   a.po_number,
                   a.ship_date,
                   a.remarks1,
                   a.remarks2,
                   CASE
                      WHEN b.acct = 'Dealers-Parts' THEN 1
                      WHEN b.acct = 'Fleet Accounts-Parts' THEN 2
                      WHEN b.acct = 'Parts-Wholesale' THEN 3
                      WHEN b.acct = 'IPC Teammembers' THEN 4
                      WHEN b.acct = 'Powertrain' THEN 5
                      WHEN b.acct = 'Export Customer' THEN 6
                      WHEN b.acct = 'Dealers-Fleet' THEN 7
                      ELSE 8
                   END
                      POSITION
              FROM (  SELECT DISTINCT
                             rcta.bill_to_customer_id,
                             (SELECT oet.NAME AS o_type
                                FROM oe_order_headers_all oeh,
                                     oe_transaction_types_tl oet
                               WHERE order_number = rctla.interface_line_attribute1
                                     AND oeh.order_type_id =
                                            oet.transaction_type_id)
                                order_type,
                             rcta.bill_to_site_use_id,
                             rcta.customer_trx_id,
                             msib.attribute6 mdl_grp,
                             cust.customer_name,
                             cust.customer_number,
                             msib.segment1 item_no,
                             cic.item_cost,
                             rctla.quantity_invoiced,
                             rctla.extended_amount sales_amt,
                             ol.unit_list_price extended_price,
                             rcta.trx_number,
                             msib.inventory_item_id,
                             msib.organization_id,
                             hcaa.account_name,
                             ol.line_id,
                             rctla.interface_line_attribute6,
                             rcta.trx_date,
                             oh.order_number so_number,
                             rctta.NAME transaction_type,
                             msib.description,
                             ol.attribute10 dr_no,
                             msib.attribute2 purchase_group,
                             msib.attribute4 pruduct_code1,
                             msib.attribute7 country_of_origin,
                             msib.attribute9 product_code2,
                             rcta.exchange_rate,
                             rctla.line_number,
                             msib.attribute17 inventory_class,
                             oh.cust_po_number po_number,
                             ol.schedule_ship_date ship_date,
                             ol.unit_selling_price unit_price,
                             oh.attribute1 remarks1,
                             oh.attribute2 remarks2,
                             CASE
                                WHEN SUBSTR (msib.attribute6, 0, 3) IN ('LUB')
                                THEN
                                   'LUBRICANTS'
                                WHEN SUBSTR (msib.attribute6, 0, 2) IN ('UB')
                                THEN
                                   'UBR/UBS'
                                WHEN SUBSTR (msib.attribute6, 0, 2) IN ('UC')
                                THEN
                                   'UCR'
                                WHEN SUBSTR (msib.attribute6, 0, 1) IN ('E')
                                THEN
                                   'E SERIES'
                                WHEN SUBSTR (msib.attribute6, 0, 1) IN ('C')
                                THEN
                                   'C SERIES'
                                WHEN SUBSTR (msib.attribute6, 0, 1) IN ('F')
                                THEN
                                   'F SERIES'
                                WHEN SUBSTR (msib.attribute6, 0, 1) IN ('N')
                                THEN
                                   'N SERIES'
                                WHEN SUBSTR (msib.attribute6, 0, 2) IN ('TF')
                                THEN
                                   'TFR'
                                WHEN SUBSTR (msib.attribute6, 0, 2) IN ('TB')
                                THEN
                                   'TBR'
                                WHEN SUBSTR (msib.attribute6, 0, 2) IN ('LV')
                                THEN
                                   'L SERIES'
                                WHEN SUBSTR (msib.attribute6, 0, 2) IN ('LT')
                                THEN
                                   'L SERIES'
                                WHEN SUBSTR (msib.attribute6, 0, 2) IN ('TO')
                                THEN
                                   'TOOL'
                                ELSE
                                   'OTHERS'
                             END
                                series
                        FROM ra_customer_trx_all rcta,
                             ar_customers cust,
                             ra_customer_trx_lines_all rctla,
                             mtl_system_items_b msib,
                             oe_order_lines_all ol,
                             oe_order_headers_all oh,
                             cst_item_costs cic,
                             hz_cust_accounts_all hcaa,
                             ra_cust_trx_types_all rctta
                       WHERE     rcta.bill_to_customer_id = cust.customer_id
                             AND rcta.customer_trx_id = rctla.customer_trx_id
                             AND rctla.inventory_item_id = msib.inventory_item_id
                             AND msib.organization_id = ol.ship_from_org_id
                             AND ol.line_id = rctla.interface_line_attribute6
                             AND ol.header_id = oh.header_id
                             AND msib.inventory_item_id = cic.inventory_item_id
                             AND msib.organization_id = cic.organization_id
                             AND oh.sold_to_org_id = hcaa.cust_account_id
                             AND rcta.cust_trx_type_id = rctta.cust_trx_type_id
                             AND rcta.trx_number LIKE '402%'
                             AND rctta.NAME != 'CM - Return Parts'
                             --and rctla.reason_code is null
                             -- and rcta.trx_number between nvl (:inv1, rcta.trx_number) and nvl (:inv2, rcta.trx_number)
                             AND rcta.trx_date BETWEEN TO_DATE (
                                                          SUBSTR (:date1, 1, 10),
                                                          'YYYY/MM/DD hh24:mi:ss')
                                                   AND TO_DATE (
                                                          SUBSTR (:date2, 1, 10),
                                                          'YYYY/MM/DD hh24:mi:ss')
                    --   and msib.segment1 = '8982542901'
                    -- and rcta.trx_number = '40200004926'
                    ORDER BY cust.customer_name, rcta.trx_number) a,
                   (SELECT hcp.cust_account_id, hcp.site_use_id, hcpc.NAME acct
                      FROM hz_customer_profiles hcp, hz_cust_profile_classes hcpc
                     WHERE hcp.profile_class_id = hcpc.profile_class_id--and hcpc.name = 'Dealers-Parts'
                                                                       --and upper(hcpc.name) = nvl(upper(:p_acct),upper(hcpc.name))
                   ) b,
                   (SELECT mic.category_id,
                           mc.category_id,
                           mcst.category_set_id,
                           mic.inventory_item_id,
                           mic.organization_id,
                           mc.segment1 || '.' || mc.segment2 item_categories
                      FROM mtl_item_categories mic,
                           mtl_categories mc,
                           mtl_category_sets_tl mcst
                     WHERE     mic.category_id = mc.category_id
                           AND mic.category_set_id = mcst.category_set_id
                           AND mcst.category_set_name = 'IPC Item Categories') c
             WHERE     a.bill_to_customer_id = b.cust_account_id
                   AND a.bill_to_site_use_id = b.site_use_id(+)
                   AND a.organization_id = c.organization_id
                   AND a.inventory_item_id = c.inventory_item_id
                   AND a.customer_name = NVL (:p_customer_name, a.customer_name)
                   AND a.customer_number =
                          NVL (:p_customer_number, a.customer_number)
          --and a.so_number = '13296'
          GROUP BY                                                 --a.line_id
                  b.acct,
                   a.extended_price,
                   a.account_name,
                   a.order_type,
                   a.mdl_grp,
                   a.series,
                   a.customer_name,
                   a.item_no,
                   a.item_cost,
                   a.quantity_invoiced,
                   -- ,a.sales_amt
                   -- ,a.extended_price
                   a.trx_number,
                   a.organization_id,
                   a.trx_date,
                   a.so_number,
                   a.transaction_type,
                   a.customer_number,
                   a.description,
                   a.dr_no,
                   a.purchase_group,
                   a.pruduct_code1,
                   a.country_of_origin,
                   a.product_code2,
                   c.item_categories,
                   a.exchange_rate,
                   a.line_number,
                   a.inventory_class,
                   a.po_number,
                   a.ship_date,
                   a.unit_price,
                   a.remarks1,
                   a.remarks2
          ORDER BY POSITION)
GROUP BY acct,
         order_type,
         mdl_grp,
         series,
         customer_name,
         customer_number,
         account_name,
         description,
         item_no,
         dr_no,
         item_cost,
         quantity_invoiced,
         exchange_rate,
         trx_number,
         so_number,
         organization_id,
         invoiced_date,
         transaction_type,
         purchase_group,
         pruduct_code1,
         country_of_origin,
         product_code2,
         item_categories,
         inventory_class,
         po_number,
         ship_date,
         unit_price,
         remarks1,
         remarks2
ORDER BY Item_Categories, position;

-- Invoice Parts Query - Total

SELECT hp.party_name customer_name,
                 hcaa.account_name,
                 hcaa.account_number,
                 hcsua.location
             
            FROM -- INVOICE
                 ra_customer_trx_all rcta
--                 INNER JOIN ra_customer_trx_lines_all rctla
--                    ON rctla.customer_trx_id = rcta.customer_trx_id
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
            
            
           WHERE 1 = 1 -- filter
           
           and 
                 
   
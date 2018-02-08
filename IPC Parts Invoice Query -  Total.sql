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

SELECT trans_type,
            customer_site,
            customer_name,
            account_name,
            account_number,
            invoice_date,
            invoice_number,
            so_number,
            dr_num,
            po_num,
            CASE 
                WHEN manual_override > 0 THEN
                    line_amount + manual_override
                ELSE line_amount
            end gross,
            CASE 
                WHEN manual_override < 0 THEN -- if amount is negative then it is a discount
                    manual_override
                ELSE 0
            end discount,
            tax,
            invoice_amount,
            
            ord_type_desc      
FROM (
            SELECT rctta.name trans_type,
                        hcsua.location customer_site,
                        hp.party_name customer_name,
                        hcaa.account_name,
                        hcaa.account_number,
                        to_char(rcta.trx_date) invoice_date,
                        rcta.trx_number invoice_number,
                        rcta.interface_header_attribute1 so_number,
                        oola.attribute10 dr_num,
                        ooha.cust_po_number po_num,
                        sum(rctla.line_recoverable) + sum(rctla.tax_recoverable) invoice_amount,
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
                            SUM (rctla.tax_recoverable) tax,
                            ord_types.ord_type_desc      
        FROM -- INVOICE
                    ra_customer_trx_all rcta
                    INNER JOIN ra_customer_trx_lines_all rctla
                        ON rctla.customer_trx_id = rcta.customer_trx_id
                    INNER JOIN ra_cust_trx_types_all rctta
                        ON rctta.cust_trx_type_id = rcta.cust_trx_type_id
                    -- SALES ORDER
                    INNER JOIN oe_order_lines_all oola
                        ON oola.line_id = rctla.interface_line_attribute6
                    INNER JOIN oe_order_headers_all ooha
                        ON ooha.header_id = oola.header_id
                    INNER JOIN xxipc_order_types ord_types
                        ON ord_types.transaction_type_id = ooha.order_type_id
                    -- CUSTOMER DATA
                    INNER JOIN hz_cust_accounts_all hcaa
                        ON hcaa.cust_account_id = rcta.bill_to_customer_id
                    INNER JOIN hz_cust_site_uses_all hcsua
                        ON hcsua.site_use_id = rcta.bill_to_site_use_id
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
                    and rcta.trx_number like '402%'
                    and to_date(rcta.trx_date) Between 
                                TO_DATE(:P_INVOICE_START,'YYYY/MM/DD HH24:MI:SS') AND 
                                TO_DATE(:P_INVOICE_END,'YYYY/MM/DD HH24:MI:SS')
GROUP BY rctta.name,
                    hcsua.location ,
                    hp.party_name ,
                    hcaa.account_name,
                    hcaa.account_number,
                    rcta.trx_date ,
                    rcta.trx_number ,
                    rcta.interface_header_attribute1 ,
                    oola.attribute10 ,
                    ooha.cust_po_number ,
                    ord_types.ord_type_desc
 );


select *
from gl_je_categories
where je_category_name = '1';

select item_cost
from cst_item_costs
where inventory_item_id = 110002
and organization_id = 102;

select *
from mtl_system_items_b
where segment1 = '1475002502';

-- item cost
SELECT cid.organization_code,
         cml.organization_id,
         mmt.transaction_id      AS "TRANSACTION ID",
         mmt.transaction_date    AS "TRANSACTION DATE",
         mty.transaction_type_name AS "TRANSACTION NAME",
         cml.inventory_item_id,
         MSI.SEGMENT1            AS item,
         MSI.DESCRIPTION,
         mck.segment1            AS ITEM_CATEGORY_FAMILY,
         mck.segment2            AS ITEM_CATEGORY_CLASS,
         MSI.ITEM_TYPE,
         FLV.MEANING             AS ITEM_TYPE_DESCRIPTION,
         mta.primary_quantity    AS "TRANSACTION QTY",
         gcc.segment6            AS "ACCOUNT",
         CID.LINE_TYPE_NAME      AS "LINE TYPE",
         CASE
            WHEN CID.BASE_TRANSACTION_VALUE > 0 THEN CID.BASE_TRANSACTION_VALUE
         END
            DEBIT,
         CASE
            WHEN CID.BASE_TRANSACTION_VALUE < 0 THEN CID.BASE_TRANSACTION_VALUE
         END
            CREDIT,
         ce.event_date           AS "COGS DATE",
         cml.unit_material_cost,
         cml.unit_moh_cost,
         cml.unit_resource_cost,
         cml.unit_op_cost,
         cml.unit_overhead_cost,
         cml.unit_cost,
         mmt.subinventory_code,
         mmt.transaction_source_name,
         mmt.transaction_uom,
         mmt.primary_quantity,
         mmt.actual_cost,
         mmt.prior_cost,
         mmt.new_cost,
         mmt.source_code
FROM cst_cogs_events             ce,
         cst_revenue_recognition_lines crl,
         cst_revenue_cogs_match_lines cml,
         mtl_transaction_accounts    mta,
         mtl_material_transactions   mmt,
         mtl_transaction_types       mty,
         gl_code_combinations_kfv    gcc,
         cst_inv_distribution_v      cid,
         MTL_ITEM_CATEGORIES         mtc,
         mtl_categories_kfv          mck,
         MTL_SYSTEM_ITEMS_B          MSI,
         FND_LOOKUP_VALUES_VL        FLV
WHERE     FLV.LOOKUP_TYPE = 'ITEM_TYPE'
         AND MSI.ITEM_TYPE = FLV.LOOKUP_CODE
         AND MCK.STRUCTURE_ID = '50388'
         AND MMT.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID
         AND MMT.ORGANIZATION_ID = MSI.ORGANIZATION_ID
         AND msi.inventory_item_id = mtc.inventory_item_id
         AND MMT.ORGANIZATION_ID = mtc.ORGANIZATION_ID
         AND mmt.transaction_id = cid.transaction_id
         AND mtc.CATEGORY_ID = mck.CATEGORY_ID
         AND mmt.organization_id = cid.organization_id
         AND cid.reference_account = gcc.code_combination_id
         AND mmt.transaction_type_id = mty.transaction_type_id
         AND mmt.transaction_id = mta.transaction_id
         AND ce.mmt_transaction_id = mta.transaction_id
         AND crl.revenue_om_line_id = cml.revenue_om_line_id
         AND ce.cogs_om_line_id = cml.cogs_om_line_id
         AND mmt.transaction_id = ce.mmt_transaction_id
         AND mmt.transaction_type_id IN (33, 10008)
         AND mta.reference_account = cid.reference_account
         AND  cid.organization_id = nvl(:p_organization,cid.organization_id)
         AND cml.cogs_om_line_id = :order_line_id
ORDER BY mmt.transaction_id;

select *
from cst_revenue_cogs_match_lines
where cogs_om_line_id  = 1610415;
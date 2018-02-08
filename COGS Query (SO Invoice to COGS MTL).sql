SELECT 
--Sales Order Information
    oh.order_number,
    ol.line_number,
    rtl.sales_order_date,
    ol.inventory_item_id,
    ol.ordered_item,
    ol.ordered_quantity,
    ol.shipped_quantity,
    ol.fulfilled_quantity,
    ol.shipping_quantity_uom,
--Invoice_information
       rta.trx_number as "INVOICE NUMBER",
       rta.trx_date as "INVOICE DATE",
       rtl.extended_amount as "INVOICE AMOUNT",
       apsa.gl_date AS "GL DATE",
       rda.gl_posted_date AS "GL POSTED DATE",
       rda.account_class AS "ACCOUNT CLASS",
       rda.acctd_amount AS "ACCOUNTED AMOUNT",
       rtl.unit_standard_price AS "UNIT STANDARD PRICE",
       rtl.unit_selling_price AS "UNIT SELLING PRICE",
       rtl.line_type,
       rtl.interface_line_attribute2,
       rtl.extended_amount,
       rtl.revenue_amount,
       rtl.line_recoverable,
       rtl.tax_recoverable,
--Transaction Information
    mty.transaction_type_name,
    mta.primary_quantity, 
    gcc.segment6 as "ACCOUNT",
    case
                                when CID.BASE_TRANSACTION_VALUE > 0 then  CID.BASE_TRANSACTION_VALUE
                                end DEBIT,
                case
                                when CID.BASE_TRANSACTION_VALUE < 0 then  CID.BASE_TRANSACTION_VALUE
                                end CREDIT ,
     --  ce.event_date,
  --     gcc.concatenated_segments AS account_code_combination,
       --to include customer info from the order header
       --rtl.customer_trx_line_id,
       --rtl.customer_trx_id,
       ce.COGS_OM_LINE_ID,
       ce.event_date,
       ce.mmt_transaction_id,
       crl.revenue_om_line_id,
       crl.acct_period_num,
       cml.deferred_cogs_acct_id,
       cml.cogs_acct_id,
       cml.organization_id,
       cml.inventory_item_id,
       cml.sales_order_issue_date,
       cml.unit_material_cost,
       cml.unit_moh_cost,
       cml.unit_resource_cost,
       cml.unit_op_cost,
       cml.unit_overhead_cost,
       cml.unit_cost,
       cml.original_shipped_qty,
       mta.transaction_id,
       mta.reference_account,
       mta.inventory_item_id,
       mta.organization_id,
       mta.transaction_date,
       mta.transaction_source_id,
       mta.transaction_source_type_id,
       mta.base_transaction_value,
       mta.rate_or_amount,
       mta.currency_conversion_date,
       mta.currency_conversion_type,
       mta.currency_conversion_rate,
       mta.inv_sub_ledger_id,
       mmt.inventory_item_id,
       mmt.organization_id,
       mmt.subinventory_code,
       mmt.transaction_type_id,
       mmt.transaction_source_id,
       mmt.transaction_source_name,
       mmt.transaction_quantity,
       mmt.transaction_uom,
       mmt.primary_quantity,
       mmt.transaction_date,
       mmt.distribution_account_id,
       mmt.actual_cost,
       mmt.prior_cost,
       mmt.new_cost,
       mmt.trx_source_line_id,
       mmt.trx_source_delivery_id,
       mmt.source_code,
       mmt.source_line_id,
       mmt.shipment_number
  FROM cst_cogs_events               ce,
                cst_revenue_recognition_lines crl,
                ra_cust_trx_line_gl_dist_all  rda,
                cst_revenue_cogs_match_lines  cml,
                oe_order_lines_all            ol,
                oe_order_headers_all          oh,
                mtl_transaction_accounts      mta,
                mtl_material_transactions     mmt,
                ra_customer_trx_lines_all     rtl,
                ra_customer_trx_all           rta,
                mtl_transaction_types         mty,
                ar_payment_schedules_all      apsa,
                gl_code_combinations_kfv      gcc,
                cst_inv_distribution_v        cid
WHERE     rda.customer_trx_line_id = rtl.customer_trx_line_id
       AND mmt.transaction_id = cid.transaction_id
       AND mmt.organization_id = cid.organization_id
       AND cid.reference_account = gcc.code_combination_id
       AND rta.trx_number = apsa.trx_number
       and rta.interface_header_attribute1 = oh.order_number
       AND mmt.transaction_type_id = mty.transaction_type_id
       AND rta.customer_trx_id = rtl.customer_trx_id
       AND rtl.interface_line_context = 'ORDER ENTRY'
       AND rtl.interface_line_attribute6 = ol.line_id
       AND mmt.transaction_id = mta.transaction_id
       AND ce.mmt_transaction_id = mta.transaction_id
       AND crl.revenue_om_line_id = cml.revenue_om_line_id
       AND ce.cogs_om_line_id = cml.cogs_om_line_id
       AND ce.cogs_om_line_id = ol.line_id
       AND oh.header_id = ol.header_id
        and mmt.transaction_id = ce.mmt_transaction_id
       AND mmt.transaction_type_id IN (33, 10008)
       and  mta.reference_account = cid.reference_account 
       AND rda.account_set_flag = 'N'
       AND rda.account_class = 'REV'
  --     AND oh.order_number = 3010004809 
       and rta.trx_number = '40300008049'
        order by mmt.transaction_id;


 /*cst_cogs_events               ce,
                cst_revenue_recognition_lines crl,
                ra_cust_trx_line_gl_dist_all  rda,
                cst_revenue_cogs_match_lines  cml,*/

select *
from cst_revenue_cogs_match_lines;
                





--Sales Order/Invoice Information
---ol.line_id,  ---link
SELECT oh.header_id,
            ol.line_id order_line_id,
            oh.order_number as "ORDER NUMBER",
            ol.line_number AS "LINE NO",
            rtl.sales_order_date AS "ORDERED DATE",
            ol.ordered_item AS "ITEM",
            ol.ordered_quantity AS "QTY",
            ol.shipping_quantity_uom AS "UOM",
            rta.trx_number      AS "INVOICE NUMBER",
            rta.trx_date        AS "INVOICE DATE",
            rtl.extended_amount AS "INVOICE AMOUNT",
            apsa.gl_date        AS "GL DATE",
            rda.account_class   AS "ACCOUNT CLASS",
            rtl.line_type,
            rtl.interface_line_attribute2,
            rtl.revenue_amount,
            rtl.line_recoverable,
            rtl.tax_recoverable,
            rta.bill_to_site_use_id,
            customers.account_number,
            customers.account_name,
            customers.party_name,
            customers.party_site_name,
            order_types.ord_type_name,
            order_types.ord_type_desc
FROM   ra_cust_trx_line_gl_dist_all rda,
            oe_order_lines_all           ol,
            oe_order_headers_all         oh,
            ra_customer_trx_lines_all    rtl,
            ra_customer_trx_all          rta,
            ar_payment_schedules_all     apsa,
            XXIPC_CUSTOMER_NAMES_V customers,
            XXIPC_ORDER_TYPES order_types
WHERE  1 = 1
            AND rda.customer_trx_line_id = rtl.customer_trx_line_id
            AND rta.trx_number = apsa.trx_number
            AND rta.customer_trx_id = rtl.customer_trx_id
            AND rtl.interface_line_context = 'ORDER ENTRY'
            AND rtl.interface_line_attribute6 = ol.line_id
            AND oh.header_id = ol.header_id
            AND rda.account_set_flag = 'N'
            AND rda.account_class = 'REV'
            AND customers.site_use_id = rta.bill_to_site_use_id
            AND order_types.transaction_type_id = oh.order_type_id
            AND rta.trx_date BETWEEN TO_DATE (:P_INV_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_INV_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
        
         --    AND oh.order_number = 3010004809
            --  and rta.trx_number = '40300008049'
;

/* COSTING QUERY */
-- 1268952
--Material COGS
---cml.cogs_om_line_id, ---link
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
         AND  cid.organization_code = nvl(:p_organization,cid.organization_code)
         AND cml.cogs_om_line_id in (1260609,
1558192,
1558193,
1558199,
1558200)
ORDER BY mmt.transaction_id;

select *
from mtl_parameters;
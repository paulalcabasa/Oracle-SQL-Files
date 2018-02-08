SELECT
    mmt.organization_id,
    org.name,
    mmt.transaction_id,
    mmt.inventory_item_id,
    msib.segment1 as "Part Number",
    msib.description,
    mck.segment1  as item_category_family,
    mck.segment2                 AS item_category_class,
    msib.item_type,
    mmt.transaction_quantity,
    mmt.rcv_transaction_id,
    --mmt.transaction_source_id,
    mty.transaction_type_name,
         we.wip_entity_name           AS "Job Order",
         we.attribute1 as "Lot Number",
         mtst.transaction_source_type_name,
         mtst.description             AS "Source Type",
         mmt.transaction_SOURCE_NAME,
         rcv.receipt_num,
         rcv.po_number,
         flv.meaning                  item_type_description,
         mty.transaction_type_name,
         mmt.transaction_source_id,
         --            xdl.application_id             AS "Application ID",
         xdl.source_distribution_type AS "Source Distribution Type",
         --            xdl.source_distribution_id_num_1 AS "Source Distribution Id Num",
         --            xdl.ae_header_id               AS "AE Header ID",
         --            xdl.ae_line_num                AS "AE Line Num",
         xal.accounting_class_code    AS "Accounting Class Code",
         xdl.accounting_line_code     AS "Accounting Line Code",
         xdl.line_definition_code     AS "Line Definition COde",
         xdl.event_class_code         AS "Event Class Code",
         xdl.event_type_code          AS "Event Type Code",
         xdl.rounding_class_code      AS "Rounding Class Code",
         xah.accounting_date          AS "Accounting Date",
         xah.gl_transfer_status_code  AS "GL Transfer Status Code",
         xah.gl_transfer_date         AS "GL Transfer Date",
         xah.je_category_name         AS "JE Category Name",
         xah.accounting_entry_type_code AS "Accounting Entry Type Code",
         xah.doc_sequence_value       AS "Document Sequence Value",
         --            gcc.segment1                   AS "Company",
         --            gcc.segment2                   AS "Cost Center",
         --            gcc.segment3                   AS "ID",
         --            gcc.segment4                   AS "Budget Account",
         --            gcc.segment5                   AS "Budget Cost Center",
         gcc.segment6                 AS "Account",
         --            gcc.segment7                   AS "Model",
         --            gcc.segment8                   AS "Projects",
         --            gcc.segment9                   AS "Future",
         --            xah.description                AS "Description",
         xal.description              AS "Line Description",
         --            xal.displayed_line_number      AS "Line Number",
         xah.period_name              AS "Period Name",
         nvl(xal.entered_dr,0)               AS "Entered Debit",
         nvl(xal.entered_cr,0)             AS "Entered Credit",
         nvl(xal.accounted_dr,0)               AS "Accounted Debit",
         nvl(xal.accounted_cr,0)              AS "Accounted Credit",
         nvl(xal.accounted_dr,0) - nvl(xal.accounted_cr,0) as "Difference" ,
         --            xal.accounted_dr               AS "Accounted Debit",
         --            xal.accounted_cr               AS "Accounted Credit",
         --            xdl.unrounded_entered_dr       AS "Unrounded Entered Debit",
         --            xdl.unrounded_entered_cr       AS "Unrounded Entered Credit",
         --            xdl.unrounded_accounted_dr     AS "Unrounded Accounted Debit",
         --            xdl.unrounded_accounted_cr     AS "Unrounded Accounted Credit",
         --            xal.currency_code              AS "Currency Code",
         --            xal.currency_conversion_date   AS "Currency Conversion Date",
         --            xal.currency_conversion_rate   AS "Currency Conversion Rate",
         xah.product_rule_code        AS "Product Rule Code",
         mmt.CREATION_DATE,
         mmt.LAST_UPDATE_DATE,
         mmt.transaction_date         AS transaction_date
    FROM xla_distribution_links  xdl,
         xla_ae_headers          xah,
         xla_ae_lines            xal,
         gl_code_combinations    gcc,
         mtl_transaction_accounts mta,
         mtl_system_items_b      msib,
         mtl_material_transactions mmt,
         MTL_ITEM_CATEGORIES     mtc,
         mtl_categories_kfv      mck,
         FND_LOOKUP_VALUES_VL    flv,
         MTL_TRANSACTION_TYPES   MTY,
         hr_all_organization_units org,
         MTL_TXN_SOURCE_TYPES    mtst,
         WIP_DISCRETE_JOBS_V            we,
         (SELECT rt.transaction_id, rsh.receipt_num, pha.segment1 po_number
            FROM rcv_transactions   rt,
                 rcv_shipment_headers rsh,
                 po_headers_all     pha
           WHERE     rt.shipment_header_id = rsh.shipment_header_id
                 AND rt.po_header_id = pha.po_header_id(+)) rcv
   WHERE     mmt.TRANSACTION_SOURCE_TYPE_ID = mtst.TRANSACTION_SOURCE_TYPE_ID
         AND mmt.inventory_item_id = msib.inventory_item_id
         AND mmt.organization_id = msib.organization_id
         AND mmt.TRANSACTION_SOURCE_ID = we.wip_entity_id(+)
         AND mmt.rcv_transaction_id = rcv.transaction_id(+)
         AND xal.code_combination_id = gcc.code_combination_id
         AND xah.ae_header_id = xal.ae_header_id
         AND xal.ae_header_id = xdl.ae_header_id
         AND xal.ae_line_num = xdl.ae_line_num
         /* new joins */
         AND msib.inventory_item_id = mtc.inventory_item_id
         AND MMT.ORGANIZATION_ID = mtc.ORGANIZATION_ID
         AND mmt.organization_id = msib.organization_id
         AND MMT.TRANSACTION_TYPE_ID = MTY.TRANSACTION_TYPE_ID
         AND mtc.CATEGORY_ID = mck.CATEGORY_ID
         AND MSIb.ITEM_TYPE = FLV.LOOKUP_CODE
         AND mmt.organization_id = org.organization_id
         AND FLV.LOOKUP_TYPE = 'ITEM_TYPE'
         AND MCK.STRUCTURE_ID = '50388'
         AND xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
         AND mmt.transaction_id = mta.transaction_id  
         AND xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id
        
         AND to_date(xah.creation_date) BETWEEN NVL(to_date(:p_creation_date_start,'yyyy/mm/dd hh24:mi:ss') ,to_date(xah.creation_date))
                                                                          AND NVL(to_date(:p_creation_date_end,'yyyy/mm/dd hh24:mi:ss'),to_date(xah.creation_date)) -- creation date
        AND to_date(xah.accounting_date) BETWEEN NVL(to_date(:p_acctg_date_start,'yyyy/mm/dd hh24:mi:ss'),to_date(xah.accounting_date)) 
                                                                      AND NVL(to_date(:p_acctg_date_end,'yyyy/mm/dd hh24:mi:ss'),to_date(xah.accounting_date)) -- gl date
        AND gcc.segment6 BETWEEN NVL(:p_account_from,gcc.segment6) AND NVL(:p_account_to,gcc.segment6) -- account
        AND mck.segment1 = NVL(:p_item_category,mck.segment1) -- item category
        AND msib.segment1 = NVL(:p_part_no,msib.segment1) -- part no
        AND msib.organization_id = NVL(:p_organization_id,msib.organization_id) -- organization
  --      AND mmt.transaction_id LIKE '2068017'
  
ORDER BY xdl.ae_header_id, xdl.ae_line_num ASC;

select fu.user_name,
ppf.*
from mtl_txn_request_headers mtrh,
        fnd_user fu,
        per_people_f ppf
where request_number like '174304%'
           and fu.user_id = mtrh.created_by
           and ppf.employee_number = fu.user_name;
           
           
           select *
           from mtl
select distinct source_distribution_type
from xla_distribution_links;



/* Formatted on 05/17/2017 11:52:16 AM (QP5 v5.294) */
SELECT mmt.transaction_date AS transaction_date,
            
            -- mmt.organization_id
            org.name organization_name,
            to_char(mmt.transaction_id) transaction_id, 
            mck.segment1 as item_category_family,
            mck.segment2 as item_category_class,
            msib.item_type,
            flv.meaning  item_type_description,
            mty.transaction_type_name,
            msib.segment1 as item,
            msib.description,
            to_char(mmt.transaction_date)  transaction_date,
            mmt.transaction_quantity,
            mmt.transaction_uom,
            mmt.transaction_source_name,
            xdl.application_id             AS "Application ID",
            xdl.source_distribution_type   AS "Source Distribution Type",
            xdl.source_distribution_id_num_1 AS "Source Distribution Id Num",
            xdl.ae_header_id               AS "AE Header ID",
            xdl.ae_line_num                AS "AE Line Num",
            xal.accounting_class_code      AS "Accounting Class Code",
            xdl.accounting_line_code       AS "Accounting Line Code",
            xdl.line_definition_code       AS "Line Definition COde",
            xdl.event_class_code           AS "Event Class Code",
            xdl.event_type_code            AS "Event Type Code",
            xdl.rounding_class_code        AS "Rounding Class Code",
            xah.accounting_date            AS "Accounting Date",
            xah.gl_transfer_status_code    AS "GL Transfer Status Code",
            xah.gl_transfer_date           AS "GL Transfer Date",
            xah.je_category_name           AS "JE Category Name",
            xah.accounting_entry_type_code AS "Accounting Entry Type Code",
            xah.doc_sequence_value         AS "Document Sequence Value",
            gcc.segment1                   AS "Company",
            gcc.segment2                   AS "Cost Center",
            gcc.segment3                   AS "ID",
            gcc.segment4                   AS "Budget Account",
            gcc.segment5                   AS "Budget Cost Center",
            gcc.segment6                   AS "Account",
            gcc.segment7                   AS "Model",
            gcc.segment8                   AS "Projects",
            gcc.segment9                   AS "Future",
            xah.description                AS "Description",
            xal.description                AS "Line Description",
            xal.displayed_line_number      AS "Line Number",
            xah.period_name                AS "Period Name",
            xal.entered_dr                 AS "Entered Debit",
            xal.entered_cr                 AS "Entered Credit",
            xal.accounted_dr               AS "Accounted Debit",
            xal.accounted_cr               AS "Accounted Credit",
            xdl.unrounded_entered_dr       AS "Unrounded Entered Debit",
            xdl.unrounded_entered_cr       AS "Unrounded Entered Credit",
            xdl.unrounded_accounted_dr     AS "Unrounded Accounted Debit",
            xdl.unrounded_accounted_cr     AS "Unrounded Accounted Credit",
            xal.currency_code              AS "Currency Code",
            xal.currency_conversion_date   AS "Currency Conversion Date",
            xal.currency_conversion_rate   AS "Currency Conversion Rate",
            xah.product_rule_code          AS "Product Rule Code"
 
FROM   xla_distribution_links xdl,
            xla_ae_headers       xah,
            xla_ae_lines         xal,
            gl_code_combinations gcc,
            mtl_transaction_accounts mta,
            mtl_system_items_b msib,
            mtl_material_transactions mmt,
            MTL_TRANSACTION_TYPES MTY,
            hr_all_organization_units org,
            MTL_ITEM_CATEGORIES  mtc,
            mtl_categories_kfv mck,
            FND_LOOKUP_VALUES_VL flv
WHERE 1 = 1
            -- TABLE LINKS 
            and mmt.inventory_item_id = msib.inventory_item_id 
            and msib.inventory_item_id = mtc.inventory_item_id 
            and MMT.ORGANIZATION_ID = mtc.ORGANIZATION_ID
            and mtc.CATEGORY_ID =mck.CATEGORY_ID  
            and mmt.organization_id = msib.organization_id  
            and xal.code_combination_id = gcc.code_combination_id
            and xah.ae_header_id = xal.ae_header_id
            and xal.ae_header_id = xdl.ae_header_id
            and xal.ae_line_num = xdl.ae_line_num
            and mmt.transaction_id = mta.transaction_id
            and MMT.TRANSACTION_TYPE_ID = MTY.TRANSACTION_TYPE_ID
            and org.organization_id = mmt.organization_id
            and  MSIb.ITEM_TYPE = FLV.LOOKUP_CODE  
            and xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id
            -- FILTERS
            and  FLV.LOOKUP_TYPE = 'ITEM_TYPE'
            and xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
            and  MCK.STRUCTURE_ID = '50388'
         --   and xah.accounting_date BETWEEN :P_Start_Date AND :P_End_Date
     --   and  xal.accounting_class_code = 'OVERHEAD_ABSORPTION'
            and mmt.organization_id IN (88) 
ORDER BY xdl.ae_header_id, xdl.ae_line_num ASC;


select *
from mtl_transaction_accounts;

select *
from xla_distribution_links;

select *
from hr_all_organization_units;
-- and xah.doc_sequence_value = '40300000724 '
-- and gcc.segment6 = '01200'
-- and xdl.source_distribution_type = "RCV_RECEIVING_SUB_LEDGER"
-- and xdl.event_class_code = 'SALES_ORDER'
-- and xdl.application_id   not in ('200','140','222')
-- and xdl.ae_header_id   in ('9586301','9614129','9614823')
-- and gcc.segment6   in('67100')
-- and xdl.line_definition_code    = 'IPC_SALES_ORDER'
-- and xdl.accounting_line_code  = 'INVENTORY_VALUATION'
-- And xal.entered_dr  = 226510
-- and  xah.gl_transfer_status_code = 'N'
--and xdl.rounding_class_code ='COST_OF_GOODS_SOLD'
--and xal.entered_dr  = 278.3
--and msib.segment1 = '8971793590'
--and  mmt.transaction_id = 1107410
--and xah.accounting_date = '13-JAN-2017' 
--and xal.accounting_class_code like 'INTERORG%'
--AND xdl.ae_header_id  = '10294671'


--5586

;

============================
-- with material dist link
/* Formatted on 05/17/2017 11:52:16 AM (QP5 v5.294) */
  SELECT 
    mmt.CREATION_DATE,
    mmt.LAST_UPDATE_DATE
    , TRUNC (mmt.transaction_date) AS transaction_date,
        mmt.transaction_id, 
        mmt.organization_id,
        mmt.inventory_item_id,
        msib.segment1,
        xdl.application_id             AS "Application ID",
         xdl.source_distribution_type   AS "Source Distribution Type",
         xdl.source_distribution_id_num_1 AS "Source Distribution Id Num",
         xdl.ae_header_id               AS "AE Header ID",
         xdl.ae_line_num                AS "AE Line Num",
         xal.accounting_class_code      AS "Accounting Class Code",
         xdl.accounting_line_code       AS "Accounting Line Code",
         xdl.line_definition_code       AS "Line Definition Code",
         xdl.event_class_code           AS "Event Class Code",
         xdl.event_type_code            AS "Event Type Code",
         xdl.rounding_class_code        AS "Rounding Class Code",
         xah.accounting_date            AS "Accounting Date",
         xah.gl_transfer_status_code    AS "GL Transfer Status Code",
         xah.gl_transfer_date           AS "GL Transfer Date",
         xah.je_category_name           AS "JE Category Name",
         xah.accounting_entry_type_code AS "Accounting Entry Type Code",
         xah.doc_sequence_value         AS "Document Sequence Value",
         gcc.segment1                   AS "Company",
         gcc.segment2                   AS "Cost Center",
         gcc.segment3                   AS "ID",
         gcc.segment4                   AS "Budget Account",
         gcc.segment5                   AS "Budget Cost Center",
         gcc.segment6                   AS "Account",
         gcc.segment7                   AS "Model",
         gcc.segment8                   AS "Projects",
         gcc.segment9                   AS "Future",
         xah.description                AS "Description",
         xal.description                AS "Line Description",
         xal.displayed_line_number      AS "Line Number",
         xah.period_name                AS "Period Name",
         xal.entered_dr                 AS "Entered Debit",
         xal.entered_cr                 AS "Entered Credit",
         xal.accounted_dr               AS "Accounted Debit",
         xal.accounted_cr               AS "Accounted Credit",
         xdl.unrounded_entered_dr       AS "Unrounded Entered Debit",
         xdl.unrounded_entered_cr       AS "Unrounded Entered Credit",
         xdl.unrounded_accounted_dr     AS "Unrounded Accounted Debit",
         xdl.unrounded_accounted_cr     AS "Unrounded Accounted Credit",
         xal.currency_code              AS "Currency Code",
         xal.currency_conversion_date   AS "Currency Conversion Date",
         xal.currency_conversion_rate   AS "Currency Conversion Rate",
         xah.product_rule_code          AS "Product Rule Code"
    FROM xla_distribution_links xdl,
         xla_ae_headers       xah,
         xla_ae_lines         xal,
         gl_code_combinations gcc,
         mtl_transaction_accounts mta,
         mtl_system_items_b msib,
       mtl_material_transactions mmt
   WHERE     
        mmt.inventory_item_id = msib.inventory_item_id and
        mmt.organization_id = msib.organization_id and 
   xal.code_combination_id = gcc.code_combination_id
         AND xah.ae_header_id = xal.ae_header_id
         AND xal.ae_header_id = xdl.ae_header_id
         AND xal.ae_line_num = xdl.ae_line_num
         -- and xah.doc_sequence_value = '40300000724 '
         -- and gcc.segment6 = '01200'
        --AND xdl.source_distribution_type = "RCV_RECEIVING_SUB_LEDGER"
         AND xah.accounting_date BETWEEN :P_Start_Date AND :P_End_Date
         --   AND xdl.event_class_code = 'SALES_ORDER'
--and xdl.application_id   not in ('200','140','222')
and xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
and mmt.transaction_id = mta.transaction_id
--and xdl.ae_header_id   in ('9586301','9614129','9614823')
--and gcc.segment6   in('67100')
--and xdl.line_definition_code    = 'IPC_SALES_ORDER'
--and xdl.accounting_line_code  = 'INVENTORY_VALUATION'
--And xal.entered_dr  = 226510
--and  xah.gl_transfer_status_code = 'N'
--and xdl.rounding_class_code ='COST_OF_GOODS_SOLD'
and  mmt.organization_id in ('88') --rio nac dbs ips
-- and  gcc.segment6 in ('65100')
--and-- xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id
--and xal.entered_dr  = 278.3
--and msib.segment1 = '8971793590'
--and  mmt.transaction_id = 1107410
--and xah.accounting_date = '13-JAN-2017' 
--and xal.accounting_class_code like 'INTERORG%'
--AND xdl.ae_header_id  = '10294671'
ORDER BY xdl.ae_header_id, xdl.ae_line_num ASC;


/***** QUERY FOR ALL ***/
  SELECT 
xah.COMPLETED_DATE,
xah.CREATION_DATE,
xah.LAST_UPDATE_DATE,
xah.PROGRAM_UPDATE_DATE,
  xdl.application_id             AS "Application ID",
         xdl.source_distribution_type   AS "Source Distribution Type",
         xdl.source_distribution_id_num_1 AS "Source Distribution Id Num",
         xdl.ae_header_id               AS "AE Header ID",
         xdl.ae_line_num                AS "AE Line Num",
         xal.accounting_class_code      AS "Accounting Class Code",
         xdl.accounting_line_code       AS "Accounting Line Code",
         xdl.line_definition_code       AS "Line Definition COde",
         xdl.event_class_code           AS "Event Class Code",
         xdl.event_type_code            AS "Event Type Code",
         xdl.rounding_class_code        AS "Rounding Class Code",
         xah.accounting_date            AS "Accounting Date",
         xah.gl_transfer_status_code    AS "GL Transfer Status Code",
         xah.gl_transfer_date           AS "GL Transfer Date",
         xah.je_category_name           AS "JE Category Name",
         xah.accounting_entry_type_code AS "Accounting Entry Type Code",
         xah.doc_sequence_value         AS "Document Sequence Value",
         gcc.segment1                   AS "Company",
         gcc.segment2                   AS "Cost Center",
         gcc.segment3                   AS "ID",
         gcc.segment4                   AS "Budget Account",
         gcc.segment5                   AS "Budget Cost Center",
         gcc.segment6                   AS "Account",
         gcc.segment7                   AS "Model",
         gcc.segment8                   AS "Projects",
         gcc.segment9                   AS "Future",
         xah.description                AS "Description",
         xal.description                AS "Line Description",
         xal.displayed_line_number      AS "Line Number",
         xah.period_name                AS "Period Name",
         xal.entered_dr                 AS "Entered Debit",
         xal.entered_cr                 AS "Entered Credit",
         xal.accounted_dr               AS "Accounted Debit",
         xal.accounted_cr               AS "Accounted Credit",
         xdl.unrounded_entered_dr       AS "Unrounded Entered Debit",
         xdl.unrounded_entered_cr       AS "Unrounded Entered Credit",
         xdl.unrounded_accounted_dr     AS "Unrounded Accounted Debit",
         xdl.unrounded_accounted_cr     AS "Unrounded Accounted Credit",
         xal.currency_code              AS "Currency Code",
         xal.currency_conversion_date   AS "Currency Conversion Date",
         xal.currency_conversion_rate   AS "Currency Conversion Rate",
         xah.product_rule_code          AS "Product Rule Code"
   FROM xla_distribution_links xdl,
        xla_ae_headers       xah,
         xla_ae_lines         xal,
         gl_code_combinations gcc
   WHERE     xal.code_combination_id = gcc.code_combination_id
         AND xah.ae_header_id = xal.ae_header_id
         AND xal.ae_header_id = xdl.ae_header_id
         AND xal.ae_line_num = xdl.ae_line_num
     
         -- and xah.doc_sequence_value = '40300000724 '
       and gcc.segment6 = '38800'
        --AND xdl.source_distribution_type = "RCV_RECEIVING_SUB_LEDGER"
        AND xah.accounting_date BETWEEN :P_Start_Date AND :P_End_Date
        --   AND xdl.event_class_code = 'SALES_ORDER'
        and xdl.application_id   not in ('200','140','222')
        --and xdl.ae_header_id   in ('9586301','9614129','9614823')
        --and gcc.segment6   in('67100')
        --and xdl.line_definition_code    = 'IPC_SALES_ORDER'
        --and xdl.accounting_line_code  = 'INVENTORY_VALUATION'
        --and xal.entered_dR  = 278.3
        --and xdl.ae_header_id  = 8557528
        --and  xah.gl_transfer_status_code = 'N'
        --and xdl.rounding_class_code ='COST_OF_GOODS_SOLD'
ORDER BY xdl.ae_header_id, xdl.ae_line_num ASC;


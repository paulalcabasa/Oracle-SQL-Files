  SELECT
  --  mmt.CREATION_DATE,
--                mmt.LAST_UPDATE_DATE , 
--                XAL.GL_SL_LINK_ID ,
               gjh.doc_sequence_value,
                to_char (mmt.transaction_date) AS transaction_date,
     --      gjh.je_category_name
                mmt.transaction_id, 
                mmt.organization_id,
                org.name organization,
                mmt.inventory_item_id,
                msib.segment1,
                msib.description,
                mck.segment1 as item_category_family,
                mck.segment2 as item_category_class,
                msib.item_type,
                flv.meaning  item_type_description,
                mty.transaction_type_name,
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
FROM  xla_distribution_links xdl,
            xla_ae_headers       xah,
            xla_ae_lines         xal,
            gl_code_combinations gcc,
            mtl_transaction_accounts mta,
            mtl_system_items_b msib,
            mtl_material_transactions mmt,
            MTL_ITEM_CATEGORIES  mtc,
            mtl_categories_kfv mck,
            FND_LOOKUP_VALUES_VL flv,
            MTL_TRANSACTION_TYPES MTY,
            hr_all_organization_units org,
           GL_IMPORT_REFERENCES gir,
          GL_JE_HEADERS gjh,
           GL_JE_LINES gjl
WHERE     1 = 1
                and mmt.inventory_item_id = msib.inventory_item_id 
                and mmt.organization_id = msib.organization_id  
                and xal.code_combination_id = gcc.code_combination_id
                and xah.ae_header_id = xal.ae_header_id
                and xal.ae_header_id = xdl.ae_header_id
                and xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id
            --    and xdl.source_distribution_id_num_1 = mta.RCV_SUB_LEDGER_ID
                -- RCV_SUB_LEDGER_ID
                and mmt.transaction_id = mta.transaction_id
          --      and xal.displayed_line_number = xdl.ae_line_num
              and xal.ae_line_num = xdl.ae_line_num
                /* new joins */
                and msib.inventory_item_id = mtc.inventory_item_id 
                and MMT.ORGANIZATION_ID = mtc.ORGANIZATION_ID
                and MMT.TRANSACTION_TYPE_ID = MTY.TRANSACTION_TYPE_ID
                and org.organization_id = MMT.organization_id
                and mtc.CATEGORY_ID =mck.CATEGORY_ID  
                and  MSIb.ITEM_TYPE = FLV.LOOKUP_CODE  
                and  FLV.LOOKUP_TYPE = 'ITEM_TYPE'
                and  MCK.STRUCTURE_ID = '50388'
          --      and xdl.source_distribution_type = 'RCV_RECEIVING_SUB_LEDGER'
                     and xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
                /** Link to GL **/
                and gir.GL_SL_LINK_ID  = XAL.GL_SL_LINK_ID(+)
                AND GIR.JE_HEADER_ID = GJL.JE_HEADER_ID(+)
                AND GIR.JE_HEADER_ID = GJH.JE_HEADER_ID(+)
                and gir.je_line_num = gjl.je_line_num(+)
          --     and xah.accounting_date BETWEEN :P_Start_Date AND :P_End_Date
              
        --        and xal.gl_sl_link_table = 'XLAJEL' 
          --      and xah.event_type_code <> 'MANUAL' 
            --     and mmt.transaction_id IN(1000757)
--     and inv_sub_ledger_id not in (471638,
--471639)
             --   and xal.ae_line_num = 4
           --     and  mmt.organization_id in ('88') --rio nac dbs ips
       
                -- 
                -- 2376806

                -- and xah.doc_sequence_value = '40300000724 '
                -- and gcc.segment6 = '01200'
                --AND xdl.source_distribution_type = "RCV_RECEIVING_SUB_LEDGER"
                --   AND xdl.event_class_code = 'SALES_ORDER'
                --and xdl.application_id   not in ('200','140','222')
                --and xdl.ae_header_id   in ('9586301','9614129','9614823')
                --and gcc.segment6   in('67100')
                --and xdl.line_definition_code    = 'IPC_SALES_ORDER'
                --and xdl.accounting_line_code  = 'INVENTORY_VALUATION'
                --And xal.entered_dr  = 226510
                --and  xah.gl_transfer_status_code = 'N'
                --and xdl.rounding_class_code ='COST_OF_GOODS_SOLD'
                -- and  gcc.segment6 in ('65100')
                --and xal.entered_dr  = 278.3
       --         and msib.segment1 = '9650027320'
                --and xah.accounting_date = '13-JAN-2017' 
                --and xal.accounting_class_code like 'INTERORG%'
                --AND xdl.ae_header_id  = '10294671'
                and gcc.segment6 between '05100' AND '05197'
                and xah.accounting_date between '01-JUL-2017' AND '31-JUL-2017'
ORDER BY xdl.ae_header_id, xdl.ae_line_num ASC;


select *
from GL_JE_LINES
where GL_SL_LINK_ID  in (26978844,26978843,26978845);

select *
from GL_IMPORT_REFERENCES
where GL_SL_LINK_ID  in (26978844,26978843,26978845);

select *
from gl_je_headers
where je_header_id = 654006;


SELECT *
FROM rcv_receiving_sub_ledger;

SELECT SEGMENT6
FROM GL_CODE_COMBINATIONS 
WHERE CODE_COMBINATION_ID = 8000;

select *
from gl_import_references;

select *
from GL_IMPORT_REFERENCES;

select *
from XLA_TRANSACTION_ENTITIES;
where source_id_int_1 = 2944969;



select *
from mtl_transaction_accounts
WHERE inv_sub_ledger_id IN(
--471636,
--471637,
471638,
471639);

select *
from xla_distribution_links
where source_distribution_id_num_1 IN(
--471636,
--471637,
471638,
471639);

SELECT *
FROM GL_JE_LINES
WHERE ENTERED_DR LIKE '24527%';

SELECT DOC_SEQUENCE_VALUE
FROM GL_JE_HEADERS
WHERE JE_HEADER_ID = '52496';

SELECT *
FROM GL_JE_LINES
WHERE ACCOUNTED_DR = '245270';


select *
from mtl_material_transactions
where transaction_id = 1067579;

select *
from ar_cash_receipts_all
where receipt

select *
from mtl_material_transactions
where transaction_id IN(1067573,1067579);

SELECT *
FROM xla_ae_lines
WHERE AE_HEADER_ID = 9188939
and ae_line_num = 4;

select *
from mtl_material_transactions
where transaction_id IN (1067579,1067573);

SELECT *
FROM xla_distribution_links
WHERE AE_HEADER_ID = 9188939;

select *

select distinct source_distribution_type
from xla_distribution_links;

/*
DEPRN
AP_INV_DIST
AR_DISTRIBUTIONS_ALL
TRX
WIP_TRANSACTION_ACCOUNTS
AP_PMT_DIST
AP_PREPAY
RA_CUST_TRX_LINE_GL_DIST_ALL
XLA_MANUAL
MTL_TRANSACTION_ACCOUNTS
RCV_RECEIVING_SUB_LEDGER
*/
select *
from mtl_material_transaction
where transaction_
;
select *
from ra_customer_trx_all
where interface_header_attribute1 = '3010014817';

select *
from hr_all_organization_units;

SELECT DISTINCT SOURCE_DISTRIBUTION_TYPE
FROM xla_distribution_links;
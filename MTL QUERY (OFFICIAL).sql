/* MTL QUERY TO BE SENT TO MS.GRACE,
    CREATED AS OF OCTOBER 10, 2017 */

SELECT 
--        glcc.segment1 company, glcc.segment2 LOCATION,
--       glcc.segment3 cost_center, glcc.segment4 ACCOUNT,
--       glcc.segment5 product, glcc.segment6 channel, glcc.segment7 project,
--       (SELECT flex_value || ' ' || fvt.description
--          FROM apps.gl_code_combinations glc,
--               apps.fnd_flex_values fv,
--               apps.fnd_flex_values_tl fvt
--         WHERE glc.code_combination_id = gjl.code_combination_id
--           AND glc.segment4 = fv.flex_value
--           AND fv.flex_value_set_id = 1002653
--           AND fv.flex_value_id = fvt.flex_value_id) code_combo_desc,
--       gjh.posted_date posted_on_dt, gjh.je_source, gjh.je_category,
--       gjb.NAME je_batch_name, gjh.NAME journal_name, '' je_seq_name,
--       '' je_seq_num, gjl.je_line_num je_line, gjl.description je_line_descr,
--       xal.entered_cr global_cr, xal.entered_dr global_dr,
--       xal.currency_code global_cur, ac.customer_name vendor_customer,
--       rcta.trx_number transaction_num, rcta.trx_date transaction_date,
--       xal.accounting_class_code transaction_type, xal.accounted_cr local_cr,
--       xal.accounted_dr local_dr, gl.currency_code local_cur,
--       (NVL (xal.accounted_dr, 0) - NVL (xal.accounted_cr, 0)
--       ) transaction_amount,
--       gl.currency_code transaction_curr_code, gjh.period_name fiscal_period,
--       (gb.begin_balance_dr - gb.begin_balance_cr) begin_balance,
--       (  gb.period_net_dr
--        - gb.period_net_cr
--        + gb.project_to_date_dr
--        - gb.project_to_date_cr
--       ) end_balance,
--       gl.NAME ledger_name
   --     xte.entity_code ,
        mmt.transaction_id,
        msib.organization_id,
        org.name organization,
        xah.period_name,
    --    rcta.trx_number invoice_number,
      --  rcta.attribute3 cs_no,
        --  rctta.name,
        --    rctta.description,
        --    rcta.attribute4 lot_no,
   --     rctal.customer_trx_line_id,
   --     rcta.comments ifs_invoice_no,
   --     msib.segment1 part_no,
   --     msib.description,
     xal.accounting_class_code      AS "Accounting Class Code",
                xdl.accounting_line_code       AS "Accounting Line Code",
                xdl.line_definition_code       AS "Line Definition COde",
                xdl.event_class_code           AS "Event Class Code",
                xdl.event_type_code            AS "Event Type Code",
                xdl.rounding_class_code        AS "Rounding Class Code",
                xah.accounting_date            AS "Accounting Date",
   msib.segment1 part_no,
   msib.description,
        mck.segment1 as item_category_family,
        mck.segment2 as item_category_class,
       msib.item_type,
        flv.meaning  item_type_description,
  --      rctal.description,
   --     rcta.trx_date invoice_date,
        gjh.je_source,
        xal.description,
        xah.JE_CATEGORY_NAME,
        to_char(gjh.doc_sequence_value) gl_voucher_no,
        gjl.je_line_num,
        to_char(glcc.segment6) account_no,
    --    to_char(rcta.trx_number) invoice_no,
    --    to_char(rcta.trx_date) invoice_date,
    --    to_char(rcta.creation_date) creation_date,
        to_char(xah.accounting_date) accounting_date,
        xah.gl_transfer_status_code,
        to_char(xah.gl_transfer_date) gl_transfer_date,
   --     sum(rct_gl.amount) distribution_amount,
        nvl(xal.entered_dr,0) XLA_ENTERED_DR,
        nvl(xal.entered_cr,0) XLA_ENTERED_CR,
        nvl(xal.entered_dr,0) - nvl(xal.entered_cr,0) xla_entered_amount,
        nvl(xal.accounted_dr,0) XLA_ACCOUNTED_DR,
        nvl(xal.accounted_cr,0) XLA_ACCOUNTED_CR,
        nvl(xal.accounted_dr,0) - nvl(xal.accounted_cr,0) xla_accounted_amount,
        nvl(gjl.entered_dr,0) GL_ENTERED_DR,
        nvl(gjl.entered_cr,0) GL_ENTERED_CR,
        nvl(gjl.entered_dr,0) - nvl(gjl.entered_cr,0) gl_entered_amount,
        nvl(gjl.accounted_dr,0) GL_ACCOUNTED_DR,
        nvl(gjl.accounted_cr,0) GL_ACCOUNTED_CR,
        nvl(gjl.accounted_dr,0) -  nvl(gjl.accounted_cr,0) gl_accounted_amount
        

FROM   
        xla.xla_ae_headers xah 
        INNER JOIN xla.xla_ae_lines xal
            ON  xah.ae_header_id = xal.ae_header_id 
            AND xal.application_id = xah.application_id
        INNER JOIN apps.gl_code_combinations glcc
            ON xal.code_combination_id = glcc.code_combination_id
        INNER  JOIN xla.xla_transaction_entities xte
            ON xah.entity_id = xte.entity_id
            AND xte.application_id = xal.application_id
        LEFT JOIN apps.gl_import_references gir
            ON gir.gl_sl_link_id = xal.gl_sl_link_id
            AND gir.gl_sl_link_table = xal.gl_sl_link_table
        LEFT JOIN apps.gl_je_lines gjl
            ON gjl.je_header_id = gir.je_header_id
            AND gjl.je_line_num = gir.je_line_num
        LEFT JOIN apps.gl_je_headers gjh         
            ON gjh.je_header_id = gjl.je_header_id
        LEFT JOIN xla_distribution_links xdl
            ON xah.ae_header_id = xdl.ae_header_id
            and xdl.event_id = xah.event_id
            and xdl.ae_line_num = xal.ae_line_num
            and xdl.application_id = xah.application_id
        INNER JOIN mtl_transaction_accounts mta
            ON xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id
        INNER JOIN mtl_material_transactions mmt
            ON mmt.transaction_id = mta.transaction_id
--        LEFT JOIN mtl_transaction_types mtt
--            ON mtt.transaction_type_id = mmt.transaction_type_id
        INNER JOIN    mtl_system_items_b msib
            ON mmt.inventory_item_id = msib.inventory_item_id
            AND mmt.organization_id = msib.organization_id
        INNER JOIN mtl_item_categories  mtc
            ON msib.inventory_item_id = mtc.inventory_item_id 
            AND msib.organization_id = mtc.organization_id 
        INNER JOIN mtl_categories_kfv mck 
            ON mtc.category_id =mck.category_id 

        INNER JOIN fnd_lookup_values flv
            ON  msib.item_type = flv.lookup_code  
        INNER JOIN hr_all_organization_units org
            ON org.organization_id = msib.organization_id

WHERE 1 = 1
            AND  mck.structure_id = '50388'
            AND  flv.lookup_type = 'ITEM_TYPE'
     --       and UPPER(mtt.transaction_type_name) like 'PO RECEIPT'
       --     and mck.segment1 = 'CKD'
     --       AND line_type = 'LINE'
        AND glcc.segment6 IN ('65300')
          --  AND xte.entity_code = 'TRANSACTIONS'
            AND xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
       --     and rct_gl.amount > 0
     --  AND rcta.trx_number = '40200013994'
           AND xah.accounting_date BETWEEN '01-JUL-2017' AND '30-SEP-2017'
     --      AND mmt.transaction_id = 868778
       --      AND mmt.organization_id = 102
group by    
     xal.accounting_class_code  ,
                xdl.accounting_line_code     ,
                xdl.line_definition_code ,
                xdl.event_class_code         ,
                xdl.event_type_code            ,
                xdl.rounding_class_code        ,
                xah.accounting_date    ,
--    xte.entity_code,
        mmt.transaction_id,
        msib.organization_id,
        org.name,
        xah.period_name,
         mck.segment1 ,
        mck.segment2 ,
       msib.item_type,
        flv.meaning ,
    msib.segment1 ,
   msib.description,
    --    rcta.attribute3 ,
        --  rctta.name,
        --    rctta.description,
        --    rcta.attribute4 lot_no,
  --      rctal.customer_trx_line_id,
    --    rcta.comments ,
    --    msib.segment1 ,
     --   msib.description,
       mck.segment1  ,
     --   mck.segment2  ,
     --   msib.item_type,
     --   flv.meaning   ,
  --      rctal.description,
    --    rcta.trx_date  ,
        gjh.je_source,
        xal.description,
        xah.JE_CATEGORY_NAME,
        to_char(gjh.doc_sequence_value)  ,
        gjl.je_line_num,
        to_char(glcc.segment6)  ,


        to_char(xah.accounting_date)  ,
        xah.gl_transfer_status_code,
        to_char(xah.gl_transfer_date)  ,
 --     rct_gl.amount,
        xal.entered_dr  ,
        xal.entered_cr  ,
        xal.accounted_dr  ,
        xal.accounted_cr  ,
        gjl.entered_dr  ,
        gjl.entered_cr  ,
        gjl.accounted_dr  ,
        gjl.accounted_cr  
      ---     AND gjh.doc_sequence_value = '84017217'
    --   AND rcta.trx_number = '40200012379'
          --  AND gjh.je_source = 'Receivables'
;


select *
from all_tab_columns
where table_name like 'XXIPC%WIP%';

SELECT *
FROM XXIPC_RCV_INSP_ACCTG_V
where   SEGMENT1 IN ('150TBR54FWL-IPCAC1/JE','150TBR54FWL-IPCACD/JE','150TBR54FWL-IPCBD2/JE','150TBR54FWL-IPCDS7T/JE','150TBR54FWL-IPCDS6T/JE','150TBR54FWL-IPCDS6/JE','150TBR54FWL-IPCDS8/JE','150TFR86DRA1P LT/B','150TFS86DRB1P LT/B','160TFR85DRD1P/B','160TFR85DRD2P/B','160TFR85DTD1P/B','160TFR85DTD2P/B','160TFS85DRD1P/B','160TFS85DTD1P/B')

;

WHERE  
XXIPC_WIP_VAL_ACCTG_V;

SELECT *
FROM rcv_transactions
where transaction_id =1895135 ;


SELECT *
FROM XXIPC_WIP_VAL_ACCTG_V;

SELECT  
 mmt.transaction_source_id,
 mmt.rcv_transaction_id,
            mmt.CREATION_DATE,
            mmt.LAST_UPDATE_DATE, 
            mmt.transaction_date AS transaction_date,
            mmt.transaction_id, 
            mmt.organization_id,
            org.name,
            mmt.inventory_item_id,
            msib.description,
            mck.segment1 as item_category_family,
            mck.segment2 as item_category_class,
            msib.item_type,
            flv.meaning  item_type_description,
            mty.transaction_type_name,
            msib.segment1,
            mmt.transaction_source_id,
--            xdl.application_id             AS "Application ID",
            xdl.source_distribution_type   AS "Source Distribution Type",
--            xdl.source_distribution_id_num_1 AS "Source Distribution Id Num",
--            xdl.ae_header_id               AS "AE Header ID",
--            xdl.ae_line_num                AS "AE Line Num",
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
--            gcc.segment1                   AS "Company",
--            gcc.segment2                   AS "Cost Center",
--            gcc.segment3                   AS "ID",
--            gcc.segment4                   AS "Budget Account",
--            gcc.segment5                   AS "Budget Cost Center",
            gcc.segment6                   AS "Account",
--            gcc.segment7                   AS "Model",
--            gcc.segment8                   AS "Projects",
--            gcc.segment9                   AS "Future",
--            xah.description                AS "Description",
            xal.description                AS "Line Description",
--            xal.displayed_line_number      AS "Line Number",
            xah.period_name                AS "Period Name",
            xal.entered_dr                 AS "Entered Debit",
            xal.entered_cr                 AS "Entered Credit",
--            xal.accounted_dr               AS "Accounted Debit",
--            xal.accounted_cr               AS "Accounted Credit",
--            xdl.unrounded_entered_dr       AS "Unrounded Entered Debit",
--            xdl.unrounded_entered_cr       AS "Unrounded Entered Credit",
--            xdl.unrounded_accounted_dr     AS "Unrounded Accounted Debit",
--            xdl.unrounded_accounted_cr     AS "Unrounded Accounted Credit",
--            xal.currency_code              AS "Currency Code",
--            xal.currency_conversion_date   AS "Currency Conversion Date",
--            xal.currency_conversion_rate   AS "Currency Conversion Rate",
            xah.product_rule_code          AS "Product Rule Code"
FROM xla_distribution_links xdl,
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
            hr_all_organization_units org
   WHERE     
        mmt.inventory_item_id = msib.inventory_item_id and
        mmt.organization_id = msib.organization_id and 
        xal.code_combination_id = gcc.code_combination_id
         AND xah.ae_header_id = xal.ae_header_id
         AND xal.ae_header_id = xdl.ae_header_id
         AND xal.ae_line_num = xdl.ae_line_num
         /* new joins */
        and msib.inventory_item_id = mtc.inventory_item_id 
        and MMT.ORGANIZATION_ID = mtc.ORGANIZATION_ID
        and mmt.organization_id = msib.organization_id  
        and MMT.TRANSACTION_TYPE_ID = MTY.TRANSACTION_TYPE_ID
        and mtc.CATEGORY_ID =mck.CATEGORY_ID  
        and  MSIb.ITEM_TYPE = FLV.LOOKUP_CODE       
         and mmt.organization_id = org.organization_id
         AND mck.segment1 = 'CKD'
            and  FLV.LOOKUP_TYPE = 'ITEM_TYPE'
-- AND  xal.accounting_class_code = 'RECEIVING_INSPECTION' 
            and  MCK.STRUCTURE_ID = '50388'
 --           AND  xdl.event_class_code like '%INT%'
   --         and msib.segment1 = '150TBR54FWL-IPCAC1/JE'
         -- and xah.doc_sequence_value = "40300000724 "
         -- and gcc.segment6 = "01200"
        --AND xdl.source_distribution_type = "RCV_RECEIVING_SUB_LEDGER"
 --      AND xah.accounting_date BETWEEN :P_Start_Date AND :P_End_Date
    --   AND MMT.TRANSACTION_DATE BETWEEN :P_Start_Date AND :P_End_Date
         --   AND xdl.event_class_code = "SALES_ORDER"
--and xdl.application_id   not in ("200","140","222")
 and xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
-- and gcc.segment6 = '01100'
and mmt.transaction_id = mta.transaction_id
--and xdl.ae_header_id   in ("9586301","9614129","9614823")
-- and gcc.segment6   between '05100' AND '05199'
--and xdl.line_definition_code    = "IPC_SALES_ORDER"
--and xdl.accounting_line_code  = "INVENTORY_VALUATION"
--And xal.entered_dr  = 226510
-- and  xah.gl_transfer_status_code ='N'
--and xdl.rounding_class_code ="COST_OF_GOODS_SOLD"
--  and  mmt.organization_id  in ('121','107') --rio nac dbs ips
-- and  gcc.segment6 in ('65100')
-- AND mmt.transaction_id = 2978467
-- and mmt.inventory_item_id = 86007
and xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id
-- and mmt.transaction_id = 1490539
-- and mmt.transaction_id = 3565296
-- and xah.gl_transfer_status_  code <> 'Y'
--and xal.entered_dr  = 278.3
--and msib.segment1 = "8971793590"
--and  mmt.transaction_id = 1493395
and xah.accounting_date BETWEEN '01-JUL-2017' AND '30-JUL-2017' 
-- and xal.accounting_class_code like 'INTERORG%'
--AND xdl.ae_header_id  = "10294671"
;
ORDER BY xdl.ae_header_id, xdl.ae_line_num ASC;

SELECT *
FROM HR_ALL_ORGANIZATION_UNITS;

SELECT *
FROM AR_CUSTOMERS;

SELECT  DISTINCT   gl_transfer_status_code 
FROM XLA_AE_HEADERS;

select *
from ra_customer_trx_all
where attribute3 in ('CS5798','CS6801');

SELECT *
FROM rcv_transactions
WHERE rcvt.transaction_id = 920407;

    select doc_sequence_value
    from ar_cash_receipts_all
    where receipt_number = '072001';

select segment1
from mtl_system_items_b
where inventory_item_id = 92584;

SELECT msib.segment1,
           msib.description, xal.accounting_class_code,
         po_lines.vendor_product_num lot_number,
           mck.segment1 AS item_category_family,
           mck.segment2 AS item_category_class,
           msib.item_type,
           mmt.transaction_quantity,
           mty.transaction_type_name,
           mmt.transaction_date AS transaction_date,
           xah.accounting_date,
           /** REFERENCES **/
           mmt.transaction_id,
           mmt.organization_id,
           org.name organization,
           mmt.rcv_transaction_id, 
         po_head.segment1 po_number,
          po_lines.line_num
      FROM xla_distribution_links xdl,
           xla_ae_headers xah,
           xla_ae_lines xal,
           gl_code_combinations gcc,
           mtl_transaction_accounts mta,
           mtl_system_items_b msib,
           mtl_material_transactions mmt,
           MTL_ITEM_CATEGORIES mtc,
           mtl_categories_kfv mck,
           FND_LOOKUP_VALUES_VL flv,
           MTL_TRANSACTION_TYPES MTY,
           hr_all_organization_units org,
         rcv_transactions rcvt,
          po_lines_all po_lines,
           po_headers_all po_head
     WHERE     1 = 1
           AND mmt.inventory_item_id = msib.inventory_item_id
           AND mmt.organization_id = msib.organization_id
           AND xal.code_combination_id = gcc.code_combination_id
           AND xah.ae_header_id = xal.ae_header_id
           AND xal.ae_header_id = xdl.ae_header_id
           AND xal.ae_line_num = xdl.ae_line_num
           /* new joins */
           AND msib.inventory_item_id = mtc.inventory_item_id
           AND MMT.ORGANIZATION_ID = mtc.ORGANIZATION_ID
           AND mmt.organization_id = msib.organization_id
           AND MMT.TRANSACTION_TYPE_ID = MTY.TRANSACTION_TYPE_ID
           AND org.organization_id = MMT.organization_id
           AND mtc.CATEGORY_ID = mck.CATEGORY_ID
           AND MSIb.ITEM_TYPE = FLV.LOOKUP_CODE
           AND FLV.LOOKUP_TYPE = 'ITEM_TYPE'
           AND MCK.STRUCTURE_ID = '50388'
           AND xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
           AND xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id
           AND mmt.transaction_id = mta.transaction_id
           --       and xah.accounting_date BETWEEN :P_Start_Date AND :P_End_Date
          AND mmt.organization_id IN ('88')                 --rio nac dbs ips
          AND mck.segment1 = 'CKD'
     AND xal.accounting_class_code = 'RECEIVING_INSPECTION'
           /***** PURCHASE ORDER *****/
           AND mmt.rcv_transaction_id = rcvt.transaction_id
         AND po_lines.po_line_id = rcvt.po_line_id(+)
          AND po_lines.po_header_id = po_head.po_header_id(+)
               and msib.segment1 = '150TBR54FWL-IPCAC1/JE';
               
               
               
              x

/* Formatted on 11/7/2017 6:53:42 PM (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW APPS.XXIPC_RCV_INSP_ACCTG_V
(
   SEGMENT1,
   DESCRIPTION,
   LOT_NUMBER,
   ITEM_CATEGORY_FAMILY,
   ITEM_CATEGORY_CLASS,
   ITEM_TYPE,
   TRANSACTION_QUANTITY,
   TRANSACTION_TYPE_NAME,
   TRANSACTION_DATE,
   ACCOUNTING_DATE,
   TRANSACTION_ID,
   ORGANIZATION_ID,
   ORGANIZATION,
   RECEIVING_TRANSACTION_ID,
   PO_NUMBER,
   LINE_NUM
)
AS
   (SELECT msib.segment1,
           msib.description,
           po_lines.vendor_product_num lot_number,
           mck.segment1 AS item_category_family,
           mck.segment2 AS item_category_class,
           msib.item_type,
           mmt.transaction_quantity, 
           mty.transaction_type_name,
           mmt.transaction_date AS transaction_date,
           xah.accounting_date,
           /** REFERENCES **/
           mmt.transaction_id,
           mmt.organization_id,
           org.name organization,
           mmt.transaction_source_id receiving_transaction_id,
           po_head.segment1 po_number,
           po_lines.line_num
      FROM xla_distribution_links xdl,
           xla_ae_headers xah,
           xla_ae_lines xal,
           gl_code_combinations gcc,
           mtl_transaction_accounts mta,
           mtl_system_items_b msib,
           mtl_material_transactions mmt,
           MTL_ITEM_CATEGORIES mtc,
           mtl_categories_kfv mck,
           FND_LOOKUP_VALUES_VL flv,
           MTL_TRANSACTION_TYPES MTY,
           hr_all_organization_units org,
           rcv_transactions rcvt,
           po_lines_all po_lines,
           po_headers_all po_head
     WHERE     1 = 1
           AND mmt.inventory_item_id = msib.inventory_item_id
           AND mmt.organization_id = msib.organization_id
           AND xal.code_combination_id = gcc.code_combination_id
           AND xah.ae_header_id = xal.ae_header_id
           AND xal.ae_header_id = xdl.ae_header_id
           AND xal.ae_line_num = xdl.ae_line_num
           /* new joins */
           AND msib.inventory_item_id = mtc.inventory_item_id
           AND MMT.ORGANIZATION_ID = mtc.ORGANIZATION_ID
           AND mmt.organization_id = msib.organization_id
           AND MMT.TRANSACTION_TYPE_ID = MTY.TRANSACTION_TYPE_ID
           AND org.organization_id = MMT.organization_id
           AND mtc.CATEGORY_ID = mck.CATEGORY_ID
           AND MSIb.ITEM_TYPE = FLV.LOOKUP_CODE
           AND FLV.LOOKUP_TYPE = 'ITEM_TYPE'
           AND MCK.STRUCTURE_ID = '50388'
           AND xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
           AND xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id
           AND mmt.transaction_id = mta.transaction_id
           --       and xah.accounting_date BETWEEN :P_Start_Date AND :P_End_Date
           AND mmt.organization_id IN ('88')                 --rio nac dbs ips
           AND  mck.segment1 = 'CKD'
           AND xal.accounting_class_code IN ('RECEIVING_INSPECTION')
           /***** PURCHASE ORDER *****/
           AND mmt.rcv_transaction_id = rcvt.transaction_id
           AND po_lines.po_line_id = rcvt.po_line_id
           AND po_lines.po_header_id = po_head.po_header_id);

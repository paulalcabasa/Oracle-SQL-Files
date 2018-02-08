select   DISTINCT
      --  rct_gl.cust_trx_line_gl_dist_id, 
        xte.entity_code, 
        gjh.doc_sequence_value GL_VOUCHER_NUM,
        rcta.trx_number invoice_number,
     --   rcta.attribute3 cs_no,
        rctta.name,
        rctta.description,
        rcta.comments ifs_invoice_no,
        msib.segment1 part_no,
        msib.description,
        mck.segment1 as item_category_family,
        mck.segment2 as item_category_class,
        msib.item_type,
        flv.meaning  item_type_description,
        to_char(rcta.trx_date) invoice_date,
        to_char(rct_gl.gl_date) gl_date,
        to_char(xah.accounting_date)            AS "Accounting Date",
        xah.gl_transfer_status_code    AS "GL Transfer Status Code",
        xah.gl_transfer_date           AS "GL Transfer Date",
        gjl.je_line_num GL_LINE_NUM,
        --       xal.ae_line_num,
        gcc.segment6                   AS "Account",
        xal.entered_dr                 AS "XLA Entered Debit",
        xal.entered_cr                 AS "XLA Entered Credit",
        gjl.entered_dr "GL Entered Debit",
        gjl.entered_cr "GL Entered Credit",
        --       xdl.application_id             AS "Application ID",
        xdl.source_distribution_type   AS "Source Distribution Type",
        --        xdl.source_distribution_id_num_1 AS "Source Distribution Id Num",
        --         xdl.ae_header_id               AS "AE Header ID",
        --       xdl.ae_line_num                AS "AE Line Num",
        xal.accounting_class_code      AS "Accounting Class Code",
        --            xdl.accounting_line_code       AS "Accounting Line Code",
        xdl.line_definition_code       AS "Line Definition Code",
        xdl.event_class_code           AS "Event Class Code",
        xdl.event_type_code            AS "Event Type Code",
        xdl.rounding_class_code        AS "Rounding Class Code",
        xah.je_category_name           AS "JE Category Name",
        xah.accounting_entry_type_code AS "Accounting Entry Type Code",
        xah.doc_sequence_value         AS "Document Sequence Value",
        xah.description                AS "Description",
        xal.description                AS "Line Description",
   --     xal.displayed_line_number      AS "Line Number",
        xah.period_name                AS "Period Name"
from -- XLA
        xla_ae_headers xah,
        xla_ae_lines xal,
        xla_distribution_links xdl,
        xla_events xe,
        xla.xla_transaction_entities xte,
        gl_import_references gir,
        -- GL
        gl_je_headers gjh,
        gl_je_lines gjl,
        -- LOOKUP TABLES
        gl_code_combinations gcc,
        -- Transactions
        ra_cust_trx_line_gl_dist_all rct_gl,
         -- ITEM
        mtl_system_items_b msib,
        mtl_item_categories  mtc,
        mtl_categories_kfv mck,
        fnd_lookup_values flv,
        -- INVOICE
        ra_customer_trx_lines_all rctal,
        ra_customer_trx_all rcta,
        RA_CUST_TRX_TYPES_ALL rctta
     --   ar_payment_schedules_all apsa
where 1 = 1
          -- XLA
        and xah.ae_header_id = xal.ae_header_id
        and xah.application_id = xal.application_id
        
        -- XLA EVENTS
        and xe.event_id = xah.event_id
        and xe.application_id = xah.application_id
        
        -- XLA TRANSACTION ENTITIES
        and xte.application_id = xe.application_id
        and xte.entity_id = xe.entity_id  
        and xte.source_id_int_1 = rct_gl.customer_trx_id 
        and xte.entity_code = 'TRANSACTIONS'  
         
        -- XLA LINK TO GL  
        and xal.gl_sl_link_id = gir.gl_sl_link_id(+)
        and xal.gl_sl_link_table = gir.gl_sl_link_table(+)
        
        -- GL
        and gir.je_header_id = gjh.je_header_id(+)
        and gir.je_header_id = gjl.je_header_id(+)
        and gir.je_line_num = gjl.je_line_num(+)
       
        -- XLA DISTRIBUTIONS
        and xdl.event_id = xah.event_id
        and xdl.ae_header_id = xah.ae_header_id
        and xdl.ae_line_num = xal.ae_line_num
        and xdl.application_id = xah.application_id
        and xdl.source_distribution_id_num_1 = rct_gl.cust_trx_line_gl_dist_id
        and xdl.source_distribution_type = 'RA_CUST_TRX_LINE_GL_DIST_ALL'
        
       -- INVOICE
        and rcta.customer_trx_id = rct_gl.customer_trx_id
        and rcta.customer_trx_id = rctal.customer_trx_id
        and rcta.cust_trx_type_id = rctta.cust_trx_type_id
      --  and rcta.customer_trx_id = apsa.customer_trx_id
        
       -- ITEM
        and rctal.inventory_item_id = msib.inventory_item_id
        and rctal.warehouse_id =  msib.organization_id
        and msib.inventory_item_id = mtc.inventory_item_id 
        and msib.organization_id = mtc.organization_id 
        and mtc.category_id =mck.category_id  
        and  msib.item_type = flv.lookup_code  
        and  flv.lookup_type = 'ITEM_TYPE'
        and  mck.structure_id = '50388'
        
        -- LOOK UPS
        and gcc.code_combination_id = xal.code_combination_id
        
        -- FILTERS
     and rcta.trx_number like '40200001893'
  --   and rcta.trx_date <> rct_gl.gl_date
        
 --   and xah.accounting_date BETWEEN '01-JAN-2017' AND '15-JAN-2017';
    --  order by gjl.je_line_num
;
    
SELECT *
FROM ra_cust_trx_line_gl_dist_all;

/*** AR INVOICE QUERY ***/
select    --distinct rcta.trx_number,
        --    rcta.trx_date invoice_date,
      distinct 
        --    gjh.je_header_id,
        gjh.doc_sequence_value GL_VOUCHER_NUM,
        rcta.trx_number invoice_number,
        rcta.attribute3 cs_no,
        rctta.name,
        rctta.description,
    --    rcta.attribute4 lot_no,
        rcta.comments ifs_invoice_no,
        msib.segment1 part_no,
        msib.description,
        mck.segment1 as item_category_family,
        mck.segment2 as item_category_class,
       msib.item_type,
       flv.meaning  item_type_description,
  --      rctal.description,
        rcta.trx_date invoice_date,
        xah.accounting_date            AS "Accounting Date",
        xah.gl_transfer_status_code    AS "GL Transfer Status Code",
        xah.gl_transfer_date           AS "GL Transfer Date",
        gjl.je_line_num GL_LINE_NUM,
        --       xal.ae_line_num,
        gcc.segment6                   AS "Account",
        xal.entered_dr                 AS "XLA Entered Debit",
        xal.entered_cr                 AS "XLA Entered Credit",
        gjl.entered_dr "GL Entered Debit",
        gjl.entered_cr "GL Entered Credit",
        --       xdl.application_id             AS "Application ID",
        xdl.source_distribution_type   AS "Source Distribution Type",
        --        xdl.source_distribution_id_num_1 AS "Source Distribution Id Num",
        --         xdl.ae_header_id               AS "AE Header ID",
        --       xdl.ae_line_num                AS "AE Line Num",
            xal.accounting_class_code      AS "Accounting Class Code",
--            xdl.accounting_line_code       AS "Accounting Line Code",
            xdl.line_definition_code       AS "Line Definition Code",
            xdl.event_class_code           AS "Event Class Code",
            xdl.event_type_code            AS "Event Type Code",
            xdl.rounding_class_code        AS "Rounding Class Code",
            xah.je_category_name           AS "JE Category Name",
            xah.accounting_entry_type_code AS "Accounting Entry Type Code",
            xah.doc_sequence_value         AS "Document Sequence Value",
            xah.description                AS "Description",
            xal.description                AS "Line Description",
            xal.displayed_line_number      AS "Line Number",
            xah.period_name                AS "Period Name"
      --      rct_gl.amount,
from -- SLA TABLES
        xla_ae_headers xah,
        xla_ae_lines xal,
        xla_distribution_links xdl,
        -- LINK TO SLA TABLE
        ra_cust_trx_line_gl_dist_all rct_gl,
        gl_code_combinations gcc,
        -- AR TABLE
        ra_customer_trx_lines_all rctal,
        ra_customer_trx_all rcta,
        RA_CUST_TRX_TYPES_ALL rctta,
        -- GL TABLES
        GL_IMPORT_REFERENCES gir,
        gl_je_headers gjh,
        gl_je_lines gjl,
        -- ITEM
        mtl_system_items_b msib,
        mtl_item_categories  mtc,
        mtl_categories_kfv mck,
        fnd_lookup_values flv
where 1 = 1
        -- SLA 
        and xah.ae_header_id = xdl.ae_header_id
        and xah.ae_header_id = xal.ae_header_id
        and xah.application_id = xal.application_id
        and xdl.source_distribution_id_num_1 = rct_gl.cust_trx_line_gl_dist_id
        and xdl.source_distribution_type = 'RA_CUST_TRX_LINE_GL_DIST_ALL'
        and xal.code_combination_id = gcc.code_combination_id
         -- GL 
        and xal.gl_sl_link_id = gir.gl_sl_link_id(+)
        and xal.gl_sl_link_table = gir.gl_sl_link_table(+)
        and gir.je_header_id = gjh.je_header_id
        and gir.je_line_num = gjl.je_line_num
        and gjh.je_header_id = gjl.je_header_id
    --  and xdl.ae_line_num = xal.ae_line_num
   --     and xdl.ae_line_num = gjl.je_line_num
     --   and gjl.reference_8=  xal.ae_line_num  
        -- INVOICE
        and rcta.customer_trx_id = rct_gl.customer_trx_id
        and rcta.customer_trx_id = rctal.customer_trx_id
        and rcta.cust_trx_type_id = rctta.cust_trx_type_id
       -- ITEM
        and rctal.inventory_item_id = msib.inventory_item_id
        and rctal.warehouse_id =  msib.organization_id
        and msib.inventory_item_id = mtc.inventory_item_id 
        and msib.organization_id = mtc.organization_id 
        and mtc.category_id =mck.category_id  
        and  msib.item_type = flv.lookup_code  
        and  flv.lookup_type = 'ITEM_TYPE'
        and  mck.structure_id = '50388'
        
--FILTERS
 and rcta.trx_number = '40200013994'
-- and xal.accounting_date between '01-JAN-2017' AND '30-JUN-2017'
-- and gcc.segment6 between '01100' and '01199'
 -- and gcc.segment6 = '02000'
--  and rcta.trx_number = '40200012379'
;

SELECT XAH.PERIOD_NAME,
            XAL.ENTERED_DR,
            XAL.ENTERED_CR,
            GCC.SEGMENT6,
            GL_TRANSFER_STATUS_CODE,
            GL_TRANSFER_DATE
FROM XLA_AE_HEADERS XAH,
          XLA_AE_LINES XAL,
          GL_CODE_COMBINATIONS GCC
 WHERE XAH.AE_HEADER_ID = XAL.AE_HEADER_ID
            AND GCC.CODE_COMBINATION_ID = XAL.CODE_COMBINATION_ID
          --  and GL_TRANSFER_STATUS_CODE = 'Y'
             AND GCC.SEGMENT6 = '02001';
             
             SELECT *
             FROM XLA_AE_HEADERS XAH , XLA_AE_LINES XAL,
                        GL_CODE_COMBINATIONS GCC
             WHERE 1 = 1
                        AND XAH.AE_HEADER_ID = XAL.AE_HEADER_ID
                        AND GCC.CODE_COMBINATION_ID = XAL.O-- GL_TRANSFER_STATUS_CODE = 'N'
             ;

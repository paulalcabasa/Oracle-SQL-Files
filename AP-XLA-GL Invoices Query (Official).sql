
select   DISTINCT
     -- GL
    gjh.doc_sequence_value,
    gjh.posted_date,
    gjh.status,
    gjl.je_line_num,
    -- INVOICE
    aia.invoice_num,
    aia.doc_sequence_value ap_voucher,
    aia.invoice_amount,
    to_char(aia.invoice_date) invoice_date,
    to_char(aia.gl_date) invoice_gl_date,
    to_char(xah.gl_transfer_date) gl_transfer_date,
    to_char(xah.accounting_date) xla_accounting_date,
    aps.vendor_name supplier_name,
    aia.invoice_id,
    aida.RECOVERY_RATE_ID,
    aida.RECOVERY_RATE_NAME,
    xah.gl_transfer_status_code    AS "GL Transfer Status Code",
    xah.je_category_name           AS "JE Category Name",
    -- XLA 
    gcc.segment6                   AS "Account",
    xah.period_name                AS "Period Name",
    xal.entered_dr                 AS "SLA Entered Debit",
    xal.entered_cr                 AS "SLA Entered Credit",
     xal.accounted_dr                 AS "SLA Accounted Debit",
    xal.accounted_cr                 AS "SLA Accounted Credit",
   -- gjl.entered_dr AS "GL Entered Debit",
   -- gjl.entered_cr as "GL Entered Credit",
    xdl.source_distribution_type   AS "Source Distribution Type",
    xal.accounting_class_code      AS "Accounting Class Code",
    xdl.accounting_line_code       AS "Accounting Line Code",
    xdl.line_definition_code       AS "Line Definition COde",
    xdl.event_class_code           AS "Event Class Code",
    xdl.event_type_code            AS "Event Type Code",
    xdl.rounding_class_code        AS "Rounding Class Code",
                
    xah.accounting_entry_type_code AS "Accounting Entry Type Code",
    xah.doc_sequence_value         AS "Document Sequence Value",
    xah.description                AS "Description",
    xal.description                AS "Line Description",
    xal.displayed_line_number      AS "Line Number"
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
        -- AP INVOCES
        ap_invoices_all aia,
        ap_suppliers aps,
        -- DISTRIBUTIONS
        AP_INVOICE_DISTRIBUTIONS_ALL aida
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
        and xte.source_id_int_1 = aia.invoice_id 
  --      and xte.entity_code = 'AP_INVOICES'   
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
        and aida.invoice_distribution_id = xdl.source_distribution_id_num_1
        and xdl.source_distribution_type = 'AP_INV_DIST'
        -- INVOICES
        and aps.vendor_id = aia.vendor_id
        -- LOOK UPS
        and gcc.code_combination_id = xal.code_combination_id
        -- FILTERS
  --      and xah.ae_header_id = 9196722
     --  and gjh.doc_sequence_value = '83007692'
      --  and gjh.doc_sequence_value IS NULL
     --   and aia.doc_sequence_value = '20010408'
      and gcc.segment6 = '89911'
    --   and xah.accounting_date BETWEEN '01-JAN-2017' AND '30-JUN-2017';
    --  order by gjl.je_line_num
;

SELECT *
FROM XLA_AE_LINES A,
           GL_CODE_COMBINATIONS GCC,
           XLA_AE_HEADERS B
 WHERE  1 = 1   
            AND A.AE_HEADER_ID  = B.AE_HEADER_ID
            AND A.CODE_COMBINATION_ID = GCC.CODE_COMBINATION_ID
            AND GCC.SEGMENT6 = '89911'
             and B.accounting_date BETWEEN '01-JAN-2017' AND '30-JUN-2017';
             
             SELECT *
FROM GL_JE_LINES A,
           GL_CODE_COMBINATIONS GCC,
           GL_JE_HEADERS B
 WHERE  1 = 1   
            AND A.JE_HEADER_ID  = B.JE_HEADER_ID
            AND A.CODE_COMBINATION_ID = GCC.CODE_COMBINATION_ID
            AND GCC.SEGMENT6 = '89911'
             and B.accounting_date BETWEEN '01-JAN-2017' AND '30-JUN-2017';;
    
select *
from ap_invoices_all
where description like '%DR%223576%';

SELECT *
FROM rcv_ship

SELECT *
FROM XLA_AE_HEADERS
WHERE GL_TRANSFER_STATUS_CODE <> 'Y';

/*** AP INVOICES QUERY - XLA TO GL ***/
select    DISTINCT
            -- GL
            gjh.doc_sequence_value,
            gjh.posted_date,
            gjh.status,
            gjl.je_line_num,
            -- INVOICE
            aia.invoice_num,
            aia.doc_sequence_value ap_voucher,
            aia.invoice_amount,
            to_char(aia.invoice_date) invoice_date,
            to_char(aia.gl_date) invoice_gl_date,
            to_char(xah.gl_transfer_date) gl_transfer_date,
            to_char(xah.accounting_date) xla_accounting_date,
            aps.vendor_name supplier_name,
            aia.invoice_id,
            aida.RECOVERY_RATE_ID,
            aida.RECOVERY_RATE_NAME,
            xah.gl_transfer_status_code    AS "GL Transfer Status Code",
            xah.je_category_name           AS "JE Category Name",
            -- XLA 
            gcc.segment6                   AS "Account",
            xah.period_name                AS "Period Name",
            xal.entered_dr                 AS "Entered Debit",
            xal.entered_cr                 AS "Entered Credit",
            xdl.source_distribution_type   AS "Source Distribution Type",
            xal.accounting_class_code      AS "Accounting Class Code",
            xdl.accounting_line_code       AS "Accounting Line Code",
            xdl.line_definition_code       AS "Line Definition COde",
            xdl.event_class_code           AS "Event Class Code",
            xdl.event_type_code            AS "Event Type Code",
            xdl.rounding_class_code        AS "Rounding Class Code",
            
            xah.accounting_entry_type_code AS "Accounting Entry Type Code",
            xah.doc_sequence_value         AS "Document Sequence Value",
            xah.description                AS "Description",
            xal.description                AS "Line Description",
            xal.displayed_line_number      AS "Line Number"
from 
        -- SLA TABLES
        xla_ae_headers xah,
        xla_ae_lines xal,
        xla_distribution_links xdl,
        ap_invoice_distributions_all aida,
        gl_code_combinations gcc,
        -- GL TABLES
        GL_IMPORT_REFERENCES gir,
        gl_je_headers gjh,
        gl_je_lines gjl,
        -- AP TABLES
      
        ap_invoices_all aia,
        ap_suppliers aps
 
where 1 = 1
        -- XLA TALBE JOINS
        and xah.ae_header_id = xal.ae_header_id
        and xah.application_id = xal.application_id
        and xah.ae_header_id = xdl.ae_header_id
        and xal.code_combination_id = gcc.code_combination_id
        and xah.event_id = xdl.event_id
        and xdl.source_distribution_id_num_1 = aida.invoice_distribution_id
        and xdl.source_distribution_type = 'AP_INV_DIST'
        -- GL TABLE JOINS
        and xal.gl_sl_link_id = gir.gl_sl_link_id(+)
        and xal.gl_sl_link_table = gir.gl_sl_link_table(+)
        and gir.je_header_id = gjh.je_header_id
        and gir.je_line_num = gjl.je_line_num
        and gjh.je_header_id = gjl.je_header_id
      and xdl.ae_line_num = xal.ae_line_num
   --     and xdl.ae_line_num = gjl.je_line_num
        and gjl.reference_8=  xal.ae_line_num 
        -- INVOICE  NTS JOIN
        and aia.invoice_id = aida.invoice_id
        and aps.vendor_id = aia.vendor_id
        -- FILTERS
        
--  and gcc.segment6 BETWEEN '01100' AND '01199'
  --    and gcc.segment6 = '89910'
     and gjh.doc_sequence_value = '83025187'
     --   and aia.invoice_num = '20694' -- POSTED
    --    and aia.invoice_num = 'SI 1612-00474'     --  UNPOSTED
    
    --   and xah.gl_transfer_status_code <> 'N'
  and xah.accounting_date BETWEEN '01-JAN-2017' AND '15-JAN-2017';
order by gjl.je_line_num
          ; 
    
select *
from ap_invoice_distributions_all
where invoice_id = 922871;

select doc_sequence_value
from ap_checks_all;

select *
from ap_invoice_payments_all;


select *
from zx_rates_tl;

select *
from zx_rates_b
where tax_rate_id = 10268;


select 

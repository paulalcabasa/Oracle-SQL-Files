
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
    max(aida.RECOVERY_RATE_ID) recovery_rate_id,
    max(aida.RECOVERY_RATE_NAME) recovery_rate_name,
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
        and xte.entity_code = 'AP_INVOICES'   
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
    --   and xah.ae_header_id = 9196722
     --  and gjh.doc_sequence_value = '83007692'
      --  and gjh.doc_sequence_value IS NULL
     --   and aia.doc_sequence_value = '20010408'
      --and gcc.segment6 = '89911'
       and xah.accounting_date BETWEEN '01-JAN-2017' AND '17-AUG-2017'
    --  order by gjl.je_line_num
group by
  gjh.doc_sequence_value,
    gjh.posted_date,
    gjh.status,
    gjl.je_line_num,
    -- INVOICE
    aia.invoice_num,
    aia.doc_sequence_value ,
    aia.invoice_amount,
    aia.invoice_date,
    aia.gl_date,
    xah.gl_transfer_date,
    xah.accounting_date,
   aps.vendor_name ,
    aia.invoice_id,

    xah.gl_transfer_status_code   ,
    xah.je_category_name   ,
    -- XLA 
    gcc.segment6    ,
    xah.period_name   ,
    xal.entered_dr       ,
    xal.entered_cr          ,
     xal.accounted_dr      ,
    xal.accounted_cr       ,
   -- gjl.entered_dr AS "GL Entered Debit",
   -- gjl.entered_cr as "GL Entered Credit",
    xdl.source_distribution_type,
    xal.accounting_class_code,
    xdl.accounting_line_code  ,
    xdl.line_definition_code    ,
    xdl.event_class_code        ,
    xdl.event_type_code       ,
    xdl.rounding_class_code   ,
                
    xah.accounting_entry_type_code ,
    xah.doc_sequence_value        ,
    xah.description        ,
    xal.description              ,
    xal.displayed_line_number 

/*** AP PAYMENTS QUERY OFFICIAL ***/ 
select    DISTINCT
            -- GL
            gjh.doc_sequence_value,
            gjh.posted_date,
            gjh.status,
            gjl.je_line_num,
            -- INVOICE
            aia.invoice_num,
            to_char(aia.invoice_date) invoice_date,
            to_char(aia.gl_date) invoice_gl_date,
            apsa.vendor_name supplier_name,
            -- CHECK
            aipa.payment_num,
            aipa.check_id,
            aca.check_number,
            to_char(aca.check_date) check_date,
            aca.doc_sequence_value check_document_no,
            -- XLA 
            xdl.source_distribution_type   AS "Source Distribution Type",
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
            gcc.segment6                   AS "Account",
            xah.description                AS "Description",
            xal.description                AS "Line Description",
            xal.displayed_line_number      AS "Line Number",
            xah.period_name                AS "Period Name",
            xal.entered_dr                 AS "Entered Debit",
            xal.entered_cr                 AS "Entered Credit"
from 
        -- SLA TABLES
        xla_ae_headers xah,
        xla_ae_lines xal,
        xla_distribution_links xdl,
        ap_payment_hist_dists aphd,
        gl_code_combinations gcc,
        -- GL TABLES
        GL_IMPORT_REFERENCES gir,
        gl_je_headers gjh,
        gl_je_lines gjl,
        -- AP TABLES
        ap_invoice_payments_all aipa,
        ap_checks_all aca,
        ap_invoices_all aia,
        ap_suppliers apsa
where 1 = 1
        -- XLA TALBE JOINS
        and xah.ae_header_id = xal.ae_header_id
        and xah.application_id = xal.application_id
        and xah.ae_header_id = xdl.ae_header_id
        and xal.code_combination_id = gcc.code_combination_id
        and xah.event_id = xdl.event_id
        and xdl.source_distribution_id_num_1 = aphd.payment_hist_dist_id
        and xdl.source_distribution_type = 'AP_PMT_DIST'
        -- GL TABLE JOINS
        and xal.gl_sl_link_id = gir.gl_sl_link_id(+)
        and xal.gl_sl_link_table = gir.gl_sl_link_table(+)
        and gir.je_header_id = gjh.je_header_id
        and gir.je_line_num = gjl.je_line_num
        and gjh.je_header_id = gjl.je_header_id
        and xdl.ae_line_num = gjl.je_line_num
        -- INVOICE PAYMENTS JOIN
        and aipa.invoice_payment_id = aphd.invoice_payment_id
        and aipa.check_id = aca.check_id
        and aia.invoice_id = aipa.invoice_id
        and apsa.vendor_id = aia.vendor_id
         and gjh.doc_sequence_value = '83033623'
    --    and aia.invoice_num = 'SI P509-16-11W' -- POSTED
    --    and aia.invoice_num = 'SI 1612-00474'     --  UNPOSTED
    
    --   and xah.gl_transfer_status_code <> 'N'
  --  and xah.accounting_date BETWEEN '01-JUN-2017' AND '30-JUN-2017';
          ;
    
  
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
        and xdl.ae_line_num = gjl.je_line_num
        -- INVOICE  NTS JOIN
        and aia.invoice_id = aida.invoice_id
        and aps.vendor_id = aia.vendor_id
        -- FILTERS
        
        and gcc.segment6 BETWEEN '67102' AND '67104'
     --   and gcc.segment6 = '89910'
  --       and gjh.doc_sequence_value = '83033623'
        and aia.invoice_num = '20694' -- POSTED
    --    and aia.invoice_num = 'SI 1612-00474'     --  UNPOSTED
    
    --   and xah.gl_transfer_status_code <> 'N'
 -- and xah.accounting_date BETWEEN '01-JAN-2017' AND '31-MAY-2017';
order by gjl.je_line_num
          ;
    
select *
from ap_invoice_distributions_all
where invoice_id = 922871;


select *
from zx_rates_tl;

select *
from zx_rates_b
where tax_rate_id = 10268;
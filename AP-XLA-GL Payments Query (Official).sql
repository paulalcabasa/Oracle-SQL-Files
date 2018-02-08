select *
from gl_je_headers
where description like 'Payment Created , Payment Document Sequence Name: IPC Check Voucher , Payment Document Sequence Number: 30001030 , Payment Number: 57612 , Payment Date: 09-JAN-17 , Bank Name: BPI EPZA- Current , Payment Currency Code PHP';

SELECT *
FROM Per_All_People_f;
-- AP PAYMENTS QUERY LEFT JOINED
select   
            xah.je_category_name,
            gjh.doc_sequence_value gl_voucher,
            aca.doc_sequence_value check_document_no,
            to_char(xah.accounting_date,'DD/MM/YYYY') voucher_date,
            gcc.segment6 account_no,
              DECODE (
                    gcc.segment6,
                    '-', gcc.segment6,
                    gl_flexfields_pkg.get_description_sql (
                       gcc.chart_of_accounts_id,
                       6,
                       segment6))
                    account_name,
                 DECODE (
                    gcc.segment2,
                    '-', gcc.segment2,
                    gl_flexfields_pkg.get_description_sql (
                       gcc.chart_of_accounts_id,
                       2,
                       gcc.segment2))
                    cost_center,
                  DECODE (
                    gcc.segment3,
                    '-', gcc.segment3,
                    gl_flexfields_pkg.get_description_sql (
                       gcc.chart_of_accounts_id,
                       3,
                       gcc.segment3))
                    employee,
                 DECODE (
                    gcc.segment7,
                    '-', gcc.segment7,
                    gl_flexfields_pkg.get_description_sql (
                       gcc.chart_of_accounts_id,
                       7,
                       gcc.segment7))
                    model,
                 DECODE (
                    gcc.segment4,
                    '-', gcc.segment4,
                    gl_flexfields_pkg.get_description_sql (
                       gcc.chart_of_accounts_id,
                       4,
                       gcc.segment4))
                    budget_acount,
                 DECODE (
                    gcc.segment5,
                    '-', gcc.segment5,
                    gl_flexfields_pkg.get_description_sql (
                       gcc.chart_of_accounts_id,
                       5,
                       gcc.segment5))
                    budget_cost_center,
            xal.accounted_dr,
            xal.accounted_cr,
            aia.invoice_num reference,
            CASE 
                WHEN xal.description IS NULL AND gjh.doc_sequence_value IS NOT NULL THEN gjl.description
                ELSE xal.description
            END voucher_text
       
from 
        -- SLA TABLES
        xla_ae_headers xah 
        INNER JOIN xla_ae_lines xal
            ON  xah.ae_header_id = xal.ae_header_id
            AND xah.application_id = xal.application_id
       INNER  JOIN xla.xla_transaction_entities xte
            ON xah.entity_id = xte.entity_id
            AND xte.application_id = xal.application_id
        INNER JOIN gl_code_combinations gcc
            ON xal.code_combination_id = gcc.code_combination_id
        -- AP TABLES
        INNER JOIN ap_checks_all aca
            ON aca.check_id = xte.source_id_int_1
        INNER JOIN ap_invoice_payments_all aipa
            ON aipa.check_id = aca.check_id
        INNER JOIN ap_invoices_all aia
            ON aia.invoice_id = aipa.invoice_id      
        -- GL TABLES
        LEFT JOIN gl_import_references gir
            ON  xal.gl_sl_link_id = gir.gl_sl_link_id
            AND xal.gl_sl_link_table = gir.gl_sl_link_table
        LEFT JOIN apps.gl_je_lines gjl
            ON gjl.je_header_id = gir.je_header_id
            AND gjl.je_line_num = gir.je_line_num
        LEFT JOIN apps.gl_je_headers gjh         
            ON gjh.je_header_id = gjl.je_header_id
where 1 = 1

        and xte.entity_code = 'AP_PAYMENTS'
        and xah.je_category_name = NVL(:P_JE_CATEGORY,xah.je_category_name)
        and aca.doc_sequence_value between :P_CHECK_FROM AND :P_CHECK_TO
order by  xal.ae_line_num;
;

select DOC_SEQUENCE_VALUE,BANK_ACCOUNT_NUM
from AP_CHECKS_ALL;
          
          SELECT *
          FROM GL_JE_CATEGORIES;
          
          SELECT *
          FROM GL_JE_SOURCES_TL;
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
        and aca.doc_sequence_value = '1226'

          ;
          
          select check_number,
                     doc_sequence_value
          from ap_checks_all
          where doc_sequence_value = '1226';
          
          
-- LOV FOR PAYMENTS
/*** AP PAYMENTS QUERY OFFICIAL ***/ 
select    DISTINCT
            -- GL
            gjh.doc_sequence_value,
            -- INVOICE
        --    aia.invoice_num,
            -- CHECK
          -- aipa.payment_num,
            aca.doc_sequence_value
           -- aca.check_number
       
from 
        -- SLA TABLES
        xla_ae_headers xah,
        xla_ae_lines xal,
        xla_distribution_links xdl,
        ap_payment_hist_dists aphd,
        -- GL TABLES
        gl_import_references gir,
        gl_je_headers gjh,
        gl_je_lines gjl,
        -- AP TABLES
        ap_invoice_payments_all aipa,
        ap_checks_all aca
      --  ap_invoices_all aia
where 1 = 1
        -- XLA TALBE JOINS
        and xah.ae_header_id = xal.ae_header_id
        and xah.application_id = xal.application_id
        and xah.ae_header_id = xdl.ae_header_id
  --      and xal.code_combination_id = gcc.code_combination_id
        and xah.event_id = xdl.event_id
        and xdl.source_distribution_id_num_1 = aphd.payment_hist_dist_id
        and xdl.source_distribution_type = 'AP_PMT_DIST'
        -- GL TABLE JOINS
        and xal.gl_sl_link_id = gir.gl_sl_link_id
        and xal.gl_sl_link_table = gir.gl_sl_link_table
        and gir.je_header_id = gjh.je_header_id
        and gir.je_line_num = gjl.je_line_num
        and gjh.je_header_id = gjl.je_header_id
        and xdl.ae_line_num = gjl.je_line_num
        -- INVOICE PAYMENTS JOIN
        and aipa.invoice_payment_id = aphd.invoice_payment_id
        and aipa.check_id = aca.check_id
   --     and aia.invoice_id = aipa.invoice_id
        and gjh.je_category = 'Payments'
        and aca.doc_sequence_value = '1226'

    
           and xah.gl_transfer_status_code = 'Y'

          ;
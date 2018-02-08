

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
            IPC_GET_AP_CHECK_INVOICES(aca.check_id) reference,
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
--        INNER JOIN ap_invoice_payments_all aipa
--            ON aipa.check_id = aca.check_id
--        INNER JOIN ap_invoices_all aia
--            ON aia.invoice_id = aipa.invoice_id      
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
;
order by  xal.ae_line_num;


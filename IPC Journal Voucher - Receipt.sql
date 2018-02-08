SELECT 
            glcc.segment6 account_no,
            DECODE(glcc.segment6,'-',
                          glcc.segment6,
                          gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,6,segment6)) account_name,
            DECODE(glcc.segment2,'-',
                          glcc.segment2,
                          gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,2,segment2)) cost_center,
            DECODE(glcc.segment3,'-',
                          glcc.segment3,
                          gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,3,segment3)) employee,
            DECODE(glcc.segment7,'-',
                          glcc.segment7,
                          gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,2,segment7)) model, 
            DECODE(glcc.segment4,'-',
                          glcc.segment4,
                          gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,4,segment4)) budget_acount,  
            DECODE(glcc.segment5,'-',
                          glcc.segment5,
                          gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,5,segment5)) budget_cost_center,  
            xal.entered_cr,
            xal.entered_dr,
            acra.receipt_number reference,
            xal.description,
            acra.doc_sequence_value,
            gjh.doc_sequence_value voucher_no
FROM    apps.ar_cash_receipts_all acra 
            LEFT JOIN xla.xla_transaction_entities xte
                ON NVL(xte.source_id_int_1, -99) = acra.cash_receipt_id
            LEFT JOIN xla.xla_ae_headers xah
                ON xte.entity_id = xah.entity_id
            LEFT JOIN xla.xla_ae_lines xal
                ON xte.application_id = xal.application_id
                AND xal.ae_header_id = xah.ae_header_id
                AND xal.application_id = xah.application_id
            LEFT JOIN apps.gl_code_combinations glcc
                ON xal.code_combination_id = glcc.code_combination_id
            LEFT JOIN apps.gl_import_references gir
                ON xal.gl_sl_link_id = gir.gl_sl_link_id
                AND xal.gl_sl_link_table = gir.gl_sl_link_table
            LEFT JOIN  apps.gl_je_lines gjl
                ON gir.je_header_id = gjl.je_header_id
                AND gir.je_line_num = gjl.je_line_num
            LEFT JOIN apps.gl_je_headers gjh
                ON gjl.je_header_id = gjh.je_header_id
WHERE 1 = 1
            AND xte.entity_code = 'RECEIPTS'
            AND xal.ae_header_id IS NOT NULL
            AND acra.cash_receipt_id between :p_start_receipt_id AND :p_end_receipt_id
ORDER BY acra.doc_sequence_value;

select *
from ar_Cash_receipts_all
where doc_sequence_value = '96';
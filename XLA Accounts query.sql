select gjh.doc_sequence_value gl_voucher_no,
         gjl.je_line_num,
         xal.ae_line_num,
         xah.accounting_date,
         xah.period_name,
         xal.description,
         xal.entered_cr,
         xal.entered_dr,
         xal.accounted_cr,
         xal.accounted_dr,
         gcc.segment6 account_no,
         xah.je_category_name,
         xah.gl_transfer_date,
         xah.gl_transfer_status_code
from xla_ae_headers xah 
        LEFT JOIN xla_ae_lines xal
            ON xal.ae_header_id = xah.ae_header_id
            AND xal.application_id = xah.application_id
        LEFT JOIN gl_code_combinations gcc
            ON gcc.code_combination_id = xal.code_combination_id
        LEFT JOIN apps.gl_import_references gir
            ON gir.gl_sl_link_id = xal.gl_sl_link_id
            AND gir.gl_sl_link_table = xal.gl_sl_link_table
        LEFT JOIN apps.gl_je_lines gjl
            ON gjl.je_header_id = gir.je_header_id
            AND gjl.je_line_num = gir.je_line_num
        LEFT JOIN apps.gl_je_headers gjh         
            ON gjh.je_header_id = gjl.je_header_id
                    LEFT  JOIN xla.xla_transaction_entities xte
            ON xah.entity_id = xte.entity_id
            AND xte.application_id = xal.application_id
where 1 = 1
        and gcc.segment6 = '89911'
        and xah.accounting_date between '01-JAN-2017' AND '30-JUN-2017'
     --   and GL_TRANSFER_STATUS_CODE = 'N'
      ;  -- and xah.ae_header_id = 9187947;
select *
from (
(select distinct
            gjh.doc_sequence_value voucher_no,
            gjh.je_source,
            gjh.je_category je_category_name,
            gjh.default_effective_date,
            gjh.posted_date,
            gjh.status,
            null xla_line_number,
            gjl.je_line_num gl_line_number,
            null accounting_date,
            null gl_transfer_status_code,
            null gl_transfer_date,
            null doc_sequence_value,
            gcc.segment1,
            gcc.segment2,
            gcc.segment3,
            gcc.segment4,
            gcc.segment5,
            gcc.segment6,
            gcc.segment7,
            gcc.segment8,
            gcc.segment9,
            gjh.description header_description,
            gjl.description line_description,

            gjh.period_name,
            gjl.entered_dr,
            gjl.entered_cr,
            gjl.accounted_dr,
            gjl.accounted_cr,
            null unrounded_entered_dr,
            null unrounded_entered_cr,
            null unrounded_accounted_dr,
            null unrounded_accounted_cr,
            null currency_code,
            null currency_conversion_date,
            null currency_conversion_rate,
            null product_rule_code
           
from gl_je_headers gjh,
         gl_je_lines gjl,
         gl_je_categories gjc,
         gl_code_combinations_kfv gcc
where 1 = 1
            and gjh.je_header_id = gjl.je_header_id
            and gcc.code_combination_id = gjl.code_combination_id
            and gjc.je_category_name = gjh.je_category
            and gjh.je_source = 'Manual'
            and gjh.default_effective_date between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
             and gcc.segment6 between NVL(:P_ACCOUNT_CODE_FROM,gcc.segment6) AND NVL(:P_ACCOUNT_CODE_TO,gcc.segment6) )

    UNION
     (select distinct 
            gjh.doc_sequence_value voucher_no,
            null je_source,
            xah.je_category_name,
            gjh.default_effective_date,
            gjh.posted_date,
            gjh.status,
            xdl.ae_line_num xla_line_number,
            gjl.je_line_num gl_line_number,
            xah.accounting_date,
            xah.gl_transfer_status_code,
            xah.gl_transfer_date,
            xah.doc_sequence_value,
            gcc.segment1,
            gcc.segment2,
            gcc.segment3,
            gcc.segment4,
            gcc.segment5,
            gcc.segment6,
            gcc.segment7,
            gcc.segment8,
            gcc.segment9,
            xah.description header_description,
            xal.description line_description,
            xah.period_name,
            xal.entered_dr,
            xal.entered_cr,
            xal.accounted_dr,
            xal.accounted_cr,
            xdl.unrounded_entered_dr,
            xdl.unrounded_entered_cr,
            xdl.unrounded_accounted_dr,
            xdl.unrounded_accounted_cr,
            xal.currency_code,
            xal.currency_conversion_date,
            xal.currency_conversion_rate,
            xah.product_rule_code
        
from 
     
        xla_ae_headers xah 
        INNER JOIN xla_ae_lines xal
            ON xah.ae_header_id = xal.ae_header_id
        INNER JOIN xla_distribution_links xdl
            ON  xal.ae_header_id = xdl.ae_header_id
            AND xal.ae_line_num = xdl.ae_line_num
        INNER JOIN gl_code_combinations gcc
            ON xal.code_combination_id = gcc.code_combination_id
        -- GL
        LEFT JOIN apps.gl_import_references gir
            ON gir.gl_sl_link_id = xal.gl_sl_link_id
            AND gir.gl_sl_link_table = xal.gl_sl_link_table
        LEFT JOIN apps.gl_je_lines gjl
            ON gjl.je_header_id = gir.je_header_id
            AND gjl.je_line_num = gir.je_line_num
        LEFT JOIN apps.gl_je_headers gjh         
            ON gjh.je_header_id = gjl.je_header_id
where 1 = 1
        and xah.accounting_date between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
        and gcc.segment6 between NVL(:P_ACCOUNT_CODE_FROM,gcc.segment6) AND NVL(:P_ACCOUNT_CODE_TO,gcc.segment6))
);
        
        
select *
from gl_je_headers;

select 
      CASE 
            WHEN je_category_name = 'Adjustment' THEN trim(REGEXP_SUBSTR (header_description, '[^-]+', 1,3))
            WHEN je_category_name = 'Debit Memos' THEN trim(REGEXP_SUBSTR (header_description, '[^-]+', 1,5))
            WHEN je_category_name = 'Sales Invoices' THEN trim(REGEXP_SUBSTR (header_description, '[^-]+', 1,7))
            WHEN je_category_name = 'Receipts' THEN substr(header_description,INSTR(header_description, 'Document Number - ') + 18, 11)
            WHEN je_category_name = 'Credit Memos' THEN TRIM(NVL(REGEXP_SUBSTR (header_description, '[^-]+', 1,5),REGEXP_SUBSTR (header_description, '[^-]+', 1,4)))
      END transaction_reference,
      gl_xla_data.*
from (
(select 
            gjh.doc_sequence_value voucher_no,
            gjh.je_source,
            gjh.je_category je_category_name,
            gjh.default_effective_date,
            gjh.posted_date,
            gjh.status,
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
            nvl(gjl.entered_dr,0) - nvl(gjl.entered_cr,0) entered_amount,
            gjl.accounted_dr,
            gjl.accounted_cr,
            nvl(gjl.accounted_dr,0) - nvl(gjl.accounted_cr,0) accounted_amount,
            null currency_code,
            null currency_conversion_date,
            null currency_conversion_rate,
            null product_rule_code,
            gjl.attribute1 supplier_id,
            NVL(gjl.attribute2,aps.vendor_name) one_time_merchant_name,
            NVL(gjl.attribute3,aps.vat_registration_num) tin,
            gjl.attribute4 address,
            gjl.attribute5 vat_code,
            gjl.attribute6 wht_tax_code,
            gjl.attribute10 employee_id,
            gjl.attribute7 qty,
            gjl.attribute8 lot_no,
            gjl.attribute9 model
from gl_je_headers gjh INNER JOIN gl_je_lines gjl
            ON  gjh.je_header_id = gjl.je_header_id
         INNER JOIN gl_je_categories gjc
            ON gjc.je_category_name = gjh.je_category
         INNER JOIN gl_code_combinations_kfv gcc
             ON gcc.code_combination_id = gjl.code_combination_id
         LEFT JOIN ap_suppliers aps
             ON aps.segment1 = gjl.attribute1
where 1 = 1
            and gjh.default_effective_date between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
            AND nvl(gjl.accounted_dr,0) - nvl(gjl.accounted_cr,0) <> 0 
            and gcc.segment6 IN ('66904','63000')
--            AND gjh.je_source = 'Receivables'
            )

    UNION
     (select  
            gjh.doc_sequence_value voucher_no,
            null je_source,
            xah.je_category_name,
            gjh.default_effective_date,
            gjh.posted_date,
            gjh.status,
--            xdl.ae_line_num xla_line_number,
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
            nvl(xal.entered_dr,0) - nvl(xal.entered_cr,0) entered_amount,
            xal.accounted_dr,
            xal.accounted_cr,
            nvl(xal.accounted_dr,0) - nvl(xal.accounted_cr,0) accounted_amount,
            xal.currency_code,
            xal.currency_conversion_date,
            xal.currency_conversion_rate,
            xah.product_rule_code,
            gjl.attribute1 supplier_id,
            NVL(gjl.attribute2,aps.vendor_name) one_time_merchant_name,
            NVL(gjl.attribute3,aps.vat_registration_num) tin,
            gjl.attribute4 address,
            gjl.attribute5 vat_code,
            gjl.attribute6 wht_tax_code,
            gjl.attribute10 employee_id,
            gjl.attribute7 qty,
            gjl.attribute8 lot_no,
            gjl.attribute9 model
from 
        xla_ae_headers xah 
        INNER JOIN xla_ae_lines xal
            ON xah.ae_header_id = xal.ae_header_id
            AND xal.application_id = xah.application_id
        INNER JOIN gl_code_combinations gcc
            ON xal.code_combination_id = gcc.code_combination_id
        LEFT JOIN apps.gl_import_references gir
            ON gir.gl_sl_link_id = xal.gl_sl_link_id
            AND gir.gl_sl_link_table = xal.gl_sl_link_table
        LEFT JOIN apps.gl_je_lines gjl
            ON gjl.je_header_id = gir.je_header_id
            AND gjl.je_line_num = gir.je_line_num
        LEFT JOIN apps.gl_je_headers gjh         
            ON gjh.je_header_id = gjl.je_header_id
        LEFT JOIN ap_suppliers aps
                ON aps.segment1 = gjl.attribute1
where 1 = 1
        and xah.gl_transfer_status_code = 'N'
        and xah.accounting_date between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
        and gcc.segment6 IN ('63000','66904')
        and nvl(xal.accounted_dr,0) - nvl(xal.accounted_cr,0) <> 0
        )      
) gl_xla_data;
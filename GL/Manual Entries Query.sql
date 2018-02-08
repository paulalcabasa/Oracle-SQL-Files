select 
            gjh.doc_sequence_value voucher_no,
            gjh.je_source,
            gjh.je_category je_category_name,
            gjh.default_effective_date,
            gjh.posted_date,
            gjh.status,
            gjl.je_line_num gl_line_number,
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
from gl_je_headers gjh LEFT JOIN gl_je_lines gjl
            ON  gjh.je_header_id = gjl.je_header_id
         LEFT JOIN gl_je_categories gjc
            ON gjc.je_category_name = gjh.je_category
         LEFT JOIN gl_code_combinations_kfv gcc
             ON gcc.code_combination_id = gjl.code_combination_id
         LEFT JOIN ap_suppliers aps
             ON aps.segment1 = gjl.attribute1
where 1 = 1
           AND gjh.je_source <> 'Payables'
--            and   TO_DATE(TO_CHAR (gjh.default_effective_date,'MON-YY'),'MON-YY') BETWEEN    TO_DATE (:P_PERIOD,
--                                                           'MM-YY')
--                                              AND TO_DATE (:P_PERIOD2,
--                                                           'MM-YY')
            AND gjh.default_effective_date between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
            AND gcc.segment6 IN ('82000','83300')
         --   AND gcc.segment6 between NVL(:P_ACCOUNT_CODE_FROM,gcc.segment6) AND NVL(:P_ACCOUNT_CODE_TO,gcc.segment6)
      --      AND nvl(gjl.accounted_dr,0) - nvl(gjl.accounted_cr,0) <> 0 
--             and GJH.status = 'P'
;
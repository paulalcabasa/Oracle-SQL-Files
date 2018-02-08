select *
from (
            (       
                SELECT 
--                            gjh.period_name,
--                            gcc.segment6 account_no,
--                            gjh.je_source,
--                            gjh.je_category je_category_name,
--                            gjl.accounted_dr,
--                            gjl.accounted_cr,
--                            NVL(gjl.accounted_dr,0) - NVL(gjl.accounted_cr,0) accounted_amount
                            gjh.doc_sequence_value voucher_no,
                            gjh.je_source,
                            gjh.je_category je_category_name,
                            gjh.default_effective_date,
                            gjh.posted_date,
                            gjh.status,
                --            null xla_line_number,
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
                FROM gl_je_headers gjh 
                            INNER JOIN gl_je_lines gjl
                                ON  gjh.je_header_id = gjl.je_header_id
                            INNER JOIN gl_je_categories gjc
                                ON gjc.je_category_name = gjh.je_category
                            INNER JOIN gl_code_combinations gcc
                                ON gcc.code_combination_id = gjl.code_combination_id
                            LEFT JOIN ap_suppliers aps
                                ON aps.segment1 = gjl.attribute1
                WHERE 1 = 1
                          AND TO_DATE(TO_CHAR (gjh.default_effective_date,'MON-YY'),'MM-YY') 
                            BETWEEN  
                            TO_DATE (NVL(:P_PERIOD_FROM,TO_DATE(TO_CHAR (gjh.default_effective_date,'MON-YY'),'MON-YY')), 'MM-YY')
                           -- TO_DATE (:P_PERIOD_FROM,'MM-YY')
                            AND TO_DATE (:P_PERIOD_TO, 'MM-YY')
                           AND gjh.creation_date <= TO_DATE (:P_AS_OF, 'yyyy/mm/dd hh24:mi:ss')
                          --  AND gjh.default_effective_date BETWEEN  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
                            AND gcc.segment6 BETWEEN NVL(:P_ACCOUNT_CODE_FROM,gcc.segment6) AND NVL(:P_ACCOUNT_CODE_TO,gcc.segment6)
                            AND NVL(gjl.accounted_dr,0) - NVL(gjl.accounted_cr,0) <> 0 
                            --and GJH.status = 'P'
            )

            UNION ALL
            (
                SELECT  
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
            --            xdl.unrounded_entered_dr,
            --            xdl.unrounded_entered_cr,
            --            xdl.unrounded_accounted_dr,
            --            xdl.unrounded_accounted_cr,
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
                FROM 
                    xla_ae_headers xah 
                    INNER JOIN xla_ae_lines xal
                        ON xah.ae_header_id = xal.ae_header_id
                        AND xal.application_id = xah.application_id
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
                    LEFT JOIN ap_suppliers aps
                            ON aps.segment1 = gjl.attribute1
                WHERE 1 = 1
                    AND xah.gl_transfer_status_code = 'N'
                    AND xah.creation_date <=  TO_DATE (:P_AS_OF, 'yyyy/mm/dd hh24:mi:ss')
            --    and xah.doc_sequence_value = '70100007716'
               --     AND xah.accounting_date BETWEEN  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
                    AND TO_DATE(TO_CHAR (xah.accounting_date,'MON-YY'),'MM-YY') 
                    BETWEEN    --TO_DATE (NVL(:P_PERIOD_FROM,TO_DATE(TO_CHAR (xah.accounting_date,'MON-YY'),'MON-YY')),'MM-YY')
                               TO_DATE(:P_PERIOD_FROM,'MM-YY')
                             AND TO_DATE (:P_PERIOD_TO,'MM-YY')
                    AND gcc.segment6 between NVL(:P_ACCOUNT_CODE_FROM,gcc.segment6) AND NVL(:P_ACCOUNT_CODE_TO,gcc.segment6)
                    AND nvl(xal.accounted_dr,0) - nvl(xal.accounted_cr,0) <> 0
                )      
);



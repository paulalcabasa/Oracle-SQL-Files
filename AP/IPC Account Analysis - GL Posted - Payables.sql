SELECT   
            trim(REGEXP_SUBSTR (gjh.description, '[^,]+', 1, 1))    AS invoice_status,
           
              gjh.doc_sequence_value voucher_no,
               gjh.je_header_id,
               gjl.je_line_num,
               gjh.je_category,
               gjh.je_source,
               gjh.period_name,
               gjh.name ,
               gjh.status,
               TO_CHAR (gjh.default_effective_date) effective_date,
               gjh.posted_date,
               aps_invoice.vendor_name supplier_name,
               CASE 
                    WHEN TRIM(REGEXP_SUBSTR (gjh.description, '[^,]+', 1, 1)) IN ('Prepayment Cancelled','Prepayment Applied','Prepayment Unapplied','Credit Memo Validated','Invoice Validated','Credit Memo Cancelled','Invoice Cancelled','Prepayment Validated')  
                    THEN (TRIM(SUBSTR(REGEXP_SUBSTR (gjh.description, '[^,]+', 1, 2),18)))
                    ELSE NULL
               END AS invoice_number,
               CASE 
                    WHEN TRIM(REGEXP_SUBSTR (gjh.description, '[^,]+', 1, 1))  IN ('Prepayment Cancelled','Prepayment Applied','Prepayment Unapplied','Credit Memo Validated','Invoice Validated','Credit Memo Cancelled','Invoice Cancelled','Prepayment Validated')  
                    THEN (TRIM(SUBSTR(REGEXP_SUBSTR (gjh.description, '[^,]+', 1, 3),8)))
                    ELSE NULL
               END AS invoice_date,
               CASE 
                    WHEN TRIM(REGEXP_SUBSTR (gjh.description, '[^,]+', 1, 1))  IN ('Prepayment Cancelled','Prepayment Applied','Prepayment Unapplied','Credit Memo Validated','Invoice Validated','Credit Memo Cancelled','Invoice Cancelled','Prepayment Validated')  
                    THEN TO_NUMBER(TRIM(SUBSTR(REGEXP_SUBSTR (gjh.description, '[^,]+', 1, 6),26)))
                    ELSE NULL
               END AS apv_no,
                CASE 
                    WHEN trim(REGEXP_SUBSTR (gjh.description, '[^,]+', 1, 1)) IN ('Payment Created','Refund Recorded','Payment Cancelled') 
                    THEN TO_NUMBER(TRIM(SUBSTR(REGEXP_SUBSTR (gjh.description, '[^,]+', 1, 3),36)))
                    ELSE NULL
                END check_voucher_no,
               gjh.description,
--               gjh.running_total_accounted_dr,
--               gjh.running_total_accounted_cr,
               gjl.code_combination_id,
               gcc.segment1 AS "Company",
               gcc.segment2 AS "Cost Center",
               gcc.segment3 AS "ID",
               gcc.segment4 AS "Budget Account",
               gcc.segment5 AS "Budget Cost Center",
               gcc.segment6 AS "Account",
               gcc.segment7 AS "Model",
               gcc.segment8 AS "Projects",
               gcc.segment9 AS "Future",
               gjl.entered_dr,
               gjl.entered_cr,
               gjl.accounted_dr,
               gjl.accounted_cr,
               gjl.description,
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
                ON gjh.je_header_id = gjl.je_header_id
           INNER JOIN gl_code_combinations gcc
                ON gcc.code_combination_id = gjl.code_combination_id
           LEFT JOIN ap_suppliers aps
                ON aps.segment1 = gjl.attribute1
           LEFT JOIN ap_invoices_all aia
                ON aia.doc_sequence_value = (CASE 
                                                                        WHEN TRIM(REGEXP_SUBSTR (gjh.description, '[^,]+', 1, 1))  IN ('Prepayment Cancelled','Prepayment Applied','Prepayment Unapplied','Prepayment Validated','Credit Memo Validated','Invoice Validated','Credit Memo Cancelled','Invoice Cancelled')  
                                                                        THEN SUBSTR(REGEXP_SUBSTR (gjh.description, '[^,]+', 1, 6),26)
                                                                        ELSE NULL
                                                                   END)
           LEFT JOIN ap_suppliers aps_invoice
                ON aps_invoice.vendor_id = aia.vendor_id
WHERE 1 = 1
   --   and gjh.je_header_id = 1065680
--            and gjh.doc_sequence_value = '83069959'
--              and  gjh.name  like '%14161584%' REFUND AND INVOICE PAYMENT
--              and  gjh.name  like '%14091836%'
--      and  gjh.name  like '%14132884%'
--and       trim(REGEXP_SUBSTR (gjh.description, '[^,]+', 1, 1)) = 'Prepayment Validated'
             AND gjh.je_source = 'Payables'
             AND TO_DATE(TO_CHAR (gjh.default_effective_date,'MON-YY'),'MON-YY') BETWEEN
                     TO_DATE (:P_PERIOD,
                                                           'MM-YY')
                                              AND TO_DATE (:P_PERIOD2,
                                                           'MM-YY')
           AND gcc.segment6 BETWEEN NVL (:P_ACCOUNT_CODE_FROM, gcc.segment6)
                            AND NVL (:P_ACCOUNT_CODE_TO, gcc.segment6)
 order by 16;

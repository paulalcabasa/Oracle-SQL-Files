select supplier_no,
         --  invoice_id,
           supplier_name,
           to_char(invoice_num) invoice_num,
           TO_CHAR(due_date) due_date,
           cut_off,
           days,
           CASE
                WHEN days <= 0 THEN 'Current'
                WHEN days BETWEEN 1 AND 30 THEN '1-30 days'
                WHEN days BETWEEN 31 AND 60 THEN '31-60 days'
                WHEN days BETWEEN 61 AND 90 THEN '61-90 days'
                WHEN days > 90 THEN 'Over 90 days'
           END aging,
           to_number(invoice_amount) invoice_amount,
           to_number(payable_amount) payable_amount,
           liability_account
from (SELECT aps.segment1 supplier_no,
                       aps.vendor_name supplier_name,
                       aia.invoice_num,
                       TO_DATE(aia.terms_date + atl.due_days) due_date,
                       TO_CHAR(TO_DATE(:p_cut_off,'YYYY/MM/DD HH24:MI:SS'),'DD-MON-YYYY') cut_off,
                       TO_DATE(:p_cut_off,'YYYY/MM/DD HH24:MI:SS') - TO_DATE(aia.terms_date + atl.due_days)  days,
                       aia.invoice_amount,
                       SUM(aila.amount) payable_amount,
                       gcc.segment6 liability_account,
                       aia.invoice_id
            FROM ap_invoices_all aia
                    INNER JOIN ap_suppliers aps
                        ON aps.vendor_id = aia.vendor_id
                    INNER JOIN ap_terms_tl apt 
                        ON apt.term_id = aia.terms_id 
                    INNER JOIN ap_terms_lines atl 
                        ON atl.term_id = apt.term_id
                    INNER JOIN ap_invoice_lines_all aila
                        ON aila.invoice_id = aia.invoice_id 
                    INNER JOIN gl_code_combinations gcc
                        ON gcc.code_combination_id = aia.accts_pay_code_combination_id
                    INNER JOIN ap_payment_schedules_all apsa
                        ON apsa.invoice_id = aia.invoice_id
                    LEFT JOIN ap_invoice_payments_all aipa
                        ON aipa.invoice_id = aia.invoice_id
                    LEFT JOIN (SELECT * FROM ap_checks_all aca WHERE aca.check_date  <= to_date(:P_AS_OF, 'YYYY/MM/DD HH24:MI:SS')) aca
                        ON aca.check_id = aipa.check_id
            WHERE 1 = 1
                         AND aia.cancelled_date IS NULL
                         and aca.check_id IS NULL
--                         AND apsa.payment_status_flag = 'N'
--                         AND (nvl(apsa.amount_remaining, 0) * nvl(aia.exchange_rate,1))  != 0
--                         AND aia.doc_sequence_value = '20029562'
            GROUP BY aps.segment1,
                               aps.vendor_name,
                               aia.invoice_num,
                               aia.terms_date,
                               atl.due_days,
                               :p_cut_off,
                               aia.invoice_amount,
                               gcc.segment6,
                               aia.invoice_id
)
where 1 =1
and liability_account = NVL(:p_liability_account,liability_account)
        ;
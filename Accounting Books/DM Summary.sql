select org_id,
         name,
         dm_date,
         regexp_replace(to_char(dm_date, 'Month'),'[[:space:]]+') DM_Month,
         to_char(dm_date, 'YYYY') DM_Year,
         invoice_currency_code,
         invoice_no,   
         voucher_number,
         customer_name,
         particulars,
         gross_amount,
         max(decode(transaction_type, 'Debit Memo', decode(account_code,'35500', acctd_amount, null))) "35500",
         max(decode(transaction_type, 'Debit Memo', decode(account_code,'38100', acctd_amount, null))) "38100",
         max(decode(transaction_type, 'Debit Memo', decode(account_code,'41600', acctd_amount, null))) "41600",
         max(decode(transaction_type, 'Debit Memo', decode(account_code,'41800', acctd_amount, null))) "41800",
         max(decode(transaction_type, 'Debit Memo', decode(account_code,'63000', acctd_amount, null))) "63000",
         max(decode(transaction_type, 'Debit Memo', decode(account_code,'66901', acctd_amount, null))) "66901",
         max(decode(transaction_type, 'Debit Memo', decode(account_code,'66904', acctd_amount, null))) "66904",
         max(decode(transaction_type, 'Debit Memo', decode(account_code,'67502', acctd_amount, null))) "67502",
         max(decode(transaction_type, 'Debit Memo', decode(account_code,'85500', acctd_amount, null))) "85500",
         max(decode(transaction_type, 'Debit Memo', decode(account_code,'88300', acctd_amount, null))) "88300"
from (select distinct rcta.org_id,
                   haou.name,
                   rcta.trx_date dm_date,
                   apsa.invoice_currency_code,
                   rcta.trx_number invoice_no,
                   gl.doc_sequence_value voucher_number, 
                   ar.customer_name,                   
                   rctla.description particulars,
                   apsa.amount_due_original gross_amount,
                   gcc.segment6 account_code,
                   rctld.acctd_amount,
                   rctta.name transaction_type
           from ra_customer_trx_all rcta,
                   ra_customer_trx_lines_all rctla,
                   ar_payment_schedules_all apsa,
                   ra_cust_trx_line_gl_dist_all rctld,
                   gl_code_combinations gcc,
                   ra_cust_trx_types_all rctta,
                   ar_customers ar,
                   hr_all_organization_units haou,
                   (select gjh.je_header_id, 
                              gjh.doc_sequence_value,
                              gjl.code_combination_id, 
                              gjl.reference_6
                      from gl_je_headers gjh,
                              gl_je_lines gjl
                   where gjh.je_header_id = gjl.je_header_id) gl
            where rcta.customer_trx_id = apsa.customer_trx_id 
            and rcta.customer_trx_id = rctla.customer_trx_id 
            and rcta.customer_trx_id = rctld.customer_trx_id
            and rcta.cust_trx_type_id = rctta.cust_trx_type_id
            and rcta.bill_to_customer_id = ar.customer_id
            and rctld.code_combination_id = gcc.code_combination_id
            and rcta.org_id = haou.organization_id
            and rctld.event_id = gl.reference_6
            and rctld.code_combination_id = gl.code_combination_id
            and rctta.name = 'Debit Memo'
            and rcta.complete_flag = 'Y'
           -- and rcta.previous_customer_trx_id is null
            and rctla.line_type = 'LINE' )
where 1 = 1 
-- invoice_no = nvl(:p_invoice_no, invoice_no)
--and regexp_replace(to_char(dm_date, 'Month'),'[[:space:]]+') = nvl(:p_month, regexp_replace(to_char(dm_date, 'Month'),'[[:space:]]+'))
--and to_char(dm_date, 'YYYY') = :p_year
and dm_date BETWEEN :P_START AND :P_END
group by org_id, name, invoice_currency_code, invoice_no, dm_date, voucher_number, customer_name, particulars, gross_amount
order by org_id, invoice_no, dm_date
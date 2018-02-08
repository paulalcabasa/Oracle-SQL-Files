select trx_date,
           invoice_currency_code,
           invoice_no,
           gl_voucher,
           particulars,
           customer_name,
           gross_amount,
            sum(acct_35500) acct_35500,
            sum(acct_38100) acct_38100,
            sum(acct_41600) acct_41600,
            sum(acct_41800) acct_41800,
            sum(acct_63000) acct_63000,
            sum(acct_66901) acct_66901,
            sum(acct_66904) acct_66904,
            sum(acct_67502) acct_67502,
            sum(acct_85500) acct_85500,
            sum(acct_88300) acct_88300
from (SELECT rcta.trx_date,
            apsa.invoice_currency_code,
            rcta.trx_number invoice_no,
            IPC_GET_CM_GL_REF(rcta.customer_trx_id) gl_voucher,
            (select  LISTAGG(description, ', ') WITHIN GROUP (ORDER BY description ASC)   
             from ra_customer_trx_lines_all 
             where customer_trx_id = rcta.customer_trx_id
                        and line_type = 'LINE') particulars,
            cust.customer_name,
            apsa.amount_due_original gross_amount,
            (DECODE(gcc.segment6,'35500', rctld.acctd_amount, 0)) acct_35500,
            (DECODE(gcc.segment6,'38100', rctld.acctd_amount, 0)) acct_38100,
            (DECODE(gcc.segment6,'41600', rctld.acctd_amount, 0)) acct_41600,
            (DECODE(gcc.segment6,'41800', rctld.acctd_amount, 0)) acct_41800,
            (DECODE(gcc.segment6,'63000', rctld.acctd_amount, 0)) acct_63000,
            (DECODE(gcc.segment6,'66901', rctld.acctd_amount, 0)) acct_66901,
            (DECODE(gcc.segment6,'66904', rctld.acctd_amount, 0)) acct_66904,
            (DECODE(gcc.segment6,'67502', rctld.acctd_amount, 0)) acct_67502,
            (DECODE(gcc.segment6,'85500', rctld.acctd_amount, 0)) acct_85500,
            (DECODE(gcc.segment6,'88300', rctld.acctd_amount, 0)) acct_88300
FROM ra_customer_trx_all rcta
        INNER JOIN ra_cust_trx_types_all rctta
            ON rcta.cust_trx_type_id = rctta.cust_trx_type_id
            AND rcta.org_id = rctta.org_id
        INNER JOIN ra_customer_trx_lines_all rctla
            ON rctla.customer_trx_id = rcta.customer_trx_id
            and rctla.line_type = 'LINE'
        LEFT JOIN ar_payment_schedules_all apsa
            ON apsa.customer_trx_id = rcta.customer_trx_id
        INNER JOIN ar_customers cust
            ON rcta.bill_to_customer_id = cust.customer_id
        LEFT JOIN ra_cust_trx_line_gl_dist_all rctld 
            ON rctld.customer_trx_id = rctla.customer_trx_id
        INNER JOIN gl_code_combinations gcc
            ON gcc.code_combination_id = rctld.code_combination_id
WHERE 1 = 1
--             AND rctta.name = 'Billing Statement'
            AND rcta.cust_trx_type_id = 1080
--             AND rcta.complete_flag = 'Y'
           -- AND regexp_replace(to_char(rcta.trx_date, 'Month'),'[[:space:]]+') = nvl(:p_month, regexp_replace(to_char(rcta.trx_date, 'Month'),'[[:space:]]+'))
       --     AND to_char(rcta.trx_date, 'YYYY') = nvl(:p_year,to_char(rcta.trx_date, 'YYYY'))
         --   AND rcta.trx_number = NVL(:p_invoice_no,rcta.trx_number)
         AND trunc(rcta.trx_date) between :p_start and :p_end
--             AND TO_DATE(rcta.trx_date) between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
GROUP BY
            rcta.trx_date,
            apsa.invoice_currency_code,
            rcta.trx_number,
            rcta.customer_trx_id,
            rcta.doc_sequence_value,
            cust.customer_name,
            gcc.segment6,
            rctld.acctd_amount,
            apsa.amount_due_original,
            rctta.cust_trx_type_id
             )
GROUP BY trx_date,
           invoice_currency_code,
           invoice_no,
           gl_voucher,
           particulars,
           customer_name,
           gross_amount;
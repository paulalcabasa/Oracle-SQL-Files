SELECT *
FROM (
        SELECT 
                     acra.receipt_number,
                     rcta.trx_number,
                     acra.receipt_date,
                     rcta.trx_date,
                     acra.doc_sequence_value,
                     apsa.amount_due_original invoice_amount,
                     apsa.amount_due_remaining balance,
                     round((apsa.amount_due_original / 1.12) * 0.01,2) wtx,
                     round(apsa.amount_due_remaining,2) - round((apsa.amount_due_original / 1.12) * 0.01,2) balance_less_wtx
        FROM ra_customer_trx_all rcta
                    INNER JOIN ar_receivable_applications_all araa
                        ON rcta.customer_trx_id = araa.applied_customer_trx_id
                    INNER JOIN ar_cash_receipts_all acra
                        ON acra.cash_receipt_id = araa.cash_receipt_id
                    INNER JOIN ar_payment_schedules_all apsa
                         ON apsa.customer_trx_id = araa.applied_customer_trx_id
        where 1 = 1
)
WHERE balance_less_wtx > 0;
            
            select *
            from ar_payment_schedules_all;
            
select MAX(CONCURRENT_PROGRAM_NAME)
from fnd_concurrent_programs_VL
where CONCURRENT_PROGRAM_NAME like '%IPC_RPT%'  
AND CONCURRENT_PROGRAM_NAME NOT IN ('IPC_RPT_MOD_CHK');
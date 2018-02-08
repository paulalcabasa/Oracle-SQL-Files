select *
from ra_customer_trx_all
where interface_header_attribute1 = '3010004846';

SELECT *
FROM RA_CUSTOMER_TRX_ALL
WHERE TRX_NUMBER = '1931';

select ifs_rec_head.series_id, 
         ifs_rec_head.payment_id,
         ifs_rec_head.pay_date,
         ifs_rec_head.voucher_date,
         ifs_rec_head.voucher_no,
         ifs_rec_head.payment_type_code,
         ifs_rec_head.payment_type_code_db,
         ifs_rec_head.payment_rollback_status,
         ifs_rec_head.short_name,
         ifs_pay.curr_amount ifs_receipt_amount,
         ora_rec.receipt_number,
         ora_rec.amount oracle_receipt_amount,
         ifs_rec_lines.ledger_item_id,
         ifs_rec_lines.curr_amount IFS_AMOUNT_APPLIED,
         rcta.trx_number,
         ora_app.amount_applied ORACLE_AMOUNT_APPLIED
from IFSAPP.INTER_PAYMENT@IFS_ORACLE.ISUZU.LOCAL ifs_rec_head,
        IFSAPP.PAYMENT_PER_CURRENCY@IFS_ORACLE.ISUZU.LOCAL ifs_pay,
        ar_cash_receipts_all ora_rec,
        IFSAPP.INTERCOMPANY_TRANSACTION_QRY@IFS_ORACLE.ISUZU.LOCAL ifs_rec_lines,
        AR_RECEIVABLE_APPLICATIONS_ALL ora_app,
        RA_CUSTOMER_TRX_ALL rcta
where 1 = 1
          and ifs_pay.payment_id = ifs_rec_head.payment_id
          and to_char(ifs_pay.payment_id(+)) =  to_char(ora_rec.receipt_number)
          and ifs_rec_lines.payment_id = ifs_rec_head.payment_id
          and ora_app.cash_receipt_id = ora_rec.cash_receipt_id
          and rcta.customer_trx_id = ora_app.applied_customer_trx_id(+)
          and ifs_rec_lines.ledger_item_id(+) = rcta.trx_number
          and ifs_rec_head.pay_date BETWEEN '01-JAN-2017' AND '01-JAN-2017'
          and ifs_rec_head.series_id = 'ORREF'
     --     and ifs_pay.payment_id = '60169'
order by ifs_rec_head.payment_id,
             ifs_rec_head.pay_date
          ;--payment_id = '62931';

select *
from IFSAPP.INTERCOMPANY_TRANSACTION_QRY@IFS_ORACLE.ISUZU.LOCAL
where payment_id = '62931';

select *
from IFSAPP.PAYMENT_PER_CURRENCY@IFS_ORACLE.ISUZU.LOCAL;

select *
from ar_cash_receipts_all ;`
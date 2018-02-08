/********  QUERY FOR RECEIPTS WITH COMPLETELY APPLIED AMOUNT *****/
select acra.receipt_number,
            acra.doc_sequence_value,
            party.party_name customer_name,
            cust.account_number,
            cust.account_name,
            site_uses.location,
            acra.amount - sum(arra.amount_applied) unapplied_amount,
            sum(arra.amount_applied) applied_amount,
            acra.amount receipt_amount,
            acra.receipt_date
from ar_cash_receipts_all acra 
        LEFT JOIN ar_receivable_applications_all arra
            ON arra.cash_receipt_id = acra.cash_receipt_id
            AND arra.display = 'Y' 
        LEFT JOIN  HZ_CUST_SITE_USES_ALL SITE_USES
            ON SITE_USES.SITE_USE_ID = ACRA.CUSTOMER_SITE_USE_ID
        LEFT JOIN HZ_CUST_ACCOUNTS CUST
            ON ACRA.PAY_FROM_CUSTOMER = CUST.CUST_ACCOUNT_ID
        LEFT JOIN HZ_PARTIES PARTY
            ON CUST.PARTY_ID = PARTY.PARTY_ID
where 1 = 1
           and acra.status <> 'REV'
           and TO_DATE(acra.receipt_date) BETWEEN TO_DATE(:p_receipt_date_from,'YYYY/MM/DD hh24:mi:ss') AND TO_DATE(:p_receipt_date_to,'YYYY/MM/DD hh24:mi:ss')
group by acra.RECEIPT_NUMBER,
                acra.amount,
                acra.receipt_date,
                party.party_name,
                cust.account_number,
                cust.account_name,
                site_uses.location,
                acra.doc_sequence_value
having sum(arra.amount_applied) <> acra.amount;   

select DISTINCT STATUS
from ar_cash_receipts_all;
/********  QUERY FOR RECEIPTS WITH PENDING APPLICATIONS  *****/

select acra.RECEIPT_NUMBER,
         acra.amount,
         acra.receipt_date,
         sum(arra.amount_applied) applied_amount,
         acra.amount - sum(arra.amount_applied) unapplied_amount
from ar_cash_receipts_all acra,
        AR_RECEIVABLE_APPLICATIONS_ALL arra
where 1 = 1
          and arra.cash_receipt_id = acra.cash_receipt_id(+)
          and arra.display = 'Y' 
   --       and acra.amount <> 0
     --     and acra.receipt_date BETWEEN  '01-FEB-2017' and '28-FEB-2017'
group by acra.RECEIPT_NUMBER,
         acra.amount,
         acra.receipt_date
having sum(arra.amount_applied) <> acra.amount;

/***** QUERY FOR RECEIPTS WITH APPLICATION *****/

select rcta.trx_number,
         rcta.comments ifs_invoice,
         acra.receipt_number,
         arra.amount_applied,
         (select sum(extended_amount) 
         from ra_customer_trx_lines_all
         where customer_trx_id = rcta.customer_trx_id) invoice_amount
from ra_customer_trx_all rcta,
        ar_receivable_applications_all arra,
        ar_cash_receipts_all acra
where 1 = 1
          and rcta.customer_trx_id = arra.APPLIED_CUSTOMER_TRX_ID(+)
          and acra.cash_receipt_id = arra.cash_receipt_id;
 
/****** QUERY FOR CHECKING *******/

select trx_number,
comments
from ra_customer_trx_all
where trx_number in ('40300000023','40300000024','40300000574');

SELECT *
FROM IPC_PARTS_DBS;

SELECT *
FROM ALL_TAb_COLUMNS
WHERE TABLE_NAME LIKE '%DBS%';

SELECT *
FROM XXIPC_DBS_ONHAND;

select trx_number,
comments
from ra_customer_trx_all
where COMMENTS   in ('980238983',
'980238981',
'980238977',
'980238975',
'980238866');


/******* IFS ORACLE QUERY *******/
SELECT pt.payment_id,
            to_char(pt.pay_date) pay_date,
            pt.accounting_year,
            pt.voucher_type,
            pt.voucher_no,
            pt.payment_rollback_status,
            pay_amt_details.short_name,
            pay_amt_details.currency,
            pay_amt_details.curr_amount
FROM payment_tab@IFS_ORACLE.ISUZU.LOCAL pt,
          payment_per_currency_tab@IFS_ORACLE.ISUZU.LOCAL pay_amt_details
WHERE 1 = 1
            and pay_amt_details.payment_id = pt.payment_id
        --    and pt.pay_date between :start_date and :end_date
       and pt.payment_id IN (60138)
            and pt.series_id = 'ORREF'
ORDER BY pt.pay_date ASC; 



select pay_header.series_id,
         pay_header.payment_id,
         pay_header.pay_date,
         pay_header.payment_rollback_status,
         pay_amt_details.curr_amount,
         pay_amt_details.currency,
         pay_amt_details.short_name,
         pay_lines.ledger_item_id invoice_no,
         pay_lines.currency,
         pay_lines.rolledback,
         pay_lines.note,
         pay_lines.identity,
         pay_lines.ledger_item_series_id,
         pay_lines.ledger_item_id,
         pay_lines.wht_curr_amt,
         rcta.trx_number,
         acra.receipt_number,
        pay_lines.curr_amount ifs_amount_applied,
        araa.amount_applied oralce_applied_amount
from payment_tab@IFS_ORACLE.ISUZU.LOCAL pay_header,
        payment_transaction_tab@IFS_ORACLE.ISUZU.LOCAL pay_lines,
        payment_per_currency_tab@IFS_ORACLE.ISUZU.LOCAL pay_amt_details,
        ra_customer_trx_all rcta,
        ar_receivable_applications_all araa,
        ar_cash_receipts_all acra
where 1 = 1
          and pay_header.payment_id = pay_lines.payment_id
          and pay_amt_details.payment_id = pay_header.payment_id
          and pay_header.series_id = 'ORREF'
       --  and pay_date between '01-JAN-2017' and '30-JAN-2017'
          and pay_lines.rowtype = 'LedgerTransaction'
          and rcta.customer_trx_id = araa.applied_customer_trx_id(+)
          and acra.cash_receipt_id(+) = araa.cash_receipt_id
          and pay_lines.ledger_item_id = rcta.comments(+)
          and pay_header.payment_id in(60235,
60267,
60270,
59557,
60347,
60334,
60335,
60333,
60237,
60221,
59578,
59744,
60115,
60170,
60169,
59411,
59853,
60030,
59721,
59526,
60369,
59834,
60291,
59919,
59413,
59346,
60405,
60399,
60397,
60396,
60376,
60375,
60367,
60366,
60362,
60352,
60343,
60305,
60276,
60275,
60268,
60240,
60238,
60177,
60174,
60162,
60138,
60119,
60118,
60111,
60110,
60052,
60045,
60041,
59968,
59921,
59904,
59858,
59835,
59799,
59770,
59769,
59735,
59734,
59598,
59550,
59483,
59455,
59415)
       --  and rcta.trx_number = '40300001567'
            -- pay_lines.ledger_item_id = rcta.trx_number)
            -- and pay_lines.ledger_item_series_id = 'CD'
;


/************** COUNT LOADED RECEIPTS ********************/

select   to_char(acra.RECEIPT_NUMBER) receipt_number,
            acra.amount,
            to_char(acra.receipt_date) receipt_date,
            cba.bank_account_name,
            rec_method.name receipt_method,
            acra.type receipt_type,
            acra.doc_sequence_value,
            sum(arra.amount_applied) applied_amount,
            acra.amount - sum(arra.amount_applied) unapplied_amount
from ar_cash_receipts_all acra,
        CE_BANK_ACCT_USES_ALL remit_bank,
        CE_BANK_ACCOUNTS cba,
        AR_RECEIPT_METHODS REC_METHOD,
        AR_RECEIVABLE_APPLICATIONS_ALL arra
where 1 = 1
        and REMIT_BANK.BANK_ACCT_USE_ID = ACRA.REMIT_BANK_ACCT_USE_ID
        and CBA.BANK_ACCOUNT_ID(+) = REMIT_BANK.BANK_ACCOUNT_ID
        and ACRA.RECEIPT_METHOD_ID = REC_METHOD.RECEIPT_METHOD_ID
        and arra.cash_receipt_id = acra.cash_receipt_id(+)
        and arra.display = 'Y' 
        
 --       and rec_method.name IN ('COLLECTION RECEIPT')
   --     and acra.type = 'CASH'
    --    and acra.receipt_date BETWEEN  '01-JAN-2017' and '31-JAN-2017'
        and acra.amount <> 0
group by  acra.RECEIPT_NUMBER,
            acra.amount,
            acra.receipt_date,
            cba.bank_account_name,
            rec_method.name,
            acra.type,
            acra.doc_sequence_value
HAVING acra.amount - sum(arra.amount_applied) > 0
ORDER BY acra.receipt_number DESC;




/**** unapp******/

SELECT *
FROM XXIPC_IFS_BANKS_LOOKUP;




select RECEIPT_NUMBER, status
from ar_cash_receipts_all
where 1 = 1
          AND RECEIPT_DATE BETWEEN '01-JUN-2017' AND '30-JUN-2017'
   ;
          
          
          select *
          from ra_customer_trx_all rcta
          where (select sum(extended_amount)
                    from ra_customer_trx_lines
                    where customer_trx_id = rcta.customer_trx_id) ='1166.59';
                    
                    
                    select comments
                    from ra_customer_trx_all
                    where trx_number = '40300001567';
                    
                    select trx_number
                    from ra_customer_trx_all
                    where comments = '980240731';
                    
                    select *
                    from ra_customer_trx_all
                    where attribute1 = '1980';
                    
                    
/************* IFS RECEIPTS HEADER QUERY ***************/

SELECT pt.payment_id,
            to_char(pt.pay_date) pay_date,
            pt.accounting_year,
            pt.voucher_type,
            pt.voucher_no,
            pt.payment_rollback_status,
            pay_amt_details.short_name,
            pay_amt_details.currency,
            pay_amt_details.curr_amount,
--            (select distinct note
--            from payment_transaction_tab@IFS_ORACLE.ISUZU.LOCAL
--            where payment_id = pt.payment_id) note,
            (SELECT distinct LISTAGG(note, ' , ') WITHIN GROUP (ORDER BY note)
            FROM (select distinct payment_id,note from payment_transaction_tab@IFS_ORACLE.ISUZU.LOCAL)
            where payment_id = pt.payment_id
            GROUP BY payment_id) check_no,
            ifs_bank.*
FROM payment_tab@IFS_ORACLE.ISUZU.LOCAL pt,
          payment_per_currency_tab@IFS_ORACLE.ISUZU.LOCAL pay_amt_details,
          XXIPC_IFS_BANKS_LOOKUP ifs_bank
WHERE 1 = 1
            and pay_amt_details.payment_id = pt.payment_id
       --     and pt.pay_date between '01-JAN-2017' AND '30-JUL-2017'
            and ifs_bank.lookup_code = pay_amt_details.short_name
     --       and pt.payment_rollback_status = 'NOTROLLEDBACK'
  --     and pt.payment_id IN (61175)
      
            and pt.series_id = 'ORREF'
     
           and to_char(pt.payment_id) NOT IN (select to_char(RECEIPT_NUMBER)
                                                    from ar_cash_receipts_all
                                                    where receipt_date between '01-JAN-2017' AND '05-JAN-2017'
                                                           and receipt_number not in ('060917-001','060917-002')
                                                        )
ORDER BY pt.payment_id,pt.pay_date ASC;

SELECT *
FROM RA_CUSTOMER_TRX_ALL
WHERE ATTRIBUTE1 = '980239396';

select receipt_number,
         to_char(receipt_date)
from ar_cash_receipts_all
order by receipt_date asc;

select RECEIPT_NUMBER
                                                    from ar_cash_receipts_all
                                                    where receipt_date between '01-JUN-2017' AND '30-JUN-2017'
                                                    order by receipt_number desc;

select RECEIPT_NUMBER
                                                    from ar_cash_receipts_all
                                                    where receipt_date between '01-JUN-2017' AND '30-JUN-2017';

select 
from payment_transaction_tab;

select *
from payment_per_currency_tab
where curr_amount = '43094.42';



select pay_header.series_id,
         pay_header.payment_id,
         pay_header.pay_date,
         pay_header.payment_rollback_status,
         pay_amt_details.curr_amount,
         pay_amt_details.currency,
         pay_amt_details.short_name,
         pay_lines.ledger_item_id invoice_no,
         pay_lines.curr_amount amount_applied,
         pay_lines.currency,
         pay_lines.rolledback,
         pay_lines.note,
         pay_lines.identity,
         pay_lines.ledger_item_series_id,
         pay_lines.ledger_item_id,
         pay_lines.wht_curr_amt
from payment_tab@IFS_ORACLE.ISUZU.LOCAL pay_header,
        payment_transaction_tab@IFS_ORACLE.ISUZU.LOCAL pay_lines,
        payment_per_currency_tab@IFS_ORACLE.ISUZU.LOCAL pay_amt_details
where 1 = 1
        and pay_header.payment_id = pay_lines.payment_id
        and pay_amt_details.payment_id = pay_header.payment_id
   --     and pay_date between '01-JAN-2017' and '30-JAN-2017'
        and pay_lines.rowtype = 'LedgerTransaction'
        and pay_lines.ledger_item_id = '1029'
--          and pay_lines.ledger_item_series_id = 'CD'
    
         and pay_header.series_id = 'ORREF'
    ---    and pay_lines.curr_amount ='14929.46';
   ;
   
   SELECT *
   FROM payment_transaction_tab
   where ledger_item_id = '2010006003';
   
   SELECT *
   FROM payment_tab@IFS_ORACLE.ISUZU.LOCAL
   WHERE PAYMENT_ID = 59799;
   
select acra.receipt_number,
         acra.amount,
         cust.customer_id,
         cust.name,
         site.group_id
         
from ar_cash_receipts_all acra,
        payment_transaction_tab@IFS_ORACLE.ISUZU.LOCAL ptt,
        CUSTOMER_info_tab@IFS_ORACLE.ISUZU.LOCAL cust,
        IFSAPP.IDENTITY_INVOICE_INFO@IFS_ORACLE.ISUZU.LOCAL site
where 1 = 1
         and ptt.payment_id = acra.receipt_number
         and site.identity =cust.customer_id
         and acra.amount <> 0
         and ptt.identity = cust.customer_id
         and ptt.rowtype = 'LedgerTransaction'
         and acra.status in ('UNID')
          and ptt.trans_id = 0
    ;  --      and acra.receipt_number = '61719';
             
             
             
   SELECT ptt.payment_id,
               cust.customer_id,
               cust.name,
               ptt.*
   FROM payment_transaction_tab@IFS_ORACLE.ISUZU.LOCAL ptt,
            CUSTOMER_info_tab@IFS_ORACLE.ISUZU.LOCAL cust
   WHERE PAYMENT_ID = 59799
                AND rowtype = 'LedgerTransaction'
                and ptt.identity = cust.customer_id
                and trans_id = (select min(trans_id) from payment_transaction_tab@IFS_ORACLE.ISUZU.LOCAL 
                                        where payment_id = 59799)
                                        and identity = 'D502';
   
select *
from CUSTOMER_info_tab@IFS_ORACLE.ISUZU.LOCAL
where customer_id = 'P501';

SELECT *
FROM IFSAPP.IDENTITY_INVOICE_INFO@IFS_ORACLE.ISUZU.LOCAL
WHERE IDENTITY = 'P501';



select *
from payment_transaction_tab
where payment_id = '60169';

select *
from IFSAPP.INTERCOMPANY_TRANSACTION_QRY
where payment_id = '60114';

select *
from payment_transaction_tab
where ledger_item_id = '980240010';
select *
from payment_transaction_tab;
 --it,
          payment_transaction_tab lt,
          ledger_item_tab li
          
          --  
         
          SELECT cs_no,dealer_code,payer,pullout
          FROM VEHICLE_MASTER_TAB
          WHERE CS_NO IN ('CR7557');
          
          SELECT Cs_no,dealer_code
          FROM CUSTOMER_MASTER_TAB;
          
          select *
          fro
          
          
          
select identity, party_type, invoice_id, invoice_no, series_id, currency,
gross_curr_amount, net_curr_amount, invoice_date, state
from man_supp_invoice
where invoice_date between '01-MAY-2017' AND '31-APR-2017'
AND PARTY_TYPE = 'Supplier';


/*********************** RECEIPT HEADER *****************************/
select *
from payment_per_currency_tab;

SELECT TO_CHAR(pt.payment_id) receipt_number,
             TO_CHAR(pt.pay_date) pay_date,
             pt.voucher_no,
             pt.payment_rollback_status,
             ppct.curr_amount,
             ppct.short_name
        --   ppct.*
FROM payment_tab pt,
          payment_per_currency_tab ppct
WHERE 1 = 1
            and pt.pay_date between '01-MAY-2017' AND '31-MAY-2017'
            and pt.payment_id = ppct.payment_id
            and pt.series_id = 'ORREF'
ORDER BY pt.payment_id ASC;


SELECT *
FROM XXIPC_AR_INVOICE_TEMP;



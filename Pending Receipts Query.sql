select acra.receipt_number,
            acra.doc_sequence_value,
            party.party_name customer_name,
            cust.account_number,
            cust.account_name,
            site_uses.location,
            CASE 
                WHEN acra.status = 'UNID' THEN acra.amount
                ELSE 0
            END unidentified_amount,
            acra.amount - sum(arra.amount_applied * nvl(arra.trans_to_receipt_rate,1)) unapplied_amount,
            sum(arra.amount_applied * nvl(arra.trans_to_receipt_rate,1)) applied_amount,
            acra.amount receipt_amount,
            acra.receipt_date,
            DECODE(acra.status,'UNID','Unidentified','UNAPP','Unapplied') status
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
          and acra.status IN ('UNID','UNAPP')
          and TO_DATE(acra.receipt_date) BETWEEN TO_DATE(:p_receipt_date_from,'YYYY/MM/DD hh24:mi:ss') AND TO_DATE(:p_receipt_date_to,'YYYY/MM/DD hh24:mi:ss')
group by acra.RECEIPT_NUMBER,
                acra.amount,
                acra.receipt_date,
                party.party_name,
                cust.account_number,
                cust.account_name,
                site_uses.location,
                acra.doc_sequence_value,
                acra.status 
;

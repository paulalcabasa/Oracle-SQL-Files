select acra.receipt_number,
           acra.type receipt_type,
           acra.doc_sequence_value,
            hp.party_name ||  CASE WHEN hca.account_name IS NOT NULL THEN ' - ' || hca.account_name ELSE NULL END customer_name,
           acra.receipt_date,
           acra.amount receipt_amount,
           rcta.trx_number invoice_no,
           araa.amount_applied,
           araa.apply_date           
from ar_cash_receipts_all acra 
         INNER JOIN ar_receivable_applications_all araa
            ON acra.cash_receipt_id = araa.cash_receipt_id
            AND araa.display = 'Y'
         INNER JOIN ra_customer_trx_all rcta
            ON rcta.customer_trx_id = araa.applied_customer_trx_id
         INNER JOIN hz_cust_accounts_all hca
            ON hca.cust_account_id = acra.pay_from_customer
          INNER JOIN hz_parties hp
            ON hp.party_id = hca.party_id
WHERE 1 = 1;
--             and acra.receipt_date between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
--             and acra.status <> 'REV'
--             and acra.TYPE = 'CASH';
  
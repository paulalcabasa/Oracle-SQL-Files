SELECT to_char(acra.receipt_number) receipt_number,
            acra.amount receipt_amount,
            acra.doc_sequence_value,
            to_char(acra.receipt_date,'DD-MON-YYYY') or_date,
            NVL(party.party_name,ACRA.MISC_PAYMENT_SOURCE) payee,
            ARPT_SQL_FUNC_UTIL.get_lookup_meaning ('CHECK_STATUS', ACRA.STATUS) status,
            to_char(nvl(apsa.gl_date,APRHA.gl_date),'DD-MON-YYYY') gl_date,
            to_char(acra.creation_date,'DD-MON-YYYY') creation_date,
            fu.description created_by
FROM ar_cash_receipts_all acra 
           LEFT JOIN hz_cust_accounts cust
                ON acra.pay_from_customer = cust.cust_account_id
           LEFT JOIN hz_cust_site_uses_all site_uses 
                ON site_uses.site_use_id = acra.customer_site_use_id
           LEFT JOIN hz_parties party
                ON cust.party_id = party.party_id
           LEFT JOIN ar_payment_schedules_all apsa
                ON apsa.cash_receipt_id = acra.cash_receipt_id
           LEFT JOIN AR_CASH_RECEIPT_HISTORY_ALL APRHA
                ON aprha.cash_receipt_id = acra.cash_receipt_id
                AND aprha.current_record_flag = 'Y'
           LEFT JOIN fnd_user fu
                ON fu.user_id = acra.created_by
WHERE 1 = 1
            AND TO_DATE(acra.receipt_date) between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
ORDER BY acra.doc_sequence_value;
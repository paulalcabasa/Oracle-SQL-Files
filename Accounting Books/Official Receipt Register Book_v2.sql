SELECT to_char(nvl(apsa.gl_date,aprha.gl_date),'DD/MM/YYYY') voucher_date,
            to_char(acra.doc_sequence_value) document_number,
            NVL(party.party_name,ACRA.MISC_PAYMENT_SOURCE) || ' ' ||
            CASE WHEN cust.account_name IS NOT NULL THEN ' - ' || cust.account_name END payee,
            site_uses.tax_reference,
            hl.address1 || ' ' || hl.address2 || ' ' || hl.address3 || ' ' || hl.address4 || ' ' || hl.city address,
            acra.receipt_number,
            acra.amount receipt_amount,
            acra.attribute2 customer_check_reference,
            bb.bank_name,
            acra.currency_code
   --         ARPT_SQL_FUNC_UTIL.get_lookup_meaning ('CHECK_STATUS', ACRA.STATUS) status -- REMOVED 01/11/2017 BY PAUL
FROM ar_cash_receipts_all acra 
           LEFT JOIN hz_cust_accounts cust
                ON acra.pay_from_customer = cust.cust_account_id
           LEFT JOIN hz_cust_site_uses_all site_uses 
                ON site_uses.site_use_id = acra.customer_site_use_id
           LEFT JOIN hz_cust_acct_sites_all hcasa
                ON hcasa.cust_acct_site_id = site_uses.cust_acct_site_id
           LEFT JOIN hz_party_sites hps
                ON hps.party_site_id = hcasa.party_site_id 
           LEFT JOIN hz_locations hl
                ON hl.location_id = hps.location_id
           LEFT JOIN hz_parties party
                ON cust.party_id = party.party_id
           LEFT JOIN ar_payment_schedules_all apsa
                ON apsa.cash_receipt_id = acra.cash_receipt_id
           LEFT JOIN ar_cash_receipt_history_all aprha
                ON aprha.cash_receipt_id = acra.cash_receipt_id
           LEFT JOIN fnd_user fu
                ON fu.user_id = acra.created_by
           LEFT JOIN ce_bank_acct_uses_all remit_bank
                ON remit_bank.bank_acct_use_id = acra.remit_bank_acct_use_id
           LEFT JOIN ce_bank_accounts cba
                ON  cba.bank_account_id = remit_bank.bank_account_id
           LEFT JOIN ce_bank_branches_v bb 
                ON bb.branch_party_id = cba.bank_branch_id
WHERE 1 = 1
            AND TO_DATE(aprha.gl_date) between  TO_DATE (:P_DATEFROM, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (NVL(:P_DATETO,SYSDATE), 'yyyy/mm/dd hh24:mi:ss');
           
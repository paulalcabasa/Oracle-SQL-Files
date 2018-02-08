-- deposit summary correct
select  
         acra.cash_receipt_id,
         rec_method.name receipt_method,
         acra.receipt_number,
         acra.currency_code,
         acra.amount,
         acra.type,
         acrha.status state,
         to_char(acra.receipt_date, 'MM/DD/YYYY') receipt_date,
         acra.attribute1 dff_customer_bank,
         acra.attribute2 dff_check_number,
         acra.attribute3 dff_check_date,
         acrha.gl_date,
         apsa.due_date,
         acrha.acctd_amount functional_amount,
         acra.doc_sequence_value,
         acra.deposit_date,
         nvl(party.party_name,acra.misc_payment_source) payer_name,
         cust.account_number,
         cust.account_name,
         site_uses.location,
         bb.bank_name,
         bb.bank_branch_name,
         cba.bank_account_name,
         cba.bank_account_num,
         apsa.gl_date payment_gl_date
      
from ar_cash_receipts_all acra
        LEFT JOIN ar_cash_receipt_history_all acrha
            ON acra.cash_receipt_id = acrha.cash_receipt_id
        LEFT JOIN ar_payment_schedules_all apsa
            ON apsa.cash_receipt_id = acra.cash_receipt_id
        LEFT JOIN ar_receipt_methods rec_method
            ON acra.receipt_method_id = rec_method.receipt_method_id
        LEFT JOIN ar_receipt_classes arc
            ON arc.receipt_class_id = rec_method.receipt_class_id
        LEFT JOIN hz_cust_accounts cust
            ON acra.pay_from_customer = cust.cust_account_id
        LEFT JOIN hz_parties party
            ON cust.party_id = party.party_id
        LEFT JOIN hz_cust_site_uses_all site_uses
            ON site_uses.site_use_id = acra.customer_site_use_id
        LEFT JOIN ce_bank_acct_uses_all remit_bank
            ON remit_bank.bank_acct_use_id = acra.remit_bank_acct_use_id
        LEFT JOIN ce_bank_accounts cba
            ON cba.bank_account_id = remit_bank.bank_account_id
        LEFT JOIN ce_bank_branches_v bb
            ON bb.branch_party_id = cba.bank_branch_id
where  1 = 1
           and acra.status <> 'REV'
          -- and acra.receipt_number = '4360'
           and acra.receipt_date between to_date (:p_start_date, 'yyyy/mm/dd hh24:mi:ss') and to_date (:p_end_date, 'yyyy/mm/dd hh24:mi:ss');
          
          
              
          

-- RECEIPT DATA WITH MATCHED INVOICES
SELECT -- RECEIPT DATA \
            bank_acct.cash_ccid,
            acra.status,
            rec_method.name receipt_method,
            acra.receipt_number,
            acra.currency_code,
            acra.amount,
            to_char(acra.receipt_date) receipt_date,
            to_char(apsa.gl_date) receipt_gl_date,
            acrha.acctd_amount functional_amount,
            acra.doc_sequence_value receipt_document,
            -- DFF
            acra.attribute1 customer_bank,
            acra.attribute2 check_number,
            acra.attribute3 check_date,
            acra.status receipt_status,
            -- CUSTOMER
            cust.account_name customer_account,
            party.party_name customer_name,
            site_uses.location customer_site,
            cust.account_number customer_account_number,
            -- REMITTANCE BANK
            bb.bank_name,
            bb.bank_branch_name,
            cba.bank_account_name,
            cba.bank_account_num,
            -- APPLICATIONS
            rcta.trx_number applied_invoice,
            rcta.comments invoice_comments,
            rcta.attribute1 invoice_attr1,
            rcta.attribute3 invoice_attr2,
            araa.amount_applied,
            to_char(araa.apply_date) apply_date,
            to_char(araa.gl_date) gl_date
            
            
FROM   ar_cash_receipts_all acra,
            ar_receivable_applications_all araa,
            ra_customer_trx_all rcta,
            ar_payment_schedules_all apsa,
            ar_cash_receipt_history_all acrha,
            -- RECEIPT CUSTOMER
            hz_cust_accounts cust,
            hz_parties party,
            hz_cust_site_uses_all site_uses,
            -- REMITTANCE BANK
            ce_bank_acct_uses_all remit_bank,
            ce_bank_accounts cba,
            ce_bank_branches_v bb,
            -- LOOKUPS
            ar_receipt_methods rec_method,
            ar_receipt_classes arc,
            gl_code_combinations gcc,
            ipc_bank_account_segments bank_acct
WHERE 1 = 1
            and araa.cash_receipt_id = acra.cash_receipt_id
            and rcta.customer_trx_id = araa.applied_customer_trx_id(+)
            and apsa.cash_receipt_id = acra.cash_receipt_id
            and acra.cash_receipt_id = acrha.cash_receipt_id
            -- RECEIPT CUSTOMER
            and acra.pay_from_customer = cust.cust_account_id(+)
            and site_uses.site_use_id(+) = acra.customer_site_use_id
            and cust.party_id = party.party_id(+)
            -- REMITTANCE BANK
            and remit_bank.bank_acct_use_id = acra.remit_bank_acct_use_id
            and cba.bank_account_id(+) = remit_bank.bank_account_id
            and bb.branch_party_id = cba.bank_branch_id
            -- LOOKUPS
            and acra.receipt_method_id = rec_method.receipt_method_id
            and arc.receipt_class_id = rec_method.receipt_class_id
            and gcc.code_combination_id = araa.code_combination_id
            and bank_acct.remit_bank_acct_use_id = acra.remit_bank_acct_use_id
            and bank_acct.receipt_method_id = acra.receipt_method_id
            -- FILTERS
     --     and rcta.trx_number = '40300006035'
--            and acra.doc_sequence_value = '70100000557'
            and araa.display = 'Y'
        --    and acra.status = 'APP'
            and acra.receipt_date BETWEEN '01-JAN-2017' AND '31-JUL-2017' 
     --      and bb.bank_branch_name like '%BPI%'
      --      and acra.receipt_number = '66956';
      ;
CREATE OR REPLACE VIEW IPC_BANK_ACCOUNT_SEGMENTS AS
select arma.remit_bank_acct_use_id,
            arma.receipt_method_id,
            cash.segment6 cash_ccid,
            unapplied.segment6 unapplied_ccid,
            unidentified.segment6 unidentified_ccid,
            on_account.segment6 on_account_ccid
from ar_receipt_method_accounts_all arma,
         gl_code_combinations cash,
         gl_code_combinations unapplied,
         gl_code_combinations unidentified,
         gl_code_combinations on_account
where 1 = 1
            and cash.code_combination_id = arma.cash_ccid
            and unapplied.code_combination_id = arma.unapplied_ccid
            and unidentified.code_combination_id = arma.unidentified_ccid
            and on_account.code_combination_id = arma.on_account_ccid
            ;

COMMIT;
-- RECEIPT DATA (HEADERS ONLY)
select acra.cash_receipt_id, 
         acra.receipt_number,
         bb.bank_name,
         bb.bank_branch_name,
         cba.bank_account_name,
         cba.bank_account_num,
         acra.amount
from  ar_cash_receipts_all acra,       
         ce_bank_accounts cba,
         ce_bank_branches_v bb,
         ce_bank_acct_uses_all remit_bank
where 1 = 1 and remit_bank.bank_acct_use_id = acra.remit_bank_acct_use_id
            and cba.bank_account_id(+) = remit_bank.bank_account_id
            and bb.branch_party_id = cba.bank_branch_id
      --      and bb.bank_branch_name like '%BPI%'
            --  AND ACRA.CASH_RECEIPT_ID = 14002
            and acra.status IN ('UNID','UNAPP')
            and acra.receipt_date BETWEEN '01-JAN-2017' AND '30-JUN-2017' 
            order by acra.receipt_number asc;
            
            
            
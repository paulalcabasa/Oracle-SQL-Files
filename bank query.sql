/* Formatted on 2/8/2017 2:10:11 PM (QP5 v5.163.1008.3004) */
  SELECT ROWID,
         CASH_CCID,
         RECEIPT_CLEARING_CCID,
         REMITTANCE_CCID,
         SHORT_TERM_DEBT_CCID,
         BR_STD_RECEIVABLES_TRX_ID,
         FACTOR_CCID,
         BANK_CHARGES_CCID,
         UNAPPLIED_CCID,
         UNIDENTIFIED_CCID,
         ON_ACCOUNT_CCID,
         BR_REMITTANCE_CCID,
         BR_FACTOR_CCID,
         UNEDISC_RECEIVABLES_TRX_ID,
         EDISC_RECEIVABLES_TRX_ID,
         ATTRIBUTE1,
         ATTRIBUTE10,
         ATTRIBUTE11,
         ATTRIBUTE12,
         ATTRIBUTE13,
         ATTRIBUTE14,
         ATTRIBUTE15,
         ATTRIBUTE2,
         ATTRIBUTE3,
         ATTRIBUTE4,
         ATTRIBUTE5,
         ATTRIBUTE6,
         ATTRIBUTE7,
         ATTRIBUTE8,
         ATTRIBUTE9,
         ATTRIBUTE_CATEGORY,
         CREATED_BY,
         CREATION_DATE,
         LAST_UPDATED_BY,
         LAST_UPDATE_DATE,
         LAST_UPDATE_LOGIN,
         RECEIPT_METHOD_ID,
         REMIT_TRANSMISSION_PROGRAM_ID,
         REMIT_PRINT_PROGRAM_ID,
         FACTOR_TRANSMISSION_PROGRAM_ID,
         FACTOR_PRINT_PROGRAM_ID,
         REMIT_BANK_ACCT_USE_ID,
         ORG_ID,
         RISK_ELIMINATION_DAYS,
         MIN_RECEIPT_AMOUNT,
         OVERRIDE_REMIT_ACCOUNT_FLAG,
         CLEARING_DAYS,
         START_DATE,
         END_DATE,
         PRIMARY_FLAG,
         CLAIM_RECEIVABLES_TRX_ID,
         BR_COLLECTION_DAYS
    FROM AR_RECEIPT_METHOD_ACCOUNTS
   WHERE ( ('' IS NULL AND '' IS NULL)
          OR remit_bank_acct_use_id IN
                (SELECT ba.bank_acct_use_id
                   FROM ce_bank_acct_uses ba,
                        ce_bank_accounts cba,
                        ce_bank_branches_v bb
                  WHERE     bb.bank_name LIKE '%'
                        AND bb.bank_branch_name LIKE '%'
                        AND bb.bank_institution_type = 'BANK'
                        AND bb.branch_party_id = cba.bank_branch_id
                        AND cba.bank_account_id = ba.bank_account_id
                        AND cba.account_classification = 'INTERNAL'))
         AND (RECEIPT_METHOD_ID = 4000)
ORDER BY REMIT_BANK_ACCT_USE_ID;

select *
from ce_bank_branches_v;

SELECT *
FROM AR_RECEIPT_METHOD_ACCOUNTS_ALL;

SELECT *
FROM ar_receipt_methods;

SELECT *
FROM ce_bank_accounts;

select *
from ce_bank_acct_uses_all;

SELECT *
FROM ce_bank_branches_v;

select *
from CE_PAYMENT_DOCUMENTS
where internal_bank_account_id = 12003;

select
           cba.bank_account_name,
           cba.bank_account_num,
           cba.currency_code,
           cbb.bank_branch_name,
           cbb.bank_name,
           cba.bank_account_id
    
from ce_bank_accounts cba
         INNER JOIN ce_bank_branches_v cbb
            ON cbb.branch_party_id = cba.bank_branch_id
 
where 1 = 1;

select *
from ap_checks_all
where  bank_account_name = 'SBC Sta. Rosa - Current PHP';

cba.bank_account_name ='BOTM Manila -Current PHP';





SELECT  to_char(aca.check_date,'MM/DD/YYYY') check_date,
                        aca.check_number,
                        aca.doc_sequence_value,
                        aca.status_lookup_code,
                        aca.vendor_name ,
                        -- hp.party_name vendor_name,
                        -- aca.payment_method_code,
                        aca.amount,
                        --aca.bank_account_name,
                        cbb.bank_name,
                        cba.bank_account_name,
                        aca.currency_code,
                        aca.vendor_site_code,
                        aca.bank_account_num,
                        aca.party_site_id,
                        aca.party_id,
                        aca.treasury_pay_date,
                        cpb.payment_document_name,
                        aca.attribute2 or_number,
                        aca.attribute3 or_date,
                        aca.attribute4 voucher_text
                FROM ap_checks_all aca
                    INNER JOIN ce_bank_acct_uses_all banks
                        ON banks.bank_acct_use_id = aca.ce_bank_acct_use_id
                    INNER JOIN ce_bank_accounts cba
                        ON cba.bank_account_id = banks.bank_account_id
                    INNER JOIN ce_bank_branches_v cbb
                        ON cbb.branch_party_id = cba.bank_branch_id
                    INNER JOIN CE_PAYMENT_DOCUMENTS CPB
                        ON cpb.payment_document_id = aca.payment_document_id
                WHERE 1 = 1
                    AND aca.doc_sequence_value = '12'
                    AND aca.bank_account_num = '0222-025472-001';
select *
from ce_bank_accounts
   -- REMITTANCE BANK
            ce_bank_acct_uses_all remit_bank,
            ce_bank_accounts cba,
            ce_bank_branches_v bb,


      and remit_bank.bank_acct_use_id = acra.remit_bank_acct_use_id
            and cba.bank_account_id(+) = remit_bank.bank_account_id
            and bb.branch_party_id = cba.bank_branch_id
;
select IPC_DECRYPT_ORA_USR_PWD(usr.encrypted_user_password)
                        
from fnd_user usr
where usr.user_name = '151107';

select *
from IPC.IPC_PPR_HEADERS;

select *
from IPC.IPC_PPR_STATES;

SELECT *
FROM AR_RECEIPT_METHOD_ACCOUNTS_ALL;

SELECT *
FROM AR_RECEIPT_METHOD_ACCOUNTS_ALL;

select *
from AR_RECEIPT_METHOD_ACCOUNTS_ALL;
SELECT *
FROM AR_RECEIPT_CLASSES;
SELECT *
FROM ce_bank_accounts;

SELECT *
FROM AR_RECEIPT_METHOD_ACCOUNTS_ALL;
/* Formatted on 8/9/2017 2:04:51 PM (QP5 v5.163.1008.3004) */
SELECT arc.name receipt_class,
             arma.name receipt_method,
             cbb.bank_name, 
             cba.bank_account_name,
             cba.BANK_ACCOUNT_NUM,
             CBA.CURRENCY_CODE,
             gcc_cash.segment6 cash,
            gcc_unapplied.segment6 unapplied,
            gcc_unidentified.segment6   unidentified,
            gcc_on_account.segment6 on_account
  FROM AR_RECEIPT_METHOD_ACCOUNTS_ALL ARMAA
       INNER JOIN ce_bank_acct_uses_all banks
          ON banks.bank_acct_use_id = ARMAA.REMIT_BANK_ACCT_USE_ID
       INNER JOIN ce_bank_accounts cba
          ON cba.bank_account_id = banks.bank_account_id
       INNER JOIN ce_bank_branches_v cbb
          ON cbb.branch_party_id = cba.bank_branch_id
       INNER JOIN AR_RECEIPT_METHODS ARMA 
        ON arma.receipt_method_id = armaa.receipt_method_id
       INNER JOIN AR_RECEIPT_CLASSES ARC
        ON arc.receipt_class_id = arma.receipt_class_id
        INNER JOIN gl_code_combinations gcc_cash
        ON gcc_cash.code_combination_id = armaa.cash_ccid
        INNER JOIN gl_code_combinations gcc_unapplied
        ON gcc_unapplied.code_combination_id = armaa.unapplied_ccid
        INNER JOIN gl_code_combinations gcc_unidentified
        ON gcc_unidentified.code_combination_id = armaa.unidentified_ccid
        INNER JOIN gl_code_combinations gcc_on_account
        ON gcc_on_account.code_combination_id = armaa.on_account_ccid
WHERE 1 = 1
              AND armaa.end_date IS NULL
              AND arma.end_date IS NULL
ORDER BY arc.name, arma.name,cba.currency_code;
                        
                      
 
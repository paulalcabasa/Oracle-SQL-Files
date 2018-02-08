/*
    NEGOTIABLE
    VOIDED
    CLEARED BUT UNACCOUNTED
    CLEARED
    
    LOV_AP_DISB_REP_CATEGORIES
*/

SELECT to_char(aca.check_date,'MM/DD/YYYY') check_date,
            aca.check_number,
            aca.doc_sequence_value,
            aca.status_lookup_code,
             aca.vendor_name ,
--            hp.party_name vendor_name,
            aca.payment_method_code,
            aca.amount,
           --aca.bank_account_name,
           cbb.bank_name,
           cba.bank_account_name,
            aca.currency_code,
            aca.vendor_site_code,
            aca.bank_account_num,
            aca.party_site_id,
            aca.party_id,
            aca.treasury_pay_date
FROM ap_checks_all aca
-- INNER JOIN hz_parties hp
--            ON aca.party_id = hp.party_id
            INNER JOIN ce_bank_acct_uses_all banks
                ON banks.bank_acct_use_id = aca.ce_bank_acct_use_id
             INNER JOIN ce_bank_accounts cba
                ON cba.bank_account_id = banks.bank_account_id
              INNER JOIN ce_bank_branches_v cbb
            ON cbb.branch_party_id = cba.bank_branch_id
--            INNER JOIN CE_PAYMENT_DOCUMENTS CPB
--                ON cpb.payment_document_id = aca.payment_document_id
WHERE 1 = 1
            AND ACA.CHECK_NUMBER = '1200000040';
            AND to_date(aca.check_date) BETWEEN TO_DATE(:p_pay_date_from, 'YYYY/MM/DD HH24:MI:SS') AND TO_DATE(:p_pay_date_to, 'YYYY/MM/DD HH24:MI:SS') 
            AND UPPER(aca.status_lookup_code) =  
                    CASE 
                                WHEN :p_report_category IN ('Outstanding Release Checks','Unreleased Checks') THEN 'NEGOTIABLE'
                                WHEN :p_report_category = 'Cancelled Checks' THEN 'VOIDED'
                                ELSE NULL
                    END 
            AND NVL(aca.treasury_pay_date,TO_DATE('01-JAN-1951')) =  
                    CASE 
                                WHEN :p_report_category = 'Outstanding Release Checks' THEN aca.treasury_pay_date
                                WHEN :p_report_category = 'Unreleased Checks' THEN TO_DATE( '01-JAN-1951')
                                WHEN :p_report_category = 'Cancelled Checks' THEN NVL(aca.treasury_pay_date,TO_DATE('01-JAN-1951'))
                                ELSE TO_DATE( '01-JAN-1951')
                    END     
            AND  aca.payment_document_id IN (18, -- BPI-check
                                                                        22, -- SBC-check
                                                                        5 --  RCBC-check
                                                                    )
            ;
  
       SELECT TO_CHAR (TO_DATE(:P_PAY_DATE_FROM,'YYYY/MM/DD HH24:MI:SS'), 'Mon dd, yyyy') 
        FROM dual;
    
select *
from CE_PAYMENT_DOCUMENTS;
SELECT status_lookup_code,treasury_pay_date,CHECK_NUMBER
FROM AP_CHECKS_ALL ACA
WHERE  aca.check_date BETWEEN :p_pay_date_from AND :p_pay_date_to
AND status_lookup_code = 'VOIDED'
AND NVL(aca.treasury_pay_date,TO_DATE('01-JAN-1951')) = TO_DATE( '01-JAN-1951')
--and treasury_pay_date =  NULLIF(treasury_pay_date, NULL);
-- and treasury_pay_date IS  NULL
       AND  aca.payment_document_id IN (18, -- BPI-check
                                                                        22, -- SBC-check
                                                                        5 --  RCBC-check
                                                                    );
            select *
            from ap_checks_all;
                      
            SELECT *
            FROM ap_invoice_payments_all;

select *
from hz_party_sites
where party_site_id = 7036;

select *
from ar_cash_receipts_all
where receipt_number = '080903';

select sum(amount_applied)
from ar_receivable_applications_all
where cash_receipt_id = 148002
and display=  'Y';

select *
from ce_bank_acct_uses_all;

select *
from ce_banks_all;


SELCT 

select *
from ce_bank_accounts;

select *
from hz_parties
where party_id = 7214;

select*
from ap_checks_all aca;
select acra.receipt_number,
           acra.cash_receipt_id,
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
                acra.status,
acra.cash_receipt_id
;

select *
from ar_receivable_applications_all;

-- invoice as of august and payment details ( ap invoice)
-- PAYMENT DETAILS

SELECT aia.invoice_id,
            aia.invoice_num,
            aia.doc_sequence_value voucher_no,
            aia.invoice_amount,
            to_char(aia.invoice_date) invoice_date,
            to_char(aia.gl_date) invoice_gl_date,
            nvl(AP_INVOICES_PKG.GET_AMOUNT_WITHHELD (aia.INVOICE_ID),0) wht,
            DECODE(AP_INVOICES_PKG.GET_POSTING_STATUS(aia.INVOICE_ID), 'D', 'No', 'N', 'No', 'P', 'Partial', 'Y', 'Yes') accounted, 
            DECODE(APPS.AP_INVOICES_PKG.GET_APPROVAL_STATUS(aia.invoice_id, aia.invoice_amount, aia.payment_status_flag, aia.invoice_type_lookup_code), 'NEVER APPROVED', 'Never Validated', 'NEEDS REAPPROVAL', 'Needs Revalidation', 'CANCELLED', 'Cancelled', 'Validated') status, 
            aia.invoice_amount - nvl(aia.total_tax_amount,0) net,
            aia.total_tax_amount vat,
            aps.vendor_name supplier_name,
            TO_CHAR(aia.terms_date) terms_date, 
            TO_CHAR(aia.terms_date + atl.due_days) due_date,
            aca.check_number,
            aca.doc_sequence_value check_voucher_no,
            aca.bank_account_name,
            aca.amount check_amount,
            TO_CHAR(aca.check_date) payment_date,
            TO_CHAR(aipa.accounting_date) payment_gl_date,
            aipa.amount amount_paid,
            aca.status_lookup_code check_status
FROM ap_invoices_all aia 
        INNER JOIN ap_suppliers aps
            ON aps.vendor_id = aia.vendor_id
        INNER JOIN ap_terms_tl apt 
            ON apt.term_id = aia.terms_id 
        INNER JOIN ap_terms_lines atl 
            ON atl.term_id = apt.term_id
        LEFT JOIN ap_invoice_payments_all aipa
           ON aipa.invoice_id = aia.invoice_id 
        LEFT JOIN ap_checks_all aca
            ON aca.check_id = aipa.check_id
WHERE 1 = 1
            and aia.invoice_date <= '31-AUG-2017';
          --  and aipa.reversal_flag = 'N'
          --  and aca.status_lookup_code <> 'VOIDED'
         --   and aia.cancelled_date IS NULL;

select *
from ap_checks_all
where check_id = 193588;

SELECT *
FROM  ap_invoice_payments_all;

select invoice_id
from ap_invoice_payments_all
WHERE reversal_flag = 'N'
group by invoice_id
having count(invoice_id) > 1;
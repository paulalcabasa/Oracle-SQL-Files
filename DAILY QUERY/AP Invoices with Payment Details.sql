/* AP Invoices with Payment Details */

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
            and aia.invoice_date <= '19-SEP-2017';

/* AP Invoices Query */
select 
        to_char(aia.doc_sequence_value) voucher_num,
         to_char(aia.invoice_num) invoice_num,
         to_char(aia.invoice_date) invoice_date,
         to_char(aia.gl_date) gl_date,
         to_char(aia.creation_date) creation_date,
         fu_create.user_name created_by,
         fu_create.description created_by_name,
         aps.vendor_name supplier_name,
         aia.invoice_amount,
         DECODE(AP_INVOICES_PKG.GET_POSTING_STATUS(aia.INVOICE_ID),
            'D', 'No',
            'N','No',
            'P','Partial',
            'Y','Yes') accounted,       
        DECODE(APPS.AP_INVOICES_PKG.GET_APPROVAL_STATUS(
            aia.invoice_id, 
            aia.invoice_amount,
            aia.payment_status_flag,
            aia.invoice_type_lookup_code
        ),
        'NEVER APPROVED', 'Never Validated',
        'NEEDS REAPPROVAL', 'Needs Revalidation',
        'CANCELLED', 'Cancelled',
        'Validated') status,
        aia.wfapproval_status approval_status
from ap_invoices_all aia,
        ap_suppliers aps,
        fnd_user fu_create
where 1 = 1
        and fu_create.user_id(+) = aia.created_by
        and aps.vendor_id = aia.vendor_id
        and aia.gl_date <= '19-SEP-2017'
     --   AND ACA.STATUS_LOOKUP_CODE <>'VOIDED'
--        and aia.invoice_id = B.invoice_id(+)
        --and aipa.invoice_id(+) = aia.invoice_id;
        ;
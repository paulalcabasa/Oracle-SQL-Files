select  aia.doc_sequence_value,
            aia.gl_date,
            aia.creation_date,
            gcc.segment6 liability_account,
            aps.segment1 supplier_id,
            aps.vendor_name,
            aia.invoice_num,
            aia.invoice_date,
            aia.invoice_amount,
            aia.payment_currency_code payment_currency,
            nvl(aia.exchange_rate,1) currency_rate,
            aia.goods_received_date date_goods_received,
            aia.terms_date,
            apt.name terms,
            DECODE(AP_INVOICES_PKG.GET_POSTING_STATUS(aia.INVOICE_ID), 'D', 'No', 'N', 'No', 'P', 'Partial', 'Y', 'Yes') accounted,
            DECODE(APPS.AP_INVOICES_PKG.GET_APPROVAL_STATUS(aia.invoice_id, aia.invoice_amount, aia.payment_status_flag, aia.invoice_type_lookup_code), 'NEVER APPROVED', 'Never Validated', 'NEEDS REAPPROVAL', 'Needs Revalidation', 'CANCELLED', 'Cancelled', 'Validated') status, 
            aia.wfapproval_status approval_status, 
            aia.cancelled_date,
            fu.description created_by
from ap_invoices_all aia
         LEFT JOIN ap_suppliers aps
            ON aps.vendor_id = aia.vendor_id
        INNER JOIN ap_terms_tl apt 
            ON apt.term_id = aia.terms_id
        INNER JOIN fnd_user fu
            ON fu.user_id = aia.created_by     
        LEFT JOIN gl_code_combinations gcc
            ON gcc.code_combination_id = aia.accts_pay_code_combination_id   
where 1 = 1
            AND TO_DATE(aia.gl_date) between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss');
         
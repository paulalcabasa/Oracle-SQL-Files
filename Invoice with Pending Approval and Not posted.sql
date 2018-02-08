SELECT aia.doc_sequence_value voucher_num,
          TO_CHAR(aia.gl_date) gl_date,
          TO_CHAR(aia.creation_date) creation_date,
          aps.segment1 supplier_id,
          aps.vendor_name supplier_name,
          aia.invoice_num invoice_number,
          TO_CHAR(aia.invoice_date) invoice_date,
          aia.invoice_amount,
          aia.invoice_currency_code,
          aia.payment_currency_code,
          aia.exchange_rate currency_date,
          TO_CHAR(aia.goods_received_date) goods_received_date, 
          TO_CHAR(aia.terms_date + atl.due_days) due_date, 
           DECODE(AP_INVOICES_PKG.GET_POSTING_STATUS(aia.INVOICE_ID),
            'D', 'No',
            'N','No',
            'P','Partial',
            'Y','Yes') accounted,       
        DECODE(
        APPS.AP_INVOICES_PKG.GET_APPROVAL_STATUS(
            aia.invoice_id, 
            aia.invoice_amount,
            aia.payment_status_flag,
            aia.invoice_type_lookup_code
        ) ,
        'NEVER APPROVED', 'Never Validated',
        'NEEDS REAPPROVAL', 'Needs Revalidation',
        'CANCELLED', 'Cancelled',
        'Validated') status,
        aia.wfapproval_status approval_status,
        aia.cancelled_date,
        aia.created_by, 
        ppf.full_name created_by_name, 
        gcc.segment6 liability_account
from ap_invoices_all aia
            INNER JOIN ap_suppliers aps
                ON aia.vendor_id = aps.vendor_id
            INNER JOIN ap_terms_tl apt 
                ON apt.term_id = aia.terms_id 
            INNER JOIN ap_terms_lines atl 
                ON atl.term_id = apt.term_id
            INNER JOIN fnd_user fu 
                ON fu.user_id = aia.created_by 
            LEFT JOIN per_people_f ppf 
                ON ppf.employee_number = fu.user_name 
            INNER JOIN gl_code_combinations_kfv gcc 
                ON gcc.code_combination_id = aia.accts_pay_code_combination_id
where aia.cancelled_date IS NULL
                and to_date(aia.gl_date) between NVL(to_date(:start_date,'YYYY/MM/DD HH24:MI:SS'),to_date(aia.gl_date)) 
                                                                        AND NVL(to_date(:end_date,'YYYY/MM/DD HH24:MI:SS'),to_date(aia.gl_date))
            AND DECODE(AP_INVOICES_PKG.GET_POSTING_STATUS(aia.INVOICE_ID),
            'D', 'No',
            'N','No',
            'P','Partial',
            'Y','Yes') <> 'Y'
            AND DECODE(
        APPS.AP_INVOICES_PKG.GET_APPROVAL_STATUS(
            aia.invoice_id, 
            aia.invoice_amount,
            aia.payment_status_flag,
            aia.invoice_type_lookup_code
        ) ,
        'NEVER APPROVED', 'Never Validated',
        'NEEDS REAPPROVAL', 'Needs Revalidation',
        'CANCELLED', 'Cancelled',
        'Validated')  NOT IN ('Validated','Cancelled')

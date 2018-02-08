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
        and aia.GL_dATE BETWEEN  '01-JAN-2017' AND '31-JUL-2017'
     --   AND ACA.STATUS_LOOKUP_CODE <>'VOIDED'
        and aia.invoice_id = a_sel.invoice_id(+)
        --and aipa.invoice_id(+) = aia.invoice_id;
        ;
        
SELECT *
FROM (select aia.doc_sequence_value voucher_num,
          to_char(aia.gl_date) gl_date,
          to_char(aia.creation_date) creation_date,
          aps.segment1 supplier_id,
          aps.vendor_name supplier_name,
          aia.invoice_number,
          to_char(aia.invoice_date) invoice_date,
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
where aia.cancelled_date IS NULL)
WHERE status NOT IN ('Validated','Cancelled')
            AND accounted <> 'Yes';
         
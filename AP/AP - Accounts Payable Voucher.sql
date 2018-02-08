SELECT aia.doc_sequence_value apv_no,
            aia.invoice_num,
            aia.invoice_type_lookup_code type,
            aps.segment1 supplier_id,
            aps.vendor_name suplier_name,
            aia.invoice_amount amount,
            to_char(aia.invoice_date,'DD/MM/YYYY') invoice_date,
            to_char(aia.gl_date,'DD/MM/YYYY') gl_date,
            to_char(aia.creation_date,'DD/MM/YYYY') creation_date,
            aia.invoice_currency_code currency,
            nvl(aia.exchange_rate,1) rate,
            fu.description created_by,
            DECODE(APPS.AP_INVOICES_PKG.GET_APPROVAL_STATUS(aia.invoice_id, aia.invoice_amount, aia.payment_status_flag, aia.invoice_type_lookup_code),
             'NEVER APPROVED', 'Never Validated', 'NEEDS REAPPROVAL', 'Needs Revalidation', 'CANCELLED', 'Cancelled', 'Validated') status
FROM ap_invoices_all aia
           INNER JOIN ap_suppliers aps
                ON aia.vendor_id = aps.vendor_id
           INNER JOIN fnd_user fu
                ON fu.user_id = aia.created_by
WHERE 1 = 1
             and TO_DATE(aia.invoice_date) between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss');
             


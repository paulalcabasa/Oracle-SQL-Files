select aia.doc_sequence_value voucher_no,
           aia.invoice_num,
           aia.invoice_date,
           aia.gl_date,
           aps.vendor_name,
           aia.invoice_amount,
           payments.payment_method_code,
           payments.check_number,
           payments.doc_sequence_value check_document,
           payments.check_date,
           payments.amount,
           payments.accounting_date payment_gl_date,
           payments.status_lookup_code,
            DECODE(APPS.AP_INVOICES_PKG.GET_APPROVAL_STATUS(
            aia.invoice_id, 
            aia.invoice_amount,
            aia.payment_status_flag,
            aia.invoice_type_lookup_code
        ),
        'NEVER APPROVED', 'Never Validated',
        'NEEDS REAPPROVAL', 'Needs Revalidation',
        'CANCELLED', 'Cancelled',
        'Validated') status
       
--           ,
--           aipa.*,
--           aca.*
from ap_invoices_all aia
         INNER JOIN ap_suppliers aps
            ON aps.vendor_id = aia.vendor_id
         LEFT JOIN (
                            SELECT  aca.payment_method_code,
                                           aca.check_number,
                                           aca.doc_sequence_value,
                                           aca.check_date,
                                           aipa.amount,
                                           aipa.accounting_date,
                                           aca.status_lookup_code,
                                           aipa.invoice_id
                            FROM ap_invoice_payments_all aipa
                                       LEFT JOIN ap_checks_all aca
                                            ON aca.check_id = aipa.check_id
                             WHERE aca.status_lookup_code <> 'VOIDED'
        ) payments
            ON payments.invoice_id = aia.invoice_id
where 1 = 1

           ;
           
      SELECT  aca.payment_method_code,
                    aca.vendor_name check_supplier,
                                           aca.check_number,
                                           aca.doc_sequence_value check_voucher_no,
                                           aca.check_date,
                                           aipa.amount check_amount,
                                           aipa.accounting_date,
                                           aca.status_lookup_code,
                                           aipa.invoice_id,
                                            aca.attribute2 "OR Number",
                                            aca.attribute3 "OR Date",
                                            aca.attribute4 "Voucher Text",
                                            aca.treasury_pay_date released_date,
                                            aia.invoice_num,
                                            aia.doc_sequence_value invoice_voucher_no,
                                            invoice_aps.vendor_name invoice_supplier
                                                
                            FROM ap_invoice_payments_all aipa
                                       LEFT JOIN ap_checks_all aca
                                            ON aca.check_id = aipa.check_id
                                       LEFT JOIN ap_invoices_all aia
                                            ON aia.invoice_id = aipa.invoice_id
                                       LEFT JOIN ap_suppliers invoice_aps
                                            ON invoice_aps.vendor_id = aia.vendor_id
                                            
                             WHERE aca.status_lookup_code <> 'VOIDED';
                             
                             select 
                             from ap_checks_all;
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
            invoice_aps.vendor_name invoice_supplier,
            aia.invoice_amount,
            aia.gl_date,
            aia.invoice_date
                                                
FROM ap_invoice_payments_all aipa
           LEFT JOIN ap_checks_all aca
                ON aca.check_id = aipa.check_id
           LEFT JOIN ap_invoices_all aia
                ON aia.invoice_id = aipa.invoice_id
           LEFT JOIN ap_suppliers invoice_aps
                ON invoice_aps.vendor_id = aia.vendor_id
                                            
 WHERE aca.status_lookup_code <> 'VOIDED'
               AND TO_DATE(aca.check_date) between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss');
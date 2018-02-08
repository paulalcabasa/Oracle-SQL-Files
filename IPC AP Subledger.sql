select
      inv.invoice_id,
      inv.vendor_id,
      sup.segment1 as supplier_number,
      sup.vendor_name,
      inv.invoice_num,
      inv.invoice_currency_code,
      inv.payment_currency_code,
      inv.payment_cross_rate,
      inv.invoice_amount,
      inv.invoice_date,
      inv.description,
      inv.amount_applicable_to_discount,
      inv.voucher_num,
      inv.approved_amount,
      inv.doc_sequence_value,
      inv.org_id,
      inv.gl_date,
      inv.terms_date,
      inv.exchange_rate,
      (inv.exchange_rate * inv.invoice_amount) as foreign_rate 
      
from ap_invoices_all inv,
ap_suppliers sup

WHERE  AP_INVOICES_PKG.GET_APPROVAL_STATUS
                       (inv.INVOICE_ID,
                        inv.INVOICE_AMOUNT,
                        inv.PAYMENT_STATUS_FLAG,
                        inv.INVOICE_TYPE_LOOKUP_CODE
                        ) ='APPROVED' 
                        
and inv.vendor_id = sup.vendor_id  
and  inv.invoice_date between to_date(:p_invoice_start_date, 'YYYY/MM/DD HH24:MI:SS') and to_date(:p_invoice_end_date, 'YYYY/MM/DD HH24:MI:SS')
order by sup.segment1 asc;
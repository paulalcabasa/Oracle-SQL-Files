/* ORIGINAL QUERY FOR THIS REPORT*/
SELECT vendor_id, segment1 vendor_code, vendor_name, invoice_num||'''' invoice_num,doc_sequence_value, description, invoice_date, gl_date, terms_id, invoice_id, payment_num, due_date
,invoice_currency_code, po_header_id
, nvl(amount,0) amount_orig
,((nvl(amount,0) - nvl(pre_payment,0))- nvl(payment,0))*exchange_rate invoice_amount_php
,(nvl(amount,0) - nvl(pre_payment,0))- nvl(payment,0) Invoice_amount
,Approval_Status
,vendor_site_id
FROM
(
select x.vendor_id, c.segment1, c.vendor_name,x.invoice_num, x.description, x.doc_sequence_value, x.invoice_date, x.gl_date, x.terms_id,x.invoice_id, d.payment_num, d.due_date
,po_header_id
,nvl(x.exchange_rate,1) exchange_rate, x.invoice_currency_code
,(select nvl(sum(amount),0) from ap_invoice_distributions_all where invoice_id = x.invoice_id and line_type_lookup_code <> 'PREPAY' and accounting_date <= to_date(:date1,'yyyy/mm/dd hh24:mi:ss')) amount
--,nvl(d.amount_remaining,0) amount
--,(select sum(nvl(p1.amount,0)) from ap_invoice_payments_all p1 where invoice_id = x.invoice_id and p1.payment_num = d.payment_num) amount2
,(select sum(nvl(p.amount,0)) from ap_invoice_payments_all p, ap_checks_all p1 where p.invoice_id = x.invoice_id and p1.check_id = p.check_id and p1.status_lookup_code <> 'VOIDED' and p.org_id = x.org_id and p.payment_num = d.payment_num) Payment
,(select nvl(sum(amount*-1),0) from ap_invoice_distributions_all where invoice_id = x.invoice_id and line_type_lookup_code = 'PREPAY' and accounting_date <= to_date(:date1,'yyyy/mm/dd hh24:mi:ss')) pre_payment
,APPS.AP_INVOICES_PKG.GET_APPROVAL_STATUS(x.INVOICE_ID,x.INVOICE_AMOUNT,x.PAYMENT_STATUS_FLAG ,x.INVOICE_TYPE_LOOKUP_CODE) Approval_Status
, x.vendor_site_id
from ap_invoices_all x
, ap_suppliers c
, AP_PAYMENT_SCHEDULES_ALL d
where 
 c.vendor_id = x.vendor_id
--and x.org_id = :org_id1
--&lp_org_id1
--&lp_supp_group
and x.invoice_id = d.invoice_id
--and x.doc_sequence_value is not null
--and x.invoice_id in (select invoice_id from ap_invoices_all i where ap_invoices_pkg.get_posting_status (i.invoice_id) = 'Y')
--and x.invoice_id = 10143
--and x.invoice_num in ('0330428A')
and x.gl_date <= to_date(:date1,'yyyy/mm/dd hh24:mi:ss')+86399/86400
)
WHERE --APPROVAL_STATUS NOT LIKE 'CANCEL% AND 
APPROVAL_STATUS in ('APPROVED', 'UNPAID','FULL')
and (nvl(amount,0) - nvl(pre_payment,0))- nvl(payment,0) <> 0
and vendor_name between nvl(:suppler1,(select min(vendor_name) from ap_suppliers)) and nvl(:supplier2,(select max(vendor_name) from ap_suppliers))
order by vendor_name;



/* IPC Aging report, modified by Paul as of June 6, 2017 */

SELECT vendor_id, 
            segment1 vendor_code, 
            vendor_name, 
             invoice_num,
            doc_sequence_value, 
            description, 
            invoice_date, 
            gl_date, 
            terms_id, 
            invoice_id, 
            payment_num, 
            due_date,
            invoice_currency_code, po_header_id,
            nvl(amount,0) amount_orig,
            ((nvl(amount,0) - nvl(pre_payment,0))- nvl(payment,0))*exchange_rate invoice_amount_php,
            (nvl(amount,0) - nvl(pre_payment,0))- nvl(payment,0) Invoice_amount,
            Approval_Status,
            vendor_site_id
FROM
        (select x.vendor_id, 
                    c.segment1, 
                    c.vendor_name,
                    x.invoice_num,
                    x.description, 
                    x.doc_sequence_value,
                    x.invoice_date, 
                    x.gl_date, 
                    x.terms_id,
                    x.invoice_id,
                    d.payment_num, 
                    d.due_date,
                    po_header_id,
                    nvl(x.exchange_rate,1) exchange_rate, x.invoice_currency_code,
                    (select nvl(sum(amount),0) 
                    from ap_invoice_distributions_all 
                    where invoice_id = x.invoice_id 
                    and line_type_lookup_code <> 'PREPAY' 
                    and accounting_date <= to_date(:date1,'yyyy/mm/dd hh24:mi:ss')) amount,
                    (select sum(nvl(p.amount,0)) from ap_invoice_payments_all p, ap_checks_all p1 where p.invoice_id = x.invoice_id and p1.check_id = p.check_id and p1.status_lookup_code <> 'VOIDED' and p.org_id = x.org_id and p.payment_num = d.payment_num) Payment,
                    (select nvl(sum(amount*-1),0) from ap_invoice_distributions_all where invoice_id = x.invoice_id and line_type_lookup_code = 'PREPAY' and accounting_date <= to_date(:date1,'yyyy/mm/dd hh24:mi:ss')) pre_payment,
                    APPS.AP_INVOICES_PKG.GET_APPROVAL_STATUS(x.INVOICE_ID,x.INVOICE_AMOUNT,x.PAYMENT_STATUS_FLAG ,x.INVOICE_TYPE_LOOKUP_CODE) Approval_Status,
                    x.vendor_site_id
    from ap_invoices_all x, 
            ap_suppliers c, 
            AP_PAYMENT_SCHEDULES_ALL d
    where 
            c.vendor_id = x.vendor_id
            and x.invoice_id = d.invoice_id
            and x.gl_date <= to_date(:date1,'yyyy/mm/dd hh24:mi:ss')+86399/86400
    )
WHERE --APPROVAL_STATUS NOT LIKE 'CANCEL% AND 
            APPROVAL_STATUS in ('APPROVED', 'UNPAID','FULL')
            and (nvl(amount,0) - nvl(pre_payment,0))- nvl(payment,0) <> 0
            and vendor_name between nvl(:supplier1,(select min(vendor_name) from ap_suppliers)) and nvl(:supplier2,(select max(vendor_name) from ap_suppliers))
      
order by vendor_name;
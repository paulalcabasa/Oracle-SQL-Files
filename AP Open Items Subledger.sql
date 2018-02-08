select  
--            aia.invoice_amount,
--            aia.amount_paid,
----            sum(aila.amount) lines_total,
            aps.segment1 "Supplier No",
            aps.vendor_name "Supplier Name",
            aia.doc_sequence_value "AP Voucher Number",
            aia.invoice_num "Invoice Reference",
            (aia.invoice_amount - aia.amount_paid) *  nvl(aia.exchange_rate,1) "Amount",
            to_char(aia.gl_date) "GL Date",
            aia.invoice_currency_code "Currency",
            nvl(aia.exchange_rate,1) "Currency Rate",
            (aia.invoice_amount - aia.amount_paid)  "Currency Amount",
            gcc.segment6 "AP Account"
from ap_invoices_all aia,
        ap_suppliers aps,
        ap_invoice_lines_all aila,
        gl_code_combinations gcc,
        ap_payment_schedules_all apsa
where 1 = 1
         and aia.vendor_id = aps.vendor_id
         and aila.invoice_id = aia.invoice_id
         and apsa.invoice_id = aia.invoice_id
         and  apsa.payment_status_flag ='N'
        and aia.cancelled_date IS NULL
         and gcc.code_combination_id = aia.accts_pay_code_combination_id
         
         AND     (nvl(apsa.amount_remaining, 0) * nvl(aia.exchange_rate,1))  != 0
         and aia.invoice_date <= to_date(:P_AS_OF, 'YYYY/MM/DD HH24:MI:SS') 
         
         and aia.accts_pay_code_combination_id = (CASE 
                                                                                    WHEN lower(:P_AP_GROUP) = 'all' THEN aia.accts_pay_code_combination_id 
                                                                                    ELSE TO_NUMBER(:P_AP_GROUP) end
                                                                               )
group by
          aia.invoice_amount,
            aia.amount_paid,
            aps.segment1 ,
            aps.vendor_name ,
            aia.doc_sequence_value,
            aia.invoice_num,
            aia.gl_date,
            aia.invoice_currency_code,
            aia.exchange_rate,
            aia.invoice_amount,
            aia.amount_paid,
            gcc.segment6;
--having sum(aila.amount) > aia.amount_paid;
            
            
     
                                                                               

select *
from ap_invoice_lines_all;
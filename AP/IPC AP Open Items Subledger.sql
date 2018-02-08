select
            supplier_no,
            supplier_name,
            ap_voucher_no,
            invoice_number,
            (nvl(invoice_amount,0) - nvl(amount_paid,0)) *  nvl(exchange_rate,1) amount,
            gl_date,
            currency,
            currency_rate,
            invoice_amount -  nvl(amount_paid,0)  currency_amount,
            ap_account
from (select  
            aia.invoice_id,
            aps.segment1 supplier_no,
            aps.vendor_name supplier_name,
            aia.doc_sequence_value ap_voucher_no,
            aia.invoice_num invoice_number,
            to_char(aia.gl_date) gl_date,
            aia.invoice_currency_code currency,
            aia.exchange_rate currency_rate,
            gcc.segment6 ap_account,
            sum(aila.amount) invoice_amount,
            aia.exchange_rate,
            (select sum(amount)
             from ap_invoice_payments_all aipa
             where aipa.accounting_date <= to_date(:P_AS_OF, 'YYYY/MM/DD HH24:MI:SS')
             and aipa.invoice_id = aia.invoice_id) amount_paid
from ap_invoices_all aia
        INNER JOIN ap_suppliers aps
            ON aia.vendor_id = aps.vendor_id
        INNER JOIN ap_invoice_lines_all aila
            ON aila.invoice_id = aia.invoice_id
        INNER JOIN ap_payment_schedules_all apsa
            ON apsa.invoice_id = aia.invoice_id
        INNER JOIN gl_code_combinations gcc
            ON  gcc.code_combination_id = aia.accts_pay_code_combination_id
where 1 = 1
        and aia.cancelled_date IS NULL
        and aia.invoice_currency_code = 'USD'
         and to_date(aia.gl_date) <= to_date(:P_AS_OF, 'YYYY/MM/DD HH24:MI:SS') 
         and aia.accts_pay_code_combination_id = (CASE 
                                                                                    WHEN lower(:P_AP_GROUP) = 'all' THEN aia.accts_pay_code_combination_id 
                                                                                    ELSE TO_NUMBER(:P_AP_GROUP) end
                                                                               )
group by  

                aia.invoice_id,
                aps.segment1,
                aps.vendor_name ,
                aia.doc_sequence_value,
                aia.invoice_num,
                aia.gl_date,
                aia.invoice_currency_code,
                aia.exchange_rate,
                gcc.segment6)
where invoice_amount -  nvl(amount_paid,0) != 0
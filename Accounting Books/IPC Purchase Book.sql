select  aia.gl_date voucher_date,
            aps.segment1 supplier_id,
            aps.vendor_name supplier_name,
            apsa.vat_registration_num supplier_tin,
            apsa.address_line1 || ' ' || apsa.address_line2 || ' ' || apsa.address_line3 address,
            aia.description,
            aia.invoice_num,
            aia.invoice_amount amount,
            0 discount,
            SUM(CASE WHEN aila.LINE_TYPE_LOOKUP_CODE = 'TAX' THEN aia.tax_amount ELSE 0 END) vat,
            SUM(aila.amount) net_purchases
from ap_invoices_all aia
         LEFT JOIN ap_suppliers aps
            ON aps.vendor_id = aia.vendor_id
        LEFT JOIN ap_supplier_sites_all apsa
            ON apsa.vendor_id = aps.vendor_id
            AND apsa.org_id = 82
        LEFT JOIN ap_invoice_lines_all aila
            ON aila.invoice_id = aia.invoice_id            
        INNER JOIN ap_terms_tl apt 
            ON apt.term_id = aia.terms_id
        INNER JOIN fnd_user fu
            ON fu.user_id = aia.created_by     
        LEFT JOIN gl_code_combinations gcc
            ON gcc.code_combination_id = aia.accts_pay_code_combination_id   
where 1 = 1
            AND aia.cancelled_date IS NULL
            AND TO_DATE(aia.gl_date) between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
            
group by 
             aia.gl_date ,
            aps.segment1 ,
            aps.vendor_name ,
            apsa.vat_registration_num ,
            apsa.address_line1,
            apsa.address_line2,
            apsa.address_line3,
            aia.description,
            aia.invoice_num,
            aia.invoice_amount;
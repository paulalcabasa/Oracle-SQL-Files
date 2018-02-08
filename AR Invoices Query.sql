select rcta.trx_number,
           to_char(rcta.trx_date) invoice_date,
           to_char(apsa.gl_date) gl_date,
           to_char(rcta.creation_date) creation_date,
           rcta.attribute3 cs_no,
           rcta.comments ifs_invoice_no,
           (select sum(extended_amount) from ra_customer_trx_lines_All 
           where customer_trx_id = rcta.customer_trx_id) amount,
           rctta.name
          
from ra_customer_trx_all rcta,
         ar_payment_schedules_all apsa,
         ra_cust_trx_types_all rctta
where 1 = 1
        and rcta.trx_number = apsa.trx_number
        and rctta.CUST_TRX_TYPE_ID = rcta.CUST_TRX_TYPE_ID
        and rcta.CUST_TRX_TYPE_ID = apsa.CUST_TRX_TYPE_Id
        and rcta.trx_date BETWEEN '01-JUL-2017' AND '31-JUL-2017'
        and rcta.trx_number like '402%'
       -- and to_date(rcta.creation_date) >= '18-MAY-2017';
select to_char(rcta.trx_number) invoice_no,
         to_char(rcta.trx_date) invoice_date,
         to_char(apsa.gl_date) gl_date,
         to_char(rcta.creation_date) creation_date,
         rcta.attribute3 CS_NO,
         rcta.comments Iifs_invoice_no
from ra_customer_trx_all rcta,
        ar_payment_schedules_all apsa
where 1 = 1
          and rcta.trx_number = apsa.trx_number
          and rcta.trx_number LIKE '403%'
    --      and to_date(rcta.trx_date) BETWEEN '01-APR-2017' AND '30-APR-2017'
    --      AND rcta.creation_date >= '18-MAY-2017'
order by rcta.customer_trx_id;
select 
    rta.trx_number,
    rta.trx_date,
    rta2.trx_number applied_invoice,
    rta2.trx_date applied_invoice_date,
    rtt.name, 
    rtt.description,
    rta.ct_reference,
    rta.status_trx,
    ara.application_type,
    ara.status,
    ara.display, 
    --ara.applied_customer_trx_id,
    --ara.customer_trx_id,
    ara.line_applied,
    ara.amount_applied
FROM 
    ra_cust_trx_types_all rtt,
    ra_customer_trx_all rta,
    ra_customer_trx_all rta2,
    ar_payment_schedules_all ps,
    AR_RECEIVABLE_APPLICATIONS_ALL  ara
where 
    rta.cust_trx_type_id = rtt.cust_trx_type_id
    and rta.customer_trx_id = ps.customer_trx_id
    and rta.customer_trx_id = ara.customer_trx_id
    and rta2.customer_trx_id = ara.APPLIED_CUSTOMER_TRX_ID
    and rtt.cust_trx_type_id = 7081
  
order by     
    rta.trx_number asc; 


select comments,attribute1,attribute3,trx_number
from ra_customer_trx_all;

SELECT *
FROM RA_CUSTOMER_TRX_ALL
WHERE attribute3 LIKE '%CR3125%';


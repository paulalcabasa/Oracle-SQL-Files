/*
        Author : Paul Alcabasa
        Date Created : July 17, 2017
        Purpose : Queries for checking balance differences in Trial Balance
*/


-- Unmatched Invoices from Receipt
select rcta.trx_number,
         rcta.comments,
         rcta.attribute1,
         rcta.trx_date,
         sum(rctal.extended_amount) invoice_amount,
         rctta.name,
         rctta.description
from ra_customer_trx_all rcta,
        ra_customer_trx_lines_all rctal,
        ra_cust_trx_types_all rctta
where 1 = 1
          and rctal.customer_trx_id  = rcta.customer_trx_id
          and rctta.cust_trx_type_id = rcta.cust_trx_type_id
          and rcta.customer_trx_id NOT IN (SELECT applied_customer_trx_id FROM ar_receivable_applications_all
                                                            where display = 'Y')
group by rcta.trx_number,
         rcta.comments,
         rcta.attribute1,
         rcta.trx_date,
         rctta.name,
         rctta.description;
         
-- Receipts with No Customers
select SUM(AMOUNT)
from ar_cash_receipts_all acra
where 1 = 1
          and acra.status = 'UNID';
          

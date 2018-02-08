select *
from ar_receivable_applications_all;

select rcta.trx_number invoice_number,
           rcta.trx_date invoice_date,
           rctta.name,
           rctta.description,
           rcta.comments,
           rcta.attribute1,
           rcta.attribute2,
           rcta.attribute3,
           sum(rctla.extended_amount) invoice_amount,
           cm_trans.cm_trx_number
    
from ra_customer_trx_all rcta,
         ra_cust_trx_types_all rctta,
         ra_customer_trx_lines_all rctla,
         IPC_AR_INVOICES_WITH_CM cm_trans
where 1 = 1
            and rctla.customer_trx_id = rcta.customer_trx_id
            and rcta.cust_trx_type_id = rctta.cust_trx_type_id
            and rcta.customer_trx_id = cm_trans.orig_trx_id (+)
            and rcta.trx_number like '521%'
            and rcta.customer_trx_id NOT IN (select applied_customer_trx_id 
                                                                    from ar_receivable_applications_all
                                                                    where display = 'Y')
  --          and complete_flag = 'Y'
            
            -- and rctta.name IN ('Debit Memo')
         --   and rctta.name IN ('CM - Cert of WTax')
group by  rcta.trx_number,
                rcta.trx_date,
                rctta.name,
                rctta.description,
                rcta.comments,
                rcta.attribute1,
                rcta.attribute2,
                rcta.attribute3,
                cm_trans.cm_trx_number
order by rcta.trx_number;

select *
from IPC_AR_INVOICES_WITH_CM;
select cust_trx_type_id,
           name 
from ra_cust_trx_types_all;

select  distinct    rctta.name
from ra_customer_trx_all rcta,
         ra_cust_trx_types_all rctta
where 1 = 1
and rcta.cust_trx_type_id = rctta.cust_trx_type_id;
        


select *
from 

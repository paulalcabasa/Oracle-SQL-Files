select  
            acra.cash_receipt_id,
           acra.receipt_number,
           acra.doc_sequence_value,
           acra.receipt_date,
           acra.misc_payment_source,
           acra.amount receipt_amount,
           acra.currency_code,
           sum(nvl(amcda.amount,0)) applied_amount,
           acra.attribute1 check_bank,
           LISTAGG(amcda.comments, ', ') WITHIN GROUP (ORDER BY amcda.comments DESC) comments 
from ar_cash_receipts_all acra 
         LEFT JOIN ar_misc_cash_distributions_all amcda
            ON acra.cash_receipt_id = amcda.cash_receipt_id
 
where 1 = 1
        and acra.type = 'MISC'
        and acra.doc_sequence_value not like '701%'
        and acra.status <> 'REV'
        and acra.cash_receipt_id between :p_cash_receipt_from AND :p_cash_receipt_to
        
group by 
        acra.cash_receipt_id,
        acra.receipt_number,
        acra.doc_sequence_value,
        acra.receipt_date,
        acra.misc_payment_source,
        acra.amount,
        acra.attribute1,
        acra.currency_code
order by  acra.doc_sequence_value;

select *
from ar_cash_receipts_all;

select *
from ar_receipt_methods;

select receipt_method_id
from ar_cash_receipts_all;
/*
M AR_MISC_CASH_DISTRIBUTIONS MCD,
          AR_CASH_RECEIPTS CR,
          AR_DISTRIBUTIONS DIST,
          AR_SYSTEM_PARAMETERS ASP
          */
select *
from ar_misc_cash_distributions_all
where cash_Receipt_id = 75000;

select acra.cash_receipt_id,
           acra.receipt_number,
           acra.doc_sequence_value,
           acra.receipt_date,
           acra.misc_payment_source,
           acra.amount receipt_amount,
           acra.currency_code,
     --      sum(nvl(amcda.amount,0)) applied_amount,
           acra.attribute1 check_bank
from ar_cash_receipts_all acra 
         LEFT JOIN ar_misc_cash_distributions_all amcda
            ON acra.cash_receipt_id = amcda.cash_receipt_id
where 1 = 1
        and acra.type = 'MISC'
   --     and acra.doc_sequence_Value like '701%'
     --   and acra.cash_receipt_id = 75000
     ;
group by 
        acra.cash_receipt_id,
        acra.receipt_number,
        acra.doc_sequence_value,
        acra.receipt_date,
        acra.misc_payment_source,
        acra.amount,
        acra.attribute1,
        acra.currency_code;

select initcap(first_name) ||' '||initcap(last_name) 
from PER_ALL_PEOPLE_F a,Fnd_User b where Employee_Id = Person_id
and user_id = 2115;

SELECT *
FROM PER_ALL_PEOPLE_F
WHERE LAST_NAME = 'JAVIER';
select EMPLOYEE_ID
from Fnd_User
where user_name = '170607';

-- NEGOTIABLE
select distinct status_lookup_code
from ap_checks_all;
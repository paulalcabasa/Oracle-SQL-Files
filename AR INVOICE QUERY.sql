SELECT *
FROM HZ_PARTIES 
WHERE party_name like '%ASIAN%TERM%';
update hz_parties
set party_name = 'XXXASIAN TERMINALS INCORPORATED'
where PARTY_ID = 7112;

COMMIT;


SELECT *
FROM HZ_PARTIES
WHERE STATUS = 'M';
select *
from ra_customer_trx_all;

SELECT *
FROM RA_CUST_TRX_TYPES_ALL;
select *
from hz_cust_accounts_all;

select *
from fnd_user;

select *
from per_people_f;
select rcta.trx_number,
         rcta.interface_header_attribute1 sales_order_number,
         rcta.trx_date,
         rctta.name,
         hp.party_name bill_to_customer,
         hca.account_name,
         hca.account_number,
         ppf.full_name,
         fu.user_name
        
         
from ra_customer_trx_all rcta,
        RA_CUST_TRX_TYPES_ALL RCTTA,
        hz_cust_accounts_all hca,
        hz_parties hp,
        fnd_user fu,
        per_people_f ppf
        
where 1 = 1
          AND RCTTA.CUST_TRX_TYPE_ID = RCTA.CUST_TRX_TYPE_ID
     
          AND hca.cust_account_id = rcta.bill_to_customer_id
          AND hp.party_id = hca.party_id
          AND FU.USER_ID =  rcta.created_By
          and fu.user_name = ppf.employee_number(+)
          AND rcta.attribute3 IN ('CQ9401',
'CQ9402',
'CQ9403',
'CQ9404',
'CR1371',
'CR1370',
'CR1373',
'CR4738',
'CR4733',
'CR4739',
'CR1347',
'CR1348',
'CR1354',
'CR1352',
'CR0346',
'CR6859',
'CR6860',
'CR4831',
'CR4834',
'CR4837',
'CR4162',
'CQ9406',
'CQ1747',
'CR9514',
'CQ3366',
'CR5097',
'CR7372',
'CR7364',
'CR7289',
'CR8736',
'CR9649',
'CR9650',
'CQ9233',
'CR5962',
'CR0325',
'CR5609',
'CR3575');

SELECT *
FROM MTL_TRANSACTION_TYPES;

SELECT *
FROM RA_CUSTOMER_TRX_ALL
WHERE TRX_NUMBER = '40300003808';

select num_1099
from ap_suppliers
where segment1 = 102335   ;

select vat_registration_num
from ap_supplier_sites_all
where vendor_id= 46007;

select *
from ap_suppliers
where segment1 = '103809';

select *
from system;

alter system set MAX_DUMP_FILE_SIZE=UNLIMITED; 

commit;

--step 2 9254138
SELECT MAX(log_sequence)
FROM fnd_log_messages;
-- 9256967
SELECT MAX(log_sequence)
FROM fnd_log_messages; 

SELECT *
FROM fnd_log_messages
WHERE log_sequence BETWEEN '9254138' AND '9256967'
ORDER BY log_sequence; 

select *
from ar_cash_receipts_all
where cash_receipt_id = 16000;
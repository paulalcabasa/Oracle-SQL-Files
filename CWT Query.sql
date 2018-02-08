select *
from ra_cust_trx_types_all;

SELECT *
FROM RA_CUSTOMER_TRX_ALL
WHERE CT_REFERENCE = '980237709';

SELECT *
FROM RA_CUSTOMER_TRX_ALL
WHERE trx_number = '2101';

SELECT *
FROM RA_CUSTOMER_TRX_ALL
WHERE attribute1 = '2099';


select trx_number,attribute3
from ra_customer_trx_all
where attribute3 in ('CR4598',
'CR3934',
'CR4012',
'CQ3788',
'CR4085',
'CR0789',
'CR3354',
'CR3515',
'CR5284',
'CQ6544',
'CR5411',
'CR5410',
'CR5557',
'CR3868',
'CR4238',
'CR6063',
'CR4988',
'CR1675');
select *
from ra_customer_trx_all
where trx_number = '40300007939';

select *
from hr_all_organization_units_all;

select rcta.trx_number,
         rcta.trx_date,
         bill_to_customer_id,
         sold_to_customer_id
from ra_customer_trx_all rcta;

select *
from XXIPC_CUSTOMER_DETAIL_V;
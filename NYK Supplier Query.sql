SELECT *
FROM ap_suppliers aps,
         ap_supplier_sites_all apsa
where 1 = 1
          and aps.vendor_id = apsa.vendor_id
          and apsa.vendor_site_code = 'NYK';

select *
from ap_supplier_sites_all;
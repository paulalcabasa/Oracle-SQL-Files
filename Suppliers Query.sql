select *

from AP_SUPPLIER_SITES_ALL;

select *
from ap_suppliers;

select -- aps.vendor_id,
-- APS.AMOUNT_INCLUDES_TAX_FLAG,
         aps.vendor_name,
        aps.segment1,
     aps.vendor_type_lookup_code,
         aps.vat_code header_vat_code
      --  aps.start_date_active,
      -- aps.end_date_active,
      --   aps.attribute1,
     --    aps.attribute2,
     --    aps.attribute3 IFS_SUPPLIER_CODE,
       --  apsa.vendor_site_id,
  --       apsa.vendor_site_code,
  --       apsa.vat_code site_vat_code,
  --       haou.name,
      --   aps.INVOICE_AMOUNT_LIMIT,
     --    aps.MATCH_OPTION,
   --    aps.invoice_currency_code,
  --      aps.HOLD_UNMATCHED_INVOICES_FLAG,
  --       aps.hold_reason,
      --   apsa.awt_group_id,
--         (select name 
--         from AP_AWT_GROUPS
--         where group_id = apsa.awt_group_id) awt_group,
--         aps.terms_date_basis,
--         apsa.purchasing_site_flag,
--         apsa.pay_site_flag,
--        apsa.address_line1,
--         apsa.address_line2
    --     apsa.country,
    --     apsa.county,
      --   apsa.org_id
         
from ap_suppliers aps,
        AP_SUPPLIER_SITES_ALL apsa,
        hr_all_organization_units haou
where 1 = 1
          AND  aps.vendor_id = apsa.vendor_id
          AND haou.organization_id = apsa.org_id
          AND  aps.end_date_active IS  NULL
      --    AND      apsa.vendor_site_code = 'FOREIGN' 
     --     AND APSA.AMOUNT_INCLUDES_TAX_FLAG = 'Y';
     --     AND aps.segment1 =100702;
          ;
          SELECT *
          from AP_AWT_GROUPS;

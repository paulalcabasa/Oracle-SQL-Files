SELECT rcta.bill_to_customer_id,
            rcta.bill_to_site_use_id,
            cust.party_name,
            cust.account_name,
            cust.account_number,
            rcta.attribute3,
            rcta.trx_date,
            vehicle.model_variant,
            vehicle.sales_model,
            vehicle.color,
            vehicle.prod_model
FROM ra_customer_trx_all rcta 
                LEFT JOIN IPC_AR_INVOICES_WITH_CM cm
                    ON rcta.customer_trx_id = cm.orig_trx_id
                LEFT JOIN ipc_dms.oracle_customers_v cust
                    ON cust.cust_account_id = rcta.ship_to_customer_id
                LEFT JOIN mtl_serial_numbers msn
                    ON msn.serial_number = rcta.attribute3
                LEFT JOIN mtl_system_items_b msib
                    ON msib.inventory_item_id = msn.inventory_item_id
                    AND msib.organization_id = msn.current_organization_id
                LEFT JOIN ipc_dms.ipc_vehicle_models_v vehicle
                    ON vehicle.inventory_item_id = msib.inventory_item_id
                    AND vehicle.organization_id = msib.organization_id
WHERE 1 = 1
             AND cm.orig_trx_id IS NULL
             AND rcta.cust_trx_type_id = 1002
             AND cust.account_number = 1724
             AND rcta.trx_date BETWEEN '01-NOV-2017' AND '30-NOV-2017';
             AND rcta.attribute3 = 'CR6565';
             
             select *
             from ipc_dms.ipc_vehicle_models_v;


SELECT *
FROM IPC_DMS.USERS;


  SELECT DISTINCT
--        hcp.site_use_id,
          hca.cust_account_id,
          hp.party_id,
--          hps.party_site_id,
          hp.party_number,
          hp.party_name,
          hca.account_number,
          hca.account_name
     --    hcpc.name profile_class_name
     FROM apps.hz_customer_profiles hcp
          INNER JOIN apps.hz_cust_profile_classes hcpc
             ON hcp.profile_class_id = hcpc.profile_class_id
          INNER JOIN apps.hz_cust_site_uses_all hcsua
             ON hcsua.site_use_id = hcp.site_use_id
          INNER JOIN apps.hz_cust_acct_sites_all hcasa
             ON hcasa.cust_acct_site_id = hcsua.cust_acct_site_id
          INNER JOIN apps.hz_cust_accounts_all hca
             ON hca.cust_account_id = hcasa.cust_account_id
          INNER JOIN apps.hz_party_sites hps
             ON hps.party_site_id = hcasa.party_site_id
          INNER JOIN apps.hz_parties hp
             ON hp.party_id = hps.party_id
    WHERE     hcp.profile_class_id IN(1040)                   -- Dealers-Vehicle
          AND hcp.status = 'A'
          AND hcsua.status = 'A'
          and  hca.account_number = 1724;


select *
from apps.hz_customer_profiles;

SELECT *
FROM HZ_PARTIES
WHERE PARTY_ID = 33138;

select *
from apps.hz_cust_profile_classes;

select *
from ipc_dms.forecast_headers;
SELECT hca.cust_account_id,
            hcasa.site_use_id,
            hcasa.site_use_code,
            hp.party_name customer_name,
            hca.account_number,
            hca.account_name,
            hps.party_site_name,
            hl.address1 || ' ' || hl.address2 || ' ' || hl.address3 || ' ' || hl.address4 || ' ' || hl.city address,
            hcasa.tax_reference,
            hcasa.*
           
FROM hz_parties hp 
           LEFT JOIN hz_cust_accounts_all hca
                ON hp.party_id = hca.party_id
           LEFT JOIN hz_cust_acct_sites_all hcas
                ON hca.cust_account_id = hcas.cust_account_id
           LEFT JOIN hz_party_sites hps
                ON hps.party_site_id = hcas.party_site_id 
           LEFT JOIN hz_locations hl
                ON hl.location_id = hps.location_id
           LEFT JOIN hz_cust_site_uses_all hcasa
                ON hcasa.cust_acct_site_id = hcas.cust_acct_site_id
WHERE 1 = 1
--             AND  hp.party_id = 32114
         --  AND hca.account_number = 1724
--            AND hcasa.site_use_id = 20527
             AND hcas.status = 'A'
             AND hca.cust_account_id = 15098
             AND hcasa.site_use_code  IN('SHIP_TO','BILL_TO');
;

SELECT *
FROM hz_cust_site_uses_all
WHERE SITE_USE_ID = 20527;
         

select *
from hz_cust_acct_sites_all
where cust_acct_site_id = 10363;

select *
from hz_cust_accounts_all
where cust_account_id = 15141;

select *
from hz_parties
where party_id = 33138;
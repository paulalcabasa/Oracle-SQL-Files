SELECT *
FROM XXIPC_CUSTOMER_DETAIL_V
where cust_account_id = 15094
and site_use_id = 10045;
     drop view XXIPC_CUSTOMER_DETAIL_V;
     commit;
CREATE VIEW XXIPC_CUSTOMER_DETAIL_V AS SELECT DISTINCT
    hca1.account_number customer_number,
    hca1.account_name,
    hp1.party_name,
    hca1.cust_account_id ,      
    ACCT_SU1.site_use_id,
    acct_site1.org_id,
  (SELECT DISTINCT loc.address1
   FROM hz_parties hp ,
    hz_cust_accounts hca ,
    HZ_LOCATIONS LOC ,
    HZ_PARTY_SITES PARTY_SITE ,
    HZ_CUST_SITE_USES_ALL ACCT_SU ,
    HZ_CUST_ACCT_SITES_ALL ACCT_SITE
  WHERE hp.party_id             = hca.party_id
     AND loc.location_id           = party_site.location_id
     AND party_site.party_site_id  = acct_site.party_site_id
     AND acct_su.cust_acct_site_id = acct_site.cust_acct_site_id
     AND acct_su.site_use_code     = 'BILL_TO'
     AND ACCT_SU.STATUS            = 'A'
     AND ACCT_SITE.CUST_ACCOUNT_ID = HCA.CUST_ACCOUNT_ID
     AND acct_site.status          = 'A'
     AND acct_site.org_id          = acct_site1.org_id
     AND hca.account_number        = hca1.account_number
     AND hps1.party_site_id        = party_site.party_site_id
  ) bill_to_address1,
 
  (SELECT DISTINCT loc.address2
  FROM hz_parties hp ,
    hz_cust_accounts hca ,
    HZ_LOCATIONS LOC ,
    HZ_PARTY_SITES PARTY_SITE ,
    HZ_CUST_SITE_USES_ALL ACCT_SU ,
    HZ_CUST_ACCT_SITES_ALL ACCT_SITE
  WHERE hp.party_id             = hca.party_id
     AND loc.location_id           = party_site.location_id
     AND party_site.party_site_id  = acct_site.party_site_id
     AND acct_su.cust_acct_site_id = acct_site.cust_acct_site_id
     AND acct_su.site_use_code     = 'BILL_TO'
     AND ACCT_SU.STATUS            = 'A'
     AND ACCT_SITE.CUST_ACCOUNT_ID = HCA.CUST_ACCOUNT_ID
     AND acct_site.status          = 'A'
     AND acct_site.org_id          = acct_site1.org_id
     AND hca.account_number        = hca1.account_number
     AND hps1.party_site_id        = party_site.party_site_id
  ) bill_to_address2,
 
  (SELECT DISTINCT loc.address3
  FROM hz_parties hp ,
    hz_cust_accounts hca ,
    HZ_LOCATIONS LOC ,
    HZ_PARTY_SITES PARTY_SITE ,
    HZ_CUST_SITE_USES_ALL ACCT_SU ,
    HZ_CUST_ACCT_SITES_ALL ACCT_SITE
  WHERE hp.party_id             = hca.party_id
     AND loc.location_id           = party_site.location_id
     AND party_site.party_site_id  = acct_site.party_site_id
     AND acct_su.cust_acct_site_id = acct_site.cust_acct_site_id
     AND acct_su.site_use_code     = 'BILL_TO'
     AND ACCT_SU.STATUS            = 'A'
     AND ACCT_SITE.CUST_ACCOUNT_ID = HCA.CUST_ACCOUNT_ID
     AND acct_site.status          = 'A'
     AND acct_site.org_id          = acct_site1.org_id
     AND hca.account_number        = hca1.account_number
     AND hps1.party_site_id        = party_site.party_site_id
  ) bill_to_address3,
 
  (SELECT DISTINCT loc.address4
  FROM hz_parties hp ,
    hz_cust_accounts hca ,
    HZ_LOCATIONS LOC ,
    HZ_PARTY_SITES PARTY_SITE ,
    HZ_CUST_SITE_USES_ALL ACCT_SU ,
    HZ_CUST_ACCT_SITES_ALL ACCT_SITE
  WHERE hp.party_id             = hca.party_id
  AND loc.location_id           = party_site.location_id
  AND party_site.party_site_id  = acct_site.party_site_id
  AND acct_su.cust_acct_site_id = acct_site.cust_acct_site_id
  AND acct_su.site_use_code     = 'BILL_TO'
  AND ACCT_SU.STATUS            = 'A'
  AND ACCT_SITE.CUST_ACCOUNT_ID = HCA.CUST_ACCOUNT_ID
  AND acct_site.status          = 'A'
  AND acct_site.org_id          = acct_site1.org_id
  AND hca.account_number        = hca1.account_number
  AND hps1.party_site_id        = party_site.party_site_id
  ) bill_to_address4,
 
  (SELECT DISTINCT loc.address1
  FROM hz_parties hp ,
    hz_cust_accounts hca ,
    HZ_LOCATIONS LOC ,
    HZ_PARTY_SITES PARTY_SITE ,
    HZ_CUST_SITE_USES_ALL ACCT_SU ,
    HZ_CUST_ACCT_SITES_ALL ACCT_SITE
  WHERE hp.party_id             = hca.party_id
  AND loc.location_id           = party_site.location_id
  AND party_site.party_site_id  = acct_site.party_site_id
  AND acct_su.cust_acct_site_id = acct_site.cust_acct_site_id
  AND acct_su.site_use_code     = 'SHIP_TO'
  AND ACCT_SU.STATUS            = 'A'
  AND ACCT_SITE.CUST_ACCOUNT_ID = HCA.CUST_ACCOUNT_ID
  AND acct_site.status          = 'A'
  AND acct_site.org_id          = acct_site1.org_id
  AND hca.account_number        = hca1.account_number
  AND hps1.party_site_id        = party_site.party_site_id
  ) SHIP_to_address1,
 
  (SELECT DISTINCT loc.address2
  FROM hz_parties hp ,
    hz_cust_accounts hca ,
    HZ_LOCATIONS LOC ,
    HZ_PARTY_SITES PARTY_SITE ,
    HZ_CUST_SITE_USES_ALL ACCT_SU ,
    HZ_CUST_ACCT_SITES_ALL ACCT_SITE
  WHERE hp.party_id             = hca.party_id
  AND loc.location_id           = party_site.location_id
  AND party_site.party_site_id  = acct_site.party_site_id
  AND acct_su.cust_acct_site_id = acct_site.cust_acct_site_id
  AND acct_su.site_use_code     = 'SHIP_TO'
  AND ACCT_SU.STATUS            = 'A'
  AND ACCT_SITE.CUST_ACCOUNT_ID = HCA.CUST_ACCOUNT_ID
  AND acct_site.status          = 'A'
  AND acct_site.org_id          = acct_site1.org_id
  AND hca.account_number        = hca1.account_number
  AND hps1.party_site_id        = party_site.party_site_id
  ) SHIP_to_address2,
 
  (SELECT DISTINCT loc.address3
  FROM hz_parties hp ,
    hz_cust_accounts hca ,
    HZ_LOCATIONS LOC ,
    HZ_PARTY_SITES PARTY_SITE ,
    HZ_CUST_SITE_USES_ALL ACCT_SU ,
    HZ_CUST_ACCT_SITES_ALL ACCT_SITE
  WHERE hp.party_id             = hca.party_id
  AND loc.location_id           = party_site.location_id
  AND party_site.party_site_id  = acct_site.party_site_id
  AND acct_su.cust_acct_site_id = acct_site.cust_acct_site_id
  AND acct_su.site_use_code     = 'SHIP_TO'
  AND ACCT_SU.STATUS            = 'A'
  AND ACCT_SITE.CUST_ACCOUNT_ID = HCA.CUST_ACCOUNT_ID
  AND acct_site.status          = 'A'
  AND acct_site.org_id          = acct_site1.org_id
  AND hca.account_number        = hca1.account_number
  AND hps1.party_site_id        = party_site.party_site_id
  ) SHIP_to_address3,
 
  (SELECT DISTINCT loc.address4
  FROM hz_parties hp ,
    hz_cust_accounts hca ,
    HZ_LOCATIONS LOC ,
    HZ_PARTY_SITES PARTY_SITE ,
    HZ_CUST_SITE_USES_ALL ACCT_SU ,
    HZ_CUST_ACCT_SITES_ALL ACCT_SITE
  WHERE hp.party_id             = hca.party_id
  AND loc.location_id           = party_site.location_id
  AND party_site.party_site_id  = acct_site.party_site_id
  AND acct_su.cust_acct_site_id = acct_site.cust_acct_site_id
  AND acct_su.site_use_code     = 'SHIP_TO'
  AND ACCT_SU.STATUS            = 'A'
  AND ACCT_SITE.CUST_ACCOUNT_ID = HCA.CUST_ACCOUNT_ID
  AND acct_site.status          = 'A'
  AND acct_site.org_id          = acct_site1.org_id
  AND hca.account_number        = hca1.account_number
  AND hps1.party_site_id        = party_site.party_site_id
  ) SHIP_to_address4,
 
  (SELECT DISTINCT party_site.party_site_number bill_PARTY_SITE_NUMBER
  FROM hz_parties hp ,
    hz_cust_accounts hca ,
    HZ_LOCATIONS LOC ,
    HZ_PARTY_SITES PARTY_SITE ,
    HZ_CUST_SITE_USES_ALL ACCT_SU ,
    HZ_CUST_ACCT_SITES_ALL ACCT_SITE
  WHERE hp.party_id             = hca.party_id
  AND loc.location_id           = party_site.location_id
  AND party_site.party_site_id  = acct_site.party_site_id
  AND acct_su.cust_acct_site_id = acct_site.cust_acct_site_id
  AND acct_su.site_use_code     = 'BILL_TO'
  AND ACCT_SU.STATUS            = 'A'
  AND ACCT_SITE.CUST_ACCOUNT_ID = HCA.CUST_ACCOUNT_ID
  AND acct_site.status          = 'A'
  AND acct_site.org_id          = acct_site1.org_id
  AND hca.account_number        = hca1.account_number
  AND hps1.party_site_id        = party_site.party_site_id
  ) bill_to_party_site,
 
  (SELECT DISTINCT party_site.party_site_number bill_PARTY_SITE_NUMBER
  FROM hz_parties hp ,
    hz_cust_accounts hca ,
    HZ_LOCATIONS LOC ,
    HZ_PARTY_SITES PARTY_SITE ,
    HZ_CUST_SITE_USES_ALL ACCT_SU ,
    HZ_CUST_ACCT_SITES_ALL ACCT_SITE
  WHERE hp.party_id             = hca.party_id
  AND loc.location_id           = party_site.location_id
  AND party_site.party_site_id  = acct_site.party_site_id
  AND acct_su.cust_acct_site_id = acct_site.cust_acct_site_id
  AND acct_su.site_use_code     = 'SHIP_TO'
  AND ACCT_SU.STATUS            = 'A'
  AND ACCT_SITE.CUST_ACCOUNT_ID = HCA.CUST_ACCOUNT_ID
  AND acct_site.status          = 'A'
  AND acct_site.org_id          = acct_site1.org_id
  AND hca.account_number        = hca1.account_number
  AND hps1.party_site_id        = party_site.party_site_id
  ) ship_to_party_site
FROM hz_parties hp1,
  hz_cust_accounts hca1,
  hz_locations hl1,
  HZ_PARTY_SITES hps1,
  HZ_CUST_SITE_USES_ALL ACCT_SU1,
  HZ_CUST_ACCT_SITES_ALL ACCT_SITE1
WHERE 1                        =1
   AND hp1.party_id               = hca1.party_id
   AND hp1.party_id               = hps1.party_id
   AND hl1.location_id            = hps1.location_id
   AND hps1.party_site_id         = acct_site1.party_site_id
   AND acct_su1.cust_acct_site_id = acct_site1.cust_acct_site_id
   AND ACCT_SITE1.CUST_ACCOUNT_ID = HCA1.CUST_ACCOUNT_ID
  -- AND acct_site1.org_id          = 82
  -- AND hca1.cust_account_id        = 14088
 --  AND  ACCT_SU1.site_use_id =  9963;

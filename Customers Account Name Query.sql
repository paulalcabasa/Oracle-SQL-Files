select distinct hp.party_number,
         hp.party_name,
         hca.account_number,
         hca.account_name
from hz_customer_profiles hcp,
        hz_cust_accounts_all hca,
        hz_parties hp
where 1 = 1 
          AND hca.cust_account_id = hcp.cust_account_id
          AND hp.party_id = hca.party_id
          AND hcp.profile_class_id = 1047;
select *
from ar_customers;
select *
from 

  hz_parties              hp,
       hz_party_sites          hps,
       hz_cust_accounts_all    hca,
       
select *
from HZ_CUST_PROFILE_CLASSES;
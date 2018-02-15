/* Author : John Paul M. Alcabasa
    Date created : September 18, 2017
    Description : Query for AR Invoices with Delivery Date
*/
SELECT 
        --  hps.PARTY_SITE_ID,
        -- hps.party_site_id,
        --  CUST_ACCOUNT_PROFILE_ID
        --hps.party_site_number,
        -- hcasa.cust_acct_site_id,
        --hcpc.profile_class_id,
        -- hcpc.NAME profile_class_name
--            hcaa.account_number,
            rcta.trx_number invoice_number,
            rcta.comments,
            rcta.attribute3 cs_no,
            hp.party_name customer_name,
            hcaa.account_name,
            TO_CHAR(rcta.trx_date) invoice_date,
            
--            distinct
--            NVL(msib.attribute9,msib.segment1) model
--            rcta.attribute3 cs_no,
--            sum(case when rctla.line_type = 'LINE' THEN rctla.extended_amount end) unit_price,
--            sum(case when rctla.line_type = 'TAX' THEN rctla.extended_amount end) vat_amount,
--            apsa.amount_due_original gross_amount,
--            TO_CHAR(TO_DATE(rcta.attribute5,'YYYY/MM/DD HH24:MI:SS'),'DD/MM/YYYY') actual_delivery_date
--             TO_CHAR(rcta.creation_date) creation_date,
            TO_CHAR(apsa.gl_date) gl_date
--             fu.description created_by
--             rcta.complete_flag,
--             DECODE(rcta.status_trx,'OP','Open','CL','Closed','VD','Void') status,
FROM ra_customer_trx_all rcta
            LEFT JOIN ar_payment_schedules_all apsa
                ON apsa.customer_trx_id = rcta.customer_trx_id
             LEFT JOIN hz_cust_accounts_all hcaa
                    ON hcaa.cust_account_id = rcta.bill_to_customer_id
             LEFT JOIN hz_cust_site_uses_all hcsua
                   ON hcsua.site_use_id = rcta.bill_to_site_use_id
                   AND hcsua.status = 'A'
                   AND hcsua.site_use_code = 'BILL_TO'
             LEFT JOIN hz_parties hp
                ON hp.party_id = hcaa.party_id
--             LEFT JOIN hz_cust_acct_sites_all hcasa
--                ON hcsua.cust_acct_site_id = hcasa.cust_acct_site_id
--             LEFT JOIN hz_party_sites hps
--                ON hps.party_site_id = hcasa.party_site_id
--             LEFT JOIN hz_locations hl
--                ON hl.location_id = hps.location_id
--             INNER JOIN fnd_user fu
--                ON fu.user_id = rcta.created_by
--            LEFT JOIN mtl_serial_numbers msn
--                ON msn.serial_number = rcta.attribute3
--            LEFT JOIN mtl_system_items_b msib
--                ON msib.inventory_item_id = msn.inventory_item_id
--                AND msib.organization_id = msn.current_organization_id
--            LEFT JOIN ra_customer_trx_lines_all rctla
--                ON rctla.customer_trx_id = rcta.customer_trx_id
--            LEFT JOIN mtl_serial_numbers msn
--                ON msn.serial_number = rcta.attribute3
--              INNER JOIN hz_customer_profiles hcp
--                ON hcp.cust_account_id = hcaa.cust_account_id
--              INNER JOIN hz_cust_profile_classes hcpc
--                ON hcpc.profile_class_id      = hcp.profile_class_id

;
WHERE 1 = 1;
          --    and rcta.complete_flag = 'Y'
         --     and rcta.status_trx <> 'VD'
--              and msn.current_organization_id = 121
        --      and hcaa.account_number IN(1724,1725,1726)
--              and rcta.trx_number like '403%'
--              and rcta.trx_date between '01-DEC-20-17' AND '31-DEC-2017'
--              and rcta.trx_number = '40300020088';
  --          and rcta.trx_number like '402%14575';
            
            
GROUP BY
                hcaa.account_number,
                hp.party_name,
                apsa.gl_date,
                hcaa.account_name,
                rcta.trx_date,
                rcta.trx_number,
                rcta.comments,
                
--                msib.attribute9,
--                msib.segment1,
                rcta.attribute3,
                apsa.amount_due_original,
                rcta.attribute5;

select *
from ra_customer_trx_all
where trx_number = '40300020088';

select *
from mtl_serial_numbers;
select *
from ra_customer_trx_lines_all       
where customer_trx_id = 1053083;       
              
              select current_organization_id,inventory_item_id
              from mtl_serial_numbers
              where serial_number = 'CS0287';
              select *
              from hz_party_sites;
              select *
              from ra_Customer_trx_all;
              
              SELECT *
              FROM hz_cust_site_uses_all
              where CUST_ACCT_SITE_ID = 5888;
              where site_use_id = 7710;
              
              SELECT *
              FROM hz_cust_acct_sites_all
              where cust_account_id = 17162;
              WHERE CUST_ACCT_SITE_ID = 5888;
              
              select *
              from hz_party_sites
              where party_site_id = 621669;
              
              select *
              from hz_parties
              where party_id = 46141;
              
              select *
              from hz_cust_accounts_all
              where party_id = 46141;
              
              select *
              from hz_Cust_Accounts 
              where cust_account_id = 17162;
              and TO_DATE(rcta.trx_date) between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss');



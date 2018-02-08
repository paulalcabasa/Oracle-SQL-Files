/* Script for Updating AR Customer Data
    Created By Sir Jojo
    Updated By Paul
    Date Updated : January 11, 2018
*/


/* 
    ========================Sales Order Customer Update ============================== 
*/

/*
    Step 1 : Create a Backup Table for the affected Sales Order using oe_order_headers_all
    Parameter : 
            order_number
*/
CREATE TABLE ooha_3010017812 AS select --a.rowid,
       sold_to_org_id, --cust_account_id
       ship_to_org_id, --ship_to_org_id
       invoice_to_org_id, --bill_to_org_id
       customer_signature --party_name
       --a.*
from oe_order_headers_all a
where order_number = '3010017812';

/*
    Step 2 : Select the data to be updated using rowid to modify data directly on TOAD without using UPDATE statement
    Parameter : oe_order_headers_all.order_number 
*/

select a.rowid,
       a.header_id,
       sold_to_org_id, --cust_account_id
       ship_to_org_id, --ship_to_org_id
       invoice_to_org_id, --bill_to_org_id 
       customer_signature, --party_name
       a.last_update_date
from oe_order_headers_all a
where order_number = '3010017812';

/* 
    Step 3 : Create a backup table for oe_order_lines_all for the update of the affected sales order lines 
    Parameter : oe_order_lines_all.header_id
*/
CREATE TABLE oola_3010017812 AS select --a.rowid,
       ship_to_org_id, 
       invoice_to_org_id, 
       sold_to_org_id, 
       a.header_id
from oe_order_lines_all a
where header_id = 1905509;

/*
    Step 4 : Select the data to be updated
*/
select -- a.rowid,
       ship_to_org_id,  -- ship_to SITE_USE_ID - 10004
       invoice_to_org_id,  -- bill_to SITE_USE_ID - 10003
       sold_to_org_id,  -- cust_account_id - 15098
       a.header_id
from oe_order_lines_all a
where header_id = 1905509;

/*
    ===================== END OF UPDATING SALES ORDER DETAILS =========================
*/



/*
    ======================= CUSTOMER INVOICE UPDATE ==========================
    Script to modify customer name and details for a specific invoice
*/

/*
    Step 1 : Create a backup table for ra_customer_trx_all details 
    Parameters:
        ct_reference (order_number)
        trx_number (invoice_number)
*/
CREATE TABLE rcta_3010017812_40300015508 AS select --a.rowid,
       sold_to_customer_id,  --cust_account_id
       bill_to_customer_id,  --cust_account_id
       bill_to_site_use_id,  --bill_to_org_id
       ship_to_customer_id,  --cust_account_id
       ship_to_site_use_id  --ship_to_org_id
  --     a.*
from RA_CUSTOMER_TRX_ALL a
where ct_reference = '3010017812'
and trx_number = '40300015508';

/*
    Step 2: Select the invoice header details using rowid to update invoice header details
    Parameters:
        ct_reference (order_number)
        trx_number (invoice_number)
*/
select a.rowid,
            a.trx_number,
            sold_to_customer_id,  --cust_account_id 15098 14088
            bill_to_customer_id,  --cust_account_id 15098
            bill_to_site_use_id,  --bill_to_org_id bill_to SITE_USE_ID - 10003 9959
            ship_to_customer_id,  --cust_account_id  15098
            ship_to_site_use_id  --ship_to_org_id ship_to SITE_USE_ID - 10004 9960
  --     a.*
from RA_CUSTOMER_TRX_ALL a
where ct_reference = '3010017812'
            and trx_number = '40300015508';


/*
    Step 3 :Create a backup table for ra_customer_trx_lines_all
*/
select *
from ra_customer_trx_all
where trx_number = '40300015508';
CREATE TABLE rctla_862920 AS 
select --a.rowid,
       ship_to_customer_id, --cust_account_id 15098
       ship_to_site_use_id, --ship_to_org_id  10004
       interface_line_attribute2
--       a.*
from ra_customer_trx_lines_all a
--where customer_trx_id = 736805
where customer_trx_id in (862920)
and ship_to_customer_id is not null;

/*
    Step 4 : Update ra_customer_trx_lines_all
*/
select a.rowid,
       ship_to_customer_id, --cust_account_id 15098
       ship_to_site_use_id, --ship_to_org_id  10004
       interface_line_attribute2
--       a.*
from ra_customer_trx_lines_all a
--where customer_trx_id = 736805
where customer_trx_id in (862920)
and ship_to_customer_id is not null;

/*
    Step 5: Create backup table for payment schedules 
*/
CREATE TABLE arpa_862920 AS
select --a.rowid,
       customer_id, --cust_account_id 15098
       customer_site_use_id -- BILL_TO_ORG_ID 10003
from ar_payment_schedules_all a
where CUSTOMER_TRX_ID in (862920);

/*
    Step 6: Update Payment Schedules
*/

select 
        a.rowid,
        customer_id, --cust_account_id 15098
        customer_site_use_id -- BILL_TO_ORG_ID 10003
from ar_payment_schedules_all a
where CUSTOMER_TRX_ID in (862920);

/*
    ====================== END OF INVOICE UPDATE =========================
*/

/*
    Invoice Payment Update
*/
select *
from ar_receivable_applications_all
where applied_CUSTOMER_TRX_ID in (862917);


CREATE TABLE ar_cash_receipts_all_VIC_ONG AS ;

select --a.rowid,
       pay_from_customer,  --cust_account_id 15098
       customer_site_use_id  --bill_to_org_id 10003
    
from ar_cash_receipts_all a
where receipt_number = '083137';



/* 
    Query to get customer data
    Note : 
            
*/

SELECT hca.cust_account_id,
            hcasa.site_use_id,
            hcasa.site_use_code,
            hp.party_name customer_name,
            hca.account_number,
            hca.account_name,
            hps.PARTY_SITE_NAME,
            hl.address1 || ' ' || hl.address2 || ' ' || hl.address3 || ' ' || hl.address4 || ' ' || hl.city address,
            hcasa.tax_reference
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
             AND hps.party_site_name = 'DEALERS-FLEET'
             AND hcasa.site_use_code  IN('SHIP_TO','BILL_TO');



select hp.party_id, 
        hp.party_number,
        hp.party_name,
        max(decode(hca.site_use_code, 'BILL_TO', hca.site_use_id, null)) bill_to_org_id,
        max(decode(hca.site_use_code, 'SHIP_TO', hca.site_use_id, null)) ship_to_org_id,
--        hca.site_use_id,
        hca.location,
        hcas.cust_account_id,
        hca.price_list_id
from hz_parties hp,
       hz_party_sites hps,
       hz_cust_acct_sites_all hcas,
       hz_cust_site_uses_all hca
where hp.party_id = hps.party_id
and hps.party_site_id = hcas.party_site_id
and hcas.cust_acct_site_id = hca.cust_acct_site_id
--and party_name like 'ISUZU CEBU INC.'  --= 'GENCARS- BATANGAS INC.'
--and party_name in ('VIC ONG ENTERPRISES', 'ISUZU CEBU INC.')
and party_name = 'ISUZU AUTOMOTIVE DEALERSHIP, INC.'
--and location = 'FLEET'
--and hca.location = 'DEALERS-VEHICLE'
group by hp.party_id, hp.party_number, hp.party_name, hca.location, hcas.cust_account_id, hca.price_list_id
order by hp.party_number;


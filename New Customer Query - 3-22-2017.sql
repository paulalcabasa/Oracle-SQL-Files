select ra_head.customer_trx_id, ra_head.trx_number, ra_head.bill_to_customer_id, ra_head.attribute1, ra_head.bill_to_site_use_id, ra_head.ship_to_customer_id, ra_head.SHIP_TO_SITE_USE_ID 
,ra_line.inventory_item_id, to_char(ra_head.trx_date, 'Month dd, yyyy') trx_date, ra_line.quantity_invoiced, ra_line.unit_selling_price, ra_line.extended_amount, ra_line.tax_recoverable
,ra_head.interface_header_attribute1 SO_NUM
,ra_line.interface_line_attribute3 dr_num
,ra_line.description
,MTT1.serial_number
,msn.attribute1 cs_no
,msn.attribute3 engine_number
,itm.attribute8  body_color
,msn.attribute6 key_no
,itm.attribute13 tire_brand
,itm.attribute21 year_model
from RA_Customer_Trx_All ra_head,
RA_Customer_Trx_Lines_All ra_line,
MTL_SYSTEM_ITEMS itm,
mtl_serial_numbers  msn,
(SELECT mtt.transaction_id,
      mtt.trx_source_line_id,
      mtt.inventory_item_id,
      mtt.organization_id,
      mut.serial_number,
      mtlv.lot_number
 FROM (SELECT *
         FROM MTL_UNIT_TRANSACTIONS_ALL_V
        WHERE TRANSACTION_SOURCE_TYPE_ID = 2) MUT,
      (SELECT *
         FROM MTL_TRANSACTION_LOT_VAL_V
        WHERE transaction_source_type_id = 2 AND STATUS_ID = 1) MTLV,
      (SELECT *
         FROM mtl_material_transactions
        WHERE TRANSACTION_SOURCE_TYPE_ID = 2
              AND TRANSACTION_TYPE_ID = 33) mtt
WHERE     1 = 1
      --and MUT.serial_number = '104-21' and MUT.organization_id = 89 and MUT.inventory_item_id = 18795
      AND mut.transaction_id = mtlv.serial_transaction_id
      AND mtlv.transaction_id = mtt.transaction_id
      AND mtlv.transaction_source_type_id =
             mtt.transaction_source_type_id
      AND mtlv.transaction_source_id = mtt.transaction_source_id
      AND mut.transaction_source_id = mtlv.transaction_source_id) MTT1
where ra_head.customer_trx_id = ra_line.customer_trx_id
and ra_head.org_id = :org_id
and ra_head.org_id = ra_line.org_id
and itm.inventory_item_id = ra_line.inventory_item_id
and itm.organization_id = ra_line.warehouse_id
and ra_line.line_type = 'LINE'
and ra_head.trx_number between NVL(:INV1, ra_head.trx_number) and NVL(:INV2,ra_head.trx_number)
and ra_head.complete_flag = 'Y'
and mtt1.trx_source_line_id = ra_line.interface_line_attribute6
AND msn.serial_number = mtt1.serial_number
AND msn.inventory_item_id = mtt1.inventory_item_id
and ra_line.interface_line_attribute11 = 0;


select distinct taxpayer_id
from ar_customers;
/*
       hz_parties              hp,
       hz_party_sites          hps,
       hz_cust_accounts_all    hca,
       hz_cust_acct_sites_all  hcas,
       hz_customer_profiles    hcp,
       hz_cust_profile_amts    hcpa,
       hz_locations            hl,
       ra_territories          ter,
       ar_collectors           col
*/
SELECT hp.party_name,
            hca.account_number,
            hca.account_name
            hps.party_site_name,
            hcsua.tax_reference,
            hcsua.site_use_code,
            hcsua.tax_code,
FROM hz_cust_accounts_all hca,
         hz_cust_acct_sites_all hcasa,
         hz_party_sites hps,
         hz_cust_site_uses_all hcsua,
         hz_parties hp
where 1 = 1
          AND hca.cust_account_id = hcasa.cust_account_id
          AND hps.party_site_id = hcasa.party_site_id
          AND hcsua.cust_acct_site_id = hcasa.cust_acct_site_id
          AND hp.party_id= hca.party_id
          AND hcsua.site_use_code = 'BILL_TO'
          AND hca.account_number = 1757;

select *
from hz_cust_acct_sites_all
where cust_account_id = 15123;

select *
from hz_party_sites;

select *
from HZ_CUST_SITE_USES_ALL;

select *
from HZ_CUST_SITEs_ALL;

SELECT *
FROM AP_SUPPLLAST_UPDATE_DATELAST_UPDATE_DATEIERS
WHERE SEGMENT1 = 100456;

SELECT *
FROM HZ_PARTIES
WHERE PARTY_ID = 7487;
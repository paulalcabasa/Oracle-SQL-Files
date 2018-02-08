select *
from ra_customer_trx_all
where interface_header_attribute1 = '3010007251';

select *
from  RA_INTERFACE_LINES_all;
where interface_line_id = 548633;

select *
from dbs_picklist_interface
where request_number = '1026028';

select *
from ra_interface_errors_all;

select * from AR_PAYMENT_SCHEDULES_ALL
where TRX_NUMBER = '50100000069';


SELECT * FROM RA_CUSTOMER_TRX_LINES_ALL
WHERE CUSTOMER_TRX_ID = '672789';


SELECT * FROM RA_CUSTOMER_TRX_ALL
WHERE TRX_NUMBER = '50100000069';

select CUST_TRX_TYPE_ID,name,status,CREDIT_MEMO_TYPE_ID
from RA_CUST_TRX_TYPES_all
where credit_memo_type_id = 6081;


SELECT moqv.organization_id,
            org.name organization,
            moqv.inventory_item_id,
            msi.segment1                              part_number,
            msi.description,
            mck.segment1 as item_category_family,
            mck.segment2 as item_category_class,
            msi.item_type,
            moqv.item_cost,
            SUM (transaction_quantity)                target_qty,
            moqv.item_cost * SUM (transaction_quantity) total
FROM mtl_onhand_qty_cost_v moqv, 
          MTL_SYSTEM_ITEMS_B msi,
          hr_all_organization_units org,
          MTL_ITEM_CATEGORIES  mtc,
          mtl_categories_kfv mck,
          FND_LOOKUP_VALUES_VL flv
WHERE  1 = 1
           and moqv.organization_id = :organization
            and moqv.inventory_item_id = msi.inventory_item_id
            and moqv.organization_id = msi.organization_id
            and moqv.organization_id = org.organization_id
            and msi.inventory_item_id = mtc.inventory_item_id
            and mtc.organization_id = msi.organization_id
            and mtc.CATEGORY_ID =mck.CATEGORY_ID  
            and  msi.ITEM_TYPE = FLV.LOOKUP_CODE   
            and  FLV.LOOKUP_TYPE = 'ITEM_TYPE'
            and  MCK.STRUCTURE_ID = '50388'
            and msi.segment1 = '1132402410'
            and mck.segment1 = NVL(:item_category,mck.segment1)
GROUP BY moqv.organization_id,
                moqv.inventory_item_id,
                msi.description,
                msi.segment1,
                moqv.item_cost,
                org.name,
                mck.segment1,
                mck.segment2,
                msi.item_type;
                
       select distinct segment1
from mtl_categories_kfv;         
                -- ITEM CATEGORY (OPTIONAL)
                
                SELECT *
                FROM HR_ALL_ORGANIZATION_UNITS;


select *
from hr_all_organization_units;
-- CREDIT_MEMO_TYPE_ID
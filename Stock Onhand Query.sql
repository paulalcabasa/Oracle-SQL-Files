SELECT moqv.organization_id,
            org.name organization,
            moqv.inventory_item_id,
            msi.segment1                              part_number,
            msi.description,
            mck.segment1 as item_category_family,
            mck.segment2 as item_category_class,
            msi.item_type,
            moqv.item_cost,
            SUM (moqv.transaction_quantity)                target_qty,
            moqv.item_cost * SUM (transaction_quantity) total,
            (select to_char(max(mmt.transaction_date))
             from mtl_material_transactions mmt
             where 1 = 1
                       and mmt.organization_id = nvl(:organization,mmt.organization_id)
                       and mmt.transaction_type_id IN(18) -- PO RECEIPT
                       and mmt.inventory_item_id = moqv.inventory_item_id) last_purchase_date,
            /*          
                1. Miscellaneous issue - 32
                2. Sales order issue - 33
                3. Internal order issue - 34
                4. WIP Issue - 35
                5. Move Order Issue - 63
            */           
             (select to_char(max(mmt.transaction_date))
              from mtl_material_transactions mmt
              where 1 = 1
                       and mmt.organization_id = nvl(:organization,mmt.organization_id)
                       and mmt.transaction_type_id IN(32,33,34,35,63) -- ISSUANCE
                       and mmt.inventory_item_id = moqv.inventory_item_id) last_movement_date
FROM mtl_onhand_qty_cost_v moqv, 
          MTL_SYSTEM_ITEMS_B msi,
          hr_all_organization_units org,
          MTL_ITEM_CATEGORIES  mtc,
          mtl_categories_kfv mck,
          FND_LOOKUP_VALUES_VL flv
WHERE  1 = 1
            and moqv.inventory_item_id = msi.inventory_item_id
            and moqv.organization_id = msi.organization_id
            and moqv.organization_id = org.organization_id
            and msi.inventory_item_id = mtc.inventory_item_id
            and mtc.organization_id = msi.organization_id
            and mtc.CATEGORY_ID =mck.CATEGORY_ID  
            and  msi.ITEM_TYPE = FLV.LOOKUP_CODE   
            and  FLV.LOOKUP_TYPE = 'ITEM_TYPE'
            and  MCK.STRUCTURE_ID = '50388'
            and moqv.organization_id = nvl(:organization,moqv.organization_id)
            and mck.segment1 = NVL(:item_category,mck.segment1)
            and to_date(moqv.creation_date, 'yyyy/mm/dd hh24:mi:ss') <= TO_DATE(NVL(:as_of,moqv.creation_date), 'yyyy/mm/dd hh24:mi:ss') 
GROUP BY moqv.organization_id,
                moqv.inventory_item_id,
                msi.description,
                msi.segment1,
                moqv.item_cost,
                org.name,
                mck.segment1,
                mck.segment2,
                msi.item_type;

select max(mmt.transaction_date)
from mtl_material_transactions mmt
where 1 = 1
          and mmt.organization_id = nvl(:organization,mmt.organization_id)
          and mmt.transaction_type_id = 18 -- PO RECEIPT
          and mmt.inventory_item_id = 100259;


select mmt.transaction_id,
         mmt.organization_id,
         mmt.subinventory_code,
         mmt.transaction_quantity,
         mmt.primary_quantity,
         mmt.transaction_date,
         mtt.transaction_type_name,
         mmt.source_code,
         mmt.inventory_item_id,
         mmt.transaction_date
from mtl_material_transactions mmt,
        mtl_transaction_types mtt
where 1 = 1
          and mmt.transaction_type_id = mtt.transaction_type_id
          and mmt.organization_id = 102
          and mmt.inventory_item_id = 99476;

select *
from mtl_material_transactions
where inventory_item_id = 116040;

select *
from ra_customer_trx_all
where attribute1 = '1342';

select *
from hr_all_organization_units;

SELECT *
FROM PO_LINES_ALL POL, 
         PO_HEADERS_ALL POH, 
         PO_LINES_ARCHIVE_ALL POA
WHERE 1 = 1 
            AND POA.PO_LINE_ID = POL.PO_LINE_ID
            AND POA.PO_HEADER_ID = POH.PO_HEADER_ID
            AND pol.item_id = 116040;
            
            select distinct transaction_type_id,transaction_type_name
            from mtl_transaction_types
            order by transaction_type_id;
            
            /* Movement / Issuance
                1. Miscellaneous issue - 32
                2. Sales order issue - 33
                3. Internal order issue - 34
                4. WIP Issue - 35
                5. Move Order Issue - 63
           */
           
           /* Last Purchase Date
               1. PO Receipt 18
           */
           
           
           (select distinct segment1,enabled_flag,structure_id from mtl_categories_kfv) WHERE enabled_flag = 'Y' 
            AND STRUCTURE_ID = '50388');
            
            select *
            from ra_customer_trx_all
                where trx_number = '1269';
                
          SELECT moqv.organization_id,
            org.name organization,
            moqv.inventory_item_id,
            msi.segment1                              part_number,
            msi.description,
            mck.segment1 as item_category_family,
            mck.segment2 as item_category_class,
            msi.item_type,
            moqv.item_cost,
            SUM (moqv.transaction_quantity)                target_qty,
            moqv.item_cost * SUM (transaction_quantity) total,
            (select to_char(max(mmt.transaction_date))
             from mtl_material_transactions mmt
             where 1 = 1
                       and mmt.organization_id = nvl(:organization,mmt.organization_id)
                       and mmt.transaction_type_id IN(18) -- PO RECEIPT
                       and mmt.inventory_item_id = moqv.inventory_item_id) last_purchase_date,
            /*          
                1. Miscellaneous issue - 32
                2. Sales order issue - 33
                3. Internal order issue - 34
                4. WIP Issue - 35
                5. Move Order Issue - 63
            */           
             (select to_char(max(mmt.transaction_date))
              from mtl_material_transactions mmt
              where 1 = 1
                       and mmt.organization_id = nvl(:organization,mmt.organization_id)
                       and mmt.transaction_type_id IN(32,33,34,35,63) -- ISSUANCE
                       and mmt.inventory_item_id = moqv.inventory_item_id) last_movement_date
FROM mtl_onhand_qty_cost_v moqv, 
          MTL_SYSTEM_ITEMS_B msi,
          hr_all_organization_units org,
          MTL_ITEM_CATEGORIES  mtc,
          mtl_categories_kfv mck,
          FND_LOOKUP_VALUES_VL flv
WHERE  1 = 1
            and moqv.inventory_item_id = msi.inventory_item_id
            and moqv.organization_id = msi.organization_id
            and moqv.organization_id = org.organization_id
            and msi.inventory_item_id = mtc.inventory_item_id
            and mtc.organization_id = msi.organization_id
            and mtc.CATEGORY_ID =mck.CATEGORY_ID  
            and  msi.ITEM_TYPE = FLV.LOOKUP_CODE   
            and  FLV.LOOKUP_TYPE = 'ITEM_TYPE'
            and  MCK.STRUCTURE_ID = '50388'
            and moqv.organization_id = nvl(:organization,moqv.organization_id)
        --    and msi.segment1 = '1142152170'
            and mck.segment1 = NVL(:item_category,mck.segment1)
            and to_date(moqv.creation_date, 'yyyy/mm/dd hh24:mi:ss') <= TO_DATE(NVL(:as_of,moqv.creation_date), 'yyyy/mm/dd hh24:mi:ss') 
GROUP BY moqv.organization_id,
                moqv.inventory_item_id,
                msi.description,
                msi.segment1,
                moqv.item_cost,
                org.name,
                mck.segment1,
                mck.segment2,
                msi.item_type;
                
                SELECT *
                FROM XXIPC_ONHAND_CATEGORY
                WHERE ORGANIZATION_ID = 87;
                
                
CREATE or replace VIEW XXIPC_ONHAND_CATEGORY AS SELECT distinct 
            mck.segment1,
            moqv.organization_id
FROM   mtl_onhand_qty_cost_v moqv, 
            MTL_SYSTEM_ITEMS_B msi,
            hr_all_organization_units org,
            MTL_ITEM_CATEGORIES  mtc,
            mtl_categories_kfv mck,
            FND_LOOKUP_VALUES_VL flv
WHERE  1 = 1
            and moqv.inventory_item_id = msi.inventory_item_id
            and moqv.organization_id = msi.organization_id
            and moqv.organization_id = org.organization_id
            and msi.inventory_item_id = mtc.inventory_item_id
            and mtc.organization_id = msi.organization_id
            and mtc.CATEGORY_ID =mck.CATEGORY_ID  
            and  msi.ITEM_TYPE = FLV.LOOKUP_CODE   
            and  FLV.LOOKUP_TYPE = 'ITEM_TYPE'
            and  MCK.STRUCTURE_ID = '50388'
            GROUP BY mck.segment1,
            moqv.organization_id;
                
                --    and moqv.organization_id = nvl(:organization,moqv.organization_id)
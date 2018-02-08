/* Formatted on 10/7/2017 11:05:04 AM (QP5 v5.163.1008.3004) */
  SELECT TRANSACTION_COSTED_DATE,
         TRANSACTION_DATE,
         PRIMARY_QUANTITY,
         ACTUAL_COST,
         NEW_QUANTITY,
         NEW_COST,
         PRIOR_COSTED_QUANTITY,
         PRIOR_COST,
         TRANSACTION_TYPE,
         COST_GROUP_ID,
         INVENTORY_ITEM_ID,
         ORGANIZATION_ID,
         TRANSACTION_ID,
         CHANGE,
         ACTUAL_MATERIAL,
         ACTUAL_MATERIAL_OVERHEAD,
         ACTUAL_RESOURCE,
         ACTUAL_OUTSIDE_PROCESSING,
         ACTUAL_OVERHEAD,
         NEW_MATERIAL,
         NEW_MATERIAL_OVERHEAD,
         NEW_RESOURCE,
         NEW_OUTSIDE_PROCESSING,
         NEW_OVERHEAD,
         PRIOR_MATERIAL,
         PRIOR_MATERIAL_OVERHEAD,
         PRIOR_RESOURCE,
         PRIOR_OUTSIDE_PROCESSING,
         PRIOR_OVERHEAD,
         transaction_id
    FROM CST_CG_COST_HISTORY_V
   WHERE     organization_id = 88
         AND inventory_item_id = 435233
         AND cost_group_id = 2000
         AND TRANSACTION_COSTED_DATE >=  TO_DATE ('2017/06/30 00:00:00', 'YYYY/MM/DD HH24:MI:SS')
         and     TRANSACTION_COSTED_DATE <=  TO_DATE ('2017/06/30 23:59:00', 'YYYY/MM/DD HH24:MI:SS')
                                 
      --   AND (COST_GROUP_ID = 2000)
         AND (INVENTORY_ITEM_ID = 435233)
         AND (ORGANIZATION_ID = 88)
ORDER BY TRANSACTION_COSTED_DATE desc
--         TRANSACTION_DATE DESC,
--         CREATION_DATE DESC,
--         TRANSACTION_ID DESC,
--         PRIMARY_QUANTITY;

;;




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
          mtl_item_categories  mtc,
          mtl_categories_kfv mck,
          fnd_lookup_values_vl flv
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
           
     
                
SELECT-- to_char(mcd.transaction_costed_date),
      --      msi.organization_id,
            org.name organization,
            msi.segment1 part_number,
            msi.description,
            mck.segment1 item_category_family,
            mck.segment2 item_category_class,
            msi.item_type,
            --    mcd.transaction_id, 
            --   msi.concatenated_segments item_code,
            --    mmt.transaction_date,
            --  mtt.transaction_type_name,
            --       mmt.transaction_quantity,
                        
            sum(mcd.actual_cost) actual_cost,
            --    sum(mcd.prior_cost) prior_cost,
            --      sum(mcd.new_cost) new_cost
            mcd.new_quantity,
            (select to_char(max(mmt.transaction_date))
                 from mtl_material_transactions mmt
                 where 1 = 1
                           and mmt.organization_id = nvl(:organization,mmt.organization_id)
                           and mmt.transaction_type_id IN(18) -- PO RECEIPT
                           and mmt.inventory_item_id = mcd.inventory_item_id) last_purchase_date,
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
                       and mmt.inventory_item_id = mcd.inventory_item_id) last_movement_date
FROM  cst_cg_cost_history_v mcd,
          mtl_system_items_kfv msi,
          mtl_material_transactions mmt,
          mtl_transaction_types mtt,
          hr_all_organization_units org,
          -- item
            mtl_item_categories  mtc,
            mtl_categories_kfv mck,
            fnd_lookup_values_vl flv

WHERE 1 = 1
            -- COST
            and mcd.inventory_item_id = msi.inventory_item_id
            and mcd.organization_id = msi.organization_id
            and mcd.transaction_id = mmt.transaction_id
            and mmt.inventory_item_id = msi.inventory_item_id
            and mmt.organization_id = msi.organization_id
            and mmt.transaction_type_id = mtt.transaction_type_id
         --   and msi.inventory_item_id = 435233
            and msi.organization_id = :organization
            -- ORG
            and org.organization_id = msi.organization_id
            -- ITEM
             and msi.inventory_item_id = mtc.inventory_item_id
            and mtc.organization_id = msi.organization_id
            and mtc.category_id =mck.category_id  
            and  msi.item_type = flv.lookup_code   
            and  flv.lookup_type = 'ITEM_TYPE'
            and  mck.structure_id = '50388'
            -- FILTERS
        --    and trunc(mcd.transaction_costed_date) between '30-JUN-2017' and '30-JUN-2017'
            and mck.segment1 = NVL(:item_category,mck.segment1)
            and to_date(mcd.transaction_costed_date) 
                  between  TO_DATE(NVL(:start_date,mcd.transaction_costed_date), 'yyyy/mm/dd hh24:mi:ss') 
                                and TO_DATE(NVL(:end_date,:start_date), 'yyyy/mm/dd hh24:mi:ss')
            
            and mcd.transaction_id = (
                                                        select max(transaction_id) 
                                                        from mtl_cst_actual_cost_details 
                                                        where to_date(transaction_costed_date) 
                                                                between  TO_DATE(NVL(:start_date,mcd.transaction_costed_date), 'yyyy/mm/dd hh24:mi:ss') 
                                                                and TO_DATE(NVL(:end_date,:start_date), 'yyyy/mm/dd hh24:mi:ss')
                                                        and inventory_item_id = msi.inventory_item_id
                                                        and organization_id = msi.organization_id
                                                  )
group by
            mcd.transaction_id, 
            msi.concatenated_segments,
            mmt.transaction_date,
            mtt.transaction_type_name,
            mmt.transaction_quantity,
            org.name,
            msi.organization_id,
             msi.segment1 ,
            msi.description,
            mck.segment1 ,
            mck.segment2  ,
            msi.item_type,
            mcd.new_quantity,
            mcd.transaction_costed_date,
            mcd.inventory_item_id;
-- ORDER BY mcd.creation_date DESC;

select *
from ar_Cash_receipts_all
where doc_sequence_value ='70100007772 ';

SELECT    decode(:end_date,NULL, 
                            trunc(sysdate), 
                            to_date(:end_date, 'yyyy/mm/dd hh24:mi:ss')
                 ) start_date,
                
                decode(:end_date,NULL, 
                            trunc(sysdate), 
                            to_date(:end_date, 'yyyy/mm/dd hh24:mi:ss')
                 ) end_date
FROM DUAL;


            select *
                                                        from mtl_cst_actual_cost_details 
                                                        where transaction_costed_date >= TO_DATE(NVL(:as_of,transaction_costed_date), 'yyyy/mm/dd hh24:mi:ss')
                                                        and inventory_item_id =435233
                                                        and organization_id = 88;


/* Formatted on 11/7/2017 1:18:32 PM (QP5 v5.163.1008.3004) */
  SELECT TRANSACTION_COSTED_DATE,
         TRANSACTION_DATE,
         PRIMARY_QUANTITY,
         ACTUAL_COST,
         NEW_QUANTITY,
         NEW_COST,
         PRIOR_COSTED_QUANTITY,
         PRIOR_COST,
         TRANSACTION_TYPE,
         COST_GROUP_ID,
         INVENTORY_ITEM_ID,
         ORGANIZATION_ID,
         TRANSACTION_ID,
         CHANGE,
         ACTUAL_MATERIAL,
         ACTUAL_MATERIAL_OVERHEAD,
         ACTUAL_RESOURCE,
         ACTUAL_OUTSIDE_PROCESSING,
         ACTUAL_OVERHEAD,
         NEW_MATERIAL,
         NEW_MATERIAL_OVERHEAD,
         NEW_RESOURCE,
         NEW_OUTSIDE_PROCESSING,
         NEW_OVERHEAD,
         PRIOR_MATERIAL,
         PRIOR_MATERIAL_OVERHEAD,
         PRIOR_RESOURCE,
         PRIOR_OUTSIDE_PROCESSING,
         PRIOR_OVERHEAD
    FROM CST_CG_COST_HISTORY_V
   WHERE     organization_id = 88
         AND inventory_item_id = 435233
         AND cost_group_id = 2000
         AND (TRANSACTION_DATE BETWEEN TO_DATE ('2017/06/30 00:00:00',
                                                'YYYY/MM/DD HH24:MI:SS')
                                   AND TO_DATE ('2017/06/30 23:59:59',
                                                'YYYY/MM/DD HH24:MI:SS'))
         AND (COST_GROUP_ID = 2000)
         AND (INVENTORY_ITEM_ID = 435233)
         AND (ORGANIZATION_ID = 88)
ORDER BY TRANSACTION_COSTED_DATE DESC,
         TRANSACTION_DATE DESC,
         CREATION_DATE DESC,
         TRANSACTION_ID DESC,
         PRIMARY_QUANTITY;
         
         
         select receipt_number
         from ar_cash_receipts_all
         where doc_sequence_value like '701%7772';
         
select *
from hr_all_organization_units;

select rcta.trx_number,
         rctta.name,
         msib.segment1 part_no,
         rctla.description
from ra_customer_trx_all rcta,
        ra_customer_trx_lines_all rctla,
        ra_cust_trx_types_all rctta,
        mtl_system_items_b msib
where 1 = 1
          and rcta.customer_trx_id = rctla.customer_trx_id
          and rctta.cust_trx_type_id = rcta.cust_trx_type_id
          and msib.inventory_item_id = rctla.inventory_item_id
          and msib.organization_id = rctla.warehouse_id
          and rctla.warehouse_id = 90;
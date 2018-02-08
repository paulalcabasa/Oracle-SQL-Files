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

;

select * from (select *
from CST_CG_COST_HISTORY_V
where inventory_item_id = 435233
and organization_id = 88
and to_Date(transaction_costed_date) >= to_date(NVL(:start_date,transaction_costed_date),'yyyy/mm/dd hh24:mi:ss')
 ORDER BY transaction_id desc
--and transaction_id = 4269960
) where rownum = 1;

select *
from cst_cost_types;

select *
from cst_item_costs
where inventory_item_id = 435233;


SELECT moqv.organization_id,
            org.name organization,
            moqv.inventory_item_id,
            msi.segment1                              part_number,
            msi.description,
            mck.segment1 as item_category_family,
            mck.segment2 as item_category_class,
            msi.item_type,
            apps.ipc_get_item_cost(:as_of,moqv.inventory_item_id,moqv.organization_id) item_cost,
            apps.ipc_get_item_quantity(:as_of,moqv.inventory_item_id,moqv.organization_id) target_qty,
       
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
    
-- cost query function
select new_quantity 
from (select new_quantity
        from cst_cg_cost_history_v mcd
        where    1 = 1
                    and mcd.inventory_item_id = 99905
                    and mcd.organization_id = 106
                    and to_date(mcd.transaction_costed_date) <= to_date(nvl(:as_of,transaction_costed_date),'yyyy/mm/dd hh24:mi:ss')
order by mcd.transaction_id desc)
where rownum < 2;
                
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
            and msi.segment1 = '9885132653'
           
--            and to_date(mcd.transaction_costed_date) 
--                  between  TO_DATE(NVL(:start_date,mcd.transaction_costed_date), 'yyyy/mm/dd hh24:mi:ss') 
--                                and TO_DATE(NVL(:end_date,:start_date), 'yyyy/mm/dd hh24:mi:ss')
--            
--            and mcd.transaction_id = (
--                                                        select max(transaction_id) 
--                                                        from mtl_cst_actual_cost_details 
--                                                        where to_date(transaction_costed_date) 
--                                                                between  TO_DATE(NVL(:start_date,mcd.transaction_costed_date), 'yyyy/mm/dd hh24:mi:ss') 
--                                                                and TO_DATE(NVL(:end_date,:start_date), 'yyyy/mm/dd hh24:mi:ss')
--                                                        and inventory_item_id = msi.inventory_item_id
--                                                        and organization_id = msi.organization_id
--                                                  )
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

select 

select *
from hr_all_organization_units;

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
          
          
          
          
          
          
          SELECT &P_ITEM_SEG IC_ITEM_NUMBER
,      &P_CAT_SEG IC_CATEGORY
,      MSI.description IC_DESCRIPTION
,      MSI.primary_uom_code IC_UOM
,      MSI.inventory_item_status_code IC_ITEM_STATUS
,      LU3.meaning IC_INV_ASSET
,      LU1.meaning IC_MAKE_BUY
,      DECODE(MSI.inventory_planning_code
,           6, LU5.meaning, LU2.meaning) IC_PLANNING_METHOD
,      CIQT.subinventory_code IC_SUBINV
,      decode(CIQT.subinventory_code,NULL,'Intransit','On-hand') IC_TYPE
,      DECODE(:P_ITEM_REVISION, 1, CIQT.revision, NULL) IC_REVISION
,      SEC.description IC_SUBINV_DESC
,      SEC.asset_inventory IC_ASSET_SUBINV
,      NVL(LU4.meaning,'Yes') IC_ASSET_SUBINV_DSP
,      ROUND(NVL(CIQT.rollback_qty,0),:P_qty_precision) IC_QTY
--BUG#5768615
,      ROUND((NVL(CICT.item_cost,0)*:P_EXCHANGE_RATE), :P_EXT_PREC) IC_UNIT_COST
,      DECODE(CICT.cost_type_id, :P_COST_TYPE_ID, ' ', '*') IC_DEFAULTED
,      NVL(CIQT.rollback_qty,0) *
--BUG#5768615
            DECODE(NVL(SEC.asset_inventory,1), 1, NVL(CICT.item_cost,0), 0) *
            :P_EXCHANGE_RATE  IC_TOTAL_COST
FROM    mfg_lookups LU5
,       mfg_lookups LU4
,       mfg_lookups LU3
,       mfg_lookups LU2
,       mfg_lookups LU1
,       mtl_categories_b MC
,       mtl_system_items_vl MSI
,       mtl_secondary_inventories SEC
,       cst_inv_qty_temp CIQT
,       cst_inv_cost_temp  CICT
,       mtl_parameters MP
,       cst_item_costs CIC
WHERE   MSI.organization_id = CIQT.organization_id
AND     MSI.inventory_item_id = CIQT.inventory_item_id
AND     MP.organization_id = CIQT.organization_id
AND     CICT.organization_id = CIQT.organization_id 
and     CICT.inventory_item_id = CIQT.inventory_item_id 
and     (CICT.cost_group_id = CIQT.cost_group_id 
      OR MP.primary_cost_method = 1)
AND     &P_SUBINV_WHERE
AND     &P_SUB_INV_SEC
AND     MC.category_id = CIQT.category_id
AND     LU1.lookup_type(+) = 'MTL_PLANNING_MAKE_BUY'
AND     LU1.lookup_code(+) = MSI.planning_make_buy_code
AND     LU2.lookup_type = 'MTL_MATERIAL_PLANNING'
AND     LU2.lookup_code = NVL(MSI.inventory_planning_code,6)
AND     LU3.lookup_type = 'SYS_YES_NO'
AND     LU3.lookup_code = CICT.inventory_asset_flag
AND     LU4.lookup_type(+) = 'SYS_YES_NO'
AND     LU4.lookup_code(+) = SEC.asset_inventory
AND     LU5.lookup_type = 'MRP_PLANNING_CODE'
AND     LU5.lookup_code = NVL(MSI.mrp_planning_code,6)
AND     CIC.organization_id = MP.cost_organization_id
AND     CIC.inventory_item_id = CIQT.inventory_item_id
AND      CIC.cost_type_id = CICT.cost_type_id;



SELECT mp.organization_code,
            msi.segment1 part_number,
            msi.description,
            mck.segment1 item_category_family,
            mck.segment2 item_category_class,
            msi.item_type,
            to_number(apps.ipc_get_item_cost(:as_of,msi.inventory_item_id,:p_organization_id)) item_cost,
            to_number(apps.ipc_get_item_quantity(:as_of,msi.inventory_item_id,:p_organization_id)) quantity,
            apps.ipc_get_item_last_purch_date(msi.inventory_item_id,:p_organization_id) last_purchase_date,
            apps.ipc_get_item_last_mvmt_date(msi.inventory_item_id,:p_organization_id) last_movement_date
FROM cst_cost_types cct,
            cst_item_costs cic,
            mtl_system_items_b msi,
            mtl_parameters mp,
            mtl_item_categories  mtc,
            mtl_categories_kfv mck,
            fnd_lookup_values_vl flv
WHERE cct.cost_type_id    = cic.cost_type_id
            and cic.inventory_item_id = msi.inventory_item_id
            and cic.organization_id   = msi.organization_id
            and msi.organization_id   = mp.organization_id
            and msi.inventory_item_id = mtc.inventory_item_id
            and mtc.organization_id = msi.organization_id
            and mtc.category_id =mck.category_id  
            and  msi.item_type = flv.lookup_code   
            and  flv.lookup_type = 'ITEM_TYPE'
            and  mck.structure_id = '50388'
            and mck.segment1 = NVL(:item_category,mck.segment1)
            and mp.organization_id    = :p_organization_id
            and cct.cost_type_id         = :p_cost_type_id;
  
  select *
  from cst_cost_types;
  

select aia.invoice_num,
         pla.line_num,
         aia.doc_sequence_value,
         aila.description,
         aila.quantity_invoiced
      --   aila.quantity_billed
from ap_invoices_all aia,
        ap_invoice_lines_all aila,
        po_headers_all pha,
        po_lines_all pla
where 1 = 1
          and aia.invoice_id = aila.invoice_id
          and pha.po_header_id = aila.po_header_id
          and pla.po_header_id = pha.po_header_id
          and aila.po_line_id = pla.po_line_id
          and line_num = 2
          and pha.segment1 = '20100002810';
          
          SELECT mp.organization_code,
            msi.segment1 part_number,
            msi.description,
            mck.segment1 item_category_family,
            mck.segment2 item_category_class,
            msi.item_type,
            to_number(apps.ipc_get_item_cost(:as_of,msi.inventory_item_id,:p_organization_id)) item_cost,
            to_number(apps.ipc_get_item_quantity(:as_of,msi.inventory_item_id,:p_organization_id)) quantity,
            apps.ipc_get_item_last_purch_date(msi.inventory_item_id,:p_organization_id) last_purchase_date,
            apps.ipc_get_item_last_mvmt_date(msi.inventory_item_id,:p_organization_id) last_movement_date
FROM cst_cost_types cct,
            cst_item_costs cic,
            mtl_system_items_b msi,
            mtl_parameters mp,
            mtl_item_categories  mtc,
            mtl_categories_kfv mck,
            fnd_lookup_values_vl flv
WHERE cct.cost_type_id    = cic.cost_type_id
            and cic.inventory_item_id = msi.inventory_item_id
            and cic.organization_id   = msi.organization_id
            and msi.organization_id   = mp.organization_id
            and msi.inventory_item_id = mtc.inventory_item_id
            and mtc.organization_id = msi.organization_id
            and mtc.category_id =mck.category_id  
            and  msi.item_type = flv.lookup_code   
            and  flv.lookup_type = 'ITEM_TYPE'
            and  mck.structure_id = '50388'
            and mck.segment1 = NVL(:item_category,mck.segment1)
            and mp.organization_id    = :p_organization_id
            and cct.cost_type         = nvl(:p_cost_type,cct.cost_type);
            
SELECT mp.organization_id,
            mp.organization_code,
            hr.name organization_name
FROM mtl_parameters mp,
          hr_all_organization_units hr
where mp.organization_id = hr.organization_id
and hr.date_to is null
and mp.organization_id <> 86;
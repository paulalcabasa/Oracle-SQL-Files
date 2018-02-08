select 
       a.jo_number,
       a.lot_number,
       a.serial_number as cs_number,
       a.item,
       a.description,       
       a.item_category_family,
       a.item_category_class,
       a.item_type,
       to_date(wip_completion_date) as wip_completion_date,
       sum(decode(trans_name, 'WIP Completion', actual_cost, null)) "WIP Completion Cost",
       sum(decode(trans_name, 'Sales order issue', actual_cost, null)) "Sales order issue Cost",
       sum(decode(trans_name, 'Direct Org Transfer FG - VSS', actual_cost, null)) "FG - VSS",
       sum(decode(trans_name, 'Direct Org Transfer VSS - FG', actual_cost, null)) "VSS - FG",
       sum(decode(trans_name, 'Direct Org Transfer NYK - VSS', actual_cost, null)) "NYK - VSS",       
       sum(decode(trans_name, 'Direct Org Transfer VSS - NYK', actual_cost, null)) "VSS - NYK",
    b.invoice_amount,
    b.cogs_amount
from 
(SELECT  
       mmt.inventory_item_id,
          msib.segment1 as item,
    msib.description,       
        mck.segment1  as item_category_family,
    mck.segment2  AS item_category_class,
    msib.item_type,
    min(mmt.transaction_date) OVER(PARTITION BY serial_number) as wip_completion_date,
(CASE
           WHEN b.transaction_type_name = 'Direct Org Transfer'
              THEN    b.transaction_type_name
                   || ' '
                   || (CASE
                          WHEN mmt.transfer_subinventory IS NULL
                             THEN mmt.subinventory_code
                          ELSE    mmt.subinventory_code
                               || ' - '
                               || mmt.transfer_subinventory
                       END
                      )
           ELSE b.transaction_type_name
        END
       ) trans_name,
       mmt.organization_id, mmt.subinventory_code,
       mmt.transfer_organization_id, mmt.transfer_subinventory,
       TO_DATE (mmt.transaction_date) transaction_date,
       CASE
          WHEN b.transaction_type_name = 'WIP Completion'
             THEN mmt.transaction_date
       END AS new_date,
       mut.serial_number, mmt.transaction_id, mmt.transaction_type_id,
       b.transaction_type_name, mmt.actual_cost, mmt.transaction_quantity,
       (SELECT b.wip_entity_name
          FROM mtl_serial_numbers a, wip_discrete_jobs_v b
         WHERE a.original_wip_entity_id = b.wip_entity_id
           AND a.attribute5 IS NOT NULL
           AND a.c_attribute30 IS NULL
           AND a.serial_number = mut.serial_number) AS jo_number,
        '' as lot_number
  FROM mtl_material_transactions mmt,
       mtl_unit_transactions mut,
       mtl_transaction_types b,
        mtl_system_items_b      msib,
        mtl_categories_kfv      mck,
        MTL_ITEM_CATEGORIES     mtc
 WHERE 
  mmt.inventory_item_id = msib.inventory_item_id
         AND mmt.organization_id = msib.organization_id and
 mmt.transaction_id = mut.transaction_id
   AND mmt.transaction_type_id = b.transaction_type_id
   AND mmt.transaction_type_id IN (3, 44, 33)
   AND mtc.CATEGORY_ID = mck.CATEGORY_ID
   AND MCK.STRUCTURE_ID = '50388'
   and   msib.inventory_item_id = mtc.inventory_item_id
     AND mmt.organization_id = mtc.organization_id
UNION
SELECT
       mmt.inventory_item_id,
          msib.segment1 as item,
    msib.description,
        mck.segment1  as item_category_family,
    mck.segment2  AS item_category_class,
    msib.item_type,
         min(mmt.transaction_date) OVER(PARTITION BY serial_number) as wip_completion_date,(CASE
           WHEN b.transaction_type_name = 'Direct Org Transfer'
              THEN    b.transaction_type_name
                   || ' '
                   || (CASE
                          WHEN mmt.transfer_subinventory IS NULL
                             THEN mmt.subinventory_code
                          ELSE    mmt.subinventory_code
                               || ' - '
                               || mmt.transfer_subinventory
                       END
                      )
           ELSE b.transaction_type_name
        END
       ) trans_name,
       mmt.organization_id, mmt.subinventory_code,
       mmt.transfer_organization_id, mmt.transfer_subinventory,
       TO_DATE (mmt.transaction_date) transaction_date,
       CASE
          WHEN b.transaction_type_name = 'WIP Completion'
             THEN mmt.transaction_date
       END AS new_date,
       mut.serial_number, mmt.transaction_id, mmt.transaction_type_id,
       b.transaction_type_name, mmt.actual_cost, mmt.transaction_quantity,
       (SELECT b.wip_entity_name
          FROM mtl_serial_numbers a, wip_discrete_jobs_v b
         WHERE a.original_wip_entity_id = b.wip_entity_id
           AND a.attribute5 IS NOT NULL
           AND a.c_attribute30 IS NULL
           AND a.serial_number = mut.serial_number) AS jo_number,
       lot_number
  FROM mtl_material_transactions mmt,
       mtl_transaction_lot_numbers mtln,
       mtl_unit_transactions mut,
       mtl_transaction_types b ,
          mtl_system_items_b      msib,
          mtl_categories_kfv      mck,
          MTL_ITEM_CATEGORIES     mtc
 WHERE 
  mmt.inventory_item_id = msib.inventory_item_id
         AND mmt.organization_id = msib.organization_id and mmt.transaction_id = mtln.transaction_id
   AND mtln.serial_transaction_id = mut.transaction_id
   AND mmt.transaction_type_id = b.transaction_type_id
   AND mmt.transaction_type_id IN (3, 44, 33)
   AND mtc.CATEGORY_ID = mck.CATEGORY_ID
    and  msib.inventory_item_id = mtc.inventory_item_id
     AND mmt.organization_id = mtc.organization_id
   AND MCK.STRUCTURE_ID = '50388'

) a,
ipc_sales_vs_cogs_v b
where 
a.serial_number = b.cs_number(+)
and a.jo_number is not null  
and trunc(wip_completion_date) between  TO_DATE (:p_start, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:p_end, 'yyyy/mm/dd hh24:mi:ss')

--and  cs_number in ('D0I628','D0H444')
group by
a.jo_number,
       a.lot_number,
       a.serial_number,
       a.item,
       a.description,       
       a.item_category_family,
       a.item_category_class,
          a.item_type,
       a.wip_completion_date,
       a.inventory_item_id,
       b.invoice_amount,
       b.cogs_amount
       
       
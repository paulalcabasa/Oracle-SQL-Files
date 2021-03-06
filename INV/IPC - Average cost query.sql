/* Formatted on 27/9/2017 8:02:28 AM (QP5 v5.163.1008.3004) */

SELECT   
                organization_name,
                item_code,
                description,
                item_category_family,
                uom,
                subinventory_code,
                item_cost as unit_cost,
                on_hand_quantity,
                total_cost as total_inventory_value,
                registration_date,
                sales_price,
                :p_date as cut_off_date,
                to_date(last_purchase_date) as last_purchase_date,
                to_date(last_movement_date) as last_sales_date,
                case 
                    when IPC_GET_AVG_AGING(last_movement_date,last_purchase_date,:p_date) between 0 AND 30 then nvl(total_cost,0)  
                end "0-30 Days",
                case 
                    when IPC_GET_AVG_AGING(last_movement_date,last_purchase_date,:p_date) between 31 AND 60 then nvl(total_cost,0)  
                end "31-60 Days",
                case 
                    when IPC_GET_AVG_AGING(last_movement_date,last_purchase_date,:p_date) between 61 AND 90 then nvl(total_cost,0)  
                end "61-90 Days",
                case 
                    when IPC_GET_AVG_AGING(last_movement_date,last_purchase_date,:p_date) > 90 then nvl(total_cost,0)  
                end "Over 90 Days"
                
--                CASE 
--                    WHEN  TO_DATE(last_movement_date) IS NULL THEN TO_DATE(:p_date) - TO_DATE(last_purchase_date)
--                    ELSE  TO_DATE(:p_date) - TO_DATE(last_movement_date)
--                END aging
FROM (
            SELECT msi.organization_id,
                        ood.organization_code,
                        ood.organization_name,
                        msi.inventory_item_id,
                        msi.creation_date AS registration_date,
                        msi.segment1 AS item_code,
                        msi.description,
                        msi.item_type,
                        flv.meaning AS item_type_description,
                        mck.segment1 AS item_category_family,
                        mck.segment2 AS item_category_class,
                        msi.primary_unit_of_measure AS uom,
                        mmt.subinventory_code,
                        cct.cost_type,
                        cct.description AS cost_type_description,
                     -- cic.item_cost, --current item cost
                     ipc_get_new_item_cost (:p_date,
                                            msi.inventory_item_id,
                                            msi.organization_id)
                        AS item_cost,
                     SUM (mmt.primary_quantity) AS on_hand_quantity,
                     wsp.price sales_price,
--                    IPC_GET_ITEM_PRICE(msi.inventory_item_id,msi.organization_id) as sales_price,
                     -- (SUM (mmt.primary_quantity)* cic.item_cost) AS total_cost --current cost total value
                     (SUM (mmt.primary_quantity)
                      * (ipc_get_new_item_cost (:p_date,
                                                msi.inventory_item_id, 
                                                msi.organization_id)))
                        AS total_cost,
                        to_date(:p_date) - to_date(max(mmt.transaction_date)) no_of_days,
                        CASE 
                            WHEN mmt.transaction_type_id not in (10008,32,42,100001,100002) THEN max(mmt.transaction_date)  
                            ELSE NULL
                        END last_movement_date,
                        CASE
                            WHEN mmt.transaction_type_id not in (10008) AND SUM(NVL(mmt.primary_quantity,0)) > 0 AND mmt.transaction_type_id = 18 THEN max(mmt.transaction_date)
                            ELSE NULL
                        END last_purchase_date,
                        SUM(CASE WHEN mmt.primary_quantity < 0 THEN mmt.primary_quantity ELSE 0 END) issued_qty
                     
            FROM mtl_categories_kfv mck,
                     mtl_material_transactions mmt,
                     mtl_system_items_b msi,
            --         mtl_system_items_b msib,
                     cst_item_costs cic,
                     cst_cost_types cct,
                     org_organization_definitions ood,
                     hr_operating_units hou,
                     mtl_item_categories mtc,
                     fnd_lookup_values_vl flv,
                     ipc_wsp_parts_pricelist wsp
            WHERE 1 = 1
            --     msib.inventory_item_id =  msi.inventory_item_id
            --         AND msib.organization_id = msi.organization_id
                        -- ITEM
                        AND msi.inventory_item_id = mmt.inventory_item_id
                        AND msi.organization_id = mmt.organization_id
                        -- ITEM COST
                        AND cic.inventory_item_id = msi.inventory_item_id
                        AND cic.organization_id = msi.organization_id
                        AND cic.cost_type_id = cct.cost_type_id
                        AND cic.cost_type_id = 2
                        -- AND                        --to add parameter for cost type (average)
                        AND mmt.subinventory_code IS NOT NULL
                        AND ood.organization_id = mmt.organization_id
                        AND ood.operating_unit = hou.organization_id
                        AND flv.lookup_type = 'ITEM_TYPE'
                        AND msi.organization_id = NVL (:p_organization, msi.organization_id)
                        AND mmt.transaction_type_id NOT IN (10008)--,32,42,100001,100002)
                        -- AND  --COGS Recognition
                        AND msi.inventory_item_id = mtc.inventory_item_id
                        AND msi.organization_id = mtc.organization_id
                        AND mtc.category_id = mck.category_id
                        AND mck.structure_id = '50388'
                        AND msi.item_type = flv.lookup_code
                        AND TO_DATE (mmt.transaction_date) <= :p_date
                        AND mck.segment1 = nvl(:p_category,mck.segment1)
                        -- SALES PRICE
                        AND wsp.inventory_item_id = msi.inventory_item_id
                        AND wsp.organization_id  = msi.organization_id
                  AND msi.inventory_item_id = 108266
              --   and msi.concatenated_segments in ('8976019670') --,'8979461440')
              HAVING SUM (NVL(mmt.primary_quantity,0)) <> 0
              --SUM (mmt.primary_quantity) IS NOT NULL
                
            --         AND msi.organization_id = 106
            GROUP BY msi.organization_id,
                     ood.organization_code,
                     ood.organization_name,
                     msi.inventory_item_id,
                     msi.segment1,
                     msi.description,
                     msi.creation_date,
                     msi.item_type,
                     flv.meaning,
                     mck.segment1,
                     mck.segment2,
                     msi.primary_unit_of_measure,
                     mmt.subinventory_code,
                     cct.cost_type,
                     cct.description,
                     cic.item_cost,
                     mmt.transaction_type_id,
                     wsp.price) mtl;
   

/*Version 1 query

   Inventory Aging Report for Average Cost
    update reference cost based on the transaction date or costing date from the date of the generated data
    mzc - 09122017 v3
    

select a.*,
    case when aging between 0 AND 30 then
             nvl(total_inventory_value,0)  
      end "0-30 Days",
      case when aging between 31 AND 60 then
             nvl(total_inventory_value,0)  
      end "31-60 Days",
    case when aging between 61 AND 90 then
             nvl(total_inventory_value,0)  
      end "61-90 Days",
      case when aging > 90 then
             nvl(total_inventory_value,0)  
      end "Over 90 Days"
from
(
select organization_name,
       item_code,
       description,
       item_category_family,
    uom,
    subinventory_code,
    item_cost as unit_cost,
    on_hand_quantity,
      total_cost as total_inventory_value,
      registration_date,
    :p_date as cut_off_date,
    to_date(last_purchase_date) as last_purchase_date,
    to_date(last_movement_date) as last_sales_date,
   -- no_of_days,
   case when no_of_days between 0 AND 30 then
             nvl(total_cost,0)  
      end "0-30 Days",
    case when no_of_days between 31 AND 60 then
             nvl(total_cost,0)
      end "31-60 Days",
    case when no_of_days between 61 AND 90 then
             nvl(total_cost,0)
      end "61-90 Days"        ,            
    case when no_of_days > 90 then
             nvl(total_cost,0)
      end "Over 90 Days", 
    case when  to_date(last_movement_date) is null then
        to_date(:p_date) - to_date(last_purchase_date)
    else
        to_date(:p_date) - to_date(last_movement_date)
    end aging
from 
    (select 
        item_code,
            organization_name,
        item_type,
            item_type_description,
        item_category_family,
        item_category_class,
        uom,
        registration_date,
        subinventory_code,
        description,
        inventory_item_id,
        organization_id,
        item_cost,
        on_hand_quantity,
        last_purchase_date,
       last_movement_date,
        no_of_days,
        issued_qty,
            total_day1,
            total_day2,
            total_day3,
            total_day4,
            --issued_qty,
        (case when (total_day2 + total_day3 + total_day4 + issued_qty) < 0
              then (total_day1 + total_day2 + total_day3 + total_day4 + issued_qty)
              else total_day1
        end) day1,
        (case when (total_day3 + total_day4 + issued_qty) < 0
              then (total_day2 + total_day3 + total_day4 + issued_qty)
              else total_day2
        end) day2,
        (case when(total_day4 + issued_qty) < 0
              then (total_day3 + total_day4 + issued_qty)
              else total_day3
        end) day3,
        (total_day4 + issued_qty) day4,
        total_cost
    from
        (select 
            organization_name,
            item_code,
            item_type,
                  item_type_description,
            item_category_family,
            item_category_class,
            uom,
            registration_date,
            subinventory_code,
            description,
            inventory_item_id,
            organization_id,
           -- organization_name,
            item_cost,
            last_purchase_date,
            last_movement_date,
            no_of_days,
            on_hand_quantity,
            total_day1,
            total_day2,
            total_day3,
            total_day4,
            (select 
                nvl(sum(mmt.primary_quantity), 0)
             from 
                mtl_material_transactions mmt
             where 
                1 = 1 and
                mmt.organization_id = mt.organization_id and
                mmt.inventory_item_id = mt.inventory_item_id and
                mmt.subinventory_code = mt.subinventory_code and
                mmt.primary_quantity < 0 and 
                to_date(mmt.transaction_date) <= to_date(:p_date)
            ) issued_qty,
            total_cost
        from
            (select 
                trans.organization_name,
                trans.item_code,
                trans.item_type,
                        trans.item_type_description,
                trans.item_category_family,
                trans.item_category_class,
                trans.uom,
                trans.registration_date,
                trans.subinventory_code,
                trans.description,
                trans.inventory_item_id,
                trans.organization_id,
                trans.item_cost,
                trans.on_hand_quantity,
                total_cost,
------generating the value of 0-30 days                
                (
                    (
                        select 
                            nvl(sum(primary_quantity),0)
                        from 
                            mtl_material_transactions mmt
                        where
                            1 = 1 and 
                            mmt.inventory_item_id = trans.inventory_item_id and
                            mmt.organization_id = trans.organization_id and 
                            mmt.subinventory_code = trans.subinventory_code and 
                            mmt.transaction_type_id not in (10008) and   --COGS Recognition
                            mmt.primary_quantity > 0 and
                            to_date(mmt.transaction_date) between to_date (:p_date) - 30 and to_date(:p_date)
                    )
                )  total_day1,
------generating the value of 31-60 days
                ( 
                    (
                        select 
                            nvl(sum(mmt.primary_quantity),0)
                        from
                            mtl_material_transactions mmt
                        where
                            1 = 1 and 
                            mmt.inventory_item_id = trans.inventory_item_id and
                            mmt.organization_id = trans.organization_id and
                            mmt.subinventory_code = trans.subinventory_code and
                            mmt.transaction_type_id not in (10008) and  --COGS Recognition
                            mmt.primary_quantity > 0 and
                            to_date(mmt.transaction_date) between to_date(:p_date) - 60 and to_date(:p_date) - 31
                    )
                ) total_day2,
------generating the value of 61-90 days
                (
                    (
                        select 
                            nvl(sum(mmt.primary_quantity),0)
                        from
                           mtl_material_transactions mmt
                        where
                            1 = 1 and 
                            mmt.inventory_item_id = trans.inventory_item_id and
                            mmt.organization_id = trans.organization_id and 
                            mmt.subinventory_code = trans.subinventory_code and
                            mmt.transaction_type_id not in (10008) and  --COGS Recognition
                            mmt.primary_quantity > 0 and
                            to_date(mmt.transaction_date) between to_date(:p_date) - 90 and to_date(:p_date) - 61
                    )
                ) total_day3,
------generating the value of more than 91days
                ( 
                    (
                        select
                            nvl(sum(mmt.primary_quantity),0)
                        from    
                            mtl_material_transactions mmt
                        where 
                            1 = 1 and
                            mmt.inventory_item_id = trans.inventory_item_id and 
                            mmt.organization_id = trans.organization_id and 
                            mmt.subinventory_code = trans.subinventory_code and 
                            mmt.transaction_type_id not in (10008) and  --COGS Recognition
                            mmt.primary_quantity > 0 and
                            to_date(mmt.transaction_date) < to_date(:p_date) - 91
                    )
                ) total_day4,
------getting the last purchase date (PO Receipt)
                ( 
                    (
                        select 
                            max(mmt.transaction_date)
                        from
                            mtl_material_transactions mmt
                        where
                            1 = 1 and 
                            mmt.inventory_item_id = trans.inventory_item_id and
                            mmt.organization_id = trans.organization_id and 
                            mmt.subinventory_code = trans.subinventory_code and
                            mmt.transaction_type_id not in (10008) and  --COGS Recognition
                            mmt.primary_quantity > 0 and
                            mmt.transaction_type_id = 18 and --PO Receipt
                            to_date(mmt.transaction_date) <= to_date(:p_date)
                    )
                ) last_purchase_date,
------getting the last movement date (issuance)
                ( 
                    (
                        select
                           MAX(MmT.TRANSACTION_date) 
                        from
                            mtl_material_transactions mmt,
                            mtl_transaction_types mtt
                        where
                            --1 = 1 and 
                            mmt.transaction_type_id = mtt.transaction_type_id and 
                            mmt.inventory_item_id = trans.inventory_item_id and 
                            mmt.organization_id = trans.organization_id and
                            mmt.subinventory_code = trans.subinventory_code and
                            mmt.transaction_type_id not in (10008,32,42,100001,100002) and  --COGS Recognition
                           -- mmt.primary_quantity < 0 and
                           -- mtt.transaction_type_name like '%issue%' and 
                           -- mmt.transaction_type_id IN ('1','11','30','31','32','33','34','35','38','63','77','98','100001') and --Issuances
                            --mmt.transaction_type_id = 33 and -- ain (1,11,30,31,32,33,34,35,38,63,77,98,100001) and 
                            mmt.transaction_date <= :p_date
                    )
                ) last_movement_date,
------getting the count of days
                ( 
                    (
                        select
                            to_date(:p_date) - to_date(max(mmt.transaction_date))
                        from
                            mtl_material_transactions mmt
                        where
                            1 = 1 and 
                            mmt.inventory_item_id = trans.inventory_item_id and
                            mmt.organization_id = trans.organization_id and
                           mmt.subinventory_code = trans.subinventory_code and
                            mmt.transaction_type_id not in (10008) and  --COGS Recognition
                            mmt.primary_quantity > 0 and
                            to_date(mmt.transaction_date) <= to_date(:p_date)
                    )
                ) no_of_days
                from 
                ( 
         --main material transaction details--
                    select 
                        msi.organization_id,
                        ood.organization_code,
                        ood.organization_name,
                        msi.inventory_item_id,
                        msib.creation_date as registration_date,
                        msi.concatenated_segments as item_code,
                        msi.description,
                        msi.item_type,
                        flv.meaning as item_type_description,
                        mck.segment1 as item_category_family,
                        mck.segment2 as item_category_class,
                        msi.primary_unit_of_measure as uom,
                        mmt.subinventory_code,
                        cct.cost_type,
                        cct.description as cost_type_description,
                        -- cic.item_cost, --current item cost
                        ipc_get_new_item_cost(:p_date,msi.inventory_item_id,msi.organization_id) as item_cost,
                        sum(mmt.primary_quantity) as on_hand_quantity,
                        -- (SUM (mmt.primary_quantity)* cic.item_cost) AS total_cost --current cost total value
                        (sum(mmt.primary_quantity) * (ipc_get_new_item_cost(:p_date,msi.inventory_item_id,msi.organization_id))) as total_cost
                   from 
                        mtl_categories_kfv mck,
                        mtl_material_transactions mmt,
                        mtl_system_items_kfv msi,
                        mtl_system_items_b msib,
                        cst_item_costs cic,
                        cst_cost_types cct,
                        org_organization_definitions ood,
                        hr_operating_units hou,
                        mtl_item_categories mtc,
                        fnd_lookup_values_vl flv
                    where
                        msib.inventory_item_id = msi.inventory_item_id and
                        msib.organization_id = msi.organization_id and 
                        msi.inventory_item_id = mmt.inventory_item_id and
                        msi.organization_id = mmt.organization_id and
                        cic.inventory_item_id = msi.inventory_item_id and 
                        cic.organization_id = msi.organization_id and
                        cic.cost_type_id = cct.cost_type_id and 
                        cic.cost_type_id = 2 and --to add parameter for cost type (average)
                        mmt.subinventory_code is not null and 
                        ood.organization_id = mmt.organization_id and
                        ood.operating_unit = hou.organization_id and
                        flv.lookup_type = 'ITEM_TYPE' and
                        msi.organization_id = nvl(:p_organization,msi.organization_id) and 
                        mmt.transaction_type_id not in (10008) and  --COGS Recognition
                        mtc.category_id = mck.category_id and
                        msi.inventory_item_id = mtc.inventory_item_id and
                        mmt.organization_id = mtc.organization_id and 
                        mck.structure_id = '50388' and
                        msi.item_type = flv.lookup_code and 
                        to_date(mmt.transaction_date) <= :p_date  
                         and mck.segment1 = nvl(:p_category,mck.segment1)
                              --    and msi.concatenated_segments in ('8976019670') --,'8979461440')
                    having
                        sum(mmt.primary_quantity) is not null and 
                        sum(mmt.primary_quantity) <> 0
                    group by
                        msi.organization_id,
                        ood.organization_code,
                        ood.organization_name,
                        msi.inventory_item_id,
                        msi.concatenated_segments,
                        msi.description,
                        msib.creation_date,
                        msi.item_type,
                        flv.meaning,
                        mck.segment1,
                        mck.segment2,
                        msi.primary_unit_of_measure,
                        mmt.subinventory_code,
                        cct.cost_type,
                        cct.description,
                        cic.item_cost
                )trans
            ) mt
        )
    )
order by
  --  subinventory_code, 
    inventory_item_id
)a


*/
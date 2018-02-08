SELECT organization_name,
             item_code,
             description,
             item_category_family,
             uom,
             subinventory_code,
             unit_cost,
             onhand_quantity,
             (unit_cost * onhand_quantity) total_inventory_value,
             registration_date,
             sales_price,
             cut_off_date,
             last_purchase_date,
             last_sales_date,
             SUM(days_0_30) days_0_30,
             SUM(days_31_60) days_31_60,
             SUM(days_61_90) days_61_90,
             SUM(days_over_90) days_over_90
              
FROM (
SELECT   
                organization_name,
                item_code,
                description,
                item_category_family,
                uom,
                subinventory_code,
                max(item_cost) as unit_cost,
                SUM(on_hand_quantity) onhand_quantity,
                registration_date,
                MAX(sales_price) sales_price,
                :p_date as cut_off_date,
                to_date(max(last_purchase_date)) as last_purchase_date,
                to_date(max(last_movement_date)) as last_sales_date,
                 sum(case 
                    when IPC_GET_AVG_AGING(last_movement_date,last_purchase_date,:p_date) between 0 AND 30 then nvl((total_cost),0)  
                end) days_0_30,
                sum(case 
                    when IPC_GET_AVG_AGING(last_movement_date,last_purchase_date,:p_date) between 31 AND 60 then nvl((total_cost),0)  
                end) days_31_60,
                sum(case 
                    when IPC_GET_AVG_AGING(last_movement_date,last_purchase_date,:p_date) between 61 AND 90 then nvl((total_cost),0)  
                end) days_61_90,
                sum(case 
                    when IPC_GET_AVG_AGING(last_movement_date,last_purchase_date,:p_date) > 90 then nvl((total_cost),0)  
                end) days_over_90
                
        
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

                        -- SALES PRICE
                        AND wsp.inventory_item_id = msi.inventory_item_id
                        AND wsp.organization_id  = msi.organization_id
--                        AND msi.segment1 = '0505410200'

              HAVING SUM (NVL(mmt.primary_quantity,0)) <> 0

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
                     wsp.price) 
GROUP BY
                organization_name,
                item_code,
                description,
                item_category_family,
                uom,
                subinventory_code,
                registration_date
                )
WHERE onhand_quantity > 0
GROUP BY
             organization_name,
             item_code,
             description,
             item_category_family,
             uom,
             subinventory_code,
             unit_cost,
             onhand_quantity,
             registration_date,
             sales_price,
             cut_off_date,
             last_purchase_date,
             last_sales_date;
   

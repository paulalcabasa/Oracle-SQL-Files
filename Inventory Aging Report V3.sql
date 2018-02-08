
--Inventory Aging Report for FIFO (IVP, IVS, NYK, IGO)
select
    organization_id, 
  	inventory_item_id,
    item_code,
    description,
	item_type,
	item_type_description,
    item_category_family,
    item_category_class,
    cost_type,
    cost_type_description,
    uom,
    item_cost as unit_cost,
    subinventory_code,
    on_hand_quantity,
    :p_date as cut_off_date,
    total_cost as total_inventory_value,
    case when day1 < 0 then 0 else day1 * item_cost end "0-30 Days",
    case when day2 < 0 then 0 else day2 * item_cost end "31-60 Days",
    case when day3 < 0 then 0 else day3 * item_cost end "61-90 Days",
    case when day4 < 0 then 0 else day4 * item_cost end "Over 90 Days",
    to_date(last_purchase_date) as last_purchase_date,
    to_date(last_movement_date) as last_movement_date,
    no_of_days
FROM 
    (SELECT
        item_code,
        item_type,
        uom,
        subinventory_code,
        item_type_description,
        item_category_family,
        item_category_class,
        cost_type,
        cost_type_description,
        description,
        inventory_item_id,
        organization_id,
        item_cost,
        on_hand_quantity,
        last_purchase_date,
        last_movement_date,
        no_of_days,
        issued_qty,
        (CASE
            WHEN (total2 + total3 + total4  + issued_qty) < 0
                THEN
                    (total1 + total2 + total3 + total4  + issued_qty)
                ELSE
                    total1
        END) day1,
        (CASE
            WHEN (total3 + total4 + issued_qty) < 0
                THEN
                    (total2 + total3 + total4 + issued_qty)
                ELSE
                    total2
        END) day2,
        (CASE
            WHEN (total4 + issued_qty) < 0
                THEN
                    (total3 + total4 + issued_qty)
                ELSE
                    total3
        END) day3,
        (total4 + issued_qty) day4,
        total_cost
            FROM (SELECT 
                         organization_name,
                         item_code,
                         item_type,
                         uom,
                         subinventory_code,
                         item_type_description,
                         item_category_family,
                         item_category_class,
                         cost_type,
                         cost_type_description,
                         description,
                         inventory_item_id,
                         organization_id,
                         organization_name,
                         item_cost,
                         last_purchase_date,
                         last_movement_date,
                         no_of_days,
                         on_hand_quantity,
                         total1,
                         total2,
                         total3,
                         total4,
                         (SELECT NVL (SUM (mmt.primary_quantity), 0)
                            FROM mtl_material_transactions mmt
                           WHERE     1 = 1
                                 AND mmt.organization_id = mtrans.organization_id
                                 AND mmt.inventory_item_id = mtrans.inventory_item_id
                                 AND mmt.subinventory_code = mtrans.subinventory_code
                                 AND mmt.primary_quantity < 0
                                 AND TO_DATE (mmt.transaction_date) <= TO_DATE (:p_date)
                                 )
                            issued_qty,
                         total_cost
                    FROM (
                        select 
                            trans.organization_name,
                            trans.item_code,
                            trans.item_type,
                            trans.uom,
                            trans.subinventory_code,
                            trans.item_type_description,
                            trans.item_category_family,
                            trans.item_category_class,
                            trans.registration_date,
                            trans.cost_type,
                            trans.cost_type_description,
                            trans.description,
                            trans.inventory_item_id,
                            trans.organization_id,
                            trans.item_cost,
                            trans.on_hand_quantity,
                            total_cost,
                            (
------generating the value of 0-30 days
                                (select 
                                    nvl(sum(primary_quantity),0)
                                 from 
                                    mtl_material_transactions mmt
                                 where
                                    1 = 1
                                    and mmt.inventory_item_id = trans.inventory_item_id
                                    and mmt.organization_id = trans.organization_id
                                    and mmt.subinventory_code = trans.subinventory_code
                                    and mmt.transaction_type_id not in (10008) --COGS Recognition
                                    and mmt.primary_quantity > 0
                                    and to_date(mmt.transaction_date) between to_date(:p_date) - 30 and to_date(:p_date)
                                ) 
                            ) total1,
------generating the value of 31-60 days                                
                            ( 
                                (select 
                                    nvl(sum(mmt.primary_quantity), 0)
                                 from 
                                    mtl_material_transactions mmt
                                 where
                                    1 = 1
                                    and mmt.inventory_item_id = trans.inventory_item_id
                                    and mmt.organization_id = trans.organization_id
                                    and mmt.subinventory_code =  trans.subinventory_code
                                    and mmt.transaction_type_id not in (10008) --COGS Recognition
                                    and mmt.primary_quantity > 0
                                    and to_date(mmt.transaction_date) between to_date(:p_date) - 60 and to_date(:p_date) - 31)
                            ) total2,
------generating the value of 61-90 days          
                            (
                                (select 
                                    nvl(sum(mmt.primary_quantity), 0)
                                 from
                                    mtl_material_transactions mmt
                                 where
                                    1 = 1
                                    and mmt.inventory_item_id = trans.inventory_item_id
                                    and mmt.organization_id = trans.organization_id
                                    and mmt.subinventory_code = trans.subinventory_code 
                                    and mmt.transaction_type_id not in (10008) --COGS Recognition
                                    and mmt.primary_quantity > 0
                                    and to_date(mmt.transaction_date) between to_date(:p_date) - 90 and to_date(:p_date) - 61)
                            ) total3,
------generating the value of over 90 days                       
                            (
                                (select 
                                    nvl(sum(mmt.primary_quantity),0)
                                 from 
                                    mtl_material_transactions mmt
                                 where
                                    1 = 1
                                    and mmt.inventory_item_id = trans.inventory_item_id
                                    and mmt.organization_id = trans.organization_id
                                    and mmt.subinventory_code =  trans.subinventory_code
                                    and mmt.transaction_type_id not in(10008) --COGS Recognition
                                    and mmt.primary_quantity > 0
                                    and to_date(mmt.transaction_date) < to_date(:p_date) - 360 --180 and to_date (:p_date) - 91
                                )
                            ) total4,
------getting the last purchase date (PO Receipt)
                            (
                                (select
                                    max(mmt.transaction_date)
                                 from 
                                    mtl_material_transactions mmt
                                 where
                                    1 = 1
                                    and mmt.inventory_item_id = trans.inventory_item_id
                                    and mmt.organization_id = trans.organization_id
                                    and mmt.subinventory_code = trans.subinventory_code
                                    and mmt.transaction_type_id not in (10008) --COGS Recognition
                                    and mmt.primary_quantity > 0
                                    and mmt.transaction_type_id = 18 --PO Receipt
                                    and to_date(mmt.transaction_date) <=  to_date(:p_date)
                                )
                            ) last_purchase_date,
------getting the last movement date (issuance)
                            (
                                (select 
                                    max(mmt.transaction_date)
                                 from
                                    mtl_material_transactions mmt
                                 where 
                                    1 = 1
                                    and mmt.inventory_item_id = trans.inventory_item_id
                                    and mmt.organization_id = trans.organization_id
                                    and mmt.subinventory_code = trans.subinventory_code
                                    and mmt.transaction_type_id not in (10008) --COGS Recognition
                                    and mmt.primary_quantity < 0
                                    and mmt.transaction_type_id in ('1','11','30','31','32','33','34','35','38','63','77','98','100001') --Issuances
                                    and to_date(mmt.transaction_date) <=  to_date(:p_date)
                                )
                            ) last_movement_date,
------getting the count of days
                            (
                                (select
                                    to_date(:p_date) - to_date(max(mmt.transaction_date))
                                 from 
                                    mtl_material_transactions mmt
                                 where
                                    1 = 1
                                    and mmt.inventory_item_id = trans.inventory_item_id
                                    and mmt.organization_id = trans.organization_id
                                    and mmt.subinventory_code = trans.subinventory_code
                                    and mmt.transaction_type_id NOT IN  (10008) --COGS Recognition
                                    and mmt.primary_quantity > 0
                                    and to_date(mmt.transaction_date) <= to_date(:p_date)
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
                    msi.concatenated_segments as item_code,
                    msi.description,
                    msi.item_type,
                    msi.creation_date as registration_date,
                    flv.meaning as item_type_description,
                    mck.segment1 as item_category_family,
                    mck.segment2 as item_category_class,
                    msi.primary_unit_of_measure as uom,
                    mmt.subinventory_code,
                    cct.cost_type,
                    cct.description as cost_type_description,
                    cic.item_cost,
                    sum (mmt.primary_quantity) as on_hand_quantity,
                    (sum (mmt.primary_quantity) * cic.item_cost) as total_cost
                from 
                    mtl_categories_kfv mck,
                    mtl_material_transactions mmt,
                    mtl_system_items_kfv msi,
                    cst_item_costs cic,
                    cst_cost_types cct,
                    org_organization_definitions ood,
                    hr_operating_units hou,
                    mtl_item_categories mtc,
                    fnd_lookup_values_vl flv
                where
                    msi.inventory_item_id = mmt.inventory_item_id
                    and msi.organization_id = mmt.organization_id
                    and cic.inventory_item_id = msi.inventory_item_id
                    and cic.organization_id = msi.organization_id
                    and cic.cost_type_id = cct.cost_type_id
                    and cic.cost_type_id = 5  --to add parameter for cost type
                    and mmt.subinventory_code is not null
                    and ood.organization_id = mmt.organization_id
                    and ood.operating_unit = hou.organization_id
                    and flv.lookup_type = 'ITEM_TYPE'
                    and msi.organization_id = nvl (:p_organization, msi.organization_id)
                    and mmt.transaction_type_id not in (10008) --COGS Recognition
                    and mtc.category_id = mck.category_id
                    and msi.inventory_item_id = mtc.inventory_item_id
                    and mmt.organization_id = mtc.organization_id
                    and mck.structure_id = '50388'
                    and msi.item_type = flv.lookup_code
                   -- and mmt.organization_id = :p_org_id
                    and to_date(mmt.transaction_date) <= :p_date
                having
                    sum (mmt.primary_quantity) is not null
                    and sum (mmt.primary_quantity) <> 0
                group by
                    msi.organization_id,
                    ood.organization_code,
                    ood.organization_name,
                    msi.inventory_item_id,
                    msi.concatenated_segments,
                    msi.description,
                    msi.item_type,
                    flv.meaning,
                    mck.segment1,
                    mck.segment2,
                    msi.primary_unit_of_measure,
                    mmt.subinventory_code,
                    cct.cost_type,
                    cct.description,
                    cic.item_cost,
                     msi.creation_date 
            ) trans
                        ) mtrans))
order by 
    subinventory_code, 
    item_code

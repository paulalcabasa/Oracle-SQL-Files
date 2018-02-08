SELECT  moqv.organization_id AS "ORG ID",
            moqv.subinventory_code AS "SUBINVENTORY",
            moqv.inventory_item_id AS "INVENTORY ITEM ID",
            msi.segment1 AS "PART NUMBER",
            msi.description AS "PART DESCRIPTION",
            moqv.item_cost AS "UNIT COST",
            SUM (transaction_quantity) AS "ON HAND QTY",
            moqv.item_cost * SUM (transaction_quantity) AS "TOTAL COST"
FROM mtl_onhand_qty_cost_v moqv, mtl_system_items_b msi
WHERE 1 = 1
         --   AND moqv.subinventory_code = :SubInventory  -- parameter but dropdown
            AND moqv.inventory_item_id = msi.inventory_item_id
            AND moqv.organization_id = :Inventory_Org
GROUP BY moqv.organization_id,
                moqv.subinventory_code,
                moqv.inventory_item_id,
                msi.segment1,
                msi.description,
                moqv.item_cost;
                
                SELECT *
                FROM MTL_SYSTEM_ITEMS_B
                WHERE ORGANIZATION_ID = 102;
                
                select *
                from XXIPC_DBS_ONHAND;
SELECT hou.NAME operating_unit_name, 
            hou.short_code,
            hou.organization_id operating_unit_id, 
            hou.set_of_books_id,
            hou.business_group_id,
            ood.organization_name inventory_organization_name,
            ood.organization_code Inv_organization_code, 
            ood.organization_id Inv_organization_id, 
            ood.chart_of_accounts_id
FROM hr_operating_units hou, org_organization_definitions ood
WHERE 1 = 1 
            AND hou.organization_id = ood.operating_unit
ORDER BY hou.organization_id ASC;

select secondary_inventory_name subinventory,
            description,
            subinventory_type,
            organization_id,
            asset_inventory,
            quantity_tracked,
            inventory_atp_code,
            availability_type,
            reservable_type,
            locator_type,
            picking_order,
            dropping_order,
            location_id,
            status_id
from mtl_secondary_inventories
where organization_id= 102;
order by subinventory 
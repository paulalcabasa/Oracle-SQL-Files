CREATE VIEW XXIPC_DBS_ONHAND as(
select
        oo.organization_name as "Organization Name"
        ,moqd.organization_id as "Org ID"
        ,moqd.subinventory_code as "Subinventory"
        ,moqd.inventory_item_id as "Item Id"
        ,msib.segment1 as "Oracle Part Number"
        ,msib.attribute14 as "IFS Part Number"    
        ,msib.description as "Part Description"
        ,sum (moqd.primary_transaction_quantity) as "On Hand Quantity"

from
      mtl_onhand_quantities_detail moqd
      ,mtl_system_items_b msib
      ,mtl_secondary_inventories_fk_v msiv
      ,org_organization_definitions oo

where
      moqd.organization_id = oo.organization_id
     and moqd.inventory_item_id = msib.inventory_item_id
     and moqd.organization_id = msib.organization_id
     and msiv.organization_id = moqd.organization_id
     and msiv.organization_id = oo.organization_id
     and msiv.organization_id = moqd.organization_id
     and moqd.subinventory_code = msiv.secondary_inventory_name
     and oo.organization_id = msib.organization_id
     and moqd.organization_id = 102
      and moqd.subinventory_code = 'DBS' 

group by
        oo.organization_name
        ,moqd.organization_id
        ,moqd.subinventory_code
        ,msiv.description
        ,moqd.inventory_item_id
        ,msib.segment1
        ,msib.attribute14
        ,msib.description);
        
        commit;
        
        SELECT *
        FROM XXIPC_DBS_ONHAND;


SELECT 
         msi.organization_id,
      --  msi.subinventory_code,
         msi.inventory_item_id,
       msi.segment1 part_no,
         msi.description,
       NVL (pl.list_price, 0) list_price,
         NVL (ic.item_cost, 0) unit_cost,
         CASE inventory_item_status_code WHEN 'Active' THEN 'A' ELSE 'N' END
            part_status,
         NVL (total_qty, 0) - NVL (reserved_qty, 0) total_available,
         reserved_qty,
         CASE
            WHEN moq.last_update_date > mr.last_update_date
            THEN
               moq.last_update_date
            ELSE
               mr.last_update_date
         END
         last_update,
         msi.creation_date create_date
   FROM mtl_system_items_b msi
         LEFT JOIN (  SELECT inventory_item_id,
                             organization_id,
                             SUM (NVL (transaction_quantity, 0)) total_qty,
                             MAX (last_update_date) last_update_date
                        FROM mtl_onhand_quantities
                    GROUP BY inventory_item_id, organization_id) moq
            ON msi.organization_id = moq.organization_id
               AND msi.inventory_item_id = moq.inventory_item_id
         LEFT JOIN (  SELECT inventory_item_id,
                             organization_id,
                             SUM (NVL (reservation_quantity, 0)) reserved_qty,
                             MAX (last_update_date) last_update_date
                        FROM mtl_reservations
                    GROUP BY inventory_item_id, organization_id) mr
            ON msi.organization_id = mr.organization_id
               AND msi.inventory_item_id = mr.inventory_item_id
         LEFT JOIN (SELECT b.product_attr_val_disp part_no,
                           b.operand list_price
                      FROM qp_secu_list_headers_vl a, qp_list_lines_v b
                     WHERE a.list_header_id = b.list_header_id
                           AND a.name = 'WSP') pl
            ON msi.segment1 = pl.part_no
                  
                  left join (select INVENTORY_ITEM_ID, organization_id, item_cost
              from cst_item_costs ) ic
                              on msi.inventory_item_id = ic.INVENTORY_ITEM_ID
                              and msi.organization_id =  ic.organization_id
      
   WHERE 1 = 1 AND msi.organization_id = 102
-- AND msi.inventory_item_id = 155700
ORDER BY reserved_qty DESC;

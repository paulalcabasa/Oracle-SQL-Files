select msib.inventory_item_id,
         org.name,
         msib.segment1,
         msib.description,
         onhand.locator_id,
         loc.description,
         loc.segment1,
         loc.subinventory_code,
        onhand.transaction_quantity,
         msib.organization_id 
from mtl_onhand_quantities onhand,
        mtl_system_items_b msib,
        hr_all_organization_units org,
        mtl_item_locations loc
where 1 = 1
          AND onhand.inventory_item_id = msib.inventory_item_id
          AND org.organization_id = onhand.organization_id
          AND loc.inventory_location_id = onhand.locator_id
          and msib.organization_id = 107
          ;
        
select *
from hr_all_organization_units;

select *
from mtl_item_locations
where organization_id = 102;

select *
from dbs_picklist_interface;


-- 3010002470
select *
from mtl_onhand_quantities
where organization_id = 102
and locator_id is  null;

select move_order_line_id
from WSH_DELIVERY_DETAILS ;


select *
from mtl_system_items_b
where inventory_item_id = 142599;


-- 3010002471 with backorder

select *
from  dbs_picklist_interface
where request_number = 472510;

select *
from ra_customer_trx_all
where attribute1 = '1991';



SELECT msi.inventory_item_id,
         msi.segment1 part_no,
         NVL (pl.list_price, 0) list_price,
         msi.description,
         msi.attribute4 model,
         CASE inventory_item_status_code WHEN 'Active' THEN 'A' ELSE 'N' END
            part_status,
         NVL (total_qty, 0) - NVL (reserved_qty, 0) total_available,
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
   WHERE 1 = 1 AND msi.organization_id = 102
    AND NVL (total_qty, 0) - NVL (reserved_qty, 0) > 0
-- AND msi.inventory_item_id = 155700
ORDER BY reserved_qty DESC;

select *
from hr_all_organization_units;

select *
from ra_customer_trx_all
where interface_header_attribute1 = '3010005101';
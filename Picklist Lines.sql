SELECT  wnd.delivery_id,
                        wnd.name delivery_name,
                        wnd.initial_pickup_location_id,
                        mtrh.request_number mo_number,
                        mtrl.line_number mo_line_number,
                        mtrl.line_id mo_line_id,
                        mtrl.from_subinventory_code,
                        mtrl.to_subinventory_code,
                        mtrl.lot_number,
                        mtrl.serial_number_start,
                        mtrl.serial_number_end,
                        mtrl.uom_code,
                        mtrl.quantity requested_quantity,
                        mtrl.quantity_delivered,
                        mtrl.quantity_detailed,
                        wdd.source_header_number so_order_number,
                        oola.line_number so_line_number,
                        oola.promise_date,
                        oola.attribute1 remarks,
                        wdd.source_header_id so_header_id,
                        wdd.source_line_id so_line_id,
                        wdd.shipping_instructions,
                        wdd.inventory_item_id,
                        wdd.requested_quantity_uom,
                        msi.segment1 part_no,
                        msi.description item_description,
                        msi.revision_qty_control_code ,
                        wdd.ship_method_code carrier,
                        wdd.shipment_priority_code priority,
                        wdd.organization_id,
                        wdd.released_status,
                        wdd.source_code,
                        mtp.organization_code,
                        item_categories.segment1,
                        item_categories.segment2
                FROM mtl_system_items_vl msi,
                     oe_order_lines_all oola,
                     mtl_txn_request_lines mtrl,
                     mtl_txn_request_headers mtrh,
                     wsh_delivery_details wdd,
                     wsh_delivery_assignments wda,
                     wsh_new_deliveries wnd,
                     mtl_system_items_b msib,
                     mtl_parameters mtp,
                     (select mic.inventory_item_id,
                               mc.segment1,
                               mc.segment2,
                               mc.category_id
                      from mtl_item_categories mic,
                              mtl_categories mc
                      where 1=1 
                                and mic.category_id = mc.category_id
                                and organization_id = 87
                                and segment1 = 'PARTS') item_categories
                WHERE 1=1 
                      AND wda.delivery_id = wnd.delivery_id(+)
                      AND wdd.delivery_detail_id = wda.delivery_detail_id
                      AND wdd.move_order_line_id = mtrl.line_id
                      AND mtrl.header_id = mtrh.header_id
                      AND wdd.inventory_item_id = msi.inventory_item_id(+)
                      AND wdd.organization_id = msi.organization_id(+)
                      AND wdd.source_line_id = oola.line_id
                      AND wdd.source_header_id = oola.header_id 
                      AND msib.inventory_item_id = wdd.inventory_item_id
                      AND msib.organization_id = mtp.organization_id
                      AND item_categories.inventory_item_id(+) = wdd.inventory_item_id
                      AND msib.organization_id = 87 
                  
         AND mtrh.request_number = '429030'
        ORDER BY so_line_number;
        
        select *
        from mtl_onhand_quantities_detail
        where inventory_item_id = 143839;
        
        select *
        from mtl_system_items_b
        where ;
        
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
          and msib.organization_id = 102
          AND msib.segment1 = '8971468260';

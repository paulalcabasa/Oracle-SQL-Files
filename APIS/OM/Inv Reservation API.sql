DECLARE
   p_rsv                     inv_reservation_global.mtl_reservation_rec_type;
   p_dummy_sn                inv_reservation_global.serial_number_tbl_type;
   x_msg_count               NUMBER;
   x_msg_data                VARCHAR2(240);
   x_rsv_id                  NUMBER;
   x_dummy_sn                inv_reservation_global.serial_number_tbl_type;
   x_status                  VARCHAR2(1);
   x_qty                     NUMBER;
BEGIN
   fnd_global.APPS_Initialize(28270,53073,660);
   dbms_application_info.set_client_info(5283);
   --p_user_id, p_resp_id,  p_resp_appl_id
   --p_rsv.reservation_id            := NULL; -- cannot know
   p_rsv.requirement_date            := Sysdate+2;
   p_rsv.organization_id             := 82; --mtl_parameters.organization id
   p_rsv.inventory_item_id           := 270001; --mtl_system_items.Inventory_item_id;
   p_rsv.demand_source_type_id       := 13; -- inv_reservation_global.g_source_type_oe;  (which is 2)
   p_rsv.demand_source_name          := 'Inventory';
   p_rsv.demand_source_header_id     := NULL ; --mtl_sales_orders.sales_order_id
   p_rsv.demand_source_line_id       := NULL ; -- oe_order_lines.line_id
   p_rsv.primary_uom_code            := 'Ea';
   p_rsv.primary_uom_id              := NULL;
   p_rsv.reservation_uom_code        := 'Ea';
   p_rsv.reservation_uom_id          := NULL;
   p_rsv.reservation_quantity        := 2;
   p_rsv.primary_reservation_quantity := 2;
   p_rsv.supply_source_type_id       := inv_reservation_global.g_source_type_inv;
   p_rsv.supply_source_name          := 'RESERV TEST';
   p_rsv.crossdock_flag := 'N';
   p_rsv.subinventory_code := '01SUB';
   p_rsv.subinventory_id := NULL; 
   p_rsv.ship_ready_flag := NULL;
   p_rsv.pick_slip_number := NULL;
p_rsv.lpn_id := NULL;
p_rsv.attribute_category := NULL;
p_rsv.attribute1 := NULL;
p_rsv.attribute2 := NULL;
p_rsv.attribute3 := NULL;
p_rsv.attribute4 := NULL;
p_rsv.attribute5 := NULL;
p_rsv.attribute6 := NULL;
p_rsv.attribute7 := NULL;
p_rsv.attribute8 := NULL;
p_rsv.attribute9 := NULL;
p_rsv.attribute10 := NULL;
p_rsv.attribute11 := NULL;
p_rsv.attribute12 := NULL;
p_rsv.attribute13 := NULL;
p_rsv.attribute14 := NULL;
p_rsv.attribute15 := NULL; 
p_rsv.lot_number := NULL;
p_rsv.lot_number_id := NULL; 
p_rsv.locator_id := NULL;
p_rsv.revision := NULL; 
p_rsv.supply_source_line_detail := NULL; 
p_rsv.supply_source_line_id := NULL; 
p_rsv.supply_source_header_id := NULL; 
p_rsv.external_source_line_id := NULL;
p_rsv.external_source_code := NULL; 
p_rsv.autodetail_group_id := NULL; 
p_rsv.demand_source_delivery := NULL; 


   inv_reservation_pub.create_reservation
   (
        p_api_version_number       =>       1.0
      , x_return_status            =>       x_status
      , x_msg_count                =>       x_msg_count
      , x_msg_data                 =>       x_msg_data
      , p_rsv_rec                  =>       p_rsv
      , p_serial_number            =>       p_dummy_sn
      , x_serial_number            =>       x_dummy_sn
      , x_quantity_reserved        =>       x_qty
      , x_reservation_id           =>       x_rsv_id
   );
   dbms_output.put_line('Return status    = '||x_status);
   dbms_output.put_line('msg count        = '||to_char(x_msg_count));
   dbms_output.put_line('msg data         = '||x_msg_data);
   dbms_output.put_line('Quantity reserved = '||to_char(x_qty));
   dbms_output.put_line('Reservation id   = '||to_char(x_rsv_id));
   IF x_msg_count >=1 THEN
     FOR I IN 1..x_msg_count
     LOOP
       dbms_output.put_line(I||'. '||SUBSTR(FND_MSG_PUB.Get(p_encoded => FND_API.G_FALSE ),1, 255));
       fnd_file.put_line(fnd_file.log,I||'. '||SUBSTR(FND_MSG_PUB.Get(p_encoded => FND_API.G_FALSE ),1, 255));
     END LOOP;
     
   END IF;
COMMIT;
END;

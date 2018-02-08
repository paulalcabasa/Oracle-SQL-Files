select aps.segment1 supplier_no,
         aps.vendor_name supplier_name,
         rcv_t.transaction_id,
         po_h.segment1 po_ref,
         po_l.line_num po_line_no,
         rcv_ship_header.receipt_num,
         rcv_ship_header.packing_slip dr_number,
         msib.segment1 part_number,
         rcv_ship_lines.item_description,
         rcv_t.transaction_date arrival_date,
         po_l.vendor_product_num location_or_lot_batch,
         po_l.quantity ordered_qty,
         rcv_t.quantity arrived_qty,
         rcv_t.uom_code purchase_uom,
         null "Converted Inventory Quantity",
         null "INV UOM",
         null "Approved Quantity",
         po_l.unit_price,
         round(po_l.unit_price *   po_l.quantity,2) total_amount,
         org.name organization,
         rcv_t.AMOUNT
from rcv_transactions rcv_t,
        po_headers_all po_h,
        po_lines_all po_l,
        rcv_shipment_headers rcv_ship_header,
        rcv_shipment_lines rcv_ship_lines,
        ap_supplier_sites_all assa,
        hr_all_organization_units org,
        mtl_system_items_b msib,
        ap_suppliers aps
where 1 = 1
          AND rcv_t.po_header_id = po_h.po_header_id
          AND po_l.po_line_id = rcv_t.po_line_id
          AND rcv_ship_header.shipment_header_id = rcv_t.shipment_header_id
          AND rcv_ship_lines.shipment_header_id = rcv_ship_header.shipment_header_id
          AND po_l.po_line_id = rcv_ship_lines.po_line_id
          AND assa.vendor_site_id =  rcv_t.vendor_site_id
          AND org.organization_id = rcv_t.organization_id
          AND msib.inventory_item_id = rcv_ship_lines.item_id
          AND msib.organization_id = rcv_ship_lines.to_organization_id
          AND aps.vendor_id = assa.vendor_id
          AND po_h.segment1 = '20100001125'
          AND rcv_t.transaction_type = 'RECEIVE'
      --    AND rcv_ship_header.packing_slip = 'B1709029'
ORDER BY rcv_t.transaction_id,     
               po_l.line_num;
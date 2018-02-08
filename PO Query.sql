    select distinct msib.organization_id
       ,hrl.location_code
       ,pha.segment1 po_number
       ,pha.comments ifs_po_number
       ,pla.line_num
       ,msib.segment1 part_number
       ,msib.description
       ,pla.quantity po_quantity
       ,rsl.quantity_received
       ,pla.unit_price price
       ,rsh.receipt_num
       ,rsh.shipment_num
       ,rsh.packing_slip
       ,rsh.creation_date
from po_headers_all pha
     ,po_lines_all pla
     ,mtl_system_items_b msib
     ,rcv_transactions rt
     ,rcv_shipment_headers rsh
     ,rcv_shipment_lines rsl
     ,po_line_locations_all plla
     ,hr_locations_all_tl hrl
where pha.po_header_id = pla.po_header_id
      and pla.item_id = msib.inventory_item_id
      and pla.po_line_id = rt.po_line_id
      and rt.shipment_line_id = rsl.shipment_line_id
      and rsl.shipment_header_id = rsh.shipment_header_id
      and pha.po_header_id = plla.po_header_id
      and plla.ship_to_location_id = hrl.location_id
      and pha.type_lookup_code = 'STANDARD'
     -- and msib.organization_id in 88
    --  and rsl.quantity_received <> 0
     -- and hrl.location_code in ('IVP-IO','NYK-IO')
      and rsh.packing_slip like '%DR%351837%'
order by pha.segment1
           ,pla.line_num

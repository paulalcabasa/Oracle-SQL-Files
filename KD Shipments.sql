select distinct RT.TT,isha.organization_id,         
         isha.attribute5 invoice_num,
         pv.vendor_name,
         isha.ship_num,
         pha.segment1||'-'||pla.line_num order_no,         
         max(isla.ship_line_num) ship_line_num,
         msi.segment1 model,
         msi.description,
         mtln.lot_number,
         isha.attribute11 bl_no,    
         isha.attribute3 boi,     
         isla.primary_qty txn_qty,         
         to_char(to_date(substr(isha.attribute1,1,10),'YYYY/MM/DD'),'MM/DD/YYYY') etd,
         to_char(to_date(substr(isha.attribute2,1,10),'YYYY/MM/DD'),'MM/DD/YYYY') eta,        
         pha.currency_code po_curr_code, 
         pla.unit_price po_unit_price,
		 (isla.primary_qty * pla.unit_price) try,
         round((MAX(decode(iclt.charge_line_type_name,null, ia.allocation_amt, null))/isla.currency_conversion_rate),2) inv_amt_po_curr,
         isla.currency_conversion_rate po_exchange_rate, 
         round(max(decode(iclt.charge_line_type_name,null, ia.allocation_amt, null)),2) inv_amt_php,
         round(max(decode(iclt.charge_line_type_name, 'Duties', ia.allocation_amt, 0)),2) Duties,
         round(max(decode(iclt.charge_line_type_name, 'Import Processing Fee', ia.allocation_amt, 0)),2) IPF,         
         round(max(decode(iclt.charge_line_type_name, 'Freight', ia.allocation_amt, 0)),2) Freight,
         round(max(decode(iclt.charge_line_type_name, 'Brokerage', ia.allocation_amt, 0)),2) Brokerage,
         round(MAX(decode(iclt.charge_line_type_name, 'Port Charges', ia.allocation_amt, 0)),2) PCharges,
         round(max(decode(iclt.charge_line_type_name, 'Trucking', ia.allocation_amt, 0)),2) Trucking,
         round(max(decode(iclt.charge_line_type_name, 'Excise Tax', ia.allocation_amt, 0)),2) Excise,         
         round(max(decode(iclt.charge_line_type_name, 'Excise Tax', ia.allocation_amt, 0))+  
               max(decode(iclt.charge_line_type_name, 'Duties', ia.allocation_amt, 0))+
               max(decode(iclt.charge_line_type_name, 'Import Processing Fee', ia.allocation_amt, 0))+
               max(decode(iclt.charge_line_type_name, 'Freight', ia.allocation_amt, 0))+
               max(decode(iclt.charge_line_type_name, 'Brokerage', ia.allocation_amt, 0))+
               MAX(decode(iclt.charge_line_type_name, 'Port Charges', ia.allocation_amt, 0))+
               max(decode(iclt.charge_line_type_name, 'Trucking', ia.allocation_amt, 0)),2) tot_import_charges,
         round(MAX(decode(iclt.charge_line_type_name,null, ia.allocation_amt, null)),2)+  -- invoice_amount
         round(MAX(decode(iclt.charge_line_type_name, 'Excise Tax', ia.allocation_amt, 0))+  
               MAX(decode(iclt.charge_line_type_name, 'Duties', ia.allocation_amt, 0))+
               MAX(decode(iclt.charge_line_type_name, 'Import Processing Fee', ia.allocation_amt, 0))+
               MAX(decode(iclt.charge_line_type_name, 'Freight', ia.allocation_amt, 0))+
               MAX(decode(iclt.charge_line_type_name, 'Brokerage', ia.allocation_amt, 0))+
               MAX(decode(iclt.charge_line_type_name, 'Port Charges', ia.allocation_amt, 0))+
               MAX(decode(iclt.charge_line_type_name, 'Trucking', ia.allocation_amt, 0)),2) landed_cost,
          :p_vat tot_vat,
        round(round(max(decode(iclt.charge_line_type_name, 'Excise Tax', ia.allocation_amt, 0))+  
               max(decode(iclt.charge_line_type_name, 'Duties', ia.allocation_amt, 0))+
               max(decode(iclt.charge_line_type_name, 'Import Processing Fee', ia.allocation_amt, 0))+
               max(decode(iclt.charge_line_type_name, 'Freight', ia.allocation_amt, 0))+
               max(decode(iclt.charge_line_type_name, 'Brokerage', ia.allocation_amt, 0))+
               MAX(decode(iclt.charge_line_type_name, 'Port Charges', ia.allocation_amt, 0))+
               max(decode(iclt.charge_line_type_name, 'Trucking', ia.allocation_amt, 0)),2) / isla.currency_conversion_rate, 2) tot_import_foreign_rate   -- added 23-Mar-2016
from inl_ship_headers_all isha,
        inl_ship_lines_all isla,
        inl_ship_line_groups islg,
        inl_ship_line_types_b islt,
        inl_allocations ia,
        inl_adj_associations_v iaa,
        inl_adj_charge_lines_v iacl,
        inl_charge_line_types_vl iclt,
        mtl_system_items_b msi,
        po_line_locations_all plla,
        po_lines_all pla,
        po_headers_all pha,
        mtl_transaction_lot_numbers mtln,
         po_vendors pv,
(select a.* ,rcv.transaction_id from (select  a.organization_id, 
receipt_num, 
po_header_id,
-- po_line_id,transaction_id,
lcm_shipment_line_id,
sum(case when transaction_type in ('RETURN TO VENDOR','RETURN TO VENDOR') then 1 else 0 end) tt
from rcv_transactions a,
rcv_shipment_headers b
where a.shipment_header_id = b.shipment_header_id
--and po_header_id = 416308
--and po_line_id = 508348
group by a.organization_id, 
receipt_num, 
po_header_id, 
lcm_shipment_line_id
order by receipt_num) a
,rcv_transactions rcv
where 1=1
--AND tt = 0
and a.lcm_shipment_line_id = rcv.lcm_shipment_line_id
) rt
where isha.ship_header_id = isla.ship_header_id
AND (TT = 0 OR TT IS NULL)
and isla.ship_header_id = islg.ship_header_id
and isla.ship_line_type_id = islt.ship_line_type_id
and isha.ship_header_id = ia.ship_header_id
and isla.ship_line_id = ia.ship_line_id
and ia.association_id = iaa.association_id(+)
and ia.ship_header_id = iaa.ship_header_id(+)
and iaa.from_parent_table_id = iacl.charge_line_id(+)
and iacl.charge_line_type_id = iclt.charge_line_type_id(+)
and isha.organization_id = msi.organization_id
and isla.inventory_item_id = msi.inventory_item_id
and isla.ship_line_source_id = plla.line_location_id
and plla.po_line_id = pla.po_line_id
and pla.po_header_id = pha.po_header_id
and rt.transaction_id = mtln.transaction_source_id(+)        -- added 01-Sep-2015 jpr
and isla.ship_line_id = rt.lcm_shipment_line_id (+)              -- added 01-Sep-2015 jpr
and pha.vendor_id = pv.vendor_id
and isha.ship_num = nvl(:p_ship_num, isha.ship_num)       -- Shipment Number
and isha.attribute5 = nvl(:p_invoice_num, isha.attribute5)                               -- Invoice Number
--and isha.ship_header_id = 117022
group by isha.organization_id, pha.segment1, isha.attribute5, pla.line_num, mtln.lot_number,
         isla.primary_qty, isha.attribute3, isha.attribute11, pv.vendor_name, msi.segment1, msi.description, isha.attribute1, 
         isha.attribute2, pha.currency_code, pla.unit_price, pha.rate, isla.currency_conversion_rate, isha.ship_num,RT.TT
order by isha.ship_num, max(isla.ship_line_num);


SELECT *
FROM inl_ship_headers_all
WHERE attribute5 = 'IMI17AB072-7';
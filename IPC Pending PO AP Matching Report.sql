select doc_sequence_value
from ap_invoices_all
where description like 'DR%9447';


select  a.po_header_id,
            a.org_id, 
            a.vendor_id, 
            f.vendor_name, 
            a.creation_date as po_date,
            a.segment1 as po_number, 
            b.line_num, 
            a.currency_code, 
            a.rate_date,
            b.item_id, 
            b.item_description, 
            b.unit_meas_lookup_code as uom,
            b.list_price_per_unit, 
            b.unit_price, 
            b.quantity,
            c.quantity_delivered,
            c.quantity_billed,
            c.destination_type_code,
            c.destination_organization_id,
            c.destination_subinventory,
            i.receipt_num,
            i.packing_slip as dr_reference,
            h.transaction_date as receiving_date
from
            po_headers_all a,
            po_lines_all b,
            po_distributions_all c,
            ap_invoice_distributions_all d,
            ap_invoices_all e,
            gl_code_combinations_kfv g,
            ap_suppliers f,
            rcv_transactions h,
            rcv_shipment_headers i
where 
        h.shipment_header_id = i.shipment_header_id and 
        a.po_header_id = h.po_header_id and
        b.po_line_id = h.po_line_id and
        c.destination_organization_id =h.organization_id and 
        a.po_header_id = b.po_header_id and
        a.po_header_id = c.po_header_id and
        b.po_line_id = c.po_line_id and 
        c.code_combination_id = g.code_combination_id and
        c.po_distribution_id = d.po_distribution_id(+) and
        d.invoice_id = e.invoice_id(+) and
        a.vendor_id = f.vendor_id and 
        e.invoice_num is null and
        b.cancel_flag <> ('Y') and
        i.packing_slip = 'DR 9352'
      --  a.creation_date between '01-AUG-2017' AND '31-AUG-2017'
   --     to_date(a.creation_date) BETWEEN NVL(to_date(:p_po_start_date,'yyyy/mm/dd hh24:mi:ss') ,to_date(a.creation_date))
                                                                       --   AND NVL(to_date(:p_po_end_date,'yyyy/mm/dd hh24:mi:ss'),to_date(a.creation_date)) -- creation date
       --  a.segment1 = nvl(:p_po_number,a.segment1)
        and c.destination_organization_id = NVL(:p_organization,c.destination_organization_id)
order by a.segment1,
              b.line_num;



select  distinct pha.po_header_id,
            pha.org_id, 
            pha.vendor_id, 
            aps.vendor_name, 
            pha.creation_date as po_date,
            pha.segment1 as po_number, 
            pla.line_num, 
            pha.currency_code, 
            pha.rate_date,
            pla.item_id, 
            pla.item_description, 
            pla.unit_meas_lookup_code as uom,
            pla.list_price_per_unit, 
            pla.unit_price, 
            pla.quantity,
            pda.quantity_delivered,
            pda.quantity_billed,
            pda.destination_type_code,
            pda.destination_organization_id,
            pda.destination_subinventory,
            rsh.receipt_num,
            rsh.packing_slip as dr_reference,
            rcvt.transaction_date as receiving_date
from
            po_headers_all pha
            INNER JOIN po_lines_all pla
                ON pha.po_header_id = pla.po_header_id
            INNER JOIN po_distributions_all pda
                ON pha.po_header_id = pda.po_header_id 
                AND pla.po_line_id = pda.po_line_id  
            INNER JOIN ap_invoice_distributions_all aida
                ON  aida.po_distribution_id = pda.po_distribution_id
            LEFT JOIN ap_invoice_lines_all aila
                ON aila.po_header_id = pha.po_header_id
                AND aila.po_line_id = pla.po_line_id
           LEFT JOIN ap_invoices_all aia
                ON aia.invoice_id = aila.invoice_id
            INNER JOIN ap_suppliers aps
                ON aps.vendor_id = pha.vendor_id
            INNER JOIN rcv_transactions rcvt
                ON rcvt.po_header_id = pha.po_header_id
            INNER JOIN rcv_shipment_headers rsh
                ON rsh.shipment_header_id = rcvt.shipment_header_id
where 
            1 =  1
            --and aia.invoice_num is null 
            and pla.cancel_flag <> 'Y' 
            and rsh.packing_slip = 'DR 9447'
            and to_date(pha.creation_date) BETWEEN NVL(to_date(:p_po_start_date,'yyyy/mm/dd hh24:mi:ss') ,to_date(pha.creation_date))
                                                                 AND NVL(to_date(:p_po_end_date,'yyyy/mm/dd hh24:mi:ss'),to_date(pha.creation_date)) -- creation date
            and pha.segment1 = nvl(:p_po_number,pha.segment1)
            and pda.destination_organization_id = NVL(:p_organization,pda.destination_organization_id)
;
order by pha.segment1,
              pla.line_num;

select *
from ap_invoice_lines_all;
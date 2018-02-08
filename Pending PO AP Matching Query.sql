select 
          -- distinct
            aia.invoice_num,
            pha.po_header_id,
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
from     -- PURCHASE ORDER
            po_lines_all  pla
            INNER JOIN po_headers_all pha
                ON pha.po_header_id = pla.po_header_id
            INNER JOIN ap_suppliers aps
                ON aps.vendor_id = pha.vendor_id
            INNER JOIN po_distributions_all pda
                ON pha.po_header_id = pda.po_header_id 
                AND pla.po_line_id = pda.po_line_id                
            LEFT JOIN rcv_transactions rcvt
                ON rcvt.po_header_id = pla.po_header_id
                AND rcvt.po_line_id = pla.po_line_id
            LEFT JOIN rcv_shipment_headers rsh
                ON rsh.shipment_header_id = rcvt.shipment_header_id
            LEFT JOIN ap_invoice_distributions_all aida
                ON  aida.po_distribution_id = pda.po_distribution_id
            LEFT JOIN ap_invoice_lines_all aila
                ON aila.po_header_id = pla.po_header_id
               AND aila.po_line_id = pla.po_line_id
           LEFT JOIN ap_invoices_all aia
               ON aia.invoice_id = aila.invoice_id
WHERE 
            1 =  1 
           -- and aila.invoice_id is  null 
            and pha.approved_flag = 'Y' 
         --   and rcvt.transaction_date IS NOT NULL
           and pha.segment1 like '201%6536'
           and rsh.packing_slip LIKE 'DR%351%837'
            and pha.type_lookup_code = 'STANDARD'
           and to_date(pha.creation_date) BETWEEN NVL(to_date(:p_po_start_date,'yyyy/mm/dd hh24:mi:ss') ,to_date(pha.creation_date))
                                                                 AND NVL(to_date(:p_po_end_date,'yyyy/mm/dd hh24:mi:ss'),to_date(pha.creation_date)) -- creation date
            and pha.segment1 = nvl(:p_po_number,pha.segment1)
            and pda.destination_organization_id = NVL(:p_organization,pda.destination_organization_id);
            
            SELECT *
            FROM rcv_shipment_headers
            where packing_slip like '%35183%7';
            
            select *
            from po_receipt_all;
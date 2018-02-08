SELECT 'Receipt' Matching, 
            pv.vendor_name, 
            pv.segment1 vendor#,
            pvs.vendor_site_code vendor_site, 
            i.invoice_num, 
            i.invoice_date,
            d.ACCOUNTING_DATE, 
            i.invoice_amount,
            i.amount_paid,
            d.DISTRIBUTION_LINE_NUMBER, 
            h.receipt_num,
             t.TRANSACTION_DATE ,
            h.SHIPMENT_NUM, 
            ph.segment1 po#, 
            pl.line_num po_line_num,
            d.line_type_lookup_code, 
            d.description, 
            pl.item_description,
            d.amount line_amount,
            d.QUANTITY_INVOICED , 
            decode(d.line_type_lookup_code,'TAX', 0,pl.QUANTITY) Po_line_qty, 
            decode(d.line_type_lookup_code,'TAX', 0,pl.UNIT_PRICE) UNIT_PRICE,
            decode(d.line_type_lookup_code,'TAX', 0, t.quantity) receipt_qty,
            i.vendor_id, 
            i.vendor_site_id, 
            i.invoice_id, 
            d.invoice_distribution_id,
            ph.po_header_id, 
            pl.po_line_id, 
            pd.po_distribution_id
FROM   ap_invoice_distributions_all d, 
            ap_invoices_all i,
            po_distributions_all pd,
            rcv_transactions t, 
            rcv_shipment_headers h, 
            po_lines_all pl, 
            po_headers_all ph,
            po_vendors pv, 
            po_vendor_sites_all pvs
WHERE 1 = 1
            and i.invoice_id = d.invoice_id (+)
            and i.vendor_id = pv.vendor_id 
            and i.vendor_site_id = pvs.vendor_site_id 
            and d.po_distribution_id = pd.po_distribution_id 
            and d.rcv_transaction_id = t.transaction_id 
            and h.shipment_header_id = t.shipment_header_id(+) 
            and t.PO_LINE_ID = pl.po_line_id 
            and pl.po_header_id = ph.po_header_id
         --   and ph.segment1 = :P_PO_NUM -- 20100003159 PARAMS (Required)
--            and h.packing_slip = :P_PACKING_SLIP 'DR 50557'
          --  and pl.line_num IN (253,208)
               and h.packing_slip = 'DR 34957'
          --  and h.receipt_num = '907'
--and i.invoice_amount = -;
--order by t.transaction_date desc;
;

select *
from rcv_shipment_headers
whe;


select rcvt.po_line_id,
           rcvt.po_header_id,
           aia.invoice_num
           
from rcv_shipment_headers rsh 
        LEFT JOIN rcv_transactions rcvt
            ON rsh.shipment_header_id = rcvt.shipment_header_id
        LEFT JOIN ap_invoice_lines_all aila
            ON aila.po_line_id = rcvt.po_line_id
        LEFT JOIN ap_invoices_all aia
            ON aia.invoice_id = aila.invoice_id
where rsh.packing_slip = 'DR 34957';
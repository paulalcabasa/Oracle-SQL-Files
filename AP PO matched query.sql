SELECT aia.doc_sequence_value ap_voucher_no,
            aia.invoice_num,
            aia.invoice_date,
            aia.invoice_amount,
            aila.line_type_lookup_code,
            aila.line_number invoice_line_number,
            aila.amount invoice_line_amount,
            aila.description,
            pha.segment1 po_number,
            pla.line_num po_line_num,
            pla.po_line_id,
            rcvt.TRANSACTION_TYPE
FROM ap_invoice_lines_all aila 
            INNER JOIN ap_invoices_all aia
                ON aila.invoice_id = aia.invoice_id
            INNER JOIN po_headers_all pha
                ON pha.po_header_id = aila.po_header_id
            INNER JOIN po_lines_all pla
                ON pla.po_header_id = pha.po_header_id
                AND pla.po_line_id = aila.po_line_id
            LEFT JOIN rcv_transactions rcvt
                ON rcvt.po_line_id = pla.po_line_id
                AND rcvt.po_header_id = pla.po_header_id
    
            LEFT JOIN rcv_shipment_headers rsh
                ON rsh.shipment_header_id = rcvt.shipment_header_id  
WHERE 
--pha.segment1 = '20100006536'
            --and 
            rsh.packing_slip LIKE '%DR 34200%';
            
            
SELECT rsh.packing_slip,
             rcvt.transaction_type,
             aia.invoice_num,
             aia.doc_sequence_value,
             pha.segment1,
             pla.item_description
FROM rcv_shipment_headers rsh
            LEFT JOIN rcv_transactions rcvt
                ON rsh.shipment_header_id = rcvt.shipment_header_id
            LEFT JOIN po_lines_all pla
                ON pla.po_line_id = rcvt.po_line_id
             LEFT JOIN ap_invoice_lines_all aila
                ON aila.po_line_id = pla.po_line_id
             LEFT JOIN ap_invoices_all aia
                ON aia.invoice_id = aila.invoice_id
             LEFT JOIN po_headers_all pha  
                ON pha.po_header_id = rcvt.po_header_id
              
where packing_slip like '%DR 34200%'
            and pha.segment1 = '20100005304';

select pha.segment1,
            rsh.packing_slip
from po_headers_all pha LEFT JOIN rcv_transactions rcvt
        ON pha.po_header_id = rcvt.po_header_id
        left join rcv_shipment_headers rsh
            ON rsh.shipment_header_id = rcvt.shipment_header_id
where segment1 = '20100005304'
            and packing_slip like '%34200%';

selec
            select *
            from rcv_transactions
            where po_line_id = 1939500;
            
            select *
            from po_headers_all;
            
            SELECT *
            FROM RCV_SHIPMENT_HEADERS
            WHERE PACKING_SLIP LIKE '%12810%';
            
            select *
            from po_lines_all;

selec
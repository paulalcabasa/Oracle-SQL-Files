-- DR18234
select rsh.receipt_num,
           rsh.packing_slip,
           rcvt.transaction_id
from rcv_shipment_headers rsh,
        rcv_shipment_lines rsl,
        rcv_transsactions rcvt
where 1 = 1
            and rsl.shipment_header_id = rsh.shipment_header_id
            and rcvt.shipment_header_id = rsl.shipment_header_id
            and rcvt.shipment_line_id = rsl.shipment_line_id
            and rcvt.shipment_header_id = rsh.shipment_header_id
             and rsh.packing_slip = 'DR 18234';
            
            
            select *
            from rcv_transactions;

select *
from po_headers_all
where segment1 like '%2170%';

select *
from rcv_shipment_headers;

select *
from rcv_transactions;
SELECT distinct aia.invoice_num, aia.doc_sequence_value voucher_no
FROM ap_invoices_all aia,
           ap_invoice_lines_all aila,
           po_headers_all pha,
           rcv_transactions rcvt,
           rcv_shipment_headers rsh
           
where 1 = 1
            and aia.invoice_id = aila.invoice_id
            and pha.po_header_id = aila.po_header_id
            and rcvt.po_line_id = aila.po_line_id
            and rcvt.po_header_id = rcvt.po_header_id
            and rsh.shipment_header_id = rcvt.shipment_header_id
            and pha.segment1 = '20100003170'
         --   and aia.description like 'DR%18234';
            and rsh.packing_slip like '%DR%18234%';

select *
from RCV_SHIPMENT_LINES;

select *
from po_receipts;
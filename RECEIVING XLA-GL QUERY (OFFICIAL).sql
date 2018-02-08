select 
    rrsl.rcv_transaction_id,
    rsh.packing_slip,
    rsh.shipment_num,
    pha.segment1,
    pla.line_num po_number,
    rcvt.transaction_date receive_date,
    --    mmt.transaction_id,
        msib.segment1 part_no,
        msib.description,
        mck.segment1 as item_category_family,
        mck.segment2 as item_category_class,
        msib.item_type,
        flv.meaning  item_type_description,
        gjh.doc_sequence_value voucher_no,
        gjl.je_line_num,
        gcc.segment6                   AS "Account",
        xal.entered_dr,
        xal.entered_cr,
        xal.accounted_dr,
        xal.accounted_cr,
        xal.description,
        gjl.description,
        xah.accounting_date,
        gjh.je_source,
        gjh.je_category,
        xah.gl_transfer_status_code    AS "GL Transfer Status Code",
        xah.je_category_name           AS "JE Category Name",
--        -- XLA 
        xah.period_name                AS "Period Name",
        xdl.source_distribution_type,
        xal.accounting_class_code      AS "Accounting Class Code",
        xdl.accounting_line_code       AS "Accounting Line Code",
        xdl.line_definition_code       AS "Line Definition COde",
        xdl.event_class_code           AS "Event Class Code",
        xdl.event_type_code            AS "Event Type Code",
        xdl.rounding_class_code        AS "Rounding Class Code",
        xah.accounting_entry_type_code AS "Accounting Entry Type Code",
        xah.doc_sequence_value         AS "Document Sequence Value",
        xah.description                AS "Description",
        xal.description                AS "Line Description"
from xla_ae_headers xah  
        INNER JOIN xla_ae_lines xal
            ON xah.ae_header_id = xal.ae_header_id
            AND xah.application_id = xal.application_id
        INNER JOIN xla_distribution_links xdl
            ON  xah.ae_header_id = xdl.ae_header_id
            AND xah.event_id = xdl.event_id
            AND xdl.ae_line_num = xal.ae_line_num
            AND xdl.application_id = 707
        INNER JOIN rcv_receiving_sub_ledger rrsl
            ON rrsl.rcv_sub_ledger_id = xdl.source_distribution_id_num_1
             
        INNER JOIN gl_code_combinations gcc
            ON gcc.code_combination_id = xal.code_combination_id
        -- PO
        INNER JOIN rcv_transactions rcvt
            ON rcvt.transaction_id = rrsl.rcv_transaction_id   
        INNER JOIN po_headers_all pha
            ON pha.po_header_id = rcvt.po_header_id
        INNER JOIN po_lines_all pla
            ON pla.po_header_id = pha.po_header_id
            AND rcvt.po_line_id = pla.po_line_id
        INNER JOIN rcv_shipment_headers rsh
            ON rsh.shipment_header_id = rcvt.shipment_header_id
--        INNER JOIN mtl_material_transactions mmt
--            ON mmt.transaction_source_id = rcvt.po_header_id
--            AND mmt.organization_id = rcvt.organization_id
--            AND TRANSACTION_SOURCE_TYPE_ID = 1
           -- shipment no 403
        -- supplier - mitsubishi corp (taiwan) LTD
       -- ITEM
       INNER JOIN    mtl_system_items_b msib
            ON pla.item_id = msib.inventory_item_id
            AND rcvt.organization_id = msib.organization_id
        INNER JOIN mtl_item_categories  mtc
            ON msib.inventory_item_id = mtc.inventory_item_id 
            AND msib.organization_id = mtc.organization_id 
        INNER JOIN mtl_categories_kfv mck 
            ON mtc.category_id =mck.category_id 
            AND  mck.structure_id = '50388'
        INNER JOIN fnd_lookup_values flv
            ON  msib.item_type = flv.lookup_code  
            AND  flv.lookup_type = 'ITEM_TYPE'
        INNER JOIN hr_all_organization_units org
            ON org.organization_id = msib.organization_id
            
        -- GL
        LEFT JOIN apps.gl_import_references gir
            ON gir.gl_sl_link_id = xal.gl_sl_link_id
            AND gir.gl_sl_link_table = xal.gl_sl_link_table
        LEFT JOIN apps.gl_je_lines gjl
            ON gjl.je_header_id = gir.je_header_id
            AND gjl.je_line_num = gir.je_line_num   
        LEFT JOIN apps.gl_je_headers gjh         
            ON gjh.je_header_id = gjl.je_header_id
where 1 = 1
      AND xdl.source_distribution_type = 'RCV_RECEIVING_SUB_LEDGER'
      AND trunc(rcvt.transaction_date) BETWEEN '01-SEP-2017' AND '31-DEC-2017'
    --  and rsh.shipment_num = '822.1'
  --    AND rsh.receipt_num = '30327'
  --    AND xah.accounting_date BETWEEN '01-AUG-2017' AND '01-AUG-2017'
--    AND gjh.doc_sequence_value = '81001035'
     --   AND GJL.JE_LINE_NUM = 608
     -- and mmt.transaction_id = 4298473
    --    AND mck.segment1 IN ('CKD','CBU')
        -- CKD AND CBU 
        -- EXTRACT AUGUST
 --    AND rcvt.po_header_id = 1753487
    --  AND rsh.packing_slip = 'MZA7BSN12203'
   --  AND xdl.event_class_code IN ('LDD_COST_ADJ_RCV','LDD_COST_ADJ_DEL')
    
     --   AND gjh.doc_sequence_value = '81000028'
  --     AND gcc.segment6 = '89911';
;

select *
from rcv_transactions;
SELECT *
FROM PO_HEADERS_ALL
WHERE SEGMENT1 = '20100006767';
select *
from po_headers_all
where segment1 like '201%5485';

select *
from rcv_transactions;

SELECT *
FROM INL_CHARGE_LINES;

SELECT *
FROM INL_SHIP_HEADERS_ALL;
select rcv_sub_ledger_id
from rcv_receiving_sub_ledger;

/* Formatted on 7/9/2017 9:34:49 AM (QP5 v5.163.1008.3004) */
SELECT rt.po_header_id,
       pd.po_distribution_id,
       rt.transaction_id,
       rrsl.rcv_sub_ledger_id,
       xdl.ae_header_id,
       xdl.SOURCE_DISTRIBUTION_ID_NUM_1,
       xdl.SOURCE_DISTRIBUTION_TYPE
  FROM rcv_receiving_sub_ledger rrsl,
       rcv_transactions rt,
       po_distributions_all pd,
       xla_distribution_links xdl
 WHERE     pd.po_distribution_id = rt.PO_DISTRIBUTION_ID
       AND rt.transaction_id = rrsl.rcv_transaction_id
       AND rt.PO_DISTRIBUTION_ID = rrsl.reference3
       AND rrsl.rcv_sub_ledger_id = xdl.SOURCE_DISTRIBUTION_ID_NUM_1
       AND xdl.SOURCE_DISTRIBUTION_TYPE = 'RCV_RECEIVING_SUB_LEDGER'
       AND xdl.APPLICATION_ID = 707
       AND rrsl.rcv_transaction_id = 2013579;
      

SELECT *
FROM rcv_receiving_sub_ledger
where rcv_transaction_id = 2013579;

 
select *
from rcv_transactions
where transaction_id = 2013579;

select *
from po_lines_all
where po_line_id = 1475568;

select *
from po_headers_all
where PO_HEADER_ID = 1225428;

select *
from hr_locations_all
where location_id = 2305;

select * from mtl_material_transactions
where transaction_source_id = 1225428
-- and inventory_item_id = 136847
and organization_id = 88;

select *
from rcv_shipment_headers;
/* Query to be given to Ms. Grace for Receiving */
select 
        pha.segment1 po_number,
        pla.line_num po_line_num,
        msib.segment1 item,
        pla.quantity po_quantity,
        rsh.shipment_num,
        rsh.packing_slip dr_num,
        rsh.receipt_num,
--        REGEXP_SUBSTR (xal.description, '[^ ]+', 1,7)    AS transaction_type,
        aia.doc_sequence_value ap_voucher_no,
        aia.invoice_num,
        gjh.doc_sequence_value voucher_no,
        gjl.je_line_num,
        gcc.segment6 account,
        xah.accounting_date,
        gjh.je_source,
        gjh.je_category,
        xah.gl_transfer_status_code    AS "GL Transfer Status Code",
        xah.je_category_name           AS "JE Category Name",
--        -- XLA 
        xah.period_name                AS "Period Name",
        xdl.source_distribution_type,
        xal.accounting_class_code      AS "Accounting Class Code",
        xdl.accounting_line_code       AS "Accounting Line Code",
        xdl.line_definition_code       AS "Line Definition COde",
        xdl.event_class_code           AS "Event Class Code",
        xdl.event_type_code            AS "Event Type Code",
        xdl.rounding_class_code        AS "Rounding Class Code",
        xah.accounting_entry_type_code AS "Accounting Entry Type Code",
        xah.doc_sequence_value         AS "Document Sequence Value",
        nvl(xah.description,gjh.description)                AS "Description",
        nvl(xal.description,gjl.description) line_description,
        nvl(xal.entered_dr,0) entered_dr,
        nvl(xal.entered_cr,0) entered_cr,
        nvl(xal.entered_dr,0) - nvl(xal.entered_cr,0) entered_amount,
        nvl(xal.accounted_dr,0) accounted_dr,
        nvl(xal.accounted_cr,0) accounted_cr,
        nvl(xal.accounted_dr,0) - nvl(xal.accounted_cr,0) accounted_amount
from xla_ae_headers xah  
        INNER JOIN xla_ae_lines xal
            ON xah.ae_header_id = xal.ae_header_id
            AND xah.application_id = xal.application_id
        INNER JOIN xla_distribution_links xdl
            ON  xah.ae_header_id = xdl.ae_header_id
            AND xah.event_id = xdl.event_id
            AND xdl.ae_line_num = xal.ae_line_num
        INNER JOIN rcv_receiving_sub_ledger rrsl
            ON rrsl.rcv_sub_ledger_id = xdl.source_distribution_id_num_1
        INNER JOIN rcv_transactions rcvt
            ON rcvt.transaction_id = rrsl.rcv_transaction_id
        INNER JOIN rcv_shipment_headers rsh
            ON rsh.shipment_header_id = rcvt.shipment_header_id
        INNER JOIN po_headers_all pha
            ON pha.po_header_id = rcvt.po_header_id
        INNER JOIN po_lines_all pla
            ON pla.po_header_id = rcvt.po_header_id
            AND rcvt.po_line_id = pla.po_line_id
        INNER JOIN hr_locations_all hla
            ON hla.location_id = pha.ship_to_location_id
        INNER JOIN mtl_system_items_b msib
            ON msib.inventory_item_id = pla.item_id
            AND msib.organization_id = hla.inventory_organization_id
        INNER JOIN ap_invoice_lines_all aila
            ON aila.po_line_id = pla.po_line_id
            AND aila.po_header_id = pla.po_header_id
            AND aila.line_type_lookup_code = 'ITEM'
        INNER JOIN ap_invoices_all aia
            ON aia.invoice_id = aila.invoice_id
--        INNER JOIN mtl_material_transactions mmt
--            ON mmt.rcv_transaction_id = rcvt.transaction_id
        INNER JOIN gl_code_combinations gcc
            ON gcc.code_combination_id = xal.code_combination_id
        LEFT JOIN apps.gl_import_references gir 
            ON gir.gl_sl_link_id = xal.gl_sl_link_id
            AND gir.gl_sl_link_table = xal.gl_sl_link_table
        LEFT JOIN apps.gl_je_lines gjl 
            ON gjl.je_header_id = gir.je_header_id
            AND gjl.je_line_num = gir.je_line_num   
        LEFT JOIN apps.gl_je_headers gjh         
            ON gjh.je_header_id = gjl.je_header_id
where 1 = 1
        AND xdl.source_distribution_type = 'RCV_RECEIVING_SUB_LEDGER'
--        AND pha.segment1 = '20100003971';
--        AND pha.segment1 = '20100003229';
        AND xah.accounting_date between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
        AND gcc.segment6 BETWEEN NVL (:P_ACCOUNT_CODE_FROM, gcc.segment6)
                            AND NVL (:P_ACCOUNT_CODE_TO, gcc.segment6);
--        AND xdl.event_class_code IN ('RCPT_REC_INSP')
        
--        
--      AND xal.accounting_class_code = 'RECEIVING_INSPECTION'
;    
        AND gcc.segment6 NOT IN ('65600');
        
        
        


SELECT *
FROM rcv_shipment_headers
where SHIPMENT_NUM like '822%'
            and receipt_num = '30327';
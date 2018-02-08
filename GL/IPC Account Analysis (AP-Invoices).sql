SELECT    distinct 
--   aila.PO_LINE_ID,
            nvl(fu_trans.description,fu_trans.user_name) transacted_by,
            fu_trans.user_id transacted_by_id,
            aia.creation_date date_created,
            nvl(fu_posted.description,fu_posted.user_name) gl_posted_by,
            fu_posted.user_id gl_posted_by_id,
            gjh.creation_date date_posted,
            to_number(gjh.doc_sequence_value) gl_voucher_no,
            xah.period_name,
            aia.invoice_num,
            aia.doc_sequence_value voucher_no,
            gjh.je_source,
            xah.je_category_name,
            
        --        gjl.je_line_num,
            to_char(glcc.segment6) account_no,
            to_char(xah.accounting_date) accounting_date,
            xah.gl_transfer_status_code,
            to_char(xah.gl_transfer_date) gl_transfer_date,
--            sum(aida.amount) distribution_amount,
            xal.entered_dr,
            xal.entered_cr, 
            nvl(xal.entered_dr,0) - nvl(xal.entered_cr,0) entered_amount,
            xal.accounted_dr,
            xal.accounted_cr,
            nvl(xal.accounted_dr,0) - nvl(xal.accounted_cr,0) accounted_amount,
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
--                sum(nvl(xal.entered_dr,0)) xla_entered_dr,
--                sum(nvl(xal.entered_cr,0)) xla_entered_cr,
--                sum(nvl(xal.accounted_dr,0)) xla_accounted_dr,
--                sum(nvl(xal.accounted_cr,0)) xla_accounted_cr
          
 --           gjl.entered_dr gl_entered_dr,
  --          gjl.entered_cr gl_entered_cr,
   --         gjl.accounted_dr gl_accounted_dr,
   --         gjl.accounted_cr gl_accounted_cr
        
FROM   
        xla.xla_ae_headers xah 
        INNER JOIN xla.xla_ae_lines xal
            ON  xah.ae_header_id = xal.ae_header_id 
            AND xal.application_id = xah.application_id
        INNER JOIN apps.gl_code_combinations glcc
            ON xal.code_combination_id = glcc.code_combination_id
        INNER  JOIN xla.xla_transaction_entities xte
            ON xah.entity_id = xte.entity_id
            AND xte.application_id = xal.application_id
        INNER JOIN xla_distribution_links xdl
            ON xah.ae_header_id = xdl.ae_header_id
            and xdl.event_id = xah.event_id
            and xdl.ae_line_num = xal.ae_line_num
            and xdl.application_id = xah.application_id


--        INNER JOIN ap_invoice_distributions_all aida
--            ON xdl.source_distribution_id_num_1 = aida.invoice_distribution_id
--            AND xdl.source_distribution_type = 'AP_INV_DIST'
        INNER JOIN ap_invoices_all aia
            ON  aia.invoice_id = NVL(xte.source_id_int_1,-99)
            AND xte.entity_code = 'AP_INVOICES'
        LEFT JOIN ap_invoice_lines_all aila
            ON aila.invoice_id = aia.invoice_id
        LEFT JOIN po_lines_all pla
            ON pla.po_line_id = aila.po_line_id
        LEFT JOIN po_headers_all pha
            ON pha.po_header_id = pla.po_header_id
        LEFT JOIN rcv_transactions rcvt
            ON rcvt.po_header_id = pla.po_header_id
            AND rcvt.po_line_id = pla.po_line_id
        LEFT JOIN rcv_shipment_headers rsh
            ON rsh.shipment_header_id = rcvt.shipment_header_id
         
--        INNER JOIN ap_invoice_lines_all aila
--            ON aila.invoice_id = aia.invoice_id
--            and aila.line_number = aida.INVOICE_LINE_NUMBER 
         -- ITEM
--       INNER JOIN rcv_transactions rcvt
--            ON rcvt.transaction_id = aida.rcv_transaction_id
--         INNER JOIN ap_invoice_lines_all aila
--            ON rcvt.transaction_id = aila.rcv_transaction_id    
--        INNER JOIN mtl_system_items_b msib
--            ON msib.inventory_item_id = aila.inventory_item_id
--            AND rcvt.organization_id = msib.organization_id
----  
--        INNER JOIN mtl_item_categories  mtc
--            ON msib.inventory_item_id = mtc.inventory_item_id 
--            AND msib.organization_id = mtc.organization_id 
--        INNER JOIN mtl_categories_kfv mck 
--            ON mtc.category_id =mck.category_id 
--          INNER JOIN fnd_lookup_values flv
--            ON  msib.item_type = flv.lookup_code  
--        
--            INNER JOIN hr_all_organization_units org
--            ON org.organization_id = rcvt.organization_id
       -- GL LINK
       LEFT JOIN apps.gl_import_references gir
            ON gir.gl_sl_link_id = xal.gl_sl_link_id
            AND gir.gl_sl_link_table = xal.gl_sl_link_table
        LEFT JOIN apps.gl_je_lines gjl
            ON gjl.je_header_id = gir.je_header_id
            AND gjl.je_line_num = gir.je_line_num
        LEFT JOIN apps.gl_je_headers gjh         
            ON gjh.je_header_id = gir.je_header_id
        LEFT JOIN   fnd_user fu_trans
            ON fu_trans.user_id = gjh.created_by
        LEFT JOIN fnd_user fu_posted
            ON fu_posted.user_id = gjh.created_by
            
            
WHERE 1 = 1
           and pha.segment1 = '20100006508'
         --       and gjh.doc_sequence_value = '83090747'
--            and aia.doc_sequence_value = '20006406'
--            AND  flv.lookup_type = 'ITEM_TYPE'
--            AND  mck.structure_id = '50388'
--            AND glcc.segment6 = '89910'
        --  and aila.po_line_id is null
       --    and glcc.segment6 = '89911'
          and xah.je_category_name = 'Purchase Invoices'
--           and gjh.doc_sequence_value = '83011459'
   --   AND gjh.doc_sequence_value IN ('83033984')
       --     and xah.accounting_date BETWEEN '05-OCT-2017' AND '30-OCT-2017'
 --  and xah.accounting_date BETWEEN '01-FEB-2017' AND '28-FEB-2017'
   --  and xah.accounting_date BETWEEN '01-MAR-2017' AND '31-MAR-2017'
  --     and xah.accounting_date BETWEEN '01-APR-2017' AND '30-APR-2017' 
--         and xah.accounting_date BETWEEN '01-MAY-2017' AND '31-MAY-2017' 
 -- and xah.accounting_date BETWEEN '01-JAN-2017' AND '30-JUN-2017' 
 ;
group by 
--                org.organization_id,
--                org.name,
--            aila.PO_LINE_ID,
                xah.period_name,
                aia.invoice_num,
                aia.doc_sequence_value,
--               mck.segment1,
                gjh.je_source,
                xah.je_category_name,
                gjh.doc_sequence_value,
       --         gjl.je_line_num,
                glcc.segment6,
                xah.accounting_date,
                xah.gl_transfer_status_code,
                xah.gl_transfer_date,
                xal.entered_dr ,
                xal.entered_cr ,
                xal.accounted_dr ,
                xal.accounted_cr 
;
-- end of invoices correct 2X

select *
from gl_je_headers
where doc_sequence_value = '83011459';
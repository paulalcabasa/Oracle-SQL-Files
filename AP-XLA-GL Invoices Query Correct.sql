SELECT    
--   aila.PO_LINE_ID,
            to_char(gjh.doc_sequence_value) gl_voucher_no,
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
            sum(aida.amount) distribution_amount,
            xal.entered_dr,
            xal.entered_cr, 
            nvl(xal.entered_dr,0) - nvl(xal.entered_cr,0) entered_amount,
            xal.accounted_dr,
            xal.accounted_cr,
            nvl(xal.accounted_dr,0) - nvl(xal.accounted_cr,0) accounted_amount
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
        INNER JOIN ap_invoice_distributions_all aida
            ON xdl.source_distribution_id_num_1 = aida.invoice_distribution_id
        INNER JOIN ap_invoices_all aia
            ON  aia.invoice_id = aida.invoice_id
        INNER JOIN ap_invoice_lines_all aila
            ON aila.invoice_id = aia.invoice_id
            and aila.line_number = aida.INVOICE_LINE_NUMBER 
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
            
            
WHERE 1 = 1
           AND xte.entity_code = 'AP_INVOICES' 
            AND xdl.source_distribution_type = 'AP_INV_DIST'
--            and aia.doc_sequence_value = '20006406'
--            AND  flv.lookup_type = 'ITEM_TYPE'
--            AND  mck.structure_id = '50388'
--            AND glcc.segment6 = '89910'
        --  and aila.po_line_id is null
           
           and xah.je_category_name = 'Purchase Invoices'
   --   AND gjh.doc_sequence_value IN ('83033984')
 and xah.accounting_date BETWEEN '01-JAN-2017' AND '30-OCT-2017'
 --  and xah.accounting_date BETWEEN '01-FEB-2017' AND '28-FEB-2017'
   --  and xah.accounting_date BETWEEN '01-MAR-2017' AND '31-MAR-2017'
  --     and xah.accounting_date BETWEEN '01-APR-2017' AND '30-APR-2017' 
--         and xah.accounting_date BETWEEN '01-MAY-2017' AND '31-MAY-2017' 
 -- and xah.accounting_date BETWEEN '01-JAN-2017' AND '30-JUN-2017' 
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

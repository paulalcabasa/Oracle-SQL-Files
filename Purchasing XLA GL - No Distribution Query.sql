SELECT 
        xte.entity_code,
-- mmt.transaction_id,
-- msib.organization_id,
-- org.name organization,
        xah.period_name, 
-- msib.segment1 part_no,
-- msib.description,
-- mck.segment1 as item_category_family,
-- mck.segment2 as item_category_class,
-- msib.item_type,

        -- flv.meaning  item_type_description,
--        gjh.je_source,
        xal.ae_line_num,
        xal.ae_header_id,
---        xal.ae_line_id,
        xal.description,
        xah.je_category_name,
        to_char(gjh.doc_sequence_value) gl_voucher_no,
--        gjl.je_line_num,
        to_char(glcc.segment6) account_no,
        to_char(xah.accounting_date) accounting_date,
        xah.gl_transfer_status_code,
        to_char(xah.gl_transfer_date) gl_transfer_date,
        xal.entered_dr xla_entered_dr,
        xal.entered_cr xla_entered_cr,
        xal.accounted_dr xla_accounted_dr,
        xal.accounted_cr xla_accounted_cr,
        xdl.source_distribution_type   AS "Source Distribution Type",
        xal.accounting_class_code      AS "Accounting Class Code",
        xdl.accounting_line_code       AS "Accounting Line Code",
        xdl.line_definition_code       AS "Line Definition COde",
        xdl.event_class_code           AS "Event Class Code",
        xdl.event_type_code            AS "Event Type Code",
        xdl.rounding_class_code        AS "Rounding Class Code",
        xah.accounting_date            AS "Accounting Date",
        xah.gl_transfer_status_code    AS "GL Transfer Status Code",
        xah.gl_transfer_date           AS "GL Transfer Date",
        xah.je_category_name           AS "JE Category Name",
        xah.accounting_entry_type_code AS "Accounting Entry Type Code",
        xah.doc_sequence_value         AS "Document Sequence Value"
--        gjl.entered_dr gl_entered_dr,
--        gjl.entered_cr gl_entered_cr,
--        gjl.accounted_dr gl_accounted_dr,
--        gjl.accounted_cr gl_accounted_cr
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
        INNER JOIN rcv_receiving_sub_ledger rcv
            ON xdl.source_distribution_id_num_1 = rcv.rcv_sub_ledger_id
        INNER JOIN rcv_transactions rcvt
            ON rcv.rcv_transaction_id = rcvt.transaction_id
        INNER JOIN po_headers_all poh
            ON poh.po_header_id = rcvt.po_header_id
--        INNER JOIN mtl_material_transactions mmt
--            ON mmt.rcv_transaction_id = rcvt.transaction_id
--        INNER JOIN po_lines_all pla
--            ON pla.po_header_id = poh.po_header_id
         -- GL
         LEFT JOIN apps.gl_import_references gir
            ON gir.gl_sl_link_id = xal.gl_sl_link_id
            AND gir.gl_sl_link_table = xal.gl_sl_link_table
        LEFT JOIN apps.gl_je_lines gjl
            ON gjl.je_header_id = gir.je_header_id
            AND gjl.je_line_num = gir.je_line_num
        LEFT JOIN apps.gl_je_headers gjh         
            ON gjh.je_header_id = gjl.je_header_id
--        LEFT JOIN mtl_material_transactions mmt
--            ON mmt.transaction_id = mta.transaction_id
--        LEFT JOIN    mtl_system_items_b msib
--            ON mmt.inventory_item_id = msib.inventory_item_id
--            AND mmt.organization_id = msib.organization_id
--        LEFT JOIN mtl_item_categories  mtc
--            ON msib.inventory_item_id = mtc.inventory_item_id 
--            AND msib.organization_id = mtc.organization_id 
--        LEFT JOIN mtl_categories_kfv mck 
--            ON mtc.category_id =mck.category_id 
--                
--        LEFT JOIN fnd_lookup_values flv
--            ON  msib.item_type = flv.lookup_code  
--        LEFT JOIN hr_all_organization_units org
--            ON org.organization_id = msib.organization_id
      
WHERE 1 = 1
--            AND  mck.structure_id = '50388'
--            AND  flv.lookup_type = 'ITEM_TYPE'
            AND xdl.source_distribution_type = 'RCV_RECEIVING_SUB_LEDGER'
     --       AND line_type = 'LINE'
    --       AND glcc.segment6 IN ('65600')
   --         AND xah.accounting_date 
        AND poh.segment1 = '20100004439'
          --  AND xte.entity_code = 'TRANSACTIONS'
            
       --     and rct_gl.amount > 0
     --  AND rcta.trx_number = '40200013994'
       --    AND xah.accounting_date BETWEEN '01-JUL-2017' AND '05-JUL-2017'
     --      AND mmt.transaction_id = 868778
       --      AND mmt.organization_id = 102
       
       ;
group by    
--    xte.entity_code,
        mmt.transaction_id,
        msib.organization_id,
        org.name,
        xah.period_name,
         mck.segment1 ,
        mck.segment2 ,
       msib.item_type,
        flv.meaning ,
    msib.segment1 ,
   msib.description,
    --    rcta.attribute3 ,
        --  rctta.name,
        --    rctta.description,
        --    rcta.attribute4 lot_no,
  --      rctal.customer_trx_line_id,
    --    rcta.comments ,
    --    msib.segment1 ,
     --   msib.description,
--       mck.segment1  ,
     --   mck.segment2  ,
     --   msib.item_type,
     --   flv.meaning   ,
  --      rctal.description,
    --    rcta.trx_date  ,
        gjh.je_source,
        xal.description,
        xah.JE_CATEGORY_NAME,
        to_char(gjh.doc_sequence_value)  ,
        gjl.je_line_num,
        to_char(glcc.segment6)  ,

      
        to_char(xah.accounting_date)  ,
        xah.gl_transfer_status_code,
        to_char(xah.gl_transfer_date)  ,
 --     rct_gl.amount,
        xal.entered_dr  ,
        xal.entered_cr  ,
        xal.accounted_dr  ,
        xal.accounted_cr  ,
        gjl.entered_dr  ,
        gjl.entered_cr  ,
        gjl.accounted_dr  ,
        gjl.accounted_cr  
      ---     AND gjh.doc_sequence_value = '84017217'
    --   AND rcta.trx_number = '40200012379'
          --  AND gjh.je_source = 'Receivables'
;


SELECT *
FROM
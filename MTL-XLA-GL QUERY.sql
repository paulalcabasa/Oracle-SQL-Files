SELECT DISTINCT TRANSACTION_SOURCE_NAME
FROM MTL_MATERIAL_TRANSACTIONS
ORDER BY TRANSACTION_SOURCE_NAME ASC;

SELECT 
--        glcc.segment1 company, glcc.segment2 LOCATION,
--       glcc.segment3 cost_center, glcc.segment4 ACCOUNT,
--       glcc.segment5 product, glcc.segment6 channel, glcc.segment7 project,
--       (SELECT flex_value || ' ' || fvt.description
--          FROM apps.gl_code_combinations glc,
--               apps.fnd_flex_values fv,
--               apps.fnd_flex_values_tl fvt
--         WHERE glc.code_combination_id = gjl.code_combination_id
--           AND glc.segment4 = fv.flex_value
--           AND fv.flex_value_set_id = 1002653
--           AND fv.flex_value_id = fvt.flex_value_id) code_combo_desc,
--       gjh.posted_date posted_on_dt, gjh.je_source, gjh.je_category,
--       gjb.NAME je_batch_name, gjh.NAME journal_name, '' je_seq_name,
--       '' je_seq_num, gjl.je_line_num je_line, gjl.description je_line_descr,
--       xal.entered_cr global_cr, xal.entered_dr global_dr,
--       xal.currency_code global_cur, ac.customer_name vendor_customer,
--       rcta.trx_number transaction_num, rcta.trx_date transaction_date,
--       xal.accounting_class_code transaction_type, xal.accounted_cr local_cr,
--       xal.accounted_dr local_dr, gl.currency_code local_cur,
--       (NVL (xal.accounted_dr, 0) - NVL (xal.accounted_cr, 0)
--       ) transaction_amount,
--       gl.currency_code transaction_curr_code, gjh.period_name fiscal_period,
--       (gb.begin_balance_dr - gb.begin_balance_cr) begin_balance,
--       (  gb.period_net_dr
--        - gb.period_net_cr
--        + gb.project_to_date_dr
--        - gb.project_to_date_cr
--       ) end_balance,
--       gl.NAME ledger_name
   --     xte.entity_code ,
        mmt.transaction_id,
        msib.organization_id,
        org.name organization,
        xah.period_name,
    --    rcta.trx_number invoice_number,
      --  rcta.attribute3 cs_no,
        --  rctta.name,
        --    rctta.description,
        --    rcta.attribute4 lot_no,
   --     rctal.customer_trx_line_id,
   --     rcta.comments ifs_invoice_no,
   --     msib.segment1 part_no,
   --     msib.description,
     xal.accounting_class_code      AS "Accounting Class Code",
                xdl.accounting_line_code       AS "Accounting Line Code",
                xdl.line_definition_code       AS "Line Definition COde",
                xdl.event_class_code           AS "Event Class Code",
                xdl.event_type_code            AS "Event Type Code",
                xdl.rounding_class_code        AS "Rounding Class Code",
                xah.accounting_date            AS "Accounting Date",
   msib.segment1 part_no,
   msib.description,
        mck.segment1 as item_category_family,
        mck.segment2 as item_category_class,
       msib.item_type,
        flv.meaning  item_type_description,
  --      rctal.description,
   --     rcta.trx_date invoice_date,
        gjh.je_source,
        xal.description,
        xah.JE_CATEGORY_NAME,
        to_char(gjh.doc_sequence_value) gl_voucher_no,
        gjl.je_line_num,
        to_char(glcc.segment6) account_no,
    --    to_char(rcta.trx_number) invoice_no,
    --    to_char(rcta.trx_date) invoice_date,
    --    to_char(rcta.creation_date) creation_date,
        to_char(xah.accounting_date) accounting_date,
        xah.gl_transfer_status_code,
        to_char(xah.gl_transfer_date) gl_transfer_date,
   --     sum(rct_gl.amount) distribution_amount,
        xal.entered_dr XLA_ENTERED_DR,
        xal.entered_cr XLA_ENTERED_CR,
        xal.accounted_dr XLA_ACCOUNTED_DR,
        xal.accounted_cr XLA_ACCOUNTED_CR,
        gjl.entered_dr GL_ENTERED_DR,
        gjl.entered_cr GL_ENTERED_CR,
        gjl.accounted_dr GL_ACCOUNTED_DR,
        gjl.accounted_cr GL_ACCOUNTED_CR
        
FROM   
        xla.xla_ae_headers xah 
        LEFT JOIN xla.xla_ae_lines xal
            ON  xah.ae_header_id = xal.ae_header_id 
            AND xal.application_id = xah.application_id
        LEFT JOIN apps.gl_code_combinations glcc
            ON xal.code_combination_id = glcc.code_combination_id
        LEFT  JOIN xla.xla_transaction_entities xte
            ON xah.entity_id = xte.entity_id
            AND xte.application_id = xal.application_id
        LEFT JOIN apps.gl_import_references gir
            ON gir.gl_sl_link_id = xal.gl_sl_link_id
            AND gir.gl_sl_link_table = xal.gl_sl_link_table
        LEFT JOIN apps.gl_je_lines gjl
            ON gjl.je_header_id = gir.je_header_id
            AND gjl.je_line_num = gir.je_line_num
        LEFT JOIN apps.gl_je_headers gjh         
            ON gjh.je_header_id = gjl.je_header_id
        LEFT JOIN xla_distribution_links xdl
            ON xah.ae_header_id = xdl.ae_header_id
            and xdl.event_id = xah.event_id
            and xdl.ae_line_num = xal.ae_line_num
            and xdl.application_id = xah.application_id
        LEFT JOIN mtl_transaction_accounts mta
            ON xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id
        LEFT JOIN mtl_material_transactions mmt
            ON mmt.transaction_id = mta.transaction_id
--        LEFT JOIN mtl_transaction_types mtt
--            ON mtt.transaction_type_id = mmt.transaction_type_id
        LEFT JOIN    mtl_system_items_b msib
            ON mmt.inventory_item_id = msib.inventory_item_id
            AND mmt.organization_id = msib.organization_id
        LEFT JOIN mtl_item_categories  mtc
            ON msib.inventory_item_id = mtc.inventory_item_id 
            AND msib.organization_id = mtc.organization_id 
        LEFT JOIN mtl_categories_kfv mck 
            ON mtc.category_id =mck.category_id 
                
        LEFT JOIN fnd_lookup_values flv
            ON  msib.item_type = flv.lookup_code  
        LEFT JOIN hr_all_organization_units org
            ON org.organization_id = msib.organization_id
      
WHERE 1 = 1
            AND  mck.structure_id = '50388'
            AND  flv.lookup_type = 'ITEM_TYPE'
            and UPPER(mtt.transaction_type_name) like 'PO RECEIPT'
       --     and mck.segment1 = 'CKD'
     --       AND line_type = 'LINE'
       --    AND glcc.segment6 IN ('65603')
          --  AND xte.entity_code = 'TRANSACTIONS'
            AND xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
       --     and rct_gl.amount > 0
     --  AND rcta.trx_number = '40200013994'
           AND xah.accounting_date BETWEEN '01-JUL-2017' AND '01-JUL-2017'
     --      AND mmt.transaction_id = 868778
       --      AND mmt.organization_id = 102
group by    
     xal.accounting_class_code  ,
                xdl.accounting_line_code     ,
                xdl.line_definition_code ,
                xdl.event_class_code         ,
                xdl.event_type_code            ,
                xdl.rounding_class_code        ,
                xah.accounting_date    ,
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
       mck.segment1  ,
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


-- MTL QUERY FOR AMBO
SELECT 

        mmt.transaction_id,
        msib.organization_id,
        org.name organization,
        xah.period_name,
    
   msib.segment1 part_no,
   msib.description,
        mck.segment1 as item_category_family,
        mck.segment2 as item_category_class,
       msib.item_type,
        flv.meaning  item_type_description,

        gjh.je_source,
        xal.description,
        xah.JE_CATEGORY_NAME,
        to_char(gjh.doc_sequence_value) gl_voucher_no,
        gjl.je_line_num,
        to_char(glcc.segment6) account_no,
        xal.accounting_class_code ,
    
        to_char(xah.accounting_date) accounting_date,
        xah.gl_transfer_status_code,
        to_char(xah.gl_transfer_date) gl_transfer_date,

        xal.entered_dr XLA_ENTERED_DR,
        xal.entered_cr XLA_ENTERED_CR,
        xal.accounted_dr XLA_ACCOUNTED_DR,
        xal.accounted_cr XLA_ACCOUNTED_CR,
        gjl.entered_dr GL_ENTERED_DR,
        gjl.entered_cr GL_ENTERED_CR,
        gjl.accounted_dr GL_ACCOUNTED_DR,
        gjl.accounted_cr GL_ACCOUNTED_CR
        
FROM   
        xla.xla_ae_headers xah 
        INNER JOIN xla.xla_ae_lines xal
            ON  xah.ae_header_id = xal.ae_header_id 
            AND xal.application_id = xah.application_id
        INNER JOIN apps.gl_code_combinations glcc
            ON xal.code_combination_id = glcc.code_combination_id    
        INNER JOIN xla_distribution_links xdl
            ON xah.ae_header_id = xdl.ae_header_id
            and xdl.event_id = xah.event_id
            and xdl.ae_line_num = xal.ae_line_num
            and xdl.application_id = xah.application_id
        INNER JOIN mtl_transaction_accounts mta
            ON xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id
        INNER JOIN mtl_material_transactions mmt
            ON mmt.transaction_id = mta.transaction_id
        INNER JOIN    mtl_system_items_b msib
            ON mmt.inventory_item_id = msib.inventory_item_id
            AND mmt.organization_id = msib.organization_id
        INNER JOIN mtl_item_categories  mtc
            ON msib.inventory_item_id = mtc.inventory_item_id 
            AND msib.organization_id = mtc.organization_id 
        INNER JOIN mtl_categories_kfv mck 
            ON mtc.category_id =mck.category_id 
        INNER JOIN fnd_lookup_values flv
            ON  msib.item_type = flv.lookup_code  
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
WHERE 1 = 1
           -- AND mmt.organization_id IN ('88')                 --rio nac dbs ips
           AND mck.segment1 IN ('CKD','CBU')
            AND  mck.structure_id = '50388'
            AND  flv.lookup_type = 'ITEM_TYPE'
           AND xdl.source_distribution_type = 'RCV_RECEIVING_SUB_LEDGER'
         --   AND gjh.doc_sequence_value = '81001035'
        --     AND MMT.TRANSACTION_ID = 3624405
 --      AND GJL.JE_LINE_NUM = 608
    --         and msib.segment1 = '150TBR54FWL-IPCAC1/JE'
    
      --     AND xal.accounting_class_code IN ('RECEIVING_INSPECTION')
     --       AND line_type = 'LINE'
           
          --  AND xte.entity_code = 'TRANSACTIONS'
           
       --     and rct_gl.amount > 0
     --  AND rcta.trx_number = '40200013994'
         AND xah.accounting_date BETWEEN '01-AUG-2017' AND '05-AUG-2017'
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
       mck.segment1  ,
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
xal.accounting_class_code ,
      
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
FROM RCV_TRANSACTIONS;
WHERE INVENTORY_ITEM_ID = 92812;


SELECT *
FROM MTL_SYSTEM_ITEMS_B
WHERE SEGMENT1 = '150TBR54FWL-IPCAC1/JE';
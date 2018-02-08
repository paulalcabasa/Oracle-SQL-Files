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
        
        msib.organization_id,
        org.name organization,
        xah.period_name,
        rcta.trx_number invoice_number,
        rcta.attribute3 cs_no,
        --  rctta.name,
        --    rctta.description,
        --    rcta.attribute4 lot_no,
   --     rctal.customer_trx_line_id,
        rcta.comments ifs_invoice_no,
        rcta.trx_date,
        msib.segment1 part_no,
        msib.description,
        mck.segment1 as item_category_family,
        mck.segment2 as item_category_class,
        msib.item_type,
        flv.meaning  item_type_description,
  --      rctal.description,
        rcta.trx_date invoice_date,
        gjh.je_source,
        xal.description,
        xah.JE_CATEGORY_NAME,
        to_char(gjh.doc_sequence_value) gl_voucher_no,
        gjl.je_line_num,
        to_char(glcc.segment6) account_no,
        to_char(rcta.trx_number) invoice_no,
        to_char(rcta.trx_date) invoice_date,
        to_char(rcta.creation_date) creation_date,
        to_char(xah.accounting_date) accounting_date,
        xah.gl_transfer_status_code,
        to_char(xah.gl_transfer_date) gl_transfer_date,
        sum(rct_gl.amount) distribution_amount,
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
        INNER  JOIN xla.xla_transaction_entities xte
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
        LEFT JOIN apps.ra_customer_trx_all rcta
            ON NVL (xte.source_id_int_1, -99) = rcta.customer_trx_id
        LEFT JOIN apps.ar_customers ac
            ON rcta.bill_to_customer_id = ac.customer_id
        LEFT JOIN xla_distribution_links xdl
            ON xah.ae_header_id = xdl.ae_header_id
            and xdl.event_id = xah.event_id
            and xdl.ae_line_num = xal.ae_line_num
            and xdl.application_id = xah.application_id
        LEFT JOIN ra_cust_trx_line_gl_dist_all rct_gl
            ON xdl.source_distribution_id_num_1 = rct_gl.cust_trx_line_gl_dist_id
        LEFT JOIN ra_customer_trx_lines_all rctal
          --  ON rcta.customer_trx_id = rctal.customer_trx_id
            on rct_gl.customer_trx_line_id = rctal.customer_trx_line_id
     LEFT JOIN ra_customer_trx_all rcta
            ON rcta.customer_trx_id = rctal.customer_trx_id
        LEFT JOIN    mtl_system_items_b msib
            ON rctal.inventory_item_id = msib.inventory_item_id
            AND rctal.warehouse_id =  msib.organization_id
            AND rct_gl.customer_trx_line_id = rctal.customer_trx_line_id
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
            AND line_type = 'LINE'
            AND rctal.warehouse_id = 121
--    AND glcc.segment6 = '84303'
            AND xte.entity_code = 'TRANSACTIONS'
            AND xdl.source_distribution_type = 'RA_CUST_TRX_LINE_GL_DIST_ALL'
        --    and xah.gl_transfer_status_code = 'N'
        --    and xah.period_name = 'JUN-17'
           
       --     and rct_gl.amount > 0
     --   AND rcta.trx_number = '40200005093'
    AND xah.accounting_date BETWEEN '01-JAN-2017' AND '30-JUN-2017'
group by 
        msib.organization_id,
        org.name,
        xah.period_name,
        rcta.trx_number ,
        rcta.attribute3 ,
        --  rctta.name,
        --    rctta.description,
        --    rcta.attribute4 lot_no,
  --      rctal.customer_trx_line_id,
        rcta.comments ,
        msib.segment1 ,
        msib.description,
        mck.segment1  ,
        mck.segment2  ,
        msib.item_type,
        flv.meaning   ,
  --      rctal.description,
        rcta.trx_date  ,
        gjh.je_source,
        xal.description,
        xah.JE_CATEGORY_NAME,
        to_char(gjh.doc_sequence_value)  ,
        gjl.je_line_num,
        to_char(glcc.segment6)  ,
        to_char(rcta.trx_number)  ,
        to_char(rcta.trx_date)  ,
        to_char(rcta.creation_date)  ,
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


select *
from hr_all_organization_units;

select *
from mtl_parameters;

-- invoices correct 2 (used query as of july 10, 2017)
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
        
        msib.organization_id,
        org.name organization,
        xah.period_name,
        rcta.trx_number invoice_number,
        rcta.trx_date invoice_date,
        ac.customer_number,
        ac.customer_name,
        
      --  rcta.attribute3 cs_no,
        --  rctta.name,
        --    rctta.description,
        --    rcta.attribute4 lot_no,
   --     rctal.customer_trx_line_id,
   --     rcta.comments ifs_invoice_no,
   --     msib.segment1 part_no,
   --     msib.description,
        mck.segment1 as item_category_family,
   --     mck.segment2 as item_category_class,
   --     msib.item_type,
  --      flv.meaning  item_type_description,
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
        sum(rct_gl.amount) distribution_amount,
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
        LEFT JOIN apps.ra_customer_trx_all rcta
            ON NVL (xte.source_id_int_1, -99) = rcta.customer_trx_id
        LEFT JOIN apps.ar_customers ac
            ON rcta.bill_to_customer_id = ac.customer_id
        LEFT JOIN xla_distribution_links xdl
            ON xah.ae_header_id = xdl.ae_header_id
            and xdl.event_id = xah.event_id
            and xdl.ae_line_num = xal.ae_line_num
            and xdl.application_id = xah.application_id
        LEFT JOIN ra_cust_trx_line_gl_dist_all rct_gl
            ON xdl.source_distribution_id_num_1 = rct_gl.cust_trx_line_gl_dist_id
        LEFT JOIN ra_customer_trx_lines_all rctal
          --  ON rcta.customer_trx_id = rctal.customer_trx_id
            on rct_gl.customer_trx_line_id = rctal.customer_trx_line_id
     LEFT JOIN ra_customer_trx_all rcta
            ON rcta.customer_trx_id = rctal.customer_trx_id
        LEFT JOIN    mtl_system_items_b msib
            ON rctal.inventory_item_id = msib.inventory_item_id
            AND rctal.warehouse_id =  msib.organization_id
            AND rct_gl.customer_trx_line_id = rctal.customer_trx_line_id
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
        AND line_type = 'LINE'
          --  AND 
      
        AND glcc.segment6  IN ('05200')
            AND xte.entity_code = 'TRANSACTIONS'
            
            AND xdl.source_distribution_type = 'RA_CUST_TRX_LINE_GL_DIST_ALL'
       --     and rct_gl.amount > 0
      -- AND rcta.trx_number = '40200015027'
          AND xah.accounting_date BETWEEN '01-JAN-2017' AND '30-JUN-2017'
group by 
        msib.organization_id,
        org.name,
        xah.period_name,
     rcta.trx_number ,
          ac.customer_number,
        ac.customer_name,
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
        to_char(rcta.trx_number)  ,
        to_char(rcta.trx_date)  ,
        to_char(rcta.creation_date)  ,
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
        gjl.accounted_cr  ,
        rcta.trx_date
      ---     AND gjh.doc_sequence_value = '84017217'
    --   AND rcta.trx_number = '40200012379'
          --  AND gjh.je_source = 'Receivables'
;
-- end of invoices correct 2X


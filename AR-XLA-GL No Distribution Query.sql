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
        gjh.je_source,
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
        LEFT OUTER JOIN xla.xla_transaction_entities xte
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
      
WHERE 1 = 1
            AND glcc.segment6 = '01200'
            AND xah.accounting_date between '01-JAN-2017' AND '30-JUN-2017'
       --     and gjh.doc_sequence_value = '84017217'
          --  AND xte.entity_code = 'TRANSACTIONS'
          --  AND gjh.je_source = 'Receivables'
;


select      
        DISTINCT xah.je_category_name
--sum(xal.accounted_cr),
--         sum(xal.accounted_Dr),
--         sum(xal.ENTERED_cr),
--         sum(xal.ENTERED_Dr)
from xla_ae_lines xal,
        gl_code_combinations gcc,
        xla_ae_headers xah
where 1 = 1
          and gcc.code_combination_id = xal.code_combination_id
          and xah.ae_header_id = xal.ae_header_id
          and gcc.segment6 = '01200'
   --    and xah.gl_transfer_status_code IN('Y','N')
              and xah.gl_transfer_status_code IN('Y')
          and xah.accounting_date between '01-JAN-2017' AND '30-JUN-2017'
    ;
    
    select distinct je_source
    from gl_je_headers gjh,
            gl_je_lines gjl,
            gl_code_combinations gcc
   where gjh.je_header_id = gjl.je_header_id
            and gcc.code_combination_id = gjl.code_combination_id
            and gcc.segment6 = '01200'
    
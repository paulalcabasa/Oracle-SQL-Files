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
            
        
FROM   apps.gl_je_headers gjh,
            apps.gl_je_lines gjl,
            apps.gl_import_references gir,
            xla.xla_ae_lines xal,
            xla.xla_ae_headers xah,
            apps.gl_code_combinations glcc,
            xla.xla_transaction_entities xte,
            apps.ra_customer_trx_all rcta,
      --      apps.gl_ledgers gl,
      --      apps.gl_balances gb,
            apps.ar_customers ac
         --   apps.gl_je_batches gjb
WHERE 1 = 1
   AND gjh.je_header_id = gjl.je_header_id(+)
   AND gjl.je_header_id = gir.je_header_id(+)
   AND gjl.je_line_num = gir.je_line_num(+)
   AND gir.gl_sl_link_id = xal.gl_sl_link_id(+)
   AND gir.gl_sl_link_table = xal.gl_sl_link_table(+)
   AND xal.ae_header_id = xah.ae_header_id
   AND xal.application_id = xah.application_id
   AND xal.code_combination_id = glcc.code_combination_id
   AND xte.entity_id = xah.entity_id(+)
  AND xte.entity_code = 'TRANSACTIONS'
 --  AND xte.ledger_id = gl.ledger_id
   AND xte.application_id(+) = xal.application_id
   AND NVL (xte.source_id_int_1, -99) = rcta.customer_trx_id(+)
 --  AND gjh.ledger_id = gl.ledger_id(+)
 --  AND gb.code_combination_id = glcc.code_combination_id
 --  AND gb.period_name = gjh.period_name
 --  AND gb.currency_code = gl.currency_code
  -- AND gjh.je_batch_id = gjb.je_batch_id
   AND rcta.bill_to_customer_id = ac.customer_id(+)
  -- and rcta.trx_date <> xah.accounting_date
 --  and rcta.trx_number like '402%'
--   and  rcta.trx_number like '40200001893'
 --  AND gjh.period_name = 'NOV-14'
 AND glcc.segment6 = '01300'
--   AND gjh.je_source = 'Receivables'
--and GJH.name = 'NOV-14 Credit Memos GBP'
;


select *
from gl_je_headers
where je_header_id = 346144;

select *
from gl_je_lines
where je_header_id = 346144;

select *
from xla_ae_lines
where ae_header_id = 9187947;

select gjh.doc_sequence_value gl_voucher_no,
         gjl.je_line_num,
         xal.ae_line_num,
         xal.description,
         xal.entered_cr,
         xal.entered_dr,
         xal.accounted_cr,
         xal.accounted_dr,
         gcc.segment6 account_no,
         xah.je_category_name,
         xah.gl_transfer_date,
         xah.gl_transfer_status_code
from xla_ae_headers xah 
        LEFT JOIN xla_ae_lines xal
            ON xal.ae_header_id = xah.ae_header_id
            AND xal.application_id = xah.application_id
        LEFT JOIN gl_code_combinations gcc
            ON gcc.code_combination_id = xal.code_combination_id
        LEFT JOIN apps.gl_import_references gir
            ON gir.gl_sl_link_id = xal.gl_sl_link_id
            AND gir.gl_sl_link_table = xal.gl_sl_link_table
        LEFT JOIN apps.gl_je_lines gjl
            ON gjl.je_header_id = gir.je_header_id
            AND gjl.je_line_num = gir.je_line_num
        LEFT JOIN apps.gl_je_headers gjh         
            ON gjh.je_header_id = gjl.je_header_id
                    LEFT  JOIN xla.xla_transaction_entities xte
            ON xah.entity_id = xte.entity_id
            AND xte.application_id = xal.application_id
where 1 = 1
        and gcc.segment6 = '89910'
     --   and GL_TRANSFER_STATUS_CODE = 'N'
      ;  -- and xah.ae_header_id = 9187947;
                
     
 select *
 from mtl_serial_numbers
 where current_organization_id = 121
            and current_subinventory_code = 'VSS'
            and serial_number like 'D%'
            and current_status = 3;




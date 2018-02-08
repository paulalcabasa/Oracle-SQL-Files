-- invoices correct 2 (used query as of july 10, 2017)
SELECT distinct
        nvl(fu_trans.description,fu_trans.user_name) transacted_by,
        fu_trans.user_id transacted_by_id,
        acra.creation_date transaction_date,
        nvl(fu_posted.description,fu_posted.user_name) gl_posted_by,
        fu_posted.user_id gl_posted_by_id,
        gjh.creation_date date_posted,
        to_number(gjh.doc_sequence_value) gl_voucher_no,
        xah.period_name,
        acra.receipt_number,
        acra.doc_sequence_value receipt_voucher_no,
--        ac.customer_number,
--        ac.customer_name,        
        gjh.je_source,
        xal.description,
        xah.je_category_name,
        gjl.je_line_num,
        to_char(glcc.segment6) account_no,
        to_char(xah.accounting_date) accounting_date,
        xah.gl_transfer_status_code,
        to_char(xah.gl_transfer_date) gl_transfer_date,
        xal.entered_dr XLA_ENTERED_DR,
        xal.entered_cr XLA_ENTERED_CR,
        nvl(xal.entered_dr,0) - nvl(xal.entered_cr,0) xla_entered_amount,
        xal.accounted_dr XLA_ACCOUNTED_DR,
        xal.accounted_cr XLA_ACCOUNTED_CR,
        nvl(xal.accounted_dr,0) - nvl(xal.accounted_cr,0) xla_accounted_amount,
        gjl.entered_dr GL_ENTERED_DR,
        gjl.entered_cr GL_ENTERED_CR,
        nvl(gjl.entered_dr,0) - nvl(gjl.entered_cr,0) gl_entered_amount,
        gjl.accounted_dr GL_ACCOUNTED_DR,
        gjl.accounted_cr GL_ACCOUNTED_CR,
        nvl(gjl.accounted_dr,0) - nvl(gjl.accounted_cr,0) gl_accounted_amount
FROM   
        xla.xla_ae_headers xah 
        INNER JOIN xla.xla_ae_lines xal
            ON  xah.ae_header_id = xal.ae_header_id 
            AND xal.application_id = xah.application_id
        INNER JOIN xla_distribution_links xdl
            ON xah.ae_header_id = xdl.ae_header_id
            and xdl.event_id = xah.event_id
            and xdl.ae_line_num = xal.ae_line_num
            and xdl.application_id = xah.application_id
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
        LEFT JOIN apps.ar_cash_receipts_all acra
            ON NVL (xte.source_id_int_1, -99) = acra.cash_receipt_id
            AND xte.entity_code = 'RECEIPTS'
--        LEFT JOIN apps.ar_customers ac
--            ON rcta.bill_to_customer_id = ac.customer_id
        LEFT JOIN fnd_user fu_trans
             ON fu_trans.user_id =acra.created_by
        LEFT JOIN fnd_user fu_posted
             ON fu_posted.user_id = xah.created_by
WHERE 1 = 1
           AND xah.je_category_name = 'Misc Receipts'
--           AND rcta.trx_number = '40200000873'
          AND gjh.je_source = 'Receivables'
--          and ACRA.RECEIPT_NUMBER = 'AR-835'
          AND xah.accounting_date BETWEEN '01-JAN-2017' AND '30-OCT-2017';
          
          SELECT *
          FROM XLA_AE_HEADERS;
          
          select *
          from ar_cash_receipts_all
          where type= 'MISC';
          
          select *
          from fnd_user
          where description like '%ALJAYVES%';
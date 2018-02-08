SELECT *
FROM IPC.IPC_ACCOUNT_ANALYSIS
WHERE je_source = 'Payables'
             and je_category_name = 'Sales Invoices'
            and to_date(creation_date) between '01-AUG-2017' AND '05-AUG-2017'
            and rownum <= 10;
grant select ON ar_cash_receipts_all TO IPC;

-- VIEWS
-- Adjustments
SELECT *
FROM IPC.IPC_AR_ADJUSTMENTS;

select *
from ap_invoices_all
where doc_sequence_value = '20043758';

select *
from xla_ae_headers;

CREATE OR REPLACE FORCE VIEW IPC.IPC_AR_ADJUSTMENTS AS 
SELECT DISTINCT
          /* ORIG COLUMNS 
          gjh.doc_sequence_value voucher_no,
          gjh.je_source,
          xah.je_category_name,
          gjh.default_effective_date,
          gjh.posted_date,
          gjh.status,
          xdl.ae_line_num xla_line_number,
          gjl.je_line_num gl_line_number,
          xah.accounting_date,
          xah.gl_transfer_status_code,
          xah.gl_transfer_date,
          xah.doc_sequence_value,
          gcc.segment1,
          gcc.segment2,
          gcc.segment3,
          gcc.segment4,
          gcc.segment5,
          gcc.segment6,
          gcc.segment7,
          gcc.segment8,
          gcc.segment9,
          xah.description header_description,
          xal.description line_description,
          xah.period_name,
          xal.entered_dr,
          xal.entered_cr,
          xal.accounted_dr,
          xal.accounted_cr,
          xdl.unrounded_entered_dr,
          xdl.unrounded_entered_cr,
          xdl.unrounded_accounted_dr,
          xdl.unrounded_accounted_cr,
          xal.currency_code,
          xal.currency_conversion_date,
          xal.currency_conversion_rate,
          xah.product_rule_code,
          xah.created_by,
          fu.user_name,
          fu.description,
          xah.creation_date,
          fu_trans.user_name created_by_transaction,
          fu_trans.description created_by_name_transaction,
          xdl.source_distribution_type,
          xdl.source_distribution_id_num_1,
          xah.entity_id
          */
          xte.source_id_int_1,
          xah.je_category_name je_category,
          gjh.default_effective_date,
          gjh.doc_sequence_value journal_entry,
          gcc.segment6 account,
          nvl(xal.accounted_dr,0)               xla_lines_accounted_dr,
          nvl(xal.accounted_cr,0)               xla_lines_accounted_cr,
          nvl(xal.accounted_dr,0)- nvl(xal.accounted_cr,0 ) as amount,
          null business_unit ,
          xah.period_name period,
          null effective_name,
          ada.creation_date           transaction_entry_date,
          fu_trans.user_name created_by, 
          ada.creation_date,
          gjh.je_source  je_header_source,
          gjl.description  je_lines_description

     FROM apps.xla_ae_headers xah
          INNER JOIN apps.xla_ae_lines xal
             ON xah.ae_header_id = xal.ae_header_id
          INNER JOIN apps.xla_distribution_links xdl
             ON xal.ae_header_id = xdl.ae_header_id
                AND xal.ae_line_num = xdl.ae_line_num
          INNER JOIN apps.gl_code_combinations gcc
             ON xal.code_combination_id = gcc.code_combination_id
          INNER JOIN xla.xla_transaction_entities xte
             ON xte.entity_id = xah.entity_id
                AND xte.entity_code = 'ADJUSTMENTS'
          LEFT JOIN apps.ar_adjustments_all ADA
             ON NVL (xte.source_id_int_1, -99) = ada.adjustment_id
          -- GL
          LEFT JOIN apps.gl_import_references gir
             ON gir.gl_sl_link_id = xal.gl_sl_link_id
                AND gir.gl_sl_link_table = xal.gl_sl_link_table
          LEFT JOIN apps.gl_je_lines gjl
             ON gjl.je_header_id = gir.je_header_id
                AND gjl.je_line_num = gir.je_line_num
          LEFT JOIN apps.gl_je_headers gjh
             ON gjh.je_header_id = gjl.je_header_id
          LEFT JOIN apps.fnd_user fu
             ON gjh.created_by = fu.user_id
          LEFT JOIN apps.fnd_user fu_trans
             ON fu_trans.user_id = ada.created_by
    WHERE 1 = 1 AND xah.je_category_name IN (              --'Sales Invoices',
                                                              --   'Receipts',
                    'Adjustment'                           --  'Credit Memos',
                                                          --    'Debit Memos',
                                                          --   'Misc Receipts'
                    );
                    
-- Receipts, Misc Receipts
SELECT *
FROM IPC.IPC_AR_RECEIPTS;

CREATE OR REPLACE VIEW IPC.IPC_AR_RECEIPTS AS
SELECT DISTINCT
          /* gjh.doc_sequence_value voucher_no,
          gjh.je_source,
          xah.je_category_name,
          gjh.default_effective_date,
          gjh.posted_date,
          gjh.status,
          xdl.ae_line_num xla_line_number,
          gjl.je_line_num gl_line_number,
          xah.accounting_date,
          xah.gl_transfer_status_code,
          xah.gl_transfer_date,
          xah.doc_sequence_value,
          gcc.segment1,
          gcc.segment2,
          gcc.segment3,
          gcc.segment4,
          gcc.segment5,
          gcc.segment6,
          gcc.segment7,
          gcc.segment8,
          gcc.segment9,
          xah.description header_description,
          xal.description line_description,
          xah.period_name,
          xal.entered_dr,
          xal.entered_cr,
          xal.accounted_dr,
          xal.accounted_cr,
          xdl.unrounded_entered_dr,
          xdl.unrounded_entered_cr,
          xdl.unrounded_accounted_dr,
          xdl.unrounded_accounted_cr,
          xal.currency_code,
          xal.currency_conversion_date,
          xal.currency_conversion_rate,
          xah.product_rule_code,
          xah.created_by,
          fu.user_name,
          fu.description,
          xah.creation_date,
          fu_trans.user_name created_by_transaction,
          fu_trans.description created_by_name_transaction,
          xdl.source_distribution_type,
          xdl.source_distribution_id_num_1,
          xah.entity_id */
          xte.source_id_int_1,
          xah.je_category_name je_category,
          gjh.default_effective_date,
          gjh.doc_sequence_value journal_entry,
          gcc.segment6 account,
          nvl(xal.accounted_dr,0)               xla_lines_accounted_dr,
          nvl(xal.accounted_cr,0)               xla_lines_accounted_cr,
          nvl(xal.accounted_dr,0)- nvl(xal.accounted_cr,0 ) as amount,
          null business_unit ,
          xah.period_name period,
          null effective_name,
          acr.creation_date           transaction_entry_date,
          fu_trans.user_name created_by, 
          acr.creation_date,
          gjh.je_source  je_header_source,
          gjl.description  je_lines_description
     FROM apps.xla_ae_headers xah
          INNER JOIN apps.xla_ae_lines xal
             ON xah.ae_header_id = xal.ae_header_id
          INNER JOIN apps.xla_distribution_links xdl
             ON xal.ae_header_id = xdl.ae_header_id
                AND xal.ae_line_num = xdl.ae_line_num
          INNER JOIN apps.gl_code_combinations gcc
             ON xal.code_combination_id = gcc.code_combination_id
          INNER JOIN xla.xla_transaction_entities xte
             ON xte.entity_id = xah.entity_id
                AND xte.entity_code = 'RECEIPTS'
          LEFT JOIN apps.ar_cash_receipts_all acr
             ON NVL (xte.source_id_int_1, -99) = acr.cash_receipt_id
          -- GL
          LEFT JOIN apps.gl_import_references gir
             ON gir.gl_sl_link_id = xal.gl_sl_link_id
                AND gir.gl_sl_link_table = xal.gl_sl_link_table
          LEFT JOIN apps.gl_je_lines gjl
             ON gjl.je_header_id = gir.je_header_id
                AND gjl.je_line_num = gir.je_line_num
          LEFT JOIN apps.gl_je_headers gjh
             ON gjh.je_header_id = gjl.je_header_id
          LEFT JOIN apps.fnd_user fu
             ON gjh.created_by = fu.user_id
          LEFT JOIN apps.fnd_user fu_trans
             ON fu_trans.user_id = acr.created_by
    WHERE 1 = 1 AND xah.je_category_name IN (              --'Sales Invoices',
                                             'Receipts'     --    'Adjustment'
                                                           --  'Credit Memos',
                                                          --    'Debit Memos',
                                                          --   'Misc Receipts'
                    );


-- Sales Invoices , CM, DM 
SELECT *
FROM IPC.IPC_AR_TRANSACTIONS;
-- SOURCE CODE FOR VIEW

CREATE OR REPLACE VIEW IPC.IPC_AR_TRANSACTIONS AS SELECT 
    distinct
         /*gjh.doc_sequence_value voucher_no,
          gjh.je_source,
          xah.je_category_name,
          gjh.default_effective_date,
          gjh.posted_date,
          gjh.status,
          xdl.ae_line_num xla_line_number,
          gjl.je_line_num gl_line_number,
          xah.accounting_date,
          xah.gl_transfer_status_code,
          xah.gl_transfer_date,
          xah.doc_sequence_value,
          gcc.segment1,
          gcc.segment2,
          gcc.segment3,
          gcc.segment4,
          gcc.segment5,
          gcc.segment6,
          gcc.segment7,
          gcc.segment8,
          gcc.segment9,
          xah.description header_description,
          xal.description line_description,
          xah.period_name,
          xal.entered_dr,
          xal.entered_cr,
          xal.accounted_dr,
          xal.accounted_cr,
          xdl.unrounded_entered_dr,
          xdl.unrounded_entered_cr,
          xdl.unrounded_accounted_dr,
          xdl.unrounded_accounted_cr,
          xal.currency_code,
          xal.currency_conversion_date,
          xal.currency_conversion_rate,
          xah.product_rule_code,
          xah.created_by,
          fu.user_name,
          fu.description,
          xah.creation_date,
          fu_trans.user_name created_by_transaction,
          fu_trans.description created_by_name_transaction,
          xdl.source_distribution_type,
          xdl.source_distribution_id_num_1,
          xah.entity_id
          */
          xte.source_id_int_1,
          xah.je_category_name je_category,
          gjh.default_effective_date,
          gjh.doc_sequence_value journal_entry,
          gcc.segment6 account,
          nvl(xal.accounted_dr,0)               xla_lines_accounted_dr,
          nvl(xal.accounted_cr,0)               xla_lines_accounted_cr,
          nvl(xal.accounted_dr,0)- nvl(xal.accounted_cr,0 ) as amount,
          null business_unit ,
          xah.period_name period,
          null effective_name,
          rcta.creation_date           transaction_entry_date,
          fu_trans.user_name created_by, 
          rcta.creation_date,
          gjh.je_source  je_header_source,
          gjl.description  je_lines_description
     FROM apps.xla_ae_headers xah
          INNER JOIN apps.xla_ae_lines xal
             ON xah.ae_header_id = xal.ae_header_id
          INNER JOIN apps.xla_distribution_links xdl
             ON xal.ae_header_id = xdl.ae_header_id
                AND xal.ae_line_num = xdl.ae_line_num
          INNER JOIN apps.gl_code_combinations gcc
             ON xal.code_combination_id = gcc.code_combination_id
          INNER JOIN xla.xla_transaction_entities xte
             ON xte.entity_id = xah.entity_id
                AND xte.entity_code = 'TRANSACTIONS'
          LEFT JOIN apps.ra_customer_trx_all rcta
             ON NVL (xte.source_id_int_1, -99) = rcta.customer_trx_id
          -- GL
          LEFT JOIN apps.gl_import_references gir
             ON gir.gl_sl_link_id = xal.gl_sl_link_id
                AND gir.gl_sl_link_table = xal.gl_sl_link_table
          LEFT JOIN apps.gl_je_lines gjl
             ON gjl.je_header_id = gir.je_header_id
                AND gjl.je_line_num = gir.je_line_num
          LEFT JOIN apps.gl_je_headers gjh
             ON gjh.je_header_id = gjl.je_header_id
          LEFT JOIN apps.fnd_user fu
             ON gjh.created_by = fu.user_id
          LEFT JOIN apps.fnd_user fu_trans
             ON fu_trans.user_id = rcta.created_by
    WHERE 1 = 1
          AND xah.je_category_name IN
                 ('Sales Invoices',                             --  'Receipts'
                                                            --    'Adjustment'
                   'Credit Memos', 'Debit Memos'         --    'Misc Receipts'
                                                );
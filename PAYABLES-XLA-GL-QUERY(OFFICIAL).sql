select *
from ipc.ipc_account_analysis;

select *
from IPC.IPC_AR_ADJUSTMENTS;

SELECT * 
FROM IPC.IPC_AP_INVOICES
WHERE JOURNAL_ENTRY = '83024794';
SELECT* 
FROM IPC.IPC_AR_TRANSACTIONS
--WHERE TO_DATE(DEFAULT_EFFECTIVE_DATE)    BETWEEN '01-AUG-2017' AND '05-AUG-2017'
AND JOURNAL_ENTRY = '83024794';

CREATE OR REPLACE VIEW  IPC.IPC_ACCOUNT_ANALYSIS_V2 AS SELECT "VOUCHER_NO",
          "JE_SOURCE",
          "JE_CATEGORY_NAME",
          "DEFAULT_EFFECTIVE_DATE",
          "POSTED_DATE",
          "STATUS",
          "XLA_LINE_NUMBER",
          "GL_LINE_NUMBER",
          "ACCOUNTING_DATE",
          "GL_TRANSFER_STATUS_CODE",
          "GL_TRANSFER_DATE",
          "DOC_SEQUENCE_VALUE",
          "SEGMENT1",
          "SEGMENT2",
          "SEGMENT3",
          "SEGMENT4",
          "SEGMENT5",
          "SEGMENT6",
          "SEGMENT7",
          "SEGMENT8",
          "SEGMENT9",
          "HEADER_DESCRIPTION",
          "LINE_DESCRIPTION",
          "PERIOD_NAME",
          "ENTERED_DR",
          "ENTERED_CR",
          "ACCOUNTED_DR",
          "ACCOUNTED_CR",
          "UNROUNDED_ENTERED_DR",
          "UNROUNDED_ENTERED_CR",
          "UNROUNDED_ACCOUNTED_DR",
          "UNROUNDED_ACCOUNTED_CR",
          "CURRENCY_CODE",
          "CURRENCY_CONVERSION_DATE",
          "CURRENCY_CONVERSION_RATE",
          "PRODUCT_RULE_CODE",
          "CREATED_BY",
          "USER_NAME",
          "DESCRIPTION",
          "CREATION_DATE",
          "SOURCE_DISTRIBUTION_TYPE",
          "SOURCE_DISTRIBUTION_ID_NUM_1",
          "ENTITY_ID"
     FROM ( (SELECT DISTINCT gjh.doc_sequence_value voucher_no,
                             gjh.je_source,
                             gjh.je_category je_category_name,
                             gjh.default_effective_date,
                             gjh.posted_date,
                             gjh.status,
                             NULL xla_line_number,
                             gjl.je_line_num gl_line_number,
                             gjh.default_effective_date accounting_date,
                             'Y' gl_transfer_status_code,
                             gjh.creation_date gl_transfer_date,
                             NULL doc_sequence_value,
                             gcc.segment1,
                             gcc.segment2,
                             gcc.segment3,
                             gcc.segment4,
                             gcc.segment5,
                             gcc.segment6,
                             gcc.segment7,
                             gcc.segment8,
                             gcc.segment9,
                             gjh.description header_description,
                             gjl.description line_description,
                             gjh.period_name,
                             gjl.entered_dr,
                             gjl.entered_cr,
                             gjl.accounted_dr,
                             gjl.accounted_cr,
                             NULL unrounded_entered_dr,
                             NULL unrounded_entered_cr,
                             NULL unrounded_accounted_dr,
                             NULL unrounded_accounted_cr,
                             NULL currency_code,
                             NULL currency_conversion_date,
                             NULL currency_conversion_rate,
                             NULL product_rule_code,
                             gjh.created_by,
                             fu.user_name,
                             fu.description,
                             gjh.creation_date,
                             NULL source_distribution_type,
                             NULL source_distribution_id_num_1,
                             NULL entity_id
               FROM apps.gl_je_headers gjh,
                    apps.gl_je_lines gjl,
                    apps.gl_je_categories gjc,
                    apps.gl_code_combinations_kfv gcc,
                    apps.fnd_user fu
              WHERE     1 = 1
                    AND gjh.created_by = fu.user_id
                    AND gjh.je_header_id = gjl.je_header_id
                    AND gcc.code_combination_id = gjl.code_combination_id
                    AND gjc.je_category_name = gjh.je_category
             --     and gjh.je_source = 'Manual'
             --    and gjh.status = 'U'
             --  and gjh.doc_sequence_value = '95000006'
             --    and gjh.default_effective_date between  TO_DATE (:P_START_DATE) and TO_DATE (:P_END_DATE)
             --   and gcc.segment6 between NVL(:P_ACCOUNT_CODE_FROM,gcc.segment6) AND NVL(:P_ACCOUNT_CODE_TO,gcc.segment6) )
             UNION
             (SELECT DISTINCT gjh.doc_sequence_value voucher_no,
                              NULL je_source,
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
                              xdl.source_distribution_type,
                              xdl.source_distribution_id_num_1,
                              xah.entity_id
                FROM apps.xla_ae_headers xah
                     INNER JOIN apps.xla_ae_lines xal
                        ON xah.ae_header_id = xal.ae_header_id
                     INNER JOIN apps.xla_distribution_links xdl
                        ON xal.ae_header_id = xdl.ae_header_id
                           AND xal.ae_line_num = xdl.ae_line_num
                     INNER JOIN apps.gl_code_combinations gcc
                        ON xal.code_combination_id = gcc.code_combination_id
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
               WHERE 1 = 1 AND xah.gl_transfer_status_code = 'N' --  and xah.accounting_date between  TO_DATE (:P_START_DATE) and TO_DATE (:P_END_DATE)
                                                                -- and gjh.doc_sequence_value = '95000006'
                                                                -- and gcc.segment6 between NVL(:P_ACCOUNT_CODE_FROM,gcc.segment6) AND NVL(:P_ACCOUNT_CODE_TO,gcc.segment6))
             )))
             WHERE JE_CATEGORY_NAME NOT IN ('Addition',
                                                                            'CIP Addition',
                                                                            'CIP Adjustment',
                                                                            'Depreciation',
                                                                            'FA Adjustment',
                                                                            'IPC FA Adjustment',
                                                                            'Reclass',
                                                                            'Retirement',
                                                                            'Transfer',
                                                                            'Inventory',
                                                                            'Receiving',
                                                                            'WIP',
                                                                            'Payments',
                                                                            'Purchase Invoices',
                                                                            'Reconciled Payments',
                                                                            'Adjustment',
                                                                            'Credit Memos',
                                                                            'Debit Memos',
                                                                            'Misc Receipts',
                                                                            'Receipts',
                                                                            'Sales Invoices');
             

select distinct je_category_name
from xla_ae_headers
where je_source = 'Payables';

select distinct je_category
from gl_je_headers
where je_source = 'Payables';
-- VIEW
SELECT *
FROM  IPC.IPC_AP_INVOICES;

CREATE OR REPLACE VIEW IPC.IPC_AP_INVOICES AS
SELECT
        DISTINCT
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
          xah.entity_id*/
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
          aia.creation_date           transaction_entry_date,
          fu_trans.user_name created_by, 
          aia.creation_date,
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
                AND xte.entity_code = 'AP_INVOICES'
          LEFT JOIN apps.ap_invoices_all aia
             ON NVL (xte.source_id_int_1, -99) = aia.invoice_id
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
             ON fu_trans.user_id = aia.created_by
    WHERE 1 = 1 AND xah.je_category_name IN ('Purchase Invoices');

SELECT *
FROM IPC.IPC_AP_PAYMENTS;

CREATE OR REPLACE VIEW IPC.IPC_AP_PAYMENTS AS
SELECT 
            DISTINCT 
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
          aca.creation_date           transaction_entry_date,
          fu_trans.user_name created_by, 
          aca.creation_date,
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
                AND xte.entity_code = 'AP_PAYMENTS'
          LEFT JOIN apps.ap_checks_all aca
             ON NVL (xte.source_id_int_1, -99) = aca.check_id
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
             ON fu_trans.user_id = aca.created_by
    WHERE 1 = 1
          AND xah.je_category_name IN ('Reconciled Payments', 'Payments')
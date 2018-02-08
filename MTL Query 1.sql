  SELECT
  xdl.application_id , 
xah.COMPLETED_DATE,
xah.CREATION_DATE,
xah.LAST_UPDATE_DATE,
xah.PROGRAM_UPDATE_DATE,
  xdl.application_id             AS "Application ID",
         xdl.source_distribution_type   AS "Source Distribution Type",
         xdl.source_distribution_id_num_1 AS "Source Distribution Id Num",
         xdl.ae_header_id               AS "AE Header ID",
         xdl.ae_line_num                AS "AE Line Num",
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
         xah.doc_sequence_value         AS "Document Sequence Value",
         gcc.segment1                   AS "Company",
         gcc.segment2                   AS "Cost Center",
         gcc.segment3                   AS "ID",
         gcc.segment4                   AS "Budget Account",
         gcc.segment5                   AS "Budget Cost Center",
         gcc.segment6                   AS "Account",
         gcc.segment7                   AS "Model",
         gcc.segment8                   AS "Projects",
         gcc.segment9                   AS "Future",
         xah.description                AS "Description",
         xal.description                AS "Line Description",
         xal.displayed_line_number      AS "Line Number",
         xah.period_name                AS "Period Name",
         xal.entered_dr                 AS "Entered Debit",
         xal.entered_cr                 AS "Entered Credit",
         xal.accounted_dr               AS "Accounted Debit",
         xal.accounted_cr               AS "Accounted Credit",
         xdl.unrounded_entered_dr       AS "Unrounded Entered Debit",
         xdl.unrounded_entered_cr       AS "Unrounded Entered Credit",
         xdl.unrounded_accounted_dr     AS "Unrounded Accounted Debit",
         xdl.unrounded_accounted_cr     AS "Unrounded Accounted Credit",
         xal.currency_code              AS "Currency Code",
         xal.currency_conversion_date   AS "Currency Conversion Date",
         xal.currency_conversion_rate   AS "Currency Conversion Rate",
         xah.product_rule_code          AS "Product Rule Code"
   FROM xla_distribution_links xdl,
        xla_ae_headers       xah,
         xla_ae_lines         xal,
         gl_code_combinations gcc
   WHERE     xal.code_combination_id = gcc.code_combination_id
         AND xah.ae_header_id = xal.ae_header_id
         AND xal.ae_header_id = xdl.ae_header_id
         --AND xal.ae_line_num = xdl.ae_line_num
            and xal.displayed_line_number = xdl.ae_line_num
         -- and xah.doc_sequence_value = '40300000724 '
         -- and gcc.segment6 = '01200'
        --AND xdl.source_distribution_type = "RCV_RECEIVING_SUB_LEDGER"
         AND xah.accounting_date BETWEEN :P_Start_Date AND :P_End_Date
         --   AND xdl.event_class_code = 'SALES_ORDER'
--and xdl.application_id   not in ('200','140','222')
--and xdl.ae_header_id   in ('9586301','9614129','9614823')
--and gcc.segment6   in('67100')
--and xdl.line_definition_code    = 'IPC_SALES_ORDER'
--and xdl.accounting_line_code  = 'INVENTORY_VALUATION'
--and xal.entered_dR  = 6535614.77
---and   xal.accounted_dr = 6535614.77
--and xdl.ae_header_id  = 8557528
   and xdl.ae_header_id  = 9188939
--and  xah.gl_transfer_status_code = 'N'
--and xdl.rounding_class_code ='COST_OF_GOODS_SOLD'
ORDER BY xdl.ae_header_id, xdl.ae_line_num ASC

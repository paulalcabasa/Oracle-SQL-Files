select
         xdl.application_id as "Application ID"
        ,xdl.source_distribution_type as "Source Distribution Type"
      ,xdl.source_distribution_id_num_1 as "Source Distribution Id Num" 
        ,xdl.ae_header_id as "AE Header ID" 
        ,xdl.ae_line_num as "AE Line Num"
        ,xal.accounting_class_code as "Accounting Class Code"
        ,xdl.accounting_line_code as "Accounting Line Code"
        ,xdl.line_definition_code as "Line Definition COde"
      ,xdl.event_class_code as "Event Class Code"
        ,xdl.event_type_code as "Event Type Code"
        ,xdl.rounding_class_code as "Rounding Class Code"
        ,xah.accounting_date as "Accounting Date"
        ,xah.gl_transfer_status_code as "GL Transfer Status Code"
      ,xah.gl_transfer_date as "GL Transfer Date"
        ,xah.je_category_name as "JE Category Name"
        ,xah.accounting_entry_type_code as "Accounting Entry Type Code"
        ,xah.doc_sequence_value as "Document Sequence Value"
      ,gcc.segment1 as "Company"
        ,gcc.segment2 as "Cost Center"
        ,gcc.segment3 as "ID" 
        ,gcc.segment4 as "Budget Account"
        ,gcc.segment5 as "Budget Cost Center"
        ,gcc.segment6 as "Account"
        ,gcc.segment7 as "Model"
        ,gcc.segment8 as "Projects"
        ,gcc.segment9 as "Future"
        ,xah.description as "Description"
        ,xal.description AS "Line Description"
        ,xal.displayed_line_number as "Line Number"
        ,xah.period_name as "Period Name"
        ,xal.entered_dr as "Entered Debit"
        ,xal.entered_cr as "Entered Credit"
        ,xal.accounted_dr as "Accounted Debit"
        ,xal.accounted_cr as "Accounted Credit"
,xdl.unrounded_entered_dr as "Unrounded Entered Debit"
,xdl.unrounded_entered_cr as "Unrounded Entered Credit"
,xdl.unrounded_accounted_dr as "Unrounded Accounted Debit"
,xdl.unrounded_accounted_cr as "Unrounded Accounted Credit"
      ,xal.currency_code as "Currency Code"
        ,xal.currency_conversion_date as "Currency Conversion Date"
        ,xal.currency_conversion_rate as "Currency Conversion Rate"
        ,xah.product_rule_code as "Product Rule Code"
        
from 
        xla_distribution_links xdl
      ,xla_ae_headers xah
      ,xla_ae_lines xal
     ,gl_code_combinations gcc
      
where
      xal.code_combination_id = gcc.code_combination_id
     and xah.ae_header_id = xal.ae_header_id
     and xal.ae_header_id = xdl.ae_header_id
     and xal.ae_line_num = xdl.ae_line_num
      and xah.accounting_date between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
     and gcc.segment6 between NVL(:P_ACCOUNT_CODE_FROM,gcc.segment6) AND NVL(:P_ACCOUNT_CODE_TO,gcc.segment6) 
     
order by
        xdl.ae_header_id
        ,xdl.ae_line_num asc
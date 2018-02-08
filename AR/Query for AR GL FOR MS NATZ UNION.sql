-- invoices correct 2 (used query as of july 10, 2017)
SELECT distinct
            rcta.trx_number transaction_number,
            ac.customer_name,
            gjh.doc_sequence_value voucher_no,
            gjh.je_source,
            xah.je_category_name,
            gjh.default_effective_date,
            gjh.posted_date,
            gjh.status,
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
            nvl(xal.entered_dr,0) - nvl(xal.entered_cr,0) entered_amount,
            xal.accounted_dr,
            xal.accounted_cr,
            nvl(xal.accounted_dr,0) - nvl(xal.accounted_cr,0) accounted_amount,
            xal.currency_code,
            xal.currency_conversion_date,
            xal.currency_conversion_rate,
            xah.product_rule_code
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
        INNER JOIN apps.gl_code_combinations gcc
            ON xal.code_combination_id = gcc.code_combination_id
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
            AND xte.entity_code = 'TRANSACTIONS'
        LEFT JOIN apps.ar_customers ac
            ON rcta.bill_to_customer_id = ac.customer_id
            
WHERE 1 = 1
       --    AND xah.je_category_name = 'Sales Invoices'
--           AND rcta.trx_number = '40200000873'    
  --        AND gcc.segment6 IN ('63000')
--          AND rcta.trx_number = '40200000873'
          AND gjh.je_source = 'Receivables'
          AND gjh.default_effective_date between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
          AND gcc.segment6 between NVL(:P_ACCOUNT_CODE_FROM,gcc.segment6) AND NVL(:P_ACCOUNT_CODE_TO,gcc.segment6)
UNION
          -- invoices correct 2 (used query as of july 10, 2017)
SELECT distinct
            acra.receipt_number transaction_number,
            party.PARTY_NAME customer_name,
            gjh.doc_sequence_value voucher_no,
            gjh.je_source,
            xah.je_category_name,
            gjh.default_effective_date,
            gjh.posted_date,
            gjh.status,
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
            nvl(xal.entered_dr,0) - nvl(xal.entered_cr,0) entered_amount,
            xal.accounted_dr,
            xal.accounted_cr,
            nvl(xal.accounted_dr,0) - nvl(xal.accounted_cr,0) accounted_amount,
            xal.currency_code,
            xal.currency_conversion_date,
            xal.currency_conversion_rate,
            xah.product_rule_code
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
        INNER JOIN apps.gl_code_combinations gcc
            ON xal.code_combination_id = gcc.code_combination_id
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
        LEFT JOIN hz_cust_accounts cust
            ON acra.pay_from_customer = cust.cust_account_id
        LEFT JOIN hz_cust_site_uses_all site_uses 
            ON site_uses.site_use_id = acra.customer_site_use_id
        LEFT JOIN hz_parties party
            ON cust.party_id = party.party_id
WHERE 1 = 1
            --  AND xah.je_category_name = 'Misc Receipts'
            --           AND rcta.trx_number = '40200000873'
            --          and ACRA.RECEIPT_NUMBER = 'AR-835'
          AND gjh.je_source = 'Receivables'
          AND gjh.default_effective_date between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
          AND gcc.segment6 between NVL(:P_ACCOUNT_CODE_FROM,gcc.segment6) AND NVL(:P_ACCOUNT_CODE_TO,gcc.segment6)
          
;

SELECT DISTINCT ENTITY_CODE
FROM xla.xla_transaction_entities;

SELECT *
FROM RA_CUSTOMER_TRX_ALL
WHERE trx_number = '1608';
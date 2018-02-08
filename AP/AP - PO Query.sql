select 
              aila.PO_LINE_ID,
            xah.period_name,
            aia.invoice_num,
            aia.doc_sequence_value voucher_no,
            gjh.je_source,
            xah.je_category_name,
            to_char(gjh.doc_sequence_value) gl_voucher_no,
        --        gjl.je_line_num,
            to_char(gcc.segment6) account_no,
            to_char(xah.accounting_date) accounting_date,
            xah.gl_transfer_status_code,
            to_char(xah.gl_transfer_date) gl_transfer_date,
--            sum(aida.amount) distribution_amount,
            xal.entered_dr,
            xal.entered_cr, 
            xal.accounted_dr,
            xal.accounted_cr
FROM  
            -- XLA TABLES
            xla_ae_headers xah
            INNER JOIN xla_ae_lines xal
                ON xah.ae_header_id = xal.ae_header_id
                AND xah.application_id = xal.application_id
            INNER JOIN xla_distribution_links xdl 
                ON xdl.event_id = xah.event_id
                AND xdl.ae_header_id = xah.ae_header_id
                AND xdl.ae_line_num = xal.ae_line_num
                AND xdl.application_id = xah.application_id
                AND xdl.source_distribution_type = 'mtl_transaction_accounts'
            INNER JOIN xla_events xe
                ON xe.event_id = xah.event_id
                AND xe.application_id = xah.application_id
            INNER JOIN xla.xla_transaction_entities xte
                ON xte.application_id = xe.application_id
                AND xte.entity_id = xe.entity_id 
         
            INNER JOIN gl_code_combinations gcc
                ON gcc.code_combination_id = xal.code_combination_id
                
            -- AP INVOICES
--           INNER JOIN ap_invoice_distributions_all aida
--                ON aida.invoice_distribution_id = xdl.source_distribution_id_num_1
            INNER JOIN ap_invoices_all aia
                ON xte.source_id_int_1 = aia.invoice_id 
            INNER JOIN ap_invoice_lines_all aila
                ON aila.invoice_id = aia.invoice_id
            INNER JOIN ap_suppliers aps
                ON  aps.vendor_id = aia.vendor_id
            
            -- PO TABLES
            INNER JOIN po_lines_all pla
                ON aila.po_line_id = pla.po_line_id
                AND aila.po_header_id = pla.po_header_id
            INNER JOIN po_headers_all pha
                ON pha.po_header_id = pla.po_header_id
                  
                   
     
--            INNER JOIN mtl_transaction_accounts mta
--            ON xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id
--            INNER JOIN mtl_material_transactions mmt
--            ON mmt.transaction_id = mta.transaction_id
            
            
            -- GL TABLES
            LEFT JOIN gl_import_references gir
                ON xal.gl_sl_link_id = gir.gl_sl_link_id
                AND xal.gl_sl_link_table = gir.gl_sl_link_table
            LEFT JOIN gl_je_headers gjh
                ON gir.je_header_id = gjh.je_header_id
            LEFT JOIN gl_je_lines gjl
                ON gir.je_header_id = gjl.je_header_id
                AND gir.je_line_num = gjl.je_line_num
            
where 1 = 1
        
            
        -- FILTERS
      
       AND (NVL(xal.accounted_dr,0) - NVL(xal.accounted_cr,0)) != 0 
     AND gcc.segment6 IN ('82000','83300')
      --JUL - AUG
           AND TO_DATE(xah.accounting_date) BETWEEN '01-JUL-2017' AND '30-JUL-2017'
            
            --BETWEEN NVL(TO_DATE(:p_date_start, 'DD/MON/RRRR hh24:mi:ss'),TO_DATe(xah.accounting_date))
   -- AND NVL(TO_DATE (:p_date_end, 'DD/MON/RRRR hh24:mi:ss'),TO_DATE(xah.accounting_date))
--      GROUP BY MAX(.transaction_id
      
   ;

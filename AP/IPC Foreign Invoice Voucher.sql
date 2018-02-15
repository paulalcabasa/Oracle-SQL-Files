SELECT *
FROM (SELECT    
    glcc.segment6 account_no ,
   SUM(NVL(xal.accounted_dr,0) - NVL(xal.accounted_cr,0))  accounted_amount
   
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
        INNER JOIN xla_distribution_links xdl
            ON xah.ae_header_id = xdl.ae_header_id
            and xdl.event_id = xah.event_id
            and xdl.ae_line_num = xal.ae_line_num
            and xdl.application_id = xah.application_id
       INNER JOIN ap_invoice_distributions_all aida
            ON xdl.source_distribution_id_num_1 = aida.invoice_distribution_id
        INNER JOIN ap_invoices_all aia
            ON  aia.invoice_id = aida.invoice_id
            
WHERE 1 = 1
            AND xte.entity_code = 'AP_INVOICES' 
           AND xdl.source_distribution_type = 'AP_INV_DIST'
            and aia.doc_sequence_value = :DOC_SEQUENCE_VALUE
group by 
           glcc.segment6)
WHERE accounted_amount != 0;
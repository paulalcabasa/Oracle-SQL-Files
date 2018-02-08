SELECT *
FROM 

(SELECT    

            -- INVOICE
                XAH.AE_HEADER_ID,
            aia.invoice_id,
            
            aia.doc_sequence_value,
            xah.accounting_date voucher_date,
            aia.vendor_id,
            aps.vendor_name,
            aps.payment_currency_code,
            aia.exchange_rate,
            aia.invoice_num,
            aia.invoice_amount,
             
           -- ACCOUNTING ENTRIES
            xal.ae_line_num,
            to_char(glcc.segment6) account_no,
            DECODE(glcc.segment6,'-',
                              glcc.segment6,
                              gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,6,segment6)) account_name,
            DECODE(glcc.segment2,'-',
                            glcc.segment2,
                            gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,2,glcc.segment2)) cost_center,
            max(aila.tax_classification_code) tax,
            max(awt.name) wtax,
            DECODE(glcc.segment7,'-',
                          glcc.segment7,
                          gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,2,glcc.segment7)) model, 
           DECODE(glcc.segment4,'-',
                          glcc.segment4,
                          gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,4,glcc.segment4)) budget_acount,  
            DECODE(glcc.segment5,'-',
                          glcc.segment5,
                          gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,5,glcc.segment5)) budget_cost_center,                
   
            xal.entered_dr,
            xal.entered_cr,
            xal.description
        
FROM   
        xla.xla_ae_headers xah 
        LEFT JOIN xla.xla_ae_lines xal
            ON  xah.ae_header_id = xal.ae_header_id 
            AND xal.application_id = xah.application_id
        LEFT JOIN apps.gl_code_combinations glcc
            ON xal.code_combination_id = glcc.code_combination_id
        LEFT  JOIN xla.xla_transaction_entities xte
            ON xah.entity_id = xte.entity_id
            AND xte.application_id = xal.application_id
        LEFT JOIN xla_distribution_links xdl
            ON xah.ae_header_id = xdl.ae_header_id
            and xdl.event_id = xah.event_id
            and xdl.ae_line_num = xal.ae_line_num
            and xdl.application_id = xah.application_id
        LEFT JOIN AP_PREPAY_APP_DISTS APAD
            ON xdl.source_distribution_id_num_1 = apad.prepay_app_dist_id
        LEFT JOIN ap_invoice_distributions_all aida
            ON  aida.invoice_distribution_id = apad.prepay_app_distribution_id
        LEFT JOIN ap_invoices_all aia
            ON  aia.invoice_id = aida.invoice_id
        LEFT JOIN ap_invoice_lines_all aila
            ON aila.invoice_id = aia.invoice_id
            and aila.line_number = aida.invoice_line_number 
        LEFT JOIN ap_awt_groups awt
            ON aila.awt_group_id = awt.group_id   
        LEFT JOIN ap_suppliers aps
            ON aps.vendor_id = aia.vendor_id
 
            
WHERE 1 = 1
            AND xte.entity_code = 'AP_INVOICES' 
            AND xdl.source_distribution_type = 'AP_PREPAY'
            and aia.doc_sequence_value between :p_start_voucher and :p_end_voucher

group by 
        XAH.AE_HEADER_ID,
            xal.ae_line_num,
            aia.invoice_id,
            aia.invoice_num,
            aia.doc_sequence_value,
            glcc.segment6,
            xal.entered_dr ,
            xal.entered_cr ,
            glcc.chart_of_accounts_id,
            glcc.segment2,
            glcc.segment7,
            glcc.segment4,
            glcc.segment5,
            xal.description,
            xah.ae_header_id,
            aia.vendor_id,
            aps.vendor_name,
            aps.payment_currency_code,
            aia.exchange_rate,
            aia.invoice_amount,
            xah.accounting_date
having nvl(xal.entered_dr,0) - nvl(xal.entered_cr,0) <> 0
order by xal.entered_cr desc,
                xal.entered_dr desc) A
                UNION              
(SELECT    

            -- INVOICE
            XAH.AE_HEADER_ID,
            aia.invoice_id,
            aia.doc_sequence_value,
            xah.accounting_date voucher_date,
            aia.vendor_id,
            aps.vendor_name,
            aps.payment_currency_code,
            aia.exchange_rate,
            aia.invoice_num,
            aia.invoice_amount,
             
           -- ACCOUNTING ENTRIES
            xal.ae_line_num,
            to_char(glcc.segment6) account_no,
            DECODE(glcc.segment6,'-',
                              glcc.segment6,
                              gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,6,segment6)) account_name,
            DECODE(glcc.segment2,'-',
                            glcc.segment2,
                            gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,2,glcc.segment2)) cost_center,
            max(aila.tax_classification_code) tax,
            max(awt.name) wtax,
            DECODE(glcc.segment7,'-',
                          glcc.segment7,
                          gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,2,glcc.segment7)) model, 
           DECODE(glcc.segment4,'-',
                          glcc.segment4,
                          gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,4,glcc.segment4)) budget_acount,  
            DECODE(glcc.segment5,'-',
                          glcc.segment5,
                          gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,5,glcc.segment5)) budget_cost_center,                
   
            xal.entered_dr,
            xal.entered_cr,
            xal.description
        
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
        INNER JOIN ap_invoice_lines_all aila
            ON aila.invoice_id = aia.invoice_id
            and aila.line_number = aida.invoice_line_number 
        LEFT JOIN ap_awt_groups awt
            ON aila.awt_group_id = awt.group_id   
        INNER JOIN ap_suppliers aps
            ON aps.vendor_id = aia.vendor_id
        
          
WHERE 1 = 1
            AND xte.entity_code = 'AP_INVOICES' 
            AND xdl.source_distribution_type = 'AP_INV_DIST'
            and aia.doc_sequence_value between :p_start_voucher and :p_end_voucher

group by 
    XAH.AE_HEADER_ID,
            xal.ae_line_num,
            aia.invoice_id,
            aia.invoice_num,
            aia.doc_sequence_value,
            glcc.segment6,
            xal.entered_dr ,
            xal.entered_cr ,
            glcc.chart_of_accounts_id,
            glcc.segment2,
            glcc.segment7,
            glcc.segment4,
            glcc.segment5,
            xal.description,
            xah.ae_header_id,
            aia.vendor_id,
            aps.vendor_name,
            aps.payment_currency_code,
            aia.exchange_rate,
            aia.invoice_amount,
            xah.accounting_date
-- having nvl(xal.entered_dr,0) - nvl(xal.entered_cr,0) <> 0
--order by xal.entered_cr desc,xal.entered_dr desc) B
            );
            
            
            SELECT *
            FROM ap_invoices_all aia,
                        ap_invoice_lines_all aila,
                        gl_code_combinations gcc
             where aia.invoice_id = aila.invoice_id
                    and aila.DEFAULT_DIST_CCID = gcc.code_combination_id
                    and gcc.segment6 = '67301';
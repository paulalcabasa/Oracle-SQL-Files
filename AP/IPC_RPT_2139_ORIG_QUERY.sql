select *
from (SELECT    

            -- INVOICE
            aia.invoice_id,
            aia.doc_sequence_value,
            xah.accounting_date voucher_date,
            aia.vendor_id,
            aps.vendor_name,
            aia.payment_currency_code,
            aia.exchange_rate,
            aia.invoice_num,
            aia.invoice_amount,
             
           -- ACCOUNTING ENTRIES
            xal.ae_line_num,
            to_char(glcc.segment6) account_no,
            DECODE(glcc.segment6,'-',
                              glcc.segment6,
                              gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,6,segment6)) account_name,
            glcc.segment2 cost_center,
            /*   Removed by Paul
                   Date:  August 2, 2017 11:30 am
                   Requested by Ms. Grace
           
            DECODE(glcc.segment2,'-',
                            glcc.segment2,
                            gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,2,glcc.segment2)) cost_center,
            */
            max(aila.tax_classification_code) tax,
            max(awt.name) wtax,
            null model, 
          glcc.segment4 budget_account,
          /*     Removed by Paul
                   Date:  August 2, 2017 11:30 am
                   Requested by Ms. Grace
           DECODE(glcc.segment4,'-',
                          glcc.segment4,
                          gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,4,glcc.segment4)) budget_acount,  
            */
            
            glcc.segment5 budget_cost_center,
            /*    Removed by Paul
                   Date:  August 2, 2017 11:30 am
                   Requested by Ms. Grace
            DECODE(glcc.segment5,'-',
                          glcc.segment5,
                          gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,5,glcc.segment5)) budget_cost_center,                
            */
            xal.entered_dr,
            xal.entered_cr,
            substr(xal.description,1,55) description,
            CASE 
                WHEN glcc.segment6 IN ('83300','83301','83303','83304','83314','82000') THEN 1
                WHEN glcc.segment6 IN ('67000','67100','67101','67102','67103','67104','67105') THEN 2
                 WHEN glcc.segment6 IN ('83302') THEN 2
                ELSE 3
            END priority
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
        LEFT JOIN ap_suppliers aps
            ON aps.vendor_id = aia.vendor_id
        
      -- ITEM
--       INNER JOIN rcv_transactions rcvt
--            ON rcvt.transaction_id = aida.rcv_transaction_id
--         INNER JOIN ap_invoice_lines_all aila
--            ON rcvt.transaction_id = aila.rcv_transaction_id    
--        INNER JOIN mtl_system_items_b msib
--            ON msib.inventory_item_id = aila.inventory_item_id
--            AND rcvt.organization_id = msib.organization_id
--  
--        INNER JOIN mtl_item_categories  mtc
--            ON msib.inventory_item_id = mtc.inventory_item_id 
--            AND msib.organization_id = mtc.organization_id 
--        INNER JOIN mtl_categories_kfv mck 
--            ON mtc.category_id =mck.category_id 
--          INNER JOIN fnd_lookup_values flv
--            ON  msib.item_type = flv.lookup_code  
--        
--            INNER JOIN hr_all_organization_units org
--            ON org.organization_id = rcvt.organization_id
       -- GL LINK
--       LEFT JOIN apps.gl_import_references gir
--            ON gir.gl_sl_link_id = xal.gl_sl_link_id
--            AND gir.gl_sl_link_table = xal.gl_sl_link_table
--        LEFT JOIN apps.gl_je_lines gjl
--            ON gjl.je_header_id = gir.je_header_id
--            AND gjl.je_line_num = gir.je_line_num
--        LEFT JOIN apps.gl_je_headers gjh         
--            ON gjh.je_header_id = gir.je_header_id
            
WHERE 1 = 1
            AND xte.entity_code = 'AP_INVOICES' 
            AND xdl.source_distribution_type = 'AP_INV_DIST'
            and aia.doc_sequence_value between :p_start_voucher and :p_end_voucher

group by 
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
            aia.payment_currency_code,
            aia.exchange_rate,
            aia.invoice_amount,
            xah.accounting_date
having nvl(xal.entered_cr,0) - nvl(xal.entered_dr,0) <> 0)
order by priority ASC
,entered_cr desc,
            entered_dr desc;
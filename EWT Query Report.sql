SELECT -- HEADER DETAILS
             aia.invoice_id,
             aia.doc_sequence_value,
             aps.vendor_name,
             aia.invoice_num,
             aia.invoice_amount,
             aia.total_tax_amount tax,
             sum(CASE WHEN aila.line_type_lookup_code IN ('ITEM','FREIGHT') THEN aila.amount ELSE 0 END) - aia.total_tax_amount net,
             (sum(case when aila.line_type_lookup_code = 'AWT' THEN aila.amount ELSE 0 END)) wtx,
             aia.gl_date,
             -- ATC DETAILS
              awt_details.awt_name atc_name,
              (awt_details.amount) atc_amount,
              supplier_tax_details.supplier_name third_party_supplier,
              supplier_tax_details.amount_net_of_vat third_party_amount,
              supplier_tax_details.vat third_party__vat,
              supplier_tax_details.wtx third_party_wtx
FROM ap_invoices_all aia
           LEFT JOIN ap_suppliers aps
                ON aia.vendor_id = aps.vendor_id
           LEFT JOIN ap_invoice_lines_all aila
                ON aila.invoice_id = aia.invoice_id
           
           LEFT JOIN (
                    SELECT invoice_id,
                                 supplier_name,
                                 CASE WHEN line_source = 'MANUAL LINE ENTRY' THEN (amount - vat) 
                                           WHEN line_source = 'HEADER MATCH' THEN amount
                                           ELSE amount 
                                END amount_net_of_vat,
                                (vat)vat,  
                                ( (amount - vat) * (wtx_rate / 100) ) wtx,
                                  awt_group_id
                    FROM (SELECT aia.invoice_id,
                                aila.line_source,
                                NVL(aps_dff.vendor_name,aps_inv.vendor_name) supplier_name,
                                 aila.amount,
                                 case 
                                        when tax.percentage_rate > 0 then (aila.amount/ 1.12) * (tax.percentage_rate/100)
                                        ELSE 0
                                 end vat,
                                 aila.tax_classification_code,
                                 awt_rates.tax_rate wtx_rate,
                                 aag.group_id awt_group_id
                    FROM ap_invoice_lines_all aila
                               LEFT JOIN ap_invoices_all aia
                                    ON aia.invoice_id = aila.invoice_id
                               LEFT JOIN ap_suppliers aps_dff
                                    ON aila.attribute1 = aps_dff.segment1
                               LEFT JOIN ap_suppliers aps_inv
                                    ON aps_inv.vendor_id = aia.vendor_id 
                               LEFT JOIN ZX_RATES_B tax
                                    ON tax.tax = aila.tax_classification_code
                                    AND tax.rate_type_code = 'PERCENTAGE'
                                    AND tax.effective_to IS NULL
                               LEFT JOIN ap_awt_groups aag
                                    ON aag.group_id = aila.awt_group_id
                               LEFT JOIN ap_awt_tax_rates_all awt_rates
                                    ON awt_rates.tax_name = aag.name
                                    AND awt_rates.org_id = 82
                    WHERE 1 = 1
                               --   AND aila.amount > 0
                                 AND aila.line_type_lookup_code IN('ITEM','FREIGHT') ) 
                  --  GROUP BY invoice_id,supplier_name,awt_group_id
                    ) supplier_tax_details 
                  ON supplier_tax_details.invoice_id = aia.invoice_id
              LEFT JOIN (SELECT aia.invoice_id,
                                            aila.awt_group_id,
                                             aag.name awt_name,
                                             aila.amount
                                FROM ap_invoices_all aia 
                                           LEFT JOIN ap_invoice_lines_all aila
                                                ON aia.invoice_id = aila.invoice_id
                                           LEFT JOIN ap_awt_groups aag
                                                ON aag.group_id = aila.awt_group_id
                                WHERE 1 = 1 
                                             and aila.line_type_lookup_code = 'AWT') awt_details
                    ON awt_details.awt_group_id = supplier_tax_details.awt_group_id
                    AND awt_details.invoice_id = supplier_tax_details.invoice_id
                  --  AND awt_details.invoice_id = aia.invoice_id
               
WHERE  aia.doc_sequence_value = '20050317'
      --   aia.gl_date between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
GROUP BY   aia.invoice_id,
                    aia.doc_sequence_value,
                    aia.total_tax_amount,
                    aps.vendor_name,
                    aia.invoice_num,
                    aia.invoice_amount,
                    aia.gl_date,
                    awt_details.awt_name,
                    awt_details.amount,
                    supplier_name,
                    amount_net_of_vat,
                    vat,
                    wtx;
                    
                    
                    SELECT aia.invoice_id,
                                aila.line_source,
                                NVL(aps_dff.vendor_name,aps_inv.vendor_name) supplier_name,
                                 aila.amount,
                                 case 
                                        when tax.percentage_rate > 0 then (aila.amount/ 1.12) * (tax.percentage_rate/100)
                                        ELSE 0
                                 end vat,
                                 aila.tax_classification_code,
                                 awt_rates.tax_rate wtx_rate,
                                 aag.group_id awt_group_id
                    FROM ap_invoice_lines_all aila
                               LEFT JOIN ap_invoices_all aia
                                    ON aia.invoice_id = aila.invoice_id
                               LEFT JOIN ap_suppliers aps_dff
                                    ON aila.attribute1 = aps_dff.segment1
                               LEFT JOIN ap_suppliers aps_inv
                                    ON aps_inv.vendor_id = aia.vendor_id 
                               LEFT JOIN ZX_RATES_B tax
                                    ON tax.tax = aila.tax_classification_code
                                    AND tax.rate_type_code = 'PERCENTAGE'
                                    AND tax.effective_to IS NULL
                               LEFT JOIN ap_awt_groups aag
                                    ON aag.group_id = aila.awt_group_id
                               LEFT JOIN ap_awt_tax_rates_all awt_rates
                                    ON awt_rates.tax_name = aag.name
                                    AND awt_rates.org_id = 82
                    WHERE 1 = 1
                               --   AND aila.amount > 0
                                 AND aila.line_type_lookup_code IN('ITEM','FREIGHT')  
                                 and AIA.DOC_SEQUENCE_VALUE = '20050317';
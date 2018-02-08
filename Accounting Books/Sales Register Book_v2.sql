SELECT apsa.gl_date,
            rcta.trx_number,
            hcsua.tax_reference,
             hp.party_name || 
             CASE 
                    WHEN hcaa.account_name IS NOT NULL THEN ' - ' || hcaa.account_name
                    ELSE NULL
             END customer_name,
             hl.address1 || ' ' || hl.address2 || ' ' || hl.address3 || ' ' || hl.address4 || ' ' || hl.city address,
             SUM(rctla.extended_amount) + sum(rctla.tax_recoverable) amount,
             rctta.name document_type,
             rcta.comments,
             rcta.invoice_currency_code
             
             
FROM 
           -- INVOICE DATA
            ra_customer_trx_all rcta
            INNER JOIN ra_customer_trx_lines_all rctla
                ON rctla.customer_trx_id = rcta.customer_trx_id
            INNER JOIN ra_cust_trx_types_all rctta
                ON rctta.cust_trx_type_id = rcta.cust_trx_type_id
            INNER JOIN ar_payment_schedules_all apsa
                ON apsa.customer_trx_id = rcta.customer_trx_id        
                AND rcta.trx_number = apsa.trx_number  
            INNER JOIN ra_cust_trx_types_all rctta
                ON rctta.cust_trx_type_id = rcta.cust_trx_type_id
            INNER JOIN ra_cust_trx_line_gl_dist_all rct_gl
                ON rct_gl.customer_trx_line_id = rctla.customer_trx_line_id
            INNER JOIN gl_code_combinations gcc
                ON gcc.code_combination_id = rct_gl.code_combination_id
            -- CUSTOMER DATA
            INNER JOIN hz_cust_accounts_all hcaa
                ON hcaa.cust_account_id = rcta.bill_to_customer_id
            INNER JOIN hz_cust_site_uses_all hcsua
                ON hcsua.site_use_id = rcta.bill_to_site_use_id
       --         AND hcsua.status = 'A'
                AND hcsua.site_use_code = 'BILL_TO'
            INNER JOIN hz_parties hp
                ON hp.party_id = hcaa.party_id
            INNER JOIN hz_cust_acct_sites_all hcasa
                ON hcsua.cust_acct_site_id = hcasa.cust_acct_site_id
            INNER JOIN hz_party_sites hps
                ON hps.party_site_id = hcasa.party_site_id
            INNER JOIN hz_locations hl
                ON hl.location_id = hps.location_id
WHERE 1 = 1
                AND gcc.segment6 BETWEEN '01100' AND '02004'
                AND rcta.complete_flag = 'Y'
           --     AND rcta.trx_number = '40100000404'
               AND TO_DATE(apsa.gl_date) between  TO_DATE (:P_DATE_FROM, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_DATE_TO, 'yyyy/mm/dd hh24:mi:ss')
--                          AND rcta.trx_number = '40300000722'
--                          AND rcta.trx_number = '40200000489'
GROUP BY 
             apsa.gl_date,
            rcta.trx_number,
            hcsua.tax_reference,
             hp.party_name, hcaa.account_name,
             hl.address1, 
             hl.address2,
             hl.address3,
             hl.address4,
             hl.city,
             rctta.name,
             rcta.comments,
              rcta.invoice_currency_code;
             
             select *
             from ra_customer_trx_all;
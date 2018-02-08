SELECT gl_date,
             tax_reference,
             customer_name,
             address,
             substr(description,1,50) description,
             document_type,
             trx_number reference_number,
            CASE    
                WHEN manual_override > 0 THEN line_amount + manual_override
                ELSE line_amount
            end gross,
            discount,
            tax vat_amount,
            total_amount net
FROM (
            SELECT apsa.gl_date,
                         hcsua.tax_reference,
                         hp.party_name || 
                         CASE 
                                WHEN hcaa.account_name IS NOT NULL THEN ' - ' || hcaa.account_name
                                ELSE NULL
                         END customer_name,
                         hl.address1 || ' ' || hl.address2 || ' ' || hl.address3 || ' ' || hl.address4 || ' ' || hl.city address,
                         rctta.name document_type,
                         rcta.trx_number,
                         LISTAGG(
                                CASE 
                                    WHEN LOWER(rctla.description) NOT LIKE  '%manual%override%' OR 
                                                (rctla.description) NOT LIKE '%Discount%' 
                                                THEN rctla.description 
                                    ELSE NULL 
                                END, '; '
                           )
                           WITHIN GROUP (
                                ORDER BY rctla.line_number
                           ) description,
--                         CASE
--                                WHEN lower(rctla.description) NOT LIKE '%override%' THEN rctla.description
--                                ELSE NULL
--                         END description,
                         SUM (        
                                CASE
                                    WHEN rctla.interface_line_attribute11 != 0 THEN
                                        rctla.line_recoverable
                                    ELSE
                                        0
                                    END
                            ) manual_override,
                            SUM (              
                                    CASE
                                        WHEN rcta.cust_trx_type_id IN(1002,2082) AND rctla.interface_line_attribute11 = 0 THEN rctla.line_recoverable
                                        WHEN rcta.cust_trx_type_id IN (3081, 6081, 8081) THEN rctla.line_recoverable
                                        ELSE 0
                                        END
                          ) line_amount,
                         SUM(rctla.extended_amount) total_amount,
                         CASE
                                WHEN rcta.cust_trx_type_id IN (1002,2082)
                                THEN
                                   CASE
                                      WHEN SUM (
                                              DECODE (rctla.interface_line_attribute11,
                                                      '0', 0,
                                                      rctla.line_recoverable)) > 0
                                      THEN
                                         0
                                      ELSE
                                         SUM (
                                            DECODE (rctla.interface_line_attribute11,
                                                    '0', 0,
                                                    rctla.line_recoverable))
                                   END
                                WHEN rcta.cust_trx_type_id IN (3081, 6081)
                                THEN
                                   CASE
                                      WHEN SUM (
                                              DECODE (rctla.interface_line_attribute11,
                                                      '0', 0,
                                                      rctla.line_recoverable)) < 0
                                      THEN
                                         0
                                      ELSE
                                         SUM (
                                            DECODE (rctla.interface_line_attribute11,
                                                    '0', 0,
                                                    rctla.line_recoverable))
                                   END
                             END discount,
                             SUM (rctla.tax_recoverable) tax
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
                            AND hcsua.status = 'A'
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
                          AND TO_DATE(apsa.gl_date) between  TO_DATE (:P_DATE_FROM, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_DATE_TO, 'yyyy/mm/dd hh24:mi:ss')
--                          AND rcta.trx_number = '40300000722'
--                          AND rcta.trx_number = '40200000489'
            GROUP BY 
                          apsa.gl_date,
                         hcsua.tax_reference,
                         hp.party_name,
                         hcaa.account_name,
                         hl.address1,
                         hl.address2,
                         hl.address3,
                         hl.address4,
                         hl.city,
                         rctta.name,
                         rcta.trx_number,
                         rcta.cust_trx_type_id
);






select distinct trx_number
from ra_customer_trx_lines_all rctla,
         ra_customer_trx_all rcta
where rctla.customer_trx_id = rcta.customer_trx_id
           and rctla.description like '%Discount%'
           and rcta.trx_number like '402%';
            
            select *
            from ar_payment_schedules_all ;
            
            SELECT *
            FROM ra_cust_trx_types_all;
            
            SELECT *
            FROM ra_customer_trx_all;
            
            SELECT *
            FROM RA_CUSTOMER_TRX_LINES_ALL;
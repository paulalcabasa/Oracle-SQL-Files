SELECT cwt.invoice_date,
             cwt.invoice_number,
             cwt.cs_number,
             cwt.customer_id,
             cwt.customer_name,
             cwt.invoice_status,
             cwt.due_date,
             cwt.days_overdue,
             round(cwt.wht_amount,2) wht_amount,
             round(cwt.amount_due_original - cwt.wht_amount,2) amount_due    ,
             round(cwt.amount_applied,2) payment_amount,
             round(cwt.amount_due_original - cwt.amount_applied,2) balance,
             cwt.receipt_date,
             cwt.receipt_number,
             cwt.customer_bank,
             cwt.check_no,
             cwt.check_date
             
FROM (
        SELECT rcta.trx_date invoice_date,
                    rcta.trx_number invoice_number,
                    rcta.attribute3 cs_number,
                    hcaa.cust_account_id customer_id,
                    hp.party_name customer_name,
                    acra.status invoice_status,
                    ipc_soa.due_date,
                    ipc_soa.days_overdue,
                    apsa.amount_line_items_original * 0.01 wht_amount,
                    apsa.amount_due_original,
                    apsa.amount_due_remaining,
                    acra.receipt_date,
                    araa.amount_applied,
                    acra.receipt_number,
                    acra.attribute1 customer_bank,
                    acra.attribute2 check_no,
                    acra.attribute3 check_date
        FROM  ra_customer_trx_all rcta
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
                    -- RECEIPT DATA
                    LEFT JOIN ar_receivable_applications_all araa
                        ON araa.applied_customer_trx_id = rcta.customer_trx_id
                        AND araa.display = 'Y'
                    LEFT JOIN ar_cash_receipts_all acra
                        ON acra.cash_receipt_id = araa.cash_receipt_id
                        AND acra.status NOT IN ('REV')
                    LEFT JOIN ar_payment_schedules_all apsa
                        ON apsa.customer_trx_id = rcta.customer_trx_id
                     LEFT JOIN  ipc.ipc_treasury_soa_details ipc_soa
                        ON ipc_soa.customer_trx_id = rcta.customer_trx_id
                        AND lower(ipc_soa.status) = 'op'
        WHERE 1 = 1
                      and rcta.trx_date between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
            
) cwt;
               
            
            select *
            from ipc.ipc_treasury_soa_details;
            SELECT distinct customer_trx_id
            FROM ar_payment_schedules_all;
                select *
                from ar_cash_receipts_all acra LEFT JOIN ar_receivable_applications_al
                where acra.receipt_date between '01-DEC-2017' AND '31-DEC-2017';
SELECT 
--  hps.PARTY_SITE_ID,
-- hps.party_site_id,
--  CUST_ACCOUNT_PROFILE_ID
--hps.party_site_number,
--             hcasa.cust_acct_site_id,
--              hcpc.profile_class_id,
--            hcpc.NAME profile_class_name
            hcaa.account_number,
            hp.party_name customer_name,
            hcaa.account_name,
            TO_CHAR(rcta.trx_date) invoice_date,
            rcta.trx_number invoice_number,
            NVL(msib.attribute9,msib.segment1) model,
            rcta.attribute3 cs_no,
            sum(case when rctla.line_type = 'LINE' THEN rctla.extended_amount end) unit_price,
            sum(case when rctla.line_type = 'TAX' THEN rctla.extended_amount end) vat_amount,
            apsa.amount_due_original gross_amount,
            TO_CHAR(TO_DATE(rcta.attribute5,'YYYY/MM/DD HH24:MI:SS'),'DD/MM/YYYY') actual_delivery_date
--             TO_CHAR(rcta.creation_date) creation_date,
--             TO_CHAR(apsa.gl_date) gl_date,
--             fu.description created_by
--             rcta.complete_flag,
--             DECODE(rcta.status_trx,'OP','Open','CL','Closed','VD','Void') status,
FROM ra_customer_trx_all rcta
            LEFT JOIN ar_payment_schedules_all apsa
                ON apsa.customer_trx_id = rcta.customer_trx_id
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
             INNER JOIN fnd_user fu
                ON fu.user_id = rcta.created_by
            LEFT JOIN mtl_serial_numbers msn
                ON msn.serial_number = rcta.attribute3
            LEFT JOIN mtl_system_items_b msib
                ON msib.inventory_item_id = msn.inventory_item_id
                AND msib.organization_id = msn.current_organization_id
            LEFT JOIN ra_customer_trx_lines_all rctla
                ON rctla.customer_trx_id = rcta.customer_trx_id
            LEFT JOIN ipc_ar_invoices_with_cm cm
                ON cm.orig_trx_id = rcta.customer_trx_id
--              INNER JOIN hz_customer_profiles hcp
--                ON hcp.cust_account_id = hcaa.cust_account_id
--              INNER JOIN hz_cust_profile_classes hcpc
--                ON hcpc.profile_class_id      = hcp.profile_class_id
WHERE 1 = 1
              and rcta.complete_flag = 'Y'
              and rcta.status_trx <> 'VD'
              and msn.current_organization_id = 121
--              and hcaa.account_number IN(1724,1725,1726)
              and rcta.trx_number like '403%'
              and cm.orig_trx_id IS NULL
              and rcta.trx_date between '01-NOV-2017' AND '30-NOV-2017'
--              and rcta.trx_number = '40300020088'
GROUP BY
                 hcaa.account_number,
            hp.party_name,
            hcaa.account_name,
            rcta.trx_date,
            rcta.trx_number,
            msib.attribute9,
            msib.segment1,
            rcta.attribute3,
            apsa.amount_due_original,
            rcta.attribute5;
            
            SELECT *
            FROM ipc_ar_invoices_with_cm;
select distinct ra.trx_number,
         ra.trx_date,
         hp.party_name,
         rctta.name,
         rctta.description
FROM ra_customer_trx_all ra,
ra_customer_trx_lines_all rl,
ar_payment_schedules_all aps,
ra_cust_trx_types_all rt,
hz_cust_accounts hc,
hz_parties hp,
hz_cust_acct_sites_all hcasa_bill,
hz_cust_site_uses_all hcsua_bill,
hz_party_sites hps_bill,
ra_cust_trx_line_gl_dist_all rct,
ra_cust_trx_types_all rctta
WHERE 1 = 1
AND ra.customer_trx_id = rl.customer_trx_id
AND ra.customer_trx_id = aps.customer_trx_id
and rctta.cust_trx_type_id = ra.cust_trx_type_id
AND ra.org_id = aps.org_id
AND rct.customer_trx_id = aps.customer_trx_id
AND rct.customer_trx_id = ra.customer_trx_id
AND rct.customer_trx_id = rl.customer_trx_id
AND rct.customer_trx_line_id = rl.customer_trx_line_id
AND ra.complete_flag = 'Y'
AND rl.line_type IN ('FREIGHT', 'LINE')
AND ra.cust_trx_type_id = rt.cust_trx_type_id
AND ra.bill_to_customer_id = hc.cust_account_id
AND hc.status = 'A'
AND hp.party_id = hc.party_id
AND hcasa_bill.cust_account_id = ra.bill_to_customer_id
AND hcasa_bill.cust_acct_site_id = hcsua_bill.cust_acct_site_id
AND hcsua_bill.site_use_code = 'BILL_TO'
AND hcsua_bill.site_use_id = ra.bill_to_site_use_id
AND hps_bill.party_site_id = hcasa_bill.party_site_id
AND hcasa_bill.status = 'A'
AND hcsua_bill.status = 'A'
AND aps.amount_due_remaining <> 0
AND aps.status = 'OP'
AND ra.trx_date between '01-MAY-2017' AND '30-MAY-2017';
select  trans_cust.party_name || receipt_cust.party_name || adj_cust.party_name customer_name,
            trans_cust.account_name || receipt_cust.account_name || adj_cust.account_name account_name,
            trans_cust.profile_class || receipt_cust.profile_class || adj_cust.profile_class site_name,
            je.*
from (select 
      CASE 
            WHEN je_category_name = 'Adjustment' THEN trim(REGEXP_SUBSTR (header_description, '[^-]+', 1,3))
            WHEN je_category_name = 'Debit Memos' THEN trim(REGEXP_SUBSTR (header_description, '[^-]+', 1,5))
            WHEN je_category_name = 'Sales Invoices' THEN trim(REGEXP_SUBSTR (header_description, '[^-]+', 1,7))
            WHEN je_category_name = 'Receipts' THEN substr(trim(REGEXP_SUBSTR (header_description, '[^-]+', 1,3)),1,11)
            WHEN je_category_name = 'Credit Memos' THEN TRIM(NVL(REGEXP_SUBSTR (header_description, '[^-]+', 1,5),REGEXP_SUBSTR (header_description, '[^-]+', 1,4)))
      END transaction_reference,
      gl_xla_data.*
from (
(select 
            gjh.doc_sequence_value voucher_no,
            gjh.je_source,
            gjh.je_category je_category_name,
            gjh.default_effective_date,
            gjh.posted_date,
            gjh.status,
            gjl.je_line_num gl_line_number,
            null accounting_date,
            null gl_transfer_status_code,
            null gl_transfer_date,
            null doc_sequence_value,
            gcc.segment1,
            gcc.segment2,
            gcc.segment3,
            gcc.segment4,
            gcc.segment5,
            gcc.segment6,
            gcc.segment7,
            gcc.segment8,
            gcc.segment9,
            gjh.description header_description,
            gjl.description line_description,
            gjh.period_name,
            gjl.entered_dr,
            gjl.entered_cr,
            nvl(gjl.entered_dr,0) - nvl(gjl.entered_cr,0) entered_amount,
            gjl.accounted_dr,
            gjl.accounted_cr,
            nvl(gjl.accounted_dr,0) - nvl(gjl.accounted_cr,0) accounted_amount,
            null currency_code,
            null currency_conversion_date,
            null currency_conversion_rate,
            null product_rule_code,
            gjl.attribute1 supplier_id,
            NVL(gjl.attribute2,aps.vendor_name) one_time_merchant_name,
            NVL(gjl.attribute3,aps.vat_registration_num) tin,
            gjl.attribute4 address,
            gjl.attribute5 vat_code,
            gjl.attribute6 wht_tax_code,
            gjl.attribute10 employee_id,
            gjl.attribute7 qty,
            gjl.attribute8 lot_no,
            gjl.attribute9 model
from gl_je_headers gjh INNER JOIN gl_je_lines gjl
            ON  gjh.je_header_id = gjl.je_header_id
         INNER JOIN gl_je_categories gjc
            ON gjc.je_category_name = gjh.je_category
         INNER JOIN gl_code_combinations_kfv gcc
             ON gcc.code_combination_id = gjl.code_combination_id
         LEFT JOIN ap_suppliers aps
             ON aps.segment1 = gjl.attribute1
where 1 = 1
            and gjh.default_effective_date between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
            AND nvl(gjl.accounted_dr,0) - nvl(gjl.accounted_cr,0) <> 0 
            and gcc.segment6 IN ('66904','63000')
--            AND gjh.je_source = 'Receivables'
            )

    UNION
     (select  
            gjh.doc_sequence_value voucher_no,
            null je_source,
            xah.je_category_name,
            gjh.default_effective_date,
            gjh.posted_date,
            gjh.status,
--            xdl.ae_line_num xla_line_number,
            gjl.je_line_num gl_line_number,
            xah.accounting_date,
            xah.gl_transfer_status_code,
            xah.gl_transfer_date,
            xah.doc_sequence_value,
            gcc.segment1,
            gcc.segment2,
            gcc.segment3,
            gcc.segment4,
            gcc.segment5,
            gcc.segment6,
            gcc.segment7,
            gcc.segment8,
            gcc.segment9,
            xah.description header_description,
            xal.description line_description,
            xah.period_name,
            xal.entered_dr,
            xal.entered_cr,
            nvl(xal.entered_dr,0) - nvl(xal.entered_cr,0) entered_amount,
            xal.accounted_dr,
            xal.accounted_cr,
            nvl(xal.accounted_dr,0) - nvl(xal.accounted_cr,0) accounted_amount,
            xal.currency_code,
            xal.currency_conversion_date,
            xal.currency_conversion_rate,
            xah.product_rule_code,
            gjl.attribute1 supplier_id,
            NVL(gjl.attribute2,aps.vendor_name) one_time_merchant_name,
            NVL(gjl.attribute3,aps.vat_registration_num) tin,
            gjl.attribute4 address,
            gjl.attribute5 vat_code,
            gjl.attribute6 wht_tax_code,
            gjl.attribute10 employee_id,
            gjl.attribute7 qty,
            gjl.attribute8 lot_no,
            gjl.attribute9 model
from 
        xla_ae_headers xah 
        INNER JOIN xla_ae_lines xal
            ON xah.ae_header_id = xal.ae_header_id
            AND xal.application_id = xah.application_id
        INNER JOIN gl_code_combinations gcc
            ON xal.code_combination_id = gcc.code_combination_id
        LEFT JOIN apps.gl_import_references gir
            ON gir.gl_sl_link_id = xal.gl_sl_link_id
            AND gir.gl_sl_link_table = xal.gl_sl_link_table
        LEFT JOIN apps.gl_je_lines gjl
            ON gjl.je_header_id = gir.je_header_id
            AND gjl.je_line_num = gir.je_line_num
        LEFT JOIN apps.gl_je_headers gjh         
            ON gjh.je_header_id = gjl.je_header_id
        LEFT JOIN ap_suppliers aps
                ON aps.segment1 = gjl.attribute1
where 1 = 1
        and xah.gl_transfer_status_code = 'N'
        and xah.accounting_date between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
        and gcc.segment6 IN ('63000','66904')
        and nvl(xal.accounted_dr,0) - nvl(xal.accounted_cr,0) <> 0
        )      
) gl_xla_data ) je 
    LEFT JOIN ra_customer_trx_all rcta
        ON je.transaction_reference = rcta.trx_number
    LEFT JOIN ipc.ipc_ar_customers_v trans_cust
        ON trans_cust.cust_account_id = rcta.bill_to_customer_id
        AND trans_cust.site_use_id = rcta.bill_to_site_use_id
    LEFT JOIN ar_cash_receipts_all acra
        ON acra.doc_sequence_value = je.transaction_reference
    LEFT JOIN  ipc.ipc_ar_customers_v receipt_cust
        ON receipt_cust.cust_account_id = acra.pay_from_customer
        AND receipt_cust.site_use_id = acra.customer_site_use_id
    LEFT JOIN ar_adjustments_all ar_adj
        ON ar_adj.doc_sequence_value = je.transaction_reference
     LEFT JOIN ra_customer_trx_all rcta_adj
        ON rcta_adj.customer_trx_id = ar_adj.customer_trx_id
      LEFT JOIN ipc.ipc_ar_customers_v adj_cust
        ON adj_cust.cust_account_id = rcta_adj.bill_to_customer_id;

select distinct JE_CATEGORY_NAME
from xla_ae_headers;
select *
from ar_cash_receipts_all;
select *
from ar_customers;

select customer_trx_id
from ar_adjustments_all
where doc_sequence_value = 92;

select *
from ra_customer_trx_all
where customer_trx_id = 1552696;

select *
from ra_customer_trx_all
where trx_number = '50100000223';

-- 320257
--23987

select *
from ipc.ipc_ar_customers_v
where cust_account_id = 320257;

SELECT hcaa.cust_account_id,
          hcaa.account_number,
          hcaa.account_name,
          hcpc.name profile_class,
          hp.party_name,
          hp.party_id,
          hzp.site_use_id,
          hcsua.site_use_code
     FROM APPS.hz_cust_accounts_all hcaa
          --                        ON soa.customer_id = hcaa.cust_account_id
          LEFT JOIN APPS.hz_customer_profiles hzp
             ON hcaa.cust_account_id = hzp.cust_account_id
          --     AND soa.customer_site_use_id = hzp.site_use_id
          LEFT JOIN APPS.hz_cust_profile_classes hcpc
             ON hzp.profile_class_id = hcpc.profile_class_id
          LEFT JOIN APPS.hz_parties hp
             ON hcaa.party_id = hp.party_id
          LEFT JOIN APPS.hz_cust_site_uses_all hcsua
             ON hcsua.site_use_id = hzp.site_use_id
where hcaa.cust_account_id = 320257;
select *
from hz_cust_accounts_all
where cust_account_id = 320257;
select *
from hz_cust_acct_sites_all;

select *
from hz_cust_site_uses_all;

select *
from ipc.ipc_ar_customers_v
where party_name = 'B.M. DOMINGO MOTOR SALES, INC.';
SELECT hcaa.cust_account_id, 
            hcaa.account_number,
            hcaa.account_name,
            hp.party_name,hcsua.cust_acct_site_id,
            hcsua.site_use_id,
            hcpc.name,
            hcp.status,
            hcpc.profile_class_id,
            hp.party_id
--            HPS.PARTY_SITE_NAME
FROM hz_cust_accounts_all hcaa
       
           
        INNER JOIN hz_parties hp
            ON hp.party_id = hcaa.party_id
        INNER JOIN hz_cust_acct_sites_all hcasa
            ON hcaa.cust_account_id = hcasa.cust_account_id
            AND hcasa.org_id = 82
        INNER JOIN hz_cust_site_uses_all hcsua
            ON hcsua.cust_acct_site_id = hcasa.cust_acct_site_id
            AND hcsua.org_id = 82
--            AND hcsua.status = 'A'
            AND hcsua.site_use_code = 'BILL_TO'
--        INNER JOIN hz_party_sites hps
--            ON hps.party_site_id = hcasa.party_site_id

 INNER JOIN hz_customer_profiles hcp
            ON hcp.site_use_id = hcsua.site_use_id
            AND hcp.status = 'A'
        INNER JOIN hz_cust_profile_classes hcpc
            ON hcpc.profile_class_id = hcp.profile_class_id
            
            
 WHERE hcaa.cust_account_id = 10085
        and hcsua.cust_acct_site_id = 5093;
        
        select *
        from hz_customer_profiles;
        select distinct site_use_id
        from  hz_customer_profiles
        ;
        select *
        from ipc.customer_tab;
        
        select *
        from hz_cust_profile_classes;
        
        select *
        from hz_party_sites;
        
        select *
        from hz_locations;
        
        SELECT *
       FROM IPC.IPC_AR_CUSTOMERS_V;
        CREATE OR REPLACE VIEW IPC.IPC_AR_CUSTOMERS_V AS 
        select hcaa.cust_account_id,
                   hcaa.account_number,
                   hcaa.account_name,
                   hcpc.name profile_class,
                   hp.party_name,
                   hp.party_id,
                   hzp.site_use_id,
                   hcsua.site_use_code
        from  APPS.hz_cust_accounts_all hcaa
--                        ON soa.customer_id = hcaa.cust_account_id
                    LEFT JOIN APPS.hz_customer_profiles hzp
                        ON     hcaa.cust_account_id = hzp.cust_account_id
                   --     AND soa.customer_site_use_id = hzp.site_use_id
                    LEFT JOIN APPS.hz_cust_profile_classes hcpc
                        ON hzp.profile_class_id = hcpc.profile_class_id
                    LEFT JOIN APPS.hz_parties hp 
                        ON hcaa.party_id = hp.party_id
                    LEFT JOIN APPS.hz_cust_site_uses_all hcsua
                        ON hcsua.site_use_id = hzp.site_use_id
              WHERE hcsua.site_use_id IS NOT NULL;
                    
                    select *
                    from hz_cust_site_uses_all;
                    
                    select *
                    from hz_customer_profiles;
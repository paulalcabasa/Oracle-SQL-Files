select cm_date,
           cm_month,
           cm_year,
           invoice_currency_code,
           invoice_no,
           gl_voucher,
           particulars,
           customer_name,
           gross_amount,
            sum(acct_35500) acct_35500,
            sum(acct_38100) acct_38100,
            sum(acct_41600) acct_41600,
            sum(acct_41800) acct_41800,
            sum(acct_63000) acct_63000,
            sum(acct_66901) acct_66901,
            sum(acct_66904) acct_66904,
            sum(acct_67502) acct_67502,
            sum(acct_85500) acct_85500,
            sum(acct_88300) acct_88300,
           cust_trx_type_id
from (SELECT rcta.trx_date cm_date,rctta.cust_trx_type_id,
            regexp_replace(to_char(rcta.trx_date, 'Month'),'[[:space:]]+') cm_month,
            to_char(rcta.trx_date, 'YYYY') cm_year,
            apsa.invoice_currency_code,
            rcta.trx_number invoice_no,
            IPC_GET_CM_GL_REF(rcta.customer_trx_id) gl_voucher,
            (select  LISTAGG(description, ', ') WITHIN GROUP (ORDER BY description ASC)   
             from ra_customer_trx_lines_all 
             where customer_trx_id = rcta.customer_trx_id
                        and line_type = 'LINE') particulars,
            cust.customer_name,
            apsa.amount_due_original gross_amount,
            (DECODE(gcc.segment6,'35500', rctld.acctd_amount, 0)) acct_35500,
            (DECODE(gcc.segment6,'38100', rctld.acctd_amount, 0)) acct_38100,
            (DECODE(gcc.segment6,'41600', rctld.acctd_amount, 0)) acct_41600,
            (DECODE(gcc.segment6,'41800', rctld.acctd_amount, 0)) acct_41800,
            (DECODE(gcc.segment6,'63000', rctld.acctd_amount, 0)) acct_63000,
            (DECODE(gcc.segment6,'66901', rctld.acctd_amount, 0)) acct_66901,
            (DECODE(gcc.segment6,'66904', rctld.acctd_amount, 0)) acct_66904,
            (DECODE(gcc.segment6,'67502', rctld.acctd_amount, 0)) acct_67502,
            (DECODE(gcc.segment6,'85500', rctld.acctd_amount, 0)) acct_85500,
            (DECODE(gcc.segment6,'88300', rctld.acctd_amount, 0)) acct_88300
FROM ra_customer_trx_all rcta
        INNER JOIN ra_cust_trx_types_all rctta
            ON rcta.cust_trx_type_id = rctta.cust_trx_type_id
            AND rcta.org_id = rctta.org_id
        INNER JOIN ra_customer_trx_lines_all rctla
            ON rctla.customer_trx_id = rcta.customer_trx_id
            and rctla.line_type = 'LINE'
        LEFT JOIN ar_payment_schedules_all apsa
            ON apsa.customer_trx_id = rcta.customer_trx_id
        INNER JOIN ar_customers cust
            ON rcta.bill_to_customer_id = cust.customer_id
        LEFT JOIN ra_cust_trx_line_gl_dist_all rctld 
            ON rctld.customer_trx_id = rctla.customer_trx_id
        INNER JOIN gl_code_combinations gcc
            ON gcc.code_combination_id = rctld.code_combination_id
WHERE 1 = 1
             AND rctta.name = 'Credit Memo'
             AND rcta.complete_flag = 'Y'
            AND regexp_replace(to_char(rcta.trx_date, 'Month'),'[[:space:]]+') = nvl(:p_month, regexp_replace(to_char(rcta.trx_date, 'Month'),'[[:space:]]+'))
            AND to_char(rcta.trx_date, 'YYYY') = :p_year
            AND rcta.trx_number = NVL(:p_invoice_no,rcta.trx_number)
--             AND TO_DATE(rcta.trx_date) between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
GROUP BY
            rcta.trx_date,
            apsa.invoice_currency_code,
            rcta.trx_number,
            rcta.customer_trx_id,
            rcta.doc_sequence_value,
            cust.customer_name,
            gcc.segment6,
            rctld.acctd_amount,
            apsa.amount_due_original,
            rctta.cust_trx_type_id
             )
GROUP BY cm_date,
           cm_month,
           cm_year,
           invoice_currency_code,
           invoice_no,
           gl_voucher,
           particulars,
           customer_name,
           cust_trx_type_id,
           gross_amount;

select *
from ra_cust_trx_types_all;

SELECT gjh.doc_sequence_value -- LISTAGG(gjh.doc_sequence_value, ', ' ) WITHIN GROUP (ORDER BY  gjh.doc_sequence_value ASC)
                        FROM xla.xla_ae_headers xah 
                                INNER JOIN xla.xla_ae_lines xal
                                    ON  xah.ae_header_id = xal.ae_header_id 
                                    AND xal.application_id = xah.application_id
                                INNER  JOIN xla.xla_transaction_entities xte
                                    ON xah.entity_id = xte.entity_id
                                    AND xte.application_id = xal.application_id
                                INNER JOIN apps.gl_import_references gir
                                    ON gir.gl_sl_link_id = xal.gl_sl_link_id
                                    AND gir.gl_sl_link_table = xal.gl_sl_link_table
                                INNER JOIN apps.gl_je_headers gjh         
                                    ON gjh.je_header_id = gir.je_header_id
            where   xte.source_id_int_1 = 921770
            group by gjh.doc_sequence_value;
            
SELECT DISTINCT gjh.doc_sequence_value, 
                                       NVL (xte.source_id_int_1, -99) source_id_int_1
                        FROM xla.xla_ae_headers xah 
                                INNER JOIN xla.xla_ae_lines xal
                                    ON  xah.ae_header_id = xal.ae_header_id 
                                    AND xal.application_id = xah.application_id
                                INNER  JOIN xla.xla_transaction_entities xte
                                    ON xah.entity_id = xte.entity_id
                                    AND xte.application_id = xal.application_id
                                INNER JOIN apps.gl_import_references gir
                                    ON gir.gl_sl_link_id = xal.gl_sl_link_id
                                    AND gir.gl_sl_link_table = xal.gl_sl_link_table
                                INNER JOIN apps.gl_je_headers gjh         
                                    ON gjh.je_header_id = gir.je_header_id
       where   xte.source_id_int_1 = 921770;
           select *
           from ra_customer_trx_all
           where trx_number = '51100000024';
          
select * 
from gl_je_headers
where description like '%51100000075%';

select *
from gl_je_headers;

             SELECT CUSTOMER_TRX_ID
             FROM AR_PAYMENT_SCHEDULES_ALL
             WHERE TRX_NUMBER = '51100000024';
             
             SELECT *
             FROM ra_cust_trx_line_gl_dist_all
             WHERE customer_trx_id = 921770;
             select *
             from ra_cust_trx_line_gl_dist_all;
             SELECT AMOUNT_DUE_ORIGINAL
             FROM AR_PAYMENT_SCHEDULES_ALL
             WHERE TRX_NUMBER = '51100000003';

select *
from ra_customer_trx_lines_all;

            
SELECT *
FROM ra_cust_trx_line_gl_dist_all;
       
SELECT rcta.trx_number invoice_number,
             rcta.trx_date invoice_date,
             rcta.interface_header_attribute1 sales_order_number,
             ooha.cust_po_number,
             apsa.amount_due_original gross,
             hp.party_name customer_name,
             hcaa.account_name,
             hcaa.account_number
FROM ra_customer_trx_all rcta
            INNER JOIN oe_order_headers_all ooha
                ON rcta.interface_header_attribute1 = ooha.order_number
            INNER JOIN ar_payment_schedules_all apsa
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
WHERE 1 = 1
              and rcta.complete_flag = 'Y'
              and rcta.trx_number like '402%';

select rcta.trx_number invoice_number,
           rcta.interface_header_attribute1 so_number,
           rctla.quantity_invoiced,
           sum(rctla.extended_amount) amount,
           msib.segment1 part_no
from ra_customer_trx_lines_all rctla 
        INNER JOIN ra_customer_trx_all rcta
            ON rcta.customer_trx_id = rctla.customer_trx_id
        INNER JOIN mtl_system_items_b msib
            ON msib.inventory_item_id = rctla.inventory_item_id
            AND rctla.warehouse_id = msib.organization_id
where 1 = 1
            and rctla.LINE_TYPE = 'LINE'
            and rcta.trx_number LIKE '402%'
            and rcta.previous_customer_trx_id is null
group by 
            rcta.trx_number ,
            rcta.interface_header_attribute1 ,
            rctla.quantity_invoiced,
            msib.segment1 ;

select cust_po_number
from oe_order_headers_all;
select *
from ra_customer_trx_all
where trx_number = '51100000007';
select distinct gjh.doc_sequence_value
from gl_je_lines gjl,
        gl_je_headers gjh
where 1 = 1
           and gjl.je_header_id = gjh.je_header_id
           and gjl.description = '51100000001';
      
select *
from ar_payment_schedules_all;


SELECT DISTINCT gjh.doc_sequence_value, NVL (xte.source_id_int_1, -99)
FROM xla.xla_ae_headers xah 
        INNER JOIN xla.xla_ae_lines xal
            ON  xah.ae_header_id = xal.ae_header_id 
            AND xal.application_id = xah.application_id
        INNER JOIN apps.gl_code_combinations glcc
            ON xal.code_combination_id = glcc.code_combination_id
        INNER  JOIN xla.xla_transaction_entities xte
            ON xah.entity_id = xte.entity_id
            AND xte.application_id = xal.application_id
        LEFT JOIN apps.gl_import_references gir
            ON gir.gl_sl_link_id = xal.gl_sl_link_id
            AND gir.gl_sl_link_table = xal.gl_sl_link_table
        LEFT JOIN apps.gl_je_lines gjl
            ON gjl.je_header_id = gir.je_header_id
            AND gjl.je_line_num = gir.je_line_num
        LEFT JOIN apps.gl_je_headers gjh         
            ON gjh.je_header_id = gjl.je_header_id
      
SELECT *
FROM ra_customer_trx_lines_all
WHERE customer_trx_id = 191407;

select num_1099
from ap_suppliers
where segment1 = '100702';




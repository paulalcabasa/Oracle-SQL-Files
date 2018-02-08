SELECT gl.doc_sequence_value gl_voucher,
            aia.doc_sequence_value ap_voucher,
            to_char(aia.invoice_date),
            aia.invoice_num,
            aia.gl_date,
            aps.segment1 supplier_id,
            aps.vendor_name supplier,
            aag.name wht_tax_code,
            aila.tax_classification_code,
            gcc.segment6 account_no,
            aida.amount,
            round(aida.amount/to_number(1||'.'||vat_rates.percentage_rate),2)  tax_base,
            round(aida.amount/to_number(1||'.'||vat_rates.percentage_rate) * (awt_rate.tax_rate/100),2) tax_amount,
            aila.attribute1 supplier_id,
            sub_brokers.vendor_name,
            sub_brokers.vat_registration_num,
            aila.attribute2 one_time_merchant,
            aila.attribute3 one_time_merchant_tin,
            aila.attribute4 one_time_merchant_address
FROM ap_invoices_all aia 
           INNER JOIN ap_invoice_lines_all aila
                ON aia.invoice_id = aila.invoice_id
           INNER JOIN ap_invoice_distributions_all aida
                ON aida.invoice_id = aia.invoice_id
                AND aila.line_number = aida.invoice_line_number
           INNER JOIN gl_code_combinations gcc
                ON gcc.code_combination_id = aida.dist_code_combination_id
           INNER JOIN ap_suppliers aps
                ON aps.vendor_id = aia.vendor_id
           LEFT JOIN ap_awt_groups aag
                ON aila.awt_group_id = aag.group_id
           LEFT JOIN ap_tax_codes_all atca
                ON atca.name = aag.name
           LEFT JOIN ap_awt_tax_rates_all awt_rate
                ON awt_rate.tax_name = aag.name
           LEFT JOIN zx_rates_b vat_rates
                ON vat_rates.tax_rate_id = aida.recovery_rate_id
                AND vat_rates.active_flag = 'Y'
                AND vat_rates.effective_to IS NULL
           LEFT JOIN ap_suppliers sub_brokers
                ON sub_brokers.segment1 = aila.attribute1
           LEFT JOIN (SELECT DISTINCT 
                                gjh.doc_sequence_value,
                                gjl.subledger_doc_sequence_value
                            FROM gl_je_lines gjl,
                                       gl_je_headers gjh
                            WHERE gjl.je_header_id = gjh.je_header_id) gl
                                ON gl.subledger_doc_sequence_value = aia.doc_sequence_value
WHERE 1 = 1
              AND aia.doc_sequence_value = '20037996'
              AND aida.amount <> 0
              AND gcc.segment6 IN ('67000','67100','67101','67102','67103','67104')
         --     AND TO_DATE(aia.gl_date) BETWEEN TO_DATE(:p_gl_date_from,'YYYY/MM/DD hh24:mi:ss') AND TO_DATE(:p_gl_date_to,'YYYY/MM/DD hh24:mi:ss');
        
;

     select *
       from zx_rates_b
       where tax_rate_id = 10264; 
SELECT gl.doc_sequence_value gl_voucher,
            aia.doc_sequence_value ap_voucher,
             to_char(aia.invoice_date) invoice_date,
             aia.invoice_num,
              aps.segment1 supplier_id,
              aps.vendor_name supplier,
              aag.name wht_tax_code,
              aila.tax_classification_code,
              tax_gcc.segment6 account_no,
              aila.amount line_amount,
              round(aila.amount/to_number(1||'.'||vat_rates.percentage_rate),2)  tax_base,
              round(aila.amount/to_number(1||'.'||vat_rates.percentage_rate) * (awt_rate.tax_rate/100),2) tax_amount,
              aila.attribute1 supplier_id,
              sub_brokers.vendor_name,
              sub_brokers.vat_registration_num,
              aila.attribute2 one_time_merchant,
              aila.attribute3 one_time_merchant_tin,
              aila.attribute4 one_time_merchant_address,
              vat_rates.percentage_rate
FROM ap_invoices_all aia
        INNER JOIN ap_invoice_lines_all aila
            ON aia.invoice_id = aila.invoice_id
        INNER JOIN gl_code_combinations tax_gcc
            ON tax_gcc.code_combination_id = aila.default_dist_ccid 
        INNER JOIN ap_suppliers aps
            ON aps.vendor_id = aia.vendor_id
        LEFT JOIN ap_awt_groups aag
            ON aila.awt_group_id = aag.group_id
     
        LEFT JOIN ap_tax_codes_all atca
            ON atca.name = aag.name

--         INNER JOIN gl_code_combinations wht_gcc
--            ON wht_gcc.code_combination_id = atca.tax_code_combination_id 
         LEFT JOIN ap_awt_tax_rates_all awt_rate
            ON awt_rate.tax_name = aag.name
         LEFT JOIN ap_suppliers sub_brokers
            ON sub_brokers.segment1 = aila.attribute1
         LEFT JOIN (SELECT DISTINCT 
                                        gjh.doc_sequence_value,
                                        gjl.subledger_doc_sequence_value
                            FROM gl_je_lines gjl,
                                       gl_je_headers gjh
                            WHERE gjl.je_header_id = gjh.je_header_id) gl
            ON gl.subledger_doc_sequence_value = aia.doc_sequence_value
          LEFT JOIN zx_rates_b vat_rates
            ON vat_rates.tax_rate_code = aila.tax_classification_code
            and vat_rates.active_flag = 'Y'
            and vat_rates.effective_to IS NULL
WHERE 1 = 1
             AND aia.doc_sequence_value = '20037996'
             AND aia.cancelled_date IS NULL
        --    AND tax_gcc.segment6 IN ('67000','67100','67101','67102','67103','67104')
--             AND AILA.LINE_TYPE_LOOKUP_CODE NOT IN ('AWT','TAX')
          --   AND TO_DATE(aia.gl_date) BETWEEN TO_DATE(:p_invoice_date_from,'YYYY/MM/DD hh24:mi:ss') AND TO_DATE(:p_invoice_date_to,'YYYY/MM/DD hh24:mi:ss');
           ;
       select *
       from ap_tax_codes_all;   
  
           select *
           from AP_INVOICE_DISTRIBUTIONS_ALL;
           select *
           from ap_tax_codes_all;
           
           select *
           from ap_invoice_lines_all aipa,
                    gl_code_combinations gcc
           where aipa.default_dist_ccid = gcc.code_combination_id
                        and gcc.segment6 = '67102';
                        
                        select *
                        from ap_invoices_all
                        where invoice_id = 68000;
                        
                        
                        create table SR_15544725181_XA
as select * from xla_events
where entity_id = 2782837 and event_id = 2834898;

update xla_events set EVENT_STATUS_CODE = 'U'
where entity_id = 2782837 and event_id = 2834898; 


select *
from SR_15544725181_XA;

select *
from xla_events 
 where entity_id = 2782837 and event_id = 2834898; 


select IPC_DECRYPT_ORA_USR_PWD(usr.encrypted_user_password)
from fnd_user usr
where user_name = '131005';
SELECT *
                FROM (SELECT usr.user_id,
                            usr.user_name,
                            ppf.first_name,
                            ppf.middle_names middle_name,
                            ppf.last_name,
                            ppf.full_name,
                            ppf.attribute2 division,
                            ppf.attribute3 department,
                            ppf.attribute4 section
                                FROM fnd_user usr LEFT JOIN per_all_people_f ppf
                                       ON usr.employee_id = ppf.person_id
                                 WHERE usr.user_name = ?
                                       AND usr.end_date IS NULL
                                       AND IPC_DECRYPT_ORA_USR_PWD(usr.encrypted_user_password) = ?
                            UNION
                            SELECT usr.user_id,
                                         usr.user_name,
                                         usr.first_name,
                                         usr.middle_name,
                                         usr.last_name,
                                         null full_name,
                                         null division,
                                         null department,
                                         null section
                            FROM IPC.IPC_FSD_USERS usr
                            WHERE usr.end_date_active IS NULL
                                         and usr.user_name = ?
                                         and usr.user_password = ?;
                                         
                                         
                                         select distinct h1.check_id, h1.accounting_event_id
from ap_payment_history_all h1,
xla_events xe
where h1.transaction_type like '%ADJUSTED'
and nvl(h1.posted_flag,'N') != 'Y'
and h1.transaction_type != 'MANUAL PAYMENT ADJUSTED'
and xe.event_id = h1.accounting_event_id
and xe.event_status_code != 'P'
and xe.application_id =200
and not exists
(select 1 from ap_invoice_distributions_all
where accounting_event_id = h1.invoice_adjustment_event_id
and line_type_lookup_code != 'AWT') ;

select *
from xla_events 
where entity_id = 2782837 and event_id = 2834898; 

    select distinct h1.check_id, h1.accounting_event_id
    from ap_payment_history_all h1,
    xla_events xe
    where h1.transaction_type like '%ADJUSTED'
    and nvl(h1.posted_flag,'N') != 'Y'
    and h1.transaction_type != 'MANUAL PAYMENT ADJUSTED'
    and xe.event_id = h1.accounting_event_id
    and xe.event_status_code != 'P'
    and xe.application_id =200
    and not exists
    (select 1 from ap_invoice_distributions_all
    where accounting_event_id = h1.invoice_adjustment_event_id
    and line_type_lookup_code != 'AWT') ;
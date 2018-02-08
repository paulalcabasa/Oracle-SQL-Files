select 
       gjh.doc_sequence_value as gl_ref_no,
       aia.doc_sequence_value as avp_voucher,
       aia.invoice_date,
       aia.invoice_num,
       aps.segment1 as supplier_id,
       aps.vendor_name as supplier,
       aag.name as tax_code,
       gcc.segment6 as account_code,
       (
       select sum(aila2.amount)
       from ap_invoice_lines_all aila2
       where line_type_lookup_code = 'ITEM'
       and aila2.invoice_id = aia.invoice_id
       and aila2.awt_group_id = aag.group_id
       ) as tax_base,
       (
           select 
           sum(amount * -1)
           from ap_invoice_lines_all
           where invoice_id = aia.invoice_id
           and  line_type_lookup_code = 'AWT'
       ) as tax_amount
from ap_invoices_all aia
left join ap_suppliers aps
on aia.vendor_id = aps.vendor_id
left join ap_invoice_distributions_all aida
on aia.invoice_id = aida.invoice_id
left join gl_code_combinations gcc
on gcc.code_combination_id = aida.dist_code_combination_id
left join ap_invoice_lines_all aila
on aia.invoice_id = aila.invoice_id
left join ap_awt_groups aag
on aila.awt_group_id = aag.group_id
left join gl_je_lines gjl
on gcc.code_combination_id = gjl.code_combination_id
and aia.doc_sequence_value = gjl.subledger_doc_sequence_value
left join gl_je_headers gjh
on gjl.je_header_id=gjh.je_header_id
where to_date(aia.invoice_date,'DD-MON-RRRR') between to_date(:p_invoice_date_from,'YYYY/MM/DD hh24:mi:ss') and to_date(:p_invoice_date_to,'YYYY/MM/DD hh24:mi:ss')
--WHERE AIA.INVOICE_ID = '133198'
and gcc.segment6 = '83302'
and cancelled_date is null
and aag.name is not null
group by aia.doc_sequence_value,
       aia.invoice_date,
       aia.invoice_num,
       aps.segment1,
       aps.vendor_name,
       aia.invoice_id,
       gcc.segment6,
       aag.name,
       aag.group_id,
       gjh.doc_sequence_value
order by aia.doc_sequence_value asc;






select *
from ap_awt_tax_rates_all;

select *
from ap_awt_tax_rates_all;

select *
from zx_taxes_b;

select *
from zx_rates_b
where tax_rate_code = 'V2(S)'
            and active_flag = 'Y'
            and effective_to IS NULL;

-- 

SELECT gl.doc_sequence_value gl_voucher,
            aia.doc_sequence_value ap_voucher,
             to_char(aia.invoice_date) invoice_date,
             aia.invoice_num,
              aps.segment1 supplier_id,
              aps.vendor_name supplier,
              aag.name wht_tax_code,
              wht_gcc.segment6 account_no,
              aila.amount line_amount,
              round(aila.amount/to_number(1||'.'||vat_rates.percentage_rate),2)  tax_base,
              round(aila.amount/to_number(1||'.'||vat_rates.percentage_rate) * (awt_rate.tax_rate/100),2) tax_amount,
              aila.attribute1 supplier_id,
              sub_brokers.vendor_name,
              sub_brokers.vat_registration_num,
              aila.attribute2 one_time_merchant,
              aila.attribute3 one_time_merchant_tin,
              aila.attribute4 one_time_merchant_address,
              aila.tax_classification_code,
              vat_rates.percentage_rate
FROM ap_invoices_all aia
        INNER JOIN ap_invoice_lines_all aila
            ON aia.invoice_id = aila.invoice_id
        INNER join ap_awt_groups aag
            ON aila.awt_group_id = aag.group_id
        INNER JOIN ap_suppliers aps
            ON aps.vendor_id = aia.vendor_id
        INNER JOIN ap_tax_codes_all atca
            ON atca.name = aag.name
         INNER JOIN gl_code_combinations wht_gcc
            ON wht_gcc.code_combination_id = atca.tax_code_combination_id 
         INNER JOIN ap_awt_tax_rates_all awt_rate
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
      --       AND aia.doc_sequence_value = '20037578'
             AND aia.cancelled_date IS NULL
             AND AILA.LINE_TYPE_LOOKUP_CODE = 'ITEM'
             AND TO_DATE(aia.invoice_date) BETWEEN TO_DATE(:p_invoice_date_from,'YYYY/MM/DD hh24:mi:ss') AND TO_DATE(:p_invoice_date_to,'YYYY/MM/DD hh24:mi:ss')
--             AND (CASE 
--                            WHEN aila.attribute1 IS NULL THEN aila.attribute2 
--                            ELSE aila.attribute1
--                      END
--                     )  IS NOT NULL;
                ;

SELECT aia.doc_sequence_value,
             aia.invoice_num,
             to_char(aia.invoice_date) invoice_date,
             to_char(aia.gl_date) gl_date,
             aia.invoice_amount,
             aps.segment1 supplier_no,
             aps.vendor_name,
             gcc.segment6 liability_account,
             aia.amount_paid,
              aia.invoice_currency_code,
              aia.payment_currency_code,
                 DECODE(AP_INVOICES_PKG.GET_POSTING_STATUS(aia.INVOICE_ID),
            'D', 'No',
            'N','No',
            'P','Partial',
            'Y','Yes') accounted,       
        DECODE(APPS.AP_INVOICES_PKG.GET_APPROVAL_STATUS(
            aia.invoice_id, 
            aia.invoice_amount,
            aia.payment_status_flag,
            aia.invoice_type_lookup_code
        ),
        'NEVER APPROVED', 'Never Validated',
        'NEEDS REAPPROVAL', 'Needs Revalidation',
        'CANCELLED', 'Cancelled',
        'Validated') status
             
FROM ap_invoices_all aia INNER JOIN ap_suppliers aps
                ON aia.vendor_id = aps.vendor_id
           LEFT JOIN gl_code_combinations gcc
                ON gcc.code_combination_id = aia.accts_pay_code_combination_id
WHERE 1 = 1
            AND aia.cancelled_date IS NULL
            AND TO_DATE(aia.gl_date) BETWEEN TO_DATE(:p_gl_date_from,'YYYY/MM/DD hh24:mi:ss') AND TO_DATE(:p_gl_date_to,'YYYY/MM/DD hh24:mi:ss');

select *
from ra_customer_trx_all
where comments = '3010021864';

-- Expanded Withholding Tax Lines

SELECT gl.doc_sequence_value gl_voucher,
            aia.doc_sequence_value ap_voucher,
             to_char(aia.invoice_date) invoice_date,
             aia.invoice_num,
              aps.segment1 supplier_id,
              aps.vendor_name supplier,
              aag.name wht_tax_code,
              wht_gcc.segment6 account_no,
              aila.amount line_amount,
              round(aila.amount/to_number(1||'.'||vat_rates.percentage_rate),2)  tax_base,
              round(aila.amount/to_number(1||'.'||vat_rates.percentage_rate) * (awt_rate.tax_rate/100),2) tax_amount,
              aila.attribute1 supplier_id,
              sub_brokers.vendor_name,
              sub_brokers.vat_registration_num,
              aila.attribute2 one_time_merchant,
              aila.attribute3 one_time_merchant_tin,
              aila.attribute4 one_time_merchant_address,
              aila.tax_classification_code,
              vat_rates.percentage_rate
FROM ap_invoices_all aia
        INNER JOIN ap_invoice_lines_all aila
            ON aia.invoice_id = aila.invoice_id
        INNER join ap_awt_groups aag
            ON aila.awt_group_id = aag.group_id
        INNER JOIN ap_suppliers aps
            ON aps.vendor_id = aia.vendor_id
        INNER JOIN ap_tax_codes_all atca
            ON atca.name = aag.name
         INNER JOIN gl_code_combinations wht_gcc
            ON wht_gcc.code_combination_id = atca.tax_code_combination_id 
         INNER JOIN ap_awt_tax_rates_all awt_rate
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
      --       AND aia.doc_sequence_value = '20037578'
             AND aia.cancelled_date IS NULL
             AND AILA.LINE_TYPE_LOOKUP_CODE NOT IN ('AWT','TAX')
             AND TO_DATE(aia.gl_date) BETWEEN TO_DATE(:p_gl_date_from,'YYYY/MM/DD hh24:mi:ss') AND TO_DATE(:p_gl_date_to,'YYYY/MM/DD hh24:mi:ss')
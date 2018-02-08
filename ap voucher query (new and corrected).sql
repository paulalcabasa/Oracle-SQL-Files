/* Formatted on 31/7/2017 8:06:23 AM (QP5 v5.163.1008.3004) */
SELECT *
  FROM ( (  SELECT -- INVOICE
                 aia.invoice_id,
                 aia.doc_sequence_value,
                 xah.accounting_date voucher_date,
                 aia.vendor_id,
                 aps.vendor_name,
                 aps.payment_currency_code,
                 aia.exchange_rate,
                 aia.invoice_num,
                 aia.invoice_amount,
                 -- ACCOUNTING ENTRIES
                 xal.ae_line_num,
                 TO_CHAR (glcc.segment6) account_no,
                 DECODE (
                    glcc.segment6,
                    '-', glcc.segment6,
                    gl_flexfields_pkg.get_description_sql (
                       glcc.chart_of_accounts_id,
                       6,
                       segment6))
                    account_name,
                 DECODE (
                    glcc.segment2,
                    '-', glcc.segment2,
                    gl_flexfields_pkg.get_description_sql (
                       glcc.chart_of_accounts_id,
                       2,
                       glcc.segment2))
                    cost_center,
                 MAX (aila.tax_classification_code) tax,
                 MAX (awt.name) wtax,
                 DECODE (
                    glcc.segment7,
                    '-', glcc.segment7,
                    gl_flexfields_pkg.get_description_sql (
                       glcc.chart_of_accounts_id,
                       2,
                       glcc.segment7))
                    model,
                 DECODE (
                    glcc.segment4,
                    '-', glcc.segment4,
                    gl_flexfields_pkg.get_description_sql (
                       glcc.chart_of_accounts_id,
                       4,
                       glcc.segment4))
                    budget_acount,
                 DECODE (
                    glcc.segment5,
                    '-', glcc.segment5,
                    gl_flexfields_pkg.get_description_sql (
                       glcc.chart_of_accounts_id,
                       5,
                       glcc.segment5))
                    budget_cost_center,
                 xal.entered_dr,
                 xal.entered_cr,
                 xal.description
            FROM xla.xla_ae_headers xah
                 INNER JOIN xla.xla_ae_lines xal
                    ON xah.ae_header_id = xal.ae_header_id
                       AND xal.application_id = xah.application_id
                 INNER JOIN apps.gl_code_combinations glcc
                    ON xal.code_combination_id = glcc.code_combination_id
                 INNER JOIN xla.xla_transaction_entities xte
                    ON xah.entity_id = xte.entity_id
                       AND xte.application_id = xal.application_id
                 INNER JOIN xla_distribution_links xdl
                    ON     xah.ae_header_id = xdl.ae_header_id
                       AND xdl.event_id = xah.event_id
                       AND xdl.ae_line_num = xal.ae_line_num
                       AND xdl.application_id = xah.application_id
                 INNER JOIN AP_PREPAY_APP_DISTS APAD
                    ON xdl.source_distribution_id_num_1 =
                          apad.prepay_app_dist_id
                 INNER JOIN ap_invoice_distributions_all aida
                    ON aida.invoice_distribution_id =
                          apad.prepay_app_distribution_id
                 INNER JOIN ap_invoices_all aia
                    ON aia.invoice_id = aida.invoice_id
                 INNER JOIN ap_invoice_lines_all aila
                    ON aila.invoice_id = aia.invoice_id
                       AND aila.line_number = aida.invoice_line_number
                 LEFT JOIN ap_awt_groups awt
                    ON aila.awt_group_id = awt.GROUP_ID
                 INNER JOIN ap_suppliers aps
                    ON aps.vendor_id = aia.vendor_id
           WHERE     1 = 1
                 AND xte.entity_code = 'AP_INVOICES'
                 AND xdl.source_distribution_type = 'AP_PREPAY'
                 AND aia.doc_sequence_value BETWEEN :p_start_voucher
                                                AND :p_end_voucher
        GROUP BY xal.ae_line_num,
                 aia.invoice_id,
                 aia.invoice_num,
                 aia.doc_sequence_value,
                 glcc.segment6,
                 xal.entered_dr,
                 xal.entered_cr,
                 glcc.chart_of_accounts_id,
                 glcc.segment2,
                 glcc.segment7,
                 glcc.segment4,
                 glcc.segment5,
                 xal.description,
                 xah.ae_header_id,
                 aia.vendor_id,
                 aps.vendor_name,
                 aps.payment_currency_code,
                 aia.exchange_rate,
                 aia.invoice_amount,
                 xah.accounting_date
          HAVING NVL (xal.entered_dr, 0) - NVL (xal.entered_cr, 0) <> 0
     ) 
UNION all
(  SELECT -- INVOICE
          aia.invoice_id,
          aia.doc_sequence_value,
          xah.accounting_date voucher_date,
          aia.vendor_id,
          aps.vendor_name,
          aps.payment_currency_code,
          aia.exchange_rate,
          aia.invoice_num,
          aia.invoice_amount,
          -- ACCOUNTING ENTRIES
          xal.ae_line_num,
          TO_CHAR (glcc.segment6) account_no,
          DECODE (
             glcc.segment6,
             '-', glcc.segment6,
             gl_flexfields_pkg.get_description_sql (glcc.chart_of_accounts_id,
                                                    6,
                                                    segment6))
             account_name,
          DECODE (
             glcc.segment2,
             '-', glcc.segment2,
             gl_flexfields_pkg.get_description_sql (glcc.chart_of_accounts_id,
                                                    2,
                                                    glcc.segment2))
             cost_center,
          MAX (aila.tax_classification_code) tax,
          MAX (awt.name) wtax,
          DECODE (
             glcc.segment7,
             '-', glcc.segment7,
             gl_flexfields_pkg.get_description_sql (glcc.chart_of_accounts_id,
                                                    2,
                                                    glcc.segment7))
             model,
          DECODE (
             glcc.segment4,
             '-', glcc.segment4,
             gl_flexfields_pkg.get_description_sql (glcc.chart_of_accounts_id,
                                                    4,
                                                    glcc.segment4))
             budget_acount,
          DECODE (
             glcc.segment5,
             '-', glcc.segment5,
             gl_flexfields_pkg.get_description_sql (glcc.chart_of_accounts_id,
                                                    5,
                                                    glcc.segment5))
             budget_cost_center,
          xal.entered_dr,
          xal.entered_cr,
          xal.description
     FROM xla.xla_ae_headers xah
          INNER JOIN xla.xla_ae_lines xal
             ON xah.ae_header_id = xal.ae_header_id
                AND xal.application_id = xah.application_id
          INNER JOIN apps.gl_code_combinations glcc
             ON xal.code_combination_id = glcc.code_combination_id
          INNER JOIN xla.xla_transaction_entities xte
             ON xah.entity_id = xte.entity_id
                AND xte.application_id = xal.application_id
          INNER JOIN xla_distribution_links xdl
             ON     xah.ae_header_id = xdl.ae_header_id
                AND xdl.event_id = xah.event_id
                AND xdl.ae_line_num = xal.ae_line_num
                AND xdl.application_id = xah.application_id
          INNER JOIN ap_invoice_distributions_all aida
             ON xdl.source_distribution_id_num_1 = aida.invoice_distribution_id
          INNER JOIN ap_invoices_all aia
             ON aia.invoice_id = aida.invoice_id
          INNER JOIN ap_invoice_lines_all aila
             ON aila.invoice_id = aia.invoice_id
                AND aila.line_number = aida.invoice_line_number
          LEFT JOIN ap_awt_groups awt
             ON aila.awt_group_id = awt.GROUP_ID
          INNER JOIN ap_suppliers aps
             ON aps.vendor_id = aia.vendor_id
    WHERE     1 = 1
          AND xte.entity_code = 'AP_INVOICES'
          AND xdl.source_distribution_type = 'AP_INV_DIST'
          AND aia.doc_sequence_value BETWEEN :p_start_voucher
                                         AND :p_end_voucher
 GROUP BY xal.ae_line_num,
          aia.invoice_id,
          aia.invoice_num,
          aia.doc_sequence_value,
          glcc.segment6,
          xal.entered_dr,
          xal.entered_cr,
          glcc.chart_of_accounts_id,
          glcc.segment2,
          glcc.segment7,
          glcc.segment4,
          glcc.segment5,
          xal.description,
          xah.ae_header_id,
          aia.vendor_id,
          aps.vendor_name,
          aps.payment_currency_code,
          aia.exchange_rate,
          aia.invoice_amount,
          xah.accounting_date
   HAVING (NVL (xal.entered_dr, 0) - NVL (xal.entered_cr, 0)) <> 0 
                ) 
 )
   ORDER BY entered_cr DESC, entered_dr DESC;


SELECT *
FROM XLA_AE_HEADERS
WHERE DOC_SEQUENCE_VALUE = '20034017';

select *
from xla_ae_headers
where description like 'Prepayment Applied , Invoice Number: PC-1706-00471A LIQ , Date: 28-JUL-17 , Document Sequence Category: STD INV , Document Sequence Name: AP Voucher , Invoice Voucher Number: 20034017 , Invoice Description: PC-1706-00471/TRANSPO ALLOWANCE FOR ISEAP PARTICIPANTS/TDL 7/27/17';

SELECT *
FROM XLA_AE_LINES XLA,
            GL_CODE_COMBINATIONS GCC
WHERE 1 = 1
              AND XLA.AE_HEADER_ID = 13863343;
-- end of invoices correct 2X


select 
        aia.doc_sequence_value,
        aia.invoice_id,
       aila.line_number, 
       aila.attribute1 Sup_ID, 
        case when AILA.ATTRIBUTE1 is null then null
                else
                    case when AILA.ATTRIBUTE2 is null then
                          aps.vendor_name
                         else
                          AILA.ATTRIBUTE2
                    end
        end  DFF_SUP_NAME,
        case when AILA.ATTRIBUTE1 is null then null
        else
            case when AILA.ATTRIBUTE3 is null then
                   aps.vat_registration_num
                 --assa.vat_registration_num
                 else AILA.ATTRIBUTE3
            end 
        end DFF_TIN,
        case when AILA.ATTRIBUTE1 is null then
        null
        else
            case when AILA.ATTRIBUTE4 is null then
                   ASSA.ADDRESS_LINE1 || ' ' || ASSA.ADDRESS_LINE2
                 else AILA.ATTRIBUTE4
            end 
        END    DFF_ADDRESS,
       case when aila.tax_classification_code in ('V2(S)','V2(OCG)','V2(IMP)') THEN 
               round((aila.amount)/ 1.12, 2)
               else aila.amount
       end amount,
       aila.tax_classification_code vat_code,
       case when aila.tax_classification_code in ('V2(S)','V2(OCG)','V2(IMP)') THEN 
               round(((aila.amount)/ 1.12)* 0.12, 2)
               when aila.tax_classification_code IN ('V0(VE)') THEN 0
               ELSE round(aila.amount * 0.12, 2)
       end vat_amount,
       awt.name invoice_witholding_tax_group,
       case when aila.tax_classification_code in ('V2(S)','V2(OCG)','V2(IMP)') THEN 
               round(((aila.amount)/ 1.12)* (awtra.tax_rate / 100), 2)
               else
            round(aila.amount * (awtra.tax_rate / 100), 2)
       end w_amount
from ap_invoice_lines_all aila,
     ap_invoices_all aia,
     ap_awt_groups awt,
     ap_suppliers aps,
     ap_supplier_sites_all assa,
     AP_AWT_TAX_RATES_all awtra
where aila.invoice_id = aia.invoice_id
and awt.group_id(+) = aila.awt_group_id
and aps.segment1(+) = aila.attribute1
and aps.vendor_id = assa.vendor_id(+)
and awt.name = awtra.tax_name
and aila.attribute1 is not null
and aia.doc_sequence_value = :DOC_SEQUENCE_VALUE;
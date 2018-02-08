/* Formatted on 28/9/2017 9:50:34 AM (QP5 v5.163.1008.3004) */
SELECT MOD (ROWNUM, 2) MOD,
       ai.invoice_id,
       ac.BANK_ACCOUNT_NAME,
       ai.invoice_id,
       (SELECT DISTINCT cbb1.BANK_NAME
          FROM ap_checks_all ac1,
               ce_bank_accounts cba1,
               ce_bank_acct_uses_all cbau1,
               ce_bank_branches_v cbb1
         WHERE     ac1.ce_bank_acct_use_id = cbau1.bank_acct_use_id
               AND cbau1.bank_account_id = cba1.bank_account_id
               AND cbb1.BANK_PARTY_ID = cba1.BANK_ID
               AND ac.check_id = ac1.check_id)
          bank_name--,SYSDATE
       ,
       AC.DOC_SEQUENCE_VALUE Voucher_num,
       AC.CHECK_date,
       AI.INVOICE_DATE,
       AC.CHECK_NUMBER,
       ai.PAYMENT_CURRENCY_CODE CUR_CODE,
       AI.INVOICE_AMOUNT,
       (SELECT SUM (AIL2.AMOUNT)
          FROM ap_invoices_all ai2, AP_INVOICE_LINES_ALL ail2
         WHERE     ai2.invoice_id = ail2.invoice_id
               AND ail2.line_type_lookup_code = 'AWT'
               AND AI2.INVOICE_ID = ai.invoice_id)
          AWT_TAX,
       DECODE (ai.total_TAX_AMOUNT, 0, NULL, ai.total_TAX_AMOUNT) TOT_TAX,
       AIP.AMOUNT pay_amount,
       (SELECT SUM (a1.AMOUNT)
          FROM ap_invoice_payments_all A1,
               ap_invoices_all B1,
               ap_checks_all C1
         WHERE     A1.invoice_id = B1.invoice_id
               AND A1.check_id = C1.check_id
               AND C1.CHECK_NUMBER = AC.CHECK_NUMBER
               AND C1.DOC_SEQUENCE_VALUE = AC.DOC_SEQUENCE_VALUE)
          TOTAL,
       AC.VENDOR_NAME,
       AI.INVOICE_NUM
  FROM ap_invoice_payments_all aip,
       ap_invoices_all ai,
       ap_checks_all ac,
       iby_payment_methods_vl iby
 WHERE     aip.invoice_id = ai.invoice_id
       AND aip.check_id = ac.check_id
       AND iby.payment_method_code = ac.payment_method_code
       AND AC.DOC_SEQUENCE_VALUE = NVL (:p_voucher, AC.DOC_SEQUENCE_VALUE)
-- and AC.CHECK_NUMBER between :p_check_from and :p_check_to
--and ac.check_number = :p_check
--and ai.AWT_FLAG = 'Y'
--AND AC.CHECK_NUMBER = 24254;
;

SELECT MOD (ROWNUM, 2) MOD,
            a.*
FROM (SELECT  
             -- CHECK DETAILS
             aca.doc_sequence_value,
             aca.check_date,
             cbb.bank_name,
             aca.amount check_amount,
             aca.vendor_name,
             aca.currency_code,
             aca.check_number,
             -- INVOICE DETAILS
             aia.invoice_num,
             aia.invoice_amount,
             nvl(aia.total_tax_amount,0) vat,
             sum(CASE WHEN aila.line_type_lookup_code = 'AWT' THEN aila.amount ELSE 0 END) awt_tax,
             aipa.amount pay_amount
FROM ap_checks_all aca
           -- BANK
           INNER JOIN ce_bank_acct_uses_all cbaua
                ON aca.ce_bank_acct_use_id = cbaua.bank_acct_use_id
           INNER JOIN ce_bank_accounts cba
                ON cba.bank_account_id = cbaua.bank_account_id
           INNER JOIN ce_bank_branches_v cbb
                ON cbb.bank_party_id = cba.bank_id
           -- INVOICES
           INNER JOIN ap_invoice_payments_all aipa
                ON aipa.check_id = aca.check_id
           INNER JOIN ap_invoices_all aia
                ON aia.invoice_id = aipa.invoice_id
           INNER JOIN ap_invoice_lines_all aila
                ON aila.invoice_id = aia.invoice_id
WHERE 1 = 1
--             AND aca.doc_sequence_value = '30005259'
              AND aca.doc_sequence_value BETWEEN  nvl(:p_voucher_from, aca.doc_sequence_value) AND nvl(:p_voucher_to, aca.doc_sequence_value)
GROUP BY
            aca.doc_sequence_value,
             aca.check_date,
             cbb.bank_name,
             aca.amount,
             aca.vendor_name,
             aca.currency_code,
             aca.check_number,
             -- INVOICE DETAILS
             aia.invoice_num,
             aia.invoice_amount,
             aia.total_tax_amount,
             aipa.amount) a;
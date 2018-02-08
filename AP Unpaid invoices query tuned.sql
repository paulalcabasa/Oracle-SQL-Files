SELECT doc_sequence_value, 
       gl_date, 
       creation_date, 
       supplier_id, 
       supplier_name, 
       invoice_num, 
       invoice_date, 
       invoice_amount, 
       total_invoice_amount, 
       paid_amount, 
       total_invoice_amount - paid_amount balance, 
       invoice_currency_code, 
       exchange_rate, 
       goods_received_date, 
       terms_date, 
       name terms, 
       due_date, 
       status, 
       approval_status, 
       created_by, 
       created_by_name, 
       liability_account 
  FROM (SELECT /*+ INDEX_JOIN(APS) */ aia.doc_sequence_value, 
               TO_CHAR(aia.gl_date) gl_date, 
               TO_CHAR(aia.creation_date) creation_date, 
               aps.segment1 supplier_id, 
               aps.vendor_name supplier_name, 
               aia.invoice_num, 
               TO_CHAR(aia.invoice_date) invoice_date, 
               aia.invoice_amount, 
               APPS.IPC_GET_TOTAL_INVOICE_AMOUNT(aia.invoice_id) total_invoice_amount, 
               aia.invoice_currency_code, 
               aia.exchange_rate, 
               TO_CHAR(aia.goods_received_date) goods_received_date, 
               TO_CHAR(aia.terms_date) terms_date, 
               TO_CHAR(aia.terms_date + atl.due_days) due_date, 
               apt.name, 
               DECODE(AP_INVOICES_PKG.GET_POSTING_STATUS(aia.INVOICE_ID), 'D', 'No', 'N', 'No', 'P', 'Partial', 'Y', 'Yes') accounted, 
               DECODE(APPS.AP_INVOICES_PKG.GET_APPROVAL_STATUS(aia.invoice_id, aia.invoice_amount, aia.payment_status_flag, aia.invoice_type_lookup_code), 'NEVER APPROVED', 'Never Validated', 'NEEDS REAPPROVAL', 'Needs Revalidation', 'CANCELLED', 'Cancelled', 'Validated') status, 
               aia.wfapproval_status approval_status, 
               aia.created_by, 
               ppf.full_name created_by_name, 
               gcc.segment6 liability_account, 
               payments.paid_amount 
          FROM ap_invoices_all aia 
               INNER JOIN ap_suppliers aps 
                  ON aia.vendor_id = aps.vendor_id 
               INNER JOIN ap_terms_tl apt 
                  ON apt.term_id = aia.terms_id 
               INNER JOIN ap_terms_lines atl 
                  ON atl.term_id = apt.term_id 
                     AND atl.due_percent = 100 
               LEFT JOIN fnd_user fu 
                 ON fu.user_id = aia.created_by 
               LEFT JOIN per_people_f ppf 
                 ON ppf.employee_number = fu.user_name 
               LEFT JOIN gl_code_combinations_kfv gcc 
                 ON gcc.code_combination_id = aia.accts_pay_code_combination_id 
               LEFT JOIN (SELECT aipa.invoice_id, 
                                 SUM(NVL(aipa.amount, 0)) paid_amount 
                            FROM ap_invoice_payments_all aipa, 
                                 ap_checks_all aca 
                           WHERE aca.status_lookup_code <> 'VOIDED' 
                             AND aca.check_id = aipa.check_id 
                           GROUP BY aipa.invoice_id) payments 
                 ON payments.invoice_id = aia.invoice_id 
         WHERE aia.cancelled_date IS NULL) 
 WHERE 1 = 1 
   AND paid_amount <> total_invoice_amount 
   AND supplier_id = NVL(:p_supplier_id, supplier_id) 
   AND invoice_currency_code = NVL(:p_invoice_currency, invoice_currency_code) 
   AND TO_DATE(due_date) <= NVL(TO_DATE(:p_due_date, 'YYYY/MM/DD HH24:MI:SS'), TO_DATE(due_date))

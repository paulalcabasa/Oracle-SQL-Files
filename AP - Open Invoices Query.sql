SELECT distinct ooha.order_number,
            oola.attribute10 dr_number,
            rcta.trx_number invoice_number
FROM oe_order_lines_all oola,
          oe_order_headers_all ooha,
          ra_customer_trx_all rcta
WHERE 1 = 1
            and oola.header_id = ooha.header_id
            and to_char(rcta.interface_header_attribute1) = to_char(ooha.order_number)
            and oola.attribute10 IN ('31200001661',
                                               '31200001662',
                                               '31200001663',
                                               '31200001664',
                                               '31200001665',
                                               '31200001684',
                                               '31200001690',
                                               '31200001677',
                                               '31200002128',
                                               '31200001922',
                                               '31200001884',
                                               '31200001847',
                                               '31200002308',
                                               '31200002311',
                                               '31200002485')
ORDER BY oola.attribute10 ASC;

SELECT b.segment1 "Supplier No",
       b.vendor_name "Supplier Name",
       c.vendor_site_code,
       c.pay_group_lookup_code,
       a.invoice_num invoice_number,
       a.invoice_date,
       a.gl_date,
       d.due_date,
       a.invoice_currency_code,
       a.invoice_amount,
       a.amount_paid,
       a.pay_group_lookup_code,
       d.payment_priority,
       (SELECT MAX (check_date)
          FROM ap_checks_all aca, ap_invoice_payments_all aip
         WHERE aca.CHECK_ID = aip.CHECK_ID AND aip.invoice_id = a.invoice_id)
          "Last Payment Made on",
          a.cancelled_date
  FROM apps.ap_invoices_all a,
       apps.ap_suppliers b,
       apps.ap_supplier_sites_all c,
       apps.ap_payment_schedules_all d,
       apps.ap_invoice_payments_all ap,
       ap_checks_all ac
WHERE     a.vendor_id = b.vendor_id
       AND a.vendor_site_id = c.vendor_site_id
       AND b.vendor_id = c.vendor_id
       AND a.invoice_id = d.invoice_id(+)
       AND ap.invoice_id = a.invoice_id(+)
       AND ac.CHECK_ID = ap.CHECK_ID
       and ac.STATUS_LOOKUP_CODE <> 'VOIDED'
 --      and   a.amount_paid = 0;
   --    AND a.org_id = 89
 --      and a.invoice_id= 1234
   --    AND a.pay_group_lookup_code IN ('DISTRIBUTOR')
   --    AND ac.check_date BETWEEN TO_DATE ('01-Apr-2014', 'DD-MON-YYYY') AND TO_DATE ('30-Jun-2014 23:59:59', 'DD-MON-YYYY HH24:MI:SS')
   ;
   select aps.segment1 "Supplier No",
            aps.vendor_name "Supplier Name",
            aia.doc_sequence_value "AP Voucher Number",
            aia.invoice_num "Invoice Reference",
            (aia.invoice_amount - aia.amount_paid) *  nvl(aia.exchange_rate,1) "Amount",
            to_char(aia.gl_date) "GL Date",
            aia.invoice_currency_code "Currency",
            nvl(aia.exchange_rate,1) "Currency Rate",
            (aia.invoice_amount - aia.amount_paid)  "Currency Amount",
            aia.ACCTS_PAY_CODE_COMBINATION_ID,
             (select segment6 from gl_code_combinations_kfv where CODE_COMBINATION_ID = aia.ACCTS_PAY_CODE_COMBINATION_ID) "AP Account"
   from ap_invoices_all aia,
           ap_suppliers aps
   where 1 = 1
             and aia.vendor_id = aps.vendor_id
             and aia.invoice_amount > aia.amount_paid
             and aia.accts_pay_code_combination_id = (CASE WHEN lower(:P_AP_GROUP) = 'all' THEN aia.accts_pay_code_combination_id ELSE TO_NUMBER(:P_AP_GROUP) end)
            ; 
            -- 1018 25073
            SELECT (CASE WHEN :P_AP_GROUP = 'all' THEN 1 ELSE :P_AP_GROUP  end)
            FROM DUAL;
            
            
select   aps.segment1 "Supplier No",
            aps.vendor_name "Supplier Name",
            aia.doc_sequence_value "AP Voucher Number",
            aia.invoice_num "Invoice Reference",
            (aia.invoice_amount - aia.amount_paid) *  nvl(aia.exchange_rate,1) "Amount",
            to_char(aia.gl_date) "GL Date",
            aia.invoice_currency_code "Currency",
            nvl(aia.exchange_rate,1) "Currency Rate",
            (aia.invoice_amount - aia.amount_paid)  "Currency Amount",
            (select segment6 from gl_code_combinations_kfv where CODE_COMBINATION_ID = aia.ACCTS_PAY_CODE_COMBINATION_ID) "AP Account"
from ap_invoices_all aia,
        ap_suppliers aps
where 1 = 1
         and aia.vendor_id = aps.vendor_id
         and aia.invoice_amount > aia.amount_paid
         and aia.invoice_date <= to_date(:P_AS_OF, 'YYYY/MM/DD HH24:MI:SS') 
         and aia.accts_pay_code_combination_id = (CASE WHEN lower(:P_AP_GROUP) = 'all' THEN aia.accts_pay_code_combination_id ELSE TO_NUMBER(:P_AP_GROUP) end);
             
     select *
     from dbs_pc;
         
select *
from dbs_picklist_interface
where request_number = '1230928';
from ap_invoices_all aia;

SELECT i.invoice_id,
            i.doc_sequence_value,
            i.invoice_num,
            i.invoice_amount,
            i.wfapproval_status,
            i.invoice_date,
            DECODE(AP_INVOICES_PKG.GET_POSTING_STATUS(i.INVOICE_ID),
            'D', 'No',
            'N','No',
            'Y','Yes') accounted ,
            DECODE(APPS.AP_INVOICES_PKG.GET_APPROVAL_STATUS(
                            i.invoice_id, 
                            i.invoice_amount,
                            i.payment_status_flag,
                            i.invoice_type_lookup_code
                         ),
           'NEVER APPROVED', 'Never Validated',
           'NEEDS REAPPROVAL', 'Needs Revalidation',
           'CANCELLED', 'Cancelled',
           'Validated') invoice_status
  FROM ap_invoices_all i
  where 1 = 1;      --      and i.invoice_date   between '01-MAY-2017' AND '31-MAY-2017'

     --   and i.doc_sequence_value NOT IN (select voucher_num from AP_SELECTED_INVOICES_ALL)
     --   and AP_INVOICES_PKG.GET_POSTING_STATUS(i.INVOICE_ID) = 'N'
        ;AND APPS.AP_INVOICES_PKG.GET_APPROVAL_STATUS(
                            i.invoice_id, 
                            i.invoice_amount,
                            i.payment_status_flag,
                            i.invoice_type_lookup_code
                         ) NOT IN ('NEVER APPROVED',
                           'NEEDS REAPPROVAL',
                           'CANCELLED');
    
  select *
  from AP_SELECTED_INVOICES_ALL;
  
 select *
 from ap_invoices_all;
 
  select *
  from ap_invoices_all
  where doc_sequence_value = '20001509';
       --     AND i.doc_sequence_value = '100000072';
  -- D - ACCOUNTED NO N  
  select *
  from EXPORT_TABLE;
  select *
  from ap_invoices_all
  where AP_INVOICES_PKG.GET_POSTING_STATUS(INVOICE_ID) = 'Y';
  
  
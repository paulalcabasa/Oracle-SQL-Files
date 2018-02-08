
select gcck.segment6,aida.*
from AP_INVOICE_DISTRIBUTIONS_ALL aida
      ,gl_code_combinations_kfv gcck
      ,ap_invoice_lines_all aila
where 1 = 1 
--and aida.recovery_rate_name is not null
and aida.dist_code_combination_id = gcck.code_combination_id
and gcck.segment6 in ('67000','67100','67101','67102','67104','67103','67105')
and aida.invoice_id = aila.invoice_id
and aida.invoice_id = 73850;


select aila.line_number,
         gcck.segment6 Account
         ,aila.invoice_id
         ,aia.doc_sequence_value
       ,aia.gl_date
         ,CONCAT(REGEXP_REPLACE (TO_CHAR (to_date(aia.gl_date,'DD-MON-RRRR' ) , ''),
                               '[[:space:]]',
                                 ''),
        to_char(to_date(aia.gl_date,'DD-MON-RRRR'),  'YYYY' )
            ) year
         ,CONCAT(REGEXP_REPLACE (TO_CHAR (to_date(aia.gl_date,'DD-MON-RRRR' ) , ''),
                               '[[:space:]]',
                                 ''),
        to_char(to_date(aia.gl_date,'DD-MON-RRRR'),  'MM' )
            ) period
       ,aia.invoice_date
         ,aia.invoice_num
         ,aps.segment1 supplier_id
         ,aps.vendor_name supplier_name 
--       ,(select max(tax_classification_code)
--                      from ap_invoice_lines_all
--                      where line_type_lookup_code = 'ITEM'
--                      and invoice_id = aila.invoice_id) tax_code
--       ,aila.tax_classification_code tax_code
   
        ,aida.withholding_tax_code_id
        ,aida.tax_code_id
        ,aida.vat_code
         ,RTRIM(aida.recovery_rate_name,'R') tax_code
         ,AIDA.AMOUNT tax_amount
         ,AIDA.AMOUNT * .12 net_purchase_amt
         ,(CASE WHEN ACA.BANK_ACCOUNT_NAME LIKE '%-%' 
           THEN SUBSTR(ACA.BANK_ACCOUNT_NAME,0, instr(ACA.BANK_ACCOUNT_NAME,'-' )-1) ELSE ACA.BANK_ACCOUNT_NAME END)||'-'||ACA.CHECK_NUMBER BANK_CHECKREF
         ,TO_CHAR(CHECK_DATE,'MM/DD/YYYY') CHECK_DATE
         ,aila.attribute1 dff_supplier_id
                        ,case when AILA.ATTRIBUTE1 is null then
                        null
                        else
                              case when AILA.ATTRIBUTE2 is null then
                                    (
                                    select max(
                                    vendor_name)
                                    from ap_suppliers
                                    where segment1 = AILA.ATTRIBUTE1
                                    )
                                    else
                                    AILA.ATTRIBUTE2
                              end
                        end  DFF_SUPPLIER_NAME
                        ,case when AILA.ATTRIBUTE1 is null then
                        null
                        else
                              case when AILA.ATTRIBUTE3 is null then
                                    (
                                    select max(
                                    vat_registration_num)
                                    from ap_suppliers
                                    where segment1 = AILA.ATTRIBUTE1
                                    )                                  --assa.vat_registration_num
                                    else AILA.ATTRIBUTE3
                              end 
                        end DFF_TIN
                        ,case when AILA.ATTRIBUTE1 is null then
                        null
                        else
                              case when AILA.ATTRIBUTE4 is null then
                                    (
                                    select max(
                                    ASSA2.ADDRESS_LINE1 || ' ' || ASSA2.ADDRESS_LINE2)
                                    from ap_suppliers aps2
                                           ,ap_supplier_sites_all assa2
                                    where aps2.vendor_id = assa2.vendor_id
                                    and aps2.segment1 = AILA.ATTRIBUTE1
                                    )
                                    --ASSA.ADDRESS_LINE1 || ' ' || ASSA.ADDRESS_LINE2 
                                     else AILA.ATTRIBUTE4
                              end 
                        END   DFF_ADDRESS
from AP_INVOICE_DISTRIBUTIONS_ALL aida
     ,gl_code_combinations_kfv gcck
     ,ap_invoice_lines_all aila
      ,ap_invoices_all AIA
      ,ap_suppliers APS
      ,ap_invoice_payments_all AIPA
     ,ap_checks_all ACA
      ,ap_supplier_sites_all ASSA
where 1 = 1 
--and aida.recovery_rate_name is not null
and aida.dist_code_combination_id = gcck.code_combination_id
and gcck.segment6 in ('67000','67100','67101','67102','67104','67103','67105')
and aida.invoice_id = aila.invoice_id
and aila.line_number = aida.invoice_line_number
and aila.invoice_id = aia.invoice_id
and aps.vendor_id = aia.vendor_id
and aia.invoice_id = aipa.invoice_id(+)
and aipa.check_id = aca.check_id(+)
and aps.vendor_id = assa.vendor_id(+)
-- and aia.gl_date between to_date(substr(:p_gl_from, 1, 10), 'YYYY/MM/DD hh24:mi:ss') and to_date(substr(:p_gl_to, 1, 10), 'YYYY/MM/DD hh24:mi:ss')
--and aida.invoice_id = 73850;
and aia.doc_sequence_value = 20021461
order by aia.doc_sequence_value, aia.gl_date;


-- AWT 
-- TAX

SELECT hou.organization_id,
       hou.NAME,
       (select segment6 from gl_code_combinations_kfv where code_combination_id = tax_account_ccid) tax_account,
       tax_account_ccid,
       zxr.tax,
       zxr.tax_status_code,
       zxr.tax_regime_code,
       zxr.tax_rate_code,
       zxr.tax_jurisdiction_code,
       zxr.rate_type_code,
       zxr.percentage_rate,
       zxr.tax_rate_id,
       zxr.effective_from,
       zxr.effective_to,
       zxr.active_flag
  FROM zx_rates_vl        zxr,
       zx_accounts        b,
      hr_operating_units hou
WHERE b.internal_organization_id = hou.organization_id
   AND b.tax_account_entity_code = 'RATES'
   AND b.tax_account_entity_id = zxr.tax_rate_id
   AND zxr.active_flag = 'Y'
   and  tax_account_ccid = 1023
--   and  zxr.tax_rate_code LIKE 'V2%'
   AND SYSDATE BETWEEN zxr.effective_from AND nvl(zxr.effective_to, SYSDATE);

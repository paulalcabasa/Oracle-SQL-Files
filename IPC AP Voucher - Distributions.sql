SELECT * 
FROM ((
            SELECT distinct
                    1 line_number,
                    gcc.segment6 account_no,
                    gl_flexfields_pkg.get_description_sql (
                        chart_of_accounts_id,--- chart of account id
                        6,----- Position of segment
                        gcc.segment6 --- Segment value
                    ) account_name,
                    case when gcc.segment2 || ' ' || gl_flexfields_pkg.get_description_sql(chart_of_accounts_id,2,gcc.segment2) = '- Default' then
                    null
                    else
                    gcc.segment2 || ' ' || gl_flexfields_pkg.get_description_sql(chart_of_accounts_id,2,gcc.segment2)
                    end cost_center,
                    null tax_classification_code,
                    --null employee,
                    gcc.segment7 model,
                    aps.vendor_name,
                    aps.segment1 supplier_no,
                    gcc.segment4 budget_account,
                    gcc.segment5 budget_cost_center,        
                    null debit,
                    (SELECT SUM(AMOUNT)
                    FROM AP_INVOICE_DISTRIBUTIONS_ALL
                    WHERE INVOICE_ID = aia.invoice_id) credit,
                    aia.invoice_num,
                    null invoice_witholding_tax_group,
                    aia.doc_sequence_value,
                    aia.gl_date,
                    aia.invoice_date,
                    aia.description,
                    org.name,
                    org.organization_id,
                    null tax_code,
                    aia.PAYMENT_CURRENCY_CODE,
                    aia.EXCHANGE_RATE,
                    aia.INVOICE_AMOUNT,
           CASE 
                WHEN gcc.segment6 IN ('83300','83301','83302','83303','83304','83314') THEN 1
                WHEN gcc.segment6 IN ('67000','67100','67101','67102','67103','67104','67105') THEN 2
                ELSE 3
            END position
        FROM ap_invoices_all aia,
                 gl_code_combinations gcc,
                 ap_suppliers aps ,
                 hr_all_organization_units org,
             ap_invoice_lines_all aila
        WHERE 1 = 1
                    AND gcc.code_combination_id = aia.ACCTS_PAY_CODE_COMBINATION_ID
                    AND aps.vendor_id = aia.vendor_id
                    AND org.organization_id = aia.org_id
                   AND aila.invoice_id = aia.invoice_id
--------------------
                  and aia.doc_sequence_value BETWEEN :P_APV_NO1 AND :P_APV_NO2
---------------------
    )
    UNION all
    (SELECT --  aila.line_number,
                rownum line_number,
                gcc.segment6 account_no,
                gl_flexfields_pkg.get_description_sql (
                    chart_of_accounts_id,--- chart of account id
                    6,----- Position of segment
                    gcc.segment6 --- Segment value
                ) account_name,
--                 CASE WHEN
--                 CASE 
--                     WHEN aida.line_type_lookup_code = 'REC_TAX' THEN  aida.vat_code--aila.tax_classification_code
--                     WHEN aida.line_type_lookup_code = 'NONREC_TAX' THEN awt.name
--                     WHEN aida.line_type_lookup_code = 'ACCRUAL' THEN awt.name
--                     WHEN aida.line_type_lookup_code = 'FREIGHT' THEN gcc.segment2 || ' ' || gl_flexfields_pkg.get_description_sql(chart_of_accounts_id,2,gcc.segment2)  
--                     ELSE gcc.segment2 || ' ' || gl_flexfields_pkg.get_description_sql(chart_of_accounts_id,2,gcc.segment2)  
--                 END = '- Default' then 
--                 null
--                 else
--                 CASE 
--                     WHEN aida.line_type_lookup_code = 'REC_TAX' THEN  aida.vat_code--aila.tax_classification_code
--                     WHEN aida.line_type_lookup_code = 'NONREC_TAX' THEN awt.name
--                     WHEN aida.line_type_lookup_code = 'ACCRUAL' THEN awt.name
--                     WHEN aida.line_type_lookup_code = 'FREIGHT' THEN gcc.segment2 || ' ' || gl_flexfields_pkg.get_description_sql(chart_of_accounts_id,2,gcc.segment2)  
--                     ELSE gcc.segment2 || ' ' || gl_flexfields_pkg.get_description_sql(chart_of_accounts_id,2,gcc.segment2)  
--                 END 
--                 end cost_center, 
                case when gcc.segment2 || ' ' || gl_flexfields_pkg.get_description_sql(chart_of_accounts_id,2,gcc.segment2) = '- Default' then
                    null
                    else
                    gcc.segment2 || ' ' || gl_flexfields_pkg.get_description_sql(chart_of_accounts_id,2,gcc.segment2)
                end cost_center,
                aila.tax_classification_code,
                --employees.FULL_NAME employee,
                gcc.segment7 model,
                sub_sup.vendor_name,
                aps.segment1 supplier_no,
                gcc.segment4 budget_account,
                gcc.segment5 budget_cost_center,
                CASE 
                    WHEN aida.amount > 0 THEN abs(aida.amount)
                    ELSE null
                END debit,
                CASE 
                    WHEN aida.amount < 0 THEN abs(aida.amount)
                    ELSE null
                END credit,
                aia.invoice_num,
                awt.name invoice_witholding_tax_group,
                aia.doc_sequence_value,     
                aia.gl_date,
                aia.invoice_date,          
                aida.description,
                org.name,
                org.organization_id,                
                SUBSTR(aida.RECOVERY_RATE_NAME,1,LENGTH(aida.RECOVERY_RATE_NAME) - 1) tax_code,
                null PAYMENT_CURRENCY_CODE,
                null EXCHANGE_RATE,
                null INVOICE_AMOUNT,
                CASE 
                    WHEN gcc.segment6 IN ('83300','83301','83302','83303','83304','83314') THEN 1
                    WHEN gcc.segment6 IN ('67000','67100','67101','67102','67103','67104','67105') THEN 2
                    ELSE 3
                END position
    FROM AP_INVOICE_DISTRIBUTIONS_ALL aida,
             ap_invoices_all aia,
             ap_supplier_sites_all assa,
             ap_invoice_lines_all aila,
             ap_suppliers aps,
             gl_code_combinations gcc,
             hr_all_organization_units org,
             ap_awt_groups awt,
             ap_suppliers sub_sup,
             PER_PEOPLE_V7 employees
    WHERE 1 = 1
                AND aida.invoice_id = aia.invoice_id
                AND assa.vendor_site_id = aia.vendor_site_id
                AND aps.vendor_id = aia.vendor_id
                AND gcc.code_combination_id = aida.DIST_CODE_COMBINATION_ID
                AND org.organization_id = aia.org_id
                AND aila.invoice_id = aia.invoice_id
                AND aila.attribute1 = sub_sup.segment1(+)
                AND aila.line_number = aida.INVOICE_LINE_NUMBER
                AND awt.group_id(+) = aila.awt_group_id
                AND employees.employee_number(+) = aila.attribute5
                AND aida.amount <> 0 
-----------------------------------
and aia.doc_sequence_value BETWEEN :P_APV_NO1 AND :P_APV_NO2
-----------------------------------
                )
             )
-- where doc_sequence_value BETWEEN :P_APV_NO1 AND :P_APV_NO2
ORDER BY position;


select distinct
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
and aila.attribute1 is not null

and aia.doc_sequence_value = :DOC_SEQUENCE_VALUE;
SELECT * 
FROM ((
            SELECT 
                    rownum line_number,
                    gcc.segment6 account_no,
                    gl_flexfields_pkg.get_description_sql (
                        chart_of_accounts_id,--- chart of account id
                        6,----- Position of segment
                        gcc.segment6 --- Segment value
                    ) account_name,
                    gcc.segment2 || ' ' || gl_flexfields_pkg.get_description_sql(chart_of_accounts_id,2,gcc.segment2) cost_center,
                    gcc.segment3 employee,
                    gcc.segment7 model,
                    aps.segment1 supplier_no,
                    gcc.segment4 budget_account,
                    gcc.segment5 budget_cost_center,        
                    0 debit,
                    (SELECT SUM(AMOUNT)
                    FROM AP_INVOICE_DISTRIBUTIONS_ALL
                    WHERE INVOICE_ID = aia.invoice_id) credit,
                    aia.invoice_num,
                    null invoice_witholding_tax_group,
                    aia.doc_sequence_value,
                    aia.gl_date,
                    aia.invoice_date,
                    aps.vendor_name,
                    aia.description,
                    org.name,
                    org.organization_id                              
        FROM ap_invoices_all aia,
                 gl_code_combinations gcc,
                 ap_suppliers aps ,
                 hr_all_organization_units org
        WHERE 1 = 1
                    AND gcc.code_combination_id = aia.ACCTS_PAY_CODE_COMBINATION_ID
                    AND aps.vendor_id = aia.vendor_id
                    AND org.organization_id = aia.org_id
    )
    UNION
    (SELECT -- aila.line_number,
                rownum line_number,
                gcc.segment6 account_no,
                gl_flexfields_pkg.get_description_sql (
                    chart_of_accounts_id,--- chart of account id
                    6,----- Position of segment
                    gcc.segment6 --- Segment value
                ) account_name,
                CASE 
                    WHEN aida.line_type_lookup_code = 'REC_TAX' THEN  aida.vat_code--aila.tax_classification_code
                    WHEN aida.line_type_lookup_code = 'NONREC_TAX' THEN awt.name
                    WHEN aida.line_type_lookup_code = 'ACCRUAL' THEN awt.name
                    WHEN aida.line_type_lookup_code = 'FREIGHT' THEN gcc.segment2 || ' ' || gl_flexfields_pkg.get_description_sql(chart_of_accounts_id,2,gcc.segment2)  
                    ELSE gcc.segment2 || ' ' || gl_flexfields_pkg.get_description_sql(chart_of_accounts_id,2,gcc.segment2)  
                END cost_center, 
                gcc.segment3 employee,
                gcc.segment7 model,
                aps.segment1 supplier_no,
                gcc.segment4 budget_account,
                gcc.segment5 budget_cost_center,
                CASE 
                    WHEN aida.amount > 0 THEN abs(aida.amount)
                    ELSE 0
                END debit,
                CASE 
                    WHEN aida.amount < 0 THEN abs(aida.amount)
                    ELSE 0
                END credit,
                aia.invoice_num,
                awt.name invoice_witholding_tax_group,
                aia.doc_sequence_value,     
                aia.gl_date,
                aia.invoice_date,
                aps.vendor_name,
                aida.description,
                org.name,
                org.organization_id     
    FROM AP_INVOICE_DISTRIBUTIONS_ALL aida,
             ap_invoices_all aia,
             ap_supplier_sites_all assa,
             ap_invoice_lines_all aila,
             ap_suppliers aps,
             gl_code_combinations gcc,
             hr_all_organization_units org,
             ap_awt_groups awt
    WHERE 1 = 1
                AND aida.invoice_id = aia.invoice_id
                AND assa.vendor_site_id = aia.vendor_site_id
                AND aps.vendor_id = aia.vendor_id
                AND gcc.code_combination_id = aida.DIST_CODE_COMBINATION_ID
                AND org.organization_id = aia.org_id
                AND aila.invoice_id = aia.invoice_id
                AND aila.line_number = aida.INVOICE_LINE_NUMBER
                AND awt.group_id(+) = aila.awt_group_id
                AND aida.amount <> 0 ) )
where doc_sequence_value BETWEEN  :P_APV_NO1 AND :P_APV_NO2
ORDER BY line_number;


    select initcap(first_name) ||' '||initcap(last_name) person_name from Per_All_People_f a,Fnd_User b where Employee_Id = Person_idAND a.attribute3 IN( 'FINANCE AND ACCOUNTING');
         
    
    SELECT *
    FROM Per_All_People_f
    WHERE LAST_NAME LIKE 'SERV%';
    
    -- ME  127
    
    select *
    from fnd_user
    where user_name = 'FINSETUPUSER';
    
    select *
    from Per_All_People_f
    ;
   -- where ;
    
    SELECT *
    FROM Fnd_User
    WHERE USER_NAME = '150603';
    
    select distinct attribute3
    from Per_All_People_f;
    
    
    /*AP_INVOICE_DISTRIBUTIONS_ALL aida,
             ap_invoices_all aia,
             ap_supplier_sites_all assa,
             ap_invoice_lines_all aila,*/
             
             
select aps.vendor_name supplier_name,
         apsa.vendor_site_code supplier_site,
         aps.segment1 supplier_no,
         aia.invoice_num,
         aia.invoice_date,
         aia.doc_sequence_value,
         aia.gl_date header_gl_date,
         aia.description header_description,
         aia.invoice_amount,
         aila.line_number,
         aila.line_type_lookup_code,
         aila.amount,
         aila.accounting_date line_gl_date,
         aila.description line_description,
         aida.accounting_date distribution_gl_date,
         aida.description distribution_description
from ap_invoices_all aia,
        ap_invoice_lines_all aila,
        ap_invoice_distributions_all aida,
        ap_suppliers aps,
        ap_supplier_sites_all apsa
where 1 = 1
          AND aia.invoice_id = aila.invoice_id
          AND aida.invoice_id = aia.invoice_id
          AND aila.line_number = aida.invoice_line_number
          AND aps.vendor_id = aia.vendor_id
          AND apsa.vendor_site_id = aia.vendor_site_id
          AND aia.invoice_date between '01-MAR-2017' AND '31-MAR-2017';
  --        AND aia.invoice_num like '1073ADV-17';


 select distinct PO_MATCHED_FLAG
 from ap_invoices_all;
 
 select *
 from ap_supplier_sites_all;
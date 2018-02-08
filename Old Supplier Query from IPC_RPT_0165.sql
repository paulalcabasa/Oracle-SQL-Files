SELECT  av.segment1,
             av.vendor_id ,
             assa.vendor_site_id ,
             av.party_id, 
             av.vendor_name as "Supplier Name",
             aSSA.country as "Tax Country",
             av.num_1099 as "Tax Payer ID",
             av.attribute1 as "Payable Type",
             av.attribute2 as "Supplier Group",
             av.attribute3 as "IFS Supplier Code",
             aSSA.invoice_currency_code as "Invoice Currency",
             aSSA.payment_currency_code as "Payment Currency",
             apt.name as "Terms",
             ieppm.payment_method_code as "Payment Method",
             '3-Way' as "Match Approval Level",        
             'Y' as "Allow Tax Applicability",
             av.offset_tax_flag as "offset_tax_flag",
             '' as "First Name",
             '' as "Last Name",
             '' as "Phone Number",
             '' as "Email Address",
             assa.allow_awt_flag  as "Allow Withholding Tax",
             aag.name as "Invoice Withholding Tax Group",
             '' as "Payment Withholding Tax Group",
              tp.inclusive_tax_flag as "Tax Inclusive",
              tp.rounding_rule_code as "Rounding Rule",
              tp.tax_classification_code as "Tax Code", --a
              ZR.TAX_REGIME_CODE as "Tax Regime Code",
              ZR.TAX  as "TAX",
              Zr.EFFECTIVE_FROM  as "Effective From",
              assa.county as "Country",
              assa.address_line1 as "Address Line 1",
              assa.address_line2 as "Address Line 2",
              assa.address_line3 as "Address Line 3",
              assa.address_line4 as "Address Line 4",
              assa.city as "City",
              assa.vendor_site_code as "Address Name",
              '' as "Phone Area Code",
              '' as "Phone Number",
              '' as "Fax Area Code",
              '' as "Fax Number",
              '' as "Email Address",
              assa.purchasing_site_flag as "Address Purpose1",                                                 
              assa.pay_site_flag as "Address Purpose2",
              hou.name as "Organization Unit",
              assa.inactive_date,
              gcc.SEGMENT1 || '.' || gcc.SEGMENT2 || '.' || gcc.SEGMENT3 || '.' || gcc.SEGMENT4 || '.' || gcc.SEGMENT5 || '.' || gcc.SEGMENT6 liability_account        
from ap_suppliers av,
        ap_supplier_sites_all assa,
        hr_operating_units hou,
        gl_code_combinations_kfv gcck,
        gl_code_combinations_kfv cc,
        iby_external_payees_all iep,
        ap_terms_tl apt,
        zx_party_tax_profile tp,
        gl_code_combinations gcc,
        ap_awt_groups aag,
        zx_registrations zr,
        iby_ext_party_pmt_mthds ieppm
where av.vendor_id = assa.vendor_id(+)
and assa.org_id = hou.organization_id(+)
and assa.accts_pay_code_combination_id = gcck.code_combination_id(+)
and assa.prepay_code_combination_id = cc.code_combination_id(+)
and assa.vendor_site_id = iep.supplier_site_id(+)
and assa.terms_id = apt.term_id(+)
and av.party_id = tp.party_id
and assa.accts_pay_code_combination_id = gcc.code_combination_id(+)
and assa.inactive_date is null
and tp.party_type_code = 'THIRD_PARTY'
and tp.party_tax_profile_id = zr.party_tax_profile_id (+)
and iep.ext_payee_id = ieppm.ext_pmt_party_id (+)
and assa.awt_group_id  = aag.group_id (+)
--and upper(av.vendor_name) like 'INTERNATIONAL CONTAINER %'
order by av.vendor_name asc;

SELECT aps.terms_DATE_BASIS,
assa.terms_DATE_BASIS,
             APS.SEGMENT1 SUPPLIER_NUMBER,
             APS.VENDOR_NAME,
             ftt.territory_short_name tax_country,
             aps.vat_registration_num as tax_payer_id,
             (select CONCATENATED_SEGMENTS from gl_code_combinations_kfv where CODE_COMBINATION_ID = assa.ACCTS_PAY_CODE_COMBINATION_ID) liability_account,
             (select CONCATENATED_SEGMENTS from gl_code_combinations_kfv where CODE_COMBINATION_ID = assa.prepay_code_combination_id) prepayment_account,
             CASE 
                    WHEN (select CONCATENATED_SEGMENTS from gl_code_combinations_kfv where CODE_COMBINATION_ID = assa.ACCTS_PAY_CODE_COMBINATION_ID) = '01.-.-.-.-.83300.-.-.-' THEN 'Non-Trade'
                    WHEN (select CONCATENATED_SEGMENTS from gl_code_combinations_kfv where CODE_COMBINATION_ID = assa.ACCTS_PAY_CODE_COMBINATION_ID) = '01.-.-.-.-.82000.-.-.-' THEN 'Trade'
                    ELSE NULL
             END payable_type,
             aps.vendor_type_lookup_code supplier_group,
             aps.attribute3 ifs_supplier_code,
             aps.invoice_currency_code header_invoice_currency,
             assa.invoice_currency_code site_inv_curr_code,
             aps.payment_currency_code header_payment_currency,    
             assa.payment_currency_code site_payment_curr_code,
             (select name from ap_terms a where a.term_id = aps.terms_id) header_terms,
             (select name from ap_terms a where a.term_id = assa.terms_id) site_payment_terms,
             payment_method_tbl.payment_method_code,
             CASE
                  WHEN aps.inspection_required_flag = 'Y' AND  aps.receipt_required_flag = 'Y' THEN '4-Way'
                  WHEN aps.inspection_required_flag = 'N' AND  aps.receipt_required_flag = 'Y' THEN '3-Way'
                  WHEN aps.inspection_required_flag = 'N' AND  aps.receipt_required_flag = 'N' THEN '2-Way'
                  ELSE NULL
             END match_approval_level,
            aps.auto_tax_calc_flag allow_tax_applicability_flag,
            APS.OFFSET_TAX_FLAG as allow_offset_taxes,
            assa.offset_tax_flag as site_allow_offset_tax_flag,
            (select name 
            from AP_AWT_GROUPS
            where group_id = assa.awt_group_id) invoice_witholding_tax_group,
            assa.PAY_GROUP_LOOKUP_CODE as payment_withholding_tax_group,
            assa.AMOUNT_INCLUDES_TAX_FLAG as set_invoice_values_as_tax_inc,
            CASE 
                WHEN assa.AP_TAX_ROUNDING_RULE = 'N' THEN 'Nearest'
                WHEN assa.AP_TAX_ROUNDING_RULE = 'D' THEN 'Down'
                WHEN assa.AP_TAX_ROUNDING_RULE = 'U' THEN 'Up'
                ELSE NULL
            END rounding_rule,
            ASSA.vat_code as tax, 
            assa.allow_awt_flag,
            assa.vendor_site_code,
            assa.address_line1,
            assa.address_line2,
            assa.address_line3,
            assa.city,
            assa.state,
            assa.province,
            assa.zip,
         --Phone Area Code    Phone Number      Fax Area Code     Fax Number  Email Address
            DECODE (assa.purchasing_site_flag, 'Y', 'Purchasing / ', NULL)
               || DECODE (assa.pay_site_flag, 'Y', 'Pay / ', NULL)
               || DECODE (assa.rfq_only_site_flag, 'Y', 'RFQ Only / ', NULL)
               || DECODE (assa.pcard_site_flag, 'Y', 'Procurement Card / ', NULL) address_purpose,
           contact_details.person_name contact_person,
           contact_details.mobile_no,
           contact_details.email_address,
           assa.AUTO_TAX_CALC_FLAG
FROM AP_SUPPLIER_SITES_ALL ASSA,
         AP_SUPPLIERS APS,
         HR_ALL_ORGANIZATION_UNITS ORG,
         fnd_territories_tl ftt,
         (SELECT ieppm.payment_method_code,
                       assa.vendor_site_id
          FROM ap_supplier_sites_all assa,
                    ap_suppliers sup,
                    iby_external_payees_all iepa,
                    iby_ext_party_pmt_mthds ieppm
          WHERE    sup.vendor_id = assa.vendor_id
                        AND assa.pay_site_flag = 'Y'
                        AND assa.vendor_site_id = iepa.supplier_site_id
                        AND iepa.ext_payee_id = ieppm.ext_pmt_party_id
                        AND ((ieppm.inactive_date IS NULL) OR (ieppm.inactive_date > SYSDATE))
                        AND ieppm.primary_flag = 'Y'
          ORDER BY sup.vendor_name, assa.vendor_site_code
          ) payment_method_tbl,
          (SELECT  hp.person_first_name || ' ' || hp.person_middle_name || ' ' || hp.person_last_name person_name
                        ,hp_email.primary_phone_area_code||' '||hp_email.primary_phone_number mobile_no
                        ,nvl(fu.email_address,hp_email.email_address) email_address
                        ,asp.vendor_id
            FROM AP_SUPPLIERS ASP
                ,AP_SUPPLIER_SITES_ALL ASSA
                ,HZ_PARTIES HP_EMAIL
                ,HZ_RELATIONSHIPS HR
                ,HZ_PARTIES HP
                ,FND_USER FU
                ,HR_ALL_ORGANIZATION_UNITS ORG
            WHERE  1 = 1
                AND ASSA.VENDOR_ID = ASP.VENDOR_ID
                AND HR.OBJECT_ID=ASP.PARTY_ID
                AND HR.PARTY_ID=HP_EMAIL.PARTY_ID
                AND HR.SUBJECT_ID=HP.PARTY_ID
                AND FU.PERSON_PARTY_ID(+)=HR.SUBJECT_ID
                AND  ORG.ORGANIZATION_ID = ASSA.ORG_ID
                AND ASP.END_DATE_ACTIVE IS NULL
                AND ASSA.INACTIVE_DATE IS NULL) contact_details
WHERE ASSA.VENDOR_ID = APS.VENDOR_ID
           AND  ORG.ORGANIZATION_ID = ASSA.ORG_ID
           AND APS.END_DATE_ACTIVE IS NULL
           AND ASSA.INACTIVE_DATE IS NULL
           AND assa.vendor_site_id = payment_method_tbl.vendor_site_id(+)
           AND assa.country = ftt.territory_code(+)
           AND contact_details.vendor_id(+) = aps.vendor_id
        --   and aps.segment1 = '101878'
        --   AND assa.AUTO_TAX_CALC_FLAG <> 'Y'
 --          AND  assa.vendor_site_code = 'FOREIGN'
      --     and assa.awt_group_id is not null
          -- AND payment_method_tbl.payment_method_code IS NULL
         --  AND aps.segment1 = 102105;s
       ;

SELECT  hp.person_first_name || ' ' || hp.person_middle_name || ' ' || hp.person_last_name person_name
            ,hp_email.primary_phone_area_code||' '||hp_email.primary_phone_number"Mobile#"
            ,nvl(fu.email_address,hp_email.email_address)"EMAIL"
FROM AP_SUPPLIERS ASP
    ,AP_SUPPLIER_SITES_ALL ASSA
    ,HZ_PARTIES HP_EMAIL
    ,HZ_RELATIONSHIPS HR
    ,HZ_PARTIES HP
    ,FND_USER FU
    ,HR_ALL_ORGANIZATION_UNITS ORG
WHERE  1 = 1

    AND ASSA.VENDOR_ID = ASP.VENDOR_ID
    AND HR.OBJECT_ID=ASP.PARTY_ID
    AND HR.PARTY_ID=HP_EMAIL.PARTY_ID
    AND HR.SUBJECT_ID=HP.PARTY_ID
    AND FU.PERSON_PARTY_ID(+)=HR.SUBJECT_ID
    AND  ORG.ORGANIZATION_ID = ASSA.ORG_ID
    AND ASP.END_DATE_ACTIVE IS NULL
    AND ASSA.INACTIVE_DATE IS NULL
 --   and aps.segment1 in ()
    ;


select AUTO_TAX_CALC_FLAG
from AP_SUPPLIER_SITES_ALL;






SELECT 
         aps.segment1 supplier_number,
         aps.vendor_name supplier_name,
         'TAX COUNTRY' as tax_country, --get the tax country 
       aps.vat_registration_num as tax_payer_id,
         gcck2.concatenated_segments liability_account,
         CASE 
            WHEN gcck2.concatenated_segments = '01.-.-.-.-.83300.-.-.-' THEN 'Non-Trade'
            WHEN gcck2.concatenated_segments = '01.-.-.-.-.82000.-.-.-' THEN 'Trade'
            ELSE NULL
       END payable_type, --payable type please identity if trade or non trade based on liabiliy account
         
         --prepayment account
            
       plc.displayed_field as supplier_group,
       aps.attribute3 ifs_supplier_code,
         aps.invoice_currency_code header_invoice_currency,
         assa.invoice_currency_code site_inv_curr_code,
         aps.payment_currency_code header_payment_currency,    
         assa.payment_currency_code site_payment_curr_code,
         (select name from ap_terms a where a.term_id = aps.terms_id) header_terms,
           apt.NAME site_payment_terms,
              payment_method_tbl.payment_method_code as payment_method,
                -- RECEIVING,
               CASE
                  WHEN aps.inspection_required_flag = 'Y' AND  aps.receipt_required_flag = 'Y' THEN '4-Way'
                  WHEN aps.inspection_required_flag = 'N' AND  aps.receipt_required_flag = 'Y' THEN '3-Way'
                  WHEN aps.inspection_required_flag = 'N' AND  aps.receipt_required_flag = 'N' THEN '2-Way'
                  ELSE NULL
               END match_approval_level,
           aps.auto_tax_calc_flag allow_tax_applicability_flag,
               APS.OFFSET_TAX_FLAG as allow_offset_taxes,
               assa.offset_tax_flag as site_allow_offset_tax_flag,
               assa.vat_code as tax_classification,
               --contact information
               'Invoice Withholding Tax Group' as invoice_withholding_tax_group,
                'payment Withholding Tax Group' as payment_withholding_tax_group,
               assa.AMOUNT_INCLUDES_TAX_FLAG as set_invoice_values_as_tax_inc,
                CASE 
            WHEN assa.AP_TAX_ROUNDING_RULE = 'N' THEN 'Nearest'
            WHEN assa.AP_TAX_ROUNDING_RULE = 'D' THEN 'Down'
            WHEN assa.AP_TAX_ROUNDING_RULE = 'U' THEN 'Up'
            ELSE NULL
       END rounding_rule,
               'tax regime code' as tax_regime_code,
               'tax code' as tax,  --v2ocg
               'tax effective from' as effective_date, 
               
                      ftt.territory_short_name country,
                assa.vendor_site_code,
       assa.address_line1,
       assa.address_line2,
       assa.address_line3,
       assa.city,
       assa.state,
       assa.province,
       assa.zip,
         --Phone Area Code    Phone Number      Fax Area Code     Fax Number  Email Address
       DECODE (assa.purchasing_site_flag, 'Y', 'Purchasing / ', NULL)
         || DECODE (assa.pay_site_flag, 'Y', 'Pay / ', NULL)
       || DECODE (assa.rfq_only_site_flag, 'Y', 'RFQ Only / ', NULL)
       || DECODE (assa.pcard_site_flag, 'Y', 'Procurement Card / ', NULL)
      address_purpose,
        
        ------------------------------------------------------------------------------------
               
       -- TAX DETAILS
       aps.allow_awt_flag header_allow_witholding_tax,
       null header_rounding_level,                 
       null header_rounding_rule,
       null h_set_invoice_tax_inclusive,
       -- TAX DETAILS - SITE
       assa.allow_awt_flag site_allow_tax_witholding,
       (select name 
        from AP_AWT_GROUPS
        where group_id = assa.awt_group_id) invoice_witholding_tax_group,
       null site_rounding_level,                 
       null site_rounding_rule,
       null site_set_invoice_tax_inclusive,
       -- ADDRESS BOOK
      

      -- ACCOUNTING
--      gcck2.concatenated_segments liability_account,
      assa.prepay_code_combination_id,
      (select CONCATENATED_SEGMENTS from gl_code_combinations_kfv where CODE_COMBINATION_ID = assa.prepay_code_combination_id) prepayment_account,
       -- TAX AND REPORTING HEADER


      -- TAX AND REPORTING SITES
       assa.AUTO_TAX_CALC_FLAG calculate_tax,
       assa.vat_registration_num site_tax_registration_number,

      
       
       
       
      
       -- PAYMENT DETAILS

       -- INVOICE MANAGEMENT HEADER
         CASE 
            WHEN aps.match_option = 'R' THEN 'Receipt'
            WHEN aps.match_option = 'P' THEN 'Purchase Order'
            ELSE NULL
        END header_invoice_match_option,


        aps.terms_date_basis,
        aps.pay_date_basis_lookup_code,
        -- INVOICE MANAGEMENT SITE
       -- INVOICING
         CASE 
            WHEN assa.match_option = 'R' THEN 'Receipt'
            WHEN assa.match_option = 'P' THEN 'Purchase Order'
            ELSE NULL
        END site_invoice_match_option,

        -- payment

         assa.terms_date_basis site_terms_date_basis,
         assa.pay_date_basis_lookup_code site_pay_date_basis
        

    --   APS.PAYMENT_METHOD_LOOKUP_CODE,
       
 --      assa.pay_group_lookup_code,
  --     assa.payment_priority,
   --    aps.hold_unmatched_invoices_flag,
    --   aps.exclude_freight_from_discount,
    --   aps.hold_all_payments_flag,
   --    aps.invoice_amount_limit,
   --    aps.invoice_currency_code,
    --   fct.description AS invoice_currency_desc,
  --     pay.description AS payment_currency_desc,
--      aps.price_tolerance,
--      aps.pay_date_basis_lookup_code pay_date_basis,
  --     aps.match_option
  --     aps.match_status_flag,
  --     aps.exclusive_payment_flag,
   --    aps.vendor_name payee_name,
   --    hou.NAME internal_organization,
    --   plc.displayed_field payee_site,
   --    ftt.territory_short_name country,
   --    hps.party_site_name supplier_site_name,
       -- aps.bank_account_name
       --aps.bank_account_num,
       --aps.bank_account_type,
       --aps.bank_number,
  --     ieba.bank_account_num,
      -- ieba.check_digits,
    ---   ieba.bank_account_name,
   --    ieba.bank_account_type,
  --     ieba.start_date,
  --     ieba.end_date,
   --    ieba.payment_factor_flag,
--       iepa.default_payment_method_code,
--      hzpbank.party_name "BANK NAME",
--      hzpbranch.party_name "BRANCH NAME",
  --     hopv.bank_or_branch_number "BANK NUMBER",
   --    hopv.bank_or_branch_number "BRANCH NUMBER",
    --   ceba.iban_number,
       --ceba.START_DATE,
       --ceba.end_DATE,
  --     gcck.concatenated_segments bills_account,
--      gcck1.concatenated_segments prepayment_account,
  --     gcck2.concatenated_segments liability_account,
  --     ads.distribution_set_name,
  --     aps.terms_date_basis,
   --    aps.freight_terms_lookup_code freight_term,
   --    hl_ship_to.location_code ship_to_location,
   --    hl_bill_to.location_code bill_to_location,
-->Recieving -----------------------------------
   --    aps.inspection_required_flag,
  --     aps.receipt_required_flag,
  --     rcpt.description AS rcpt_routing_name,
    --   aps.qty_rcv_tolerance,
    --   aps.qty_rcv_exception_code,
     --  aps.enforce_ship_to_location_code,
     --  aps.days_early_receipt_allowed,
     --  aps.days_late_receipt_allowed,
     --  aps.receipt_days_exception_code,
     --  aps.receiving_routing_id,
     ---  aps.allow_substitute_receipts_flag,
  --     aps.allow_unordered_receipts_flag,
  --     NVL2 (fu.user_name, 'UserAcct','N') AS user_acc,
   --    fnd_message.get_string('POS',decode(sign(trunc(nvl(hzr.end_date,sysdate
  --    +1))-trunc(sysdate)),1,'POS_SP_STATUS_CHANGED_PENDING',
  --    'POS_SP_STATUS_INACTIVE')) as status
  --     jcvs.excise_duty_range,
  --     jcvs.excise_duty_zone,
  --     jcvs.excise_duty_comm excise_duty_collectorate,
   --    jcvs.excise_duty_division,
    --   jcvs.excise_duty_region,
  -- -    jcvs.ec_code,
   --    jcvs.excise_duty_reg_no,
   --    jcvs.excise_duty_circle,
  --     jcvs.document_type,
--      excise_pl.NAME excise_assessable_value,
  --     jcvs.cst_reg_no,
  --     jcvs.st_reg_no lst_reg_no,
  --     jcvs.vat_reg_no,
  --     vat_pl.NAME vat_assessable_value,
--      (SELECT tax_category_name
   --       FROM jai_cmn_tax_ctgs_all
   --      WHERE tax_category_id = jcvs.tax_category_id AND org_id = assa.org_id
  --    ) tax_category_name,
  --     jcvs.service_tax_regno,
  --     flv_service_type.meaning service_type,
  --     jcvs.approved_invoice_flag create_preval_tds_inv_cm,
  --     flv_vendor_type.meaning tds_vendor_type,
--      jatvh.pan_no,
--      jatvh.tan_no,
  --     jatvh.ward_no,
  --     jatvh.section_type,
   --    jatvh.section_code,
    --   jcta.tax_name
  FROM ap_suppliers aps,
       ap_supplier_sites_all assa,

           fnd_territories_tl ftt,
       hr_operating_units hou,
       po_lookup_codes plc,
       fnd_user fu_vendor_create_by,
       fnd_user fu_vendor_update_by,
       fnd_user fu_site_create_by,
       fnd_user fu_site_update_by,
       ap_terms_tl apt,
       ce_bank_accounts ceba,
       gl_code_combinations_kfv gcck,
       gl_code_combinations_kfv gcck1,
       gl_code_combinations_kfv gcck2,
       rcv_routing_headers rcpt,
       fnd_currencies_tl fct,
       fnd_currencies_tl pay,
       hz_organization_profiles hopv,
       hz_parties hp,
       hz_contact_points hcpe,
       hz_contact_points hcpp,
       fnd_user fu,
       hz_party_sites hps,
       hz_relationships hzr,
       hz_parties hp_contact_person,
--       ce_banks_v cbv,
       ap_distribution_sets_all ads,
       hr_locations hl_ship_to,
       hr_locations hl_bill_to,
       iby_external_payees_all iepa,
       iby_pmt_instr_uses_all ipiua,
       iby_ext_bank_accounts ieba,
       hz_parties hzpbank,
       hz_parties hzpbranch,
       jai_cmn_vendor_sites jcvs,
       qp_list_headers_tl excise_pl,
       qp_list_headers_tl vat_pl,
       --jai_cmn_tax_ctgs_all vat_jctc,
       fnd_lookup_values flv_service_type,
       jai_ap_tds_vendor_hdrs jatvh,
       fnd_lookup_values flv_vendor_type,
       jai_cmn_taxes_all jcta,
       (SELECT   ieppm.payment_method_code,
                       assa.vendor_site_id
       FROM ap_supplier_sites_all assa,
            ap_suppliers sup,
            iby_external_payees_all iepa,
            iby_ext_party_pmt_mthds ieppm
      WHERE sup.vendor_id = assa.vendor_id
        AND assa.pay_site_flag = 'Y'
        AND assa.vendor_site_id = iepa.supplier_site_id
        AND iepa.ext_payee_id = ieppm.ext_pmt_party_id
        AND ((ieppm.inactive_date IS NULL) OR (ieppm.inactive_date > SYSDATE)
            )
       -- AND assa.vendor_site_id = :p_vendor_site_id
        AND ieppm.primary_flag = 'Y'
      ORDER BY sup.vendor_name, assa.vendor_site_code) payment_method_tbl
--     hz_organization_profiles hopbank,
--     hz_organization_profiles hopbranch
--     ce_bank_branches_v cbbv
--     iby_ext_bank_accounts ieba,
--     iby_ext_banks_v ibeb
WHERE  aps.vendor_id = assa.vendor_id
   AND assa.country = ftt.territory_code
   AND assa.org_id = hou.organization_id
   AND aps.vendor_type_lookup_code = plc.lookup_code(+)
   AND plc.lookup_type(+) = 'VENDOR TYPE'
   AND aps.created_by = fu_vendor_create_by.user_id(+)
   AND aps.last_updated_by = fu_vendor_update_by.user_id(+)
   AND assa.created_by = fu_site_create_by.user_id(+)
   AND assa.last_updated_by = fu_site_update_by.user_id(+)
   AND assa.terms_id = apt.term_id(+)
--      AND aps.segment1 = :p_supp_no  --10549  --10549  --10531 --11075 --11074
   AND aps.bank_account_num = ceba.bank_account_num(+)
   AND assa.future_dated_payment_ccid = gcck.code_combination_id(+)
   AND assa.prepay_code_combination_id = gcck1.code_combination_id(+)
   AND assa.accts_pay_code_combination_id = gcck2.code_combination_id(+)
   AND aps.receiving_routing_id = rcpt.routing_header_id(+)
   AND aps.invoice_currency_code = fct.currency_code(+)
   AND aps.payment_currency_code = pay.currency_code(+)
   AND aps.party_id = hopv.party_id(+)
   AND aps.party_id = hp.party_id
   AND hp.party_id = hps.party_id(+)
   AND hp.party_id = fu.person_party_id(+)
   AND SYSDATE BETWEEN hopv.effective_start_date AND NVL (hopv.
      effective_end_date, SYSDATE)
   AND hp.party_id = hzr.subject_id(+)
   AND hzr.party_id = hcpe.owner_table_id(+)
   AND hcpe.owner_table_name(+) = 'HZ_PARTIES'
   AND hcpe.contact_point_type(+) = 'EMAIL'
   AND hcpe.primary_flag(+) = 'Y'
   AND hcpe.status(+) = 'A'
   AND hzr.party_id = hcpp.owner_table_id(+)
   AND hcpp.phone_line_type(+) = 'GEN'
   AND hcpp.contact_point_type(+) = 'PHONE'
   AND hcpp.primary_flag(+) = 'Y'
   AND hcpp.primary_flag(+) = 'Y'
   AND hcpp.owner_table_name(+) = 'HZ_PARTIES'
   AND hzr.subject_type(+) = 'ORGANIZATION'
   AND hzr.object_type(+) = 'PERSON'
   AND hzr.status(+) = 'A'
   AND hzr.relationship_type(+) = 'CONTACT'
   AND hzr.object_id = hp_contact_person.party_id(+)
   --and hp.PARTY_ID = cbv.BANK_PARTY_ID(+)
   AND assa.distribution_set_id = ads.distribution_set_id(+)
   AND assa.ship_to_location_id = hl_ship_to.location_id(+)
   AND assa.bill_to_location_id = hl_bill_to.location_id(+)
   AND hp.party_id = iepa.payee_party_id(+)
   AND iepa.supplier_site_id IS NULL
   AND iepa.ext_payee_id = ipiua.ext_pmt_party_id(+)
   AND ipiua.instrument_id = ieba.ext_bank_account_id(+)
   AND ieba.bank_id = hzpbank.party_id(+)
   AND ieba.bank_id = hzpbranch.party_id(+)
   AND assa.vendor_id = jcvs.vendor_id(+)
   AND assa.vendor_site_id = jcvs.vendor_site_id(+)
   AND jcvs.price_list_id = excise_pl.list_header_id(+)
   AND jcvs.vat_price_list_id = vat_pl.list_header_id(+)
   --AND jcvs.tax_category_id = vat_jctc.tax_category_id (+)
   --AND assa.org_id = vat_jctc.org_id(+)
   AND jcvs.service_type_code = flv_service_type.lookup_code(+)
   AND flv_service_type.lookup_type(+) = 'JAI_SERVICE_TYPE'
   AND assa.vendor_id = jatvh.vendor_id(+)
   AND assa.vendor_site_id = jatvh.vendor_site_id(+)
   AND jatvh.tds_vendor_type_lookup_code = flv_vendor_type.lookup_code(+)
   AND flv_vendor_type.lookup_type(+) = 'JAI_TDS_VENDOR_TYPE'
   AND jatvh.tax_id = jcta.tax_id(+)
   AND  aps.end_date_active IS  NULL
   AND hps.status = 'A'
   AND assa.inactive_date IS NULL
   AND assa.vendor_site_id = payment_method_tbl.vendor_site_id(+)
--   and aps.vendor_name like '%ALCABASA%'
-- AND aps.segment1 = '101982';


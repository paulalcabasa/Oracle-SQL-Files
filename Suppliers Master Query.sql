SELECT 
      hou.NAME ou_name,

       hp.party_number register_id,
       aps.vendor_name vendor_code,
       aps.vendor_id,
       assa.duns_number,
       aps.vendor_name_alt,
       aps.segment1 vendor_number,
       --aps.END_DATE_ACTIVE inactive_date,
       hp.party_id,
       party_site_number,
       assa.edi_id_number,
       assa.ece_tp_location_code edi_location,
       assa.shipping_control,
       aps.vendor_name,
       aps.enabled_flag,
       plc.displayed_field vendor_type,
       aps.one_time_flag,
       aps.hold_flag po_hold_flag,
       aps.num_1099 taxpayer_id,
       aps.vat_registration_num tax_registration_num,
       aps.federal_reportable_flag,
       hopv.analysis_fy,
       hopv.fiscal_yearend_month fiscal_year_end,
       hopv.curr_fy_potential_revenue potential_revenue,
       hopv.next_fy_potential_revenue annual_revenue,
       hopv.pref_functional_currency currency_preference,
       aps.federal_reportable_flag income_tax_reportable,
       aps.state_reportable_flag state_reportable,
       aps.type_1099 income_tax_type,
       aps.creation_date vendor_creation_date,
       fu_vendor_create_by.user_name vendor_created_by,
       aps.last_update_date vendor_last_updated_date,
       fu_vendor_update_by.user_name vendor_last_updated_by,
       assa.vendor_site_id,
       assa.vendor_site_code,
       assa.address_line1,
       assa.address_line2,
       assa.address_line3,
       assa.city,
       assa.state,
       assa.province,
       assa.zip,
       ftt.territory_short_name,
       assa.area_code,
       assa.phone,
       assa.fax_area_code,
       assa.fax,
       DECODE (SIGN (NVL (assa.inactive_date, SYSDATE + 1) - SYSDATE), -1,
      'INACTIVE', 'ACTIVE') site_status,
       hp_contact_person.person_first_name,
       hp_contact_person.person_last_name,
       aps.end_date_active inactive_date,
       hcpp.phone_area_code || ' ' || hcpp.phone_number || ' ' || hcpp.
      phone_extension phone_number,
       hcpe.email_address,
       assa.creation_date site_creation_date,
       fu_site_create_by.user_name site_created_by,
       assa.last_update_date site_last_update_date,
       fu_site_update_by.user_name site_last_updated_by,
       assa.pay_site_flag,
       assa.rfq_only_site_flag,
       assa.purchasing_site_flag,
       assa.pcard_site_flag,
          DECODE (assa.pay_site_flag, 'Y', 'Pay / ', NULL)
       || DECODE (assa.rfq_only_site_flag, 'Y', 'RFQ Only / ', NULL)
       || DECODE (assa.purchasing_site_flag, 'Y', 'Purchasing / ', NULL)
       || DECODE (assa.pcard_site_flag, 'Y', 'Procurement Card / ', NULL)
      site_uses,
       apt.NAME payment_terms,
       assa.pay_group_lookup_code,
       assa.payment_priority,
       aps.hold_unmatched_invoices_flag,
       aps.exclude_freight_from_discount,
       aps.hold_all_payments_flag,
       aps.invoice_amount_limit,
       aps.invoice_currency_code,
       fct.description AS invoice_currency_desc,
       pay.description AS payment_currency_desc,
       aps.price_tolerance,
       aps.pay_date_basis_lookup_code pay_date_basis,
       aps.match_option,
       aps.match_status_flag,
       aps.exclusive_payment_flag,
       aps.vendor_name payee_name,
       hou.NAME internal_organization,
       plc.displayed_field payee_site,
       ftt.territory_short_name country,
       hps.party_site_name supplier_site_name,
       -- aps.bank_account_name
       --aps.bank_account_num,
       --aps.bank_account_type,
       --aps.bank_number,
       ieba.bank_account_num,
       ieba.check_digits,
       ieba.bank_account_name,
       ieba.bank_account_type,
       ieba.start_date,
       ieba.end_date,
       ieba.payment_factor_flag,
       iepa.default_payment_method_code,
       hzpbank.party_name "BANK NAME",
       hzpbranch.party_name "BRANCH NAME",
       hopv.bank_or_branch_number "BANK NUMBER",
       hopv.bank_or_branch_number "BRANCH NUMBER",
       ceba.iban_number,
       --ceba.START_DATE,
       --ceba.end_DATE,
       gcck.concatenated_segments bills_account,
       gcck1.concatenated_segments prepayment_account,
       gcck2.concatenated_segments liability_account,
       ads.distribution_set_name,
       aps.terms_date_basis,
       aps.freight_terms_lookup_code freight_term,
       hl_ship_to.location_code ship_to_location,
       hl_bill_to.location_code bill_to_location,
-->Recieving -----------------------------------
       aps.inspection_required_flag,
       aps.receipt_required_flag,
       rcpt.description AS rcpt_routing_name,
       aps.qty_rcv_tolerance,
       aps.qty_rcv_exception_code,
       aps.enforce_ship_to_location_code,
       aps.days_early_receipt_allowed,
       aps.days_late_receipt_allowed,
       aps.receipt_days_exception_code,
       aps.receiving_routing_id,
       aps.allow_substitute_receipts_flag,
       aps.allow_unordered_receipts_flag,
       NVL2 (fu.user_name, 'UserAcct','N') AS user_acc,
   --    fnd_message.get_string('POS',decode(sign(trunc(nvl(hzr.end_date,sysdate
  --    +1))-trunc(sysdate)),1,'POS_SP_STATUS_CHANGED_PENDING',
  --    'POS_SP_STATUS_INACTIVE')) as status
       jcvs.excise_duty_range,
       jcvs.excise_duty_zone,
       jcvs.excise_duty_comm excise_duty_collectorate,
       jcvs.excise_duty_division,
       jcvs.excise_duty_region,
       jcvs.ec_code,
       jcvs.excise_duty_reg_no,
       jcvs.excise_duty_circle,
       jcvs.document_type,
       excise_pl.NAME excise_assessable_value,
       jcvs.cst_reg_no,
       jcvs.st_reg_no lst_reg_no,
       jcvs.vat_reg_no,
       vat_pl.NAME vat_assessable_value,
       (SELECT tax_category_name
          FROM jai_cmn_tax_ctgs_all
         WHERE tax_category_id = jcvs.tax_category_id AND org_id = assa.org_id
      ) tax_category_name,
       jcvs.service_tax_regno,
       flv_service_type.meaning service_type,
       jcvs.approved_invoice_flag create_preval_tds_inv_cm,
       flv_vendor_type.meaning tds_vendor_type,
       jatvh.pan_no,
       jatvh.tan_no,
       jatvh.ward_no,
       jatvh.section_type,
       jatvh.section_code,
       jcta.tax_name
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
       jai_cmn_taxes_all jcta
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
  -- AND SYSDATE BETWEEN hopv.effective_start_date AND NVL (hopv.
    --  effective_end_date, SYSDATE)
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
   and hp.party_name like '%K%LINE%'
     --       AND  aps.end_date_active IS  NULL
 --AND  hp.party_number = 1818
-- AND hps.status = 'A'
-- AND    ftt.territory_short_name <> 'Philippines'
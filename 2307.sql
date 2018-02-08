select decode(address_line_1,null,'',address_line_1||', ')||
                  decode(address_line_2,null,'',address_line_2||', ')||
                  decode(address_line_3,null,'',address_line_3||', ')||
                  decode(town_or_city,null,'',town_or_city)
     into address
     from HR_LOCATIONS_ALL where location_id in
(select location_id from XLE_REGISTRATIONS where source_id in
(select legal_entity_id from ap_invoices_all where org_id = 82 and rownum <2)
 and rownum <2);
select *
from ar_cash_receipts_all
where amount = 193805.30;


SELECT aps.vendor_id,
            apsa.vendor_site_id,
            apsa.vendor_site_code,
            aps.segment1, 
            aps.vendor_name,
            substr(apsa.vat_registration_num,1,3) supplier_tin1,
            substr(apsa.vat_registration_num,5,3) supplier_tin2,
            substr(apsa.vat_registration_num,9,3) supplier_tin3,
            substr(apsa.vat_registration_num,13,3) supplier_tin4,
            (hp.address1 || ' ' || hp.address2 || ' ' || hp.address3 || ' ' || hp.address4 || ' ' || hp.country) supplier_address,
            hp.postal_code
FROM ap_suppliers aps,
          ap_supplier_sites_all apsa,
          hz_parties hp
WHERE 1 = 1
            AND aps.vendor_id = apsa.vendor_id
            AND apsa.inactive_date IS NULL
            AND aps.end_date_active IS NULL
            AND apsa.org_id = :p_org_id
            AND hp.party_id = aps.party_id
            AND aps.vendor_name BETWEEN :p_vendor_from AND :p_vendor_to;

select *
from ap_invoices_all aia,
        ap_invoice_lines_all aila
where 1 = 1
          and aia.invoice_id = aila.invoice_id
          and aia.vendor_id = :vendor_id
          and aia.invoice_date between to_date(:p_from_date, 'YYYY/MM/DD HH24:MI:SS') and to_date(:p_to_date, 'YYYY/MM/DD HH24:MI:SS');

update dbs_picklist_interface
    set is_interface_picked = NULL
    WHERE request_number IN (956877,955876,965876);
    
    COMMIT;

 select substr(registration_number,1,instr(registration_number,'-',1,1)-1)

  from xle_registrations
  where jurisdiction_id = 59966 and
              source_table = 'XLE_ETB_PROFILES';
    
SELECT TO_CHAR(TO_DATE('04/01/2017', 'MM/DD/YYYY'), 'Q') AS MY_QTR
FROM DUAL ;

select *
from ap_invoice_distributions_all;

select ata.name,
         ata.description,
         sum(aida.amount * nvl(aia.exchange_rate,1)) amount
from  ap_invoices_all aia, 
         ap_invoice_distributions_all aida,
         ap_tax_codes_all ata
where  1 = 1
           and aida.invoice_id = aia.invoice_id 
           and ata.tax_id = aida.withholding_tax_code_id 
           and aida.line_type_lookup_code = 'AWT' 
           and aida.amount <> 0
           and aia.vendor_id = :vendor_id
           and aia.invoice_date between to_date(:p_from_date, 'YYYY/MM/DD HH24:MI:SS') and to_date(:p_to_date, 'YYYY/MM/DD HH24:MI:SS')
group by ata.name,
              ata.description;

select *
from ap_tax_codes_all;        
           --and
           --  and aia.vendor_id = :vendor_id
    --      and aia.invoice_date between to_date(:p_from_date, 'YYYY/MM/DD HH24:MI:SS') and to_date(:p_to_date, 'YYYY/MM/DD HH24:MI:SS');
                --  substr(ap_tax_codes_all.name,1,5) in('WV010','WV012','WV014','WV020','WV024','WB084','WV040','WV060','WC180','WC191','WC230','WI260');
                  
                  
select *
from ap_invoices_all;

select *
from ap_supplier_sites_all apsa;

select *
from hz_parties;



select *
from ap_suppliers;


select po_vendors.vendor_name,
         nvl(ap_invoices_all.exchange_rate,1) exchange_rate,
       
       hz_parties.address1||' '||hz_parties.country Address,
       hz_parties.postal_code,
                   ap_invoices_all.gl_date,
       to_char(ap_invoices_all.gl_date, 'DD-Mon-YYYY') gl_date2,
                   to_char(ap_invoices_all.invoice_date, 'DD-Mon-YYYY') invoice_date,
       ap_invoices_all.doc_sequence_value,
       ap_invoices_all.invoice_id,
                   ap_invoices_all.invoice_id,
                   ap_invoices_all.invoice_id,
                   ap_invoices_all.invoice_num,
       ap_invoice_distributions_all.amount * nvl(ap_invoices_all.exchange_rate,1) amount,
                   ap_tax_codes_all.name,
                   substr(ap_tax_codes_all.description,1,60) description,
                   ap_tax_codes_all.description description2307,
                   ap_invoice_distributions_all.awt_origin_group_id,
                   ap_invoice_distributions_all.withholding_tax_code_id
from po_vendors,
     hz_parties,
     ap_invoices_all,
     ap_invoice_distributions_all,
                 ap_tax_codes_all
where hz_parties.party_id = po_vendors.party_id and
      ap_invoices_all.vendor_id = po_vendors.vendor_id and
      ap_invoice_distributions_all.invoice_id = ap_invoices_all.invoice_id and
      ap_tax_codes_all.tax_id = ap_invoice_distributions_all.withholding_tax_code_id and
      ap_invoice_distributions_all.line_type_lookup_code = 'AWT' and
      ap_invoice_distributions_all.amount <> 0 and
      ap_invoices_all.org_id = :p_org_id and
      ap_invoices_all.invoice_date between
        to_date(:p_datefrom, 'YYYY/MM/DD HH24:MI:SS') and 
        to_date(:p_dateto, 'YYYY/MM/DD HH24:MI:SS') + 86399/86400 and
        po_vendors.vendor_name between
        :p_vendorfrom and
       :p_vendorto
        ;
        
        
        
        SELECT *
        FROM po_vendors;
        
        
        select to_char(add_months(trunc('3','Q'),3) - 1,'MM')
        from dual;
        

        
select po_vendors.vendor_name,
         nvl(ap_invoices_all.exchange_rate,1) exchange_rate,
      
         ap_invoices_all.gl_date,
       to_char(ap_invoices_all.gl_date, 'DD-Mon-YYYY') gl_date2,
                   to_char(ap_invoices_all.invoice_date, 'DD-Mon-YYYY') invoice_date,
       ap_invoices_all.doc_sequence_value,
       ap_invoices_all.invoice_id,
                   ap_invoices_all.invoice_id,
                   ap_invoices_all.invoice_id,
                   ap_invoices_all.invoice_num,
       ap_invoice_distributions_all.amount * nvl(ap_invoices_all.exchange_rate,1) amount,
                   ap_tax_codes_all.name,
                   substr(ap_tax_codes_all.description,1,60) description,
                   ap_tax_codes_all.description description2307,
                   ap_invoice_distributions_all.awt_origin_group_id,
                   ap_invoice_distributions_all.withholding_tax_code_id
from po_vendors,
     hz_parties,
     ap_invoices_all,
     ap_invoice_distributions_all,
                 ap_tax_codes_all
where hz_parties.party_id = po_vendors.party_id and
      ap_invoices_all.vendor_id = po_vendors.vendor_id and
      ap_invoice_distributions_all.invoice_id = ap_invoices_all.invoice_id and
                  ap_tax_codes_all.tax_id = ap_invoice_distributions_all.withholding_tax_code_id and
      ap_invoice_distributions_all.line_type_lookup_code = 'AWT' and
      ap_invoice_distributions_all.amount <> 0 and
      ap_invoices_all.org_id = :p_org_id and
      ap_invoices_all.invoice_date between
        to_date(:p_datefrom, 'YYYY/MM/DD HH24:MI:SS') and 
        to_date(:p_dateto, 'YYYY/MM/DD HH24:MI:SS') + 86399/86400 and
        po_vendors.vendor_id = :vendor_id;
        
 
 select ap_invoice_distributions_all.invoice_id,
                   ap_invoice_distributions_all.awt_origin_group_id,
                   ap_tax_codes_all.name,
                   ap_invoice_distributions_all.amount,
                   nvl(ap_invoices_all.exchange_rate,1) exchange_rate
from  ap_invoices_all, 
                 ap_invoice_distributions_all,
                 ap_tax_codes_all
where  ap_invoice_distributions_all.invoice_id = ap_invoices_all.invoice_id and
                  ap_invoice_distributions_all.invoice_id = :invoice_id and
                  ap_tax_codes_all.tax_id = ap_invoice_distributions_all.withholding_tax_code_id and
      ap_invoice_distributions_all.line_type_lookup_code = 'AWT' and
      ap_invoice_distributions_all.amount <> 0 and
                  substr(ap_tax_codes_all.name,1,5) in('WV010','WV012','WV014','WV020','WV024','WB084','WV040','WV060','WC180','WC191','WC230','WI260');
                  
                  select ap_invoice_distributions_all.invoice_id,
                   ap_invoice_distributions_all.awt_origin_group_id,
                   ap_tax_codes_all.name,
                   ap_invoice_distributions_all.amount,
                   nvl(ap_invoices_all.exchange_rate,1) exchange_rate
from          ap_invoices_all,
                 ap_invoice_distributions_all,
                 ap_tax_codes_all
where   ap_invoice_distributions_all.invoice_id = ap_invoices_all.invoice_id and
                  ap_invoice_distributions_all.invoice_id = :invoice_id and
                  ap_tax_codes_all.tax_id = ap_invoice_distributions_all.withholding_tax_code_id and
      ap_invoice_distributions_all.line_type_lookup_code = 'AWT' and
      ap_invoice_distributions_all.amount <> 0
select 
       a.customer_id,
       a.name,
       c.fee_code,
         ifsapp.identity_invoice_info_api.get_group_id('10',a.customer_id,a.party_type) customer_group,
        b.address1,
        b.address2,
      
        b.address,             
        b.country,
        b.zip_code,
        b.city,
--   a.association_no,
        a.party_type,
    --     a.else_name,
  
       ifsapp.customer_info_vat_api.get_vat_no(a.customer_id,'01','10') vat_no,
     
       ifsapp.identity_invoice_info_api.get_pay_term_id('10',a.customer_id,a.party_type) payment_term,
       ifsapp.identity_invoice_info_api.get_def_vat_code('10',a.customer_id,a.party_type) vat_code,
       ifsapp.identity_invoice_info_api.get_identity_type('10',a.customer_id,a.party_type) identity_type,
       ifsapp.identity_invoice_info_api.get_def_currency('10',a.customer_id,a.party_type) currency,
       ifsapp.customer_credit_info_api.get_note_text('10',a.customer_id) note_text,
       (select credit_comments from  IFSAPP.CUSTOMER_CREDIT_INFO_CUST
       where identity =  a.customer_id) business_style
from IFSAPP.CUSTOMER_INFO a,
        IFSAPP.CUSTOMER_INFO_ADDRESS b,
        IFSAPP.IDENTITY_INVOICE_INFO c
where  a.party_type = 'Customer'
           and a.customer_id = b.customer_id
           and c.identity  = A.customer_id
           and a.name IN(
          -- 'A.M. GEOCONSULT & ASSOCIATES INC.',
'ALLPMEDS DRUGSTORE',
'ALRICH COMMERCIAL INC',
'C.I.C.M. MISSIONARIES, INC.-PROCURATION OFFICE',
'CEBU PAPER SALES, INC.',
'DAGUPAN ELECT. CORP.',
'GOLDEN ACRES FOOD SERVICE CORPORATION',
'GRIND TECH ABRASIVES CORPORATION',
--'JOMCRET TRADE & DEVELOPMENT CORP.',
'JROG MARKETING',
'LGU TUGUEGARAO',
'LUCKY STAR CENTER',
'MASS - V GROUP, INC.',
'REGULUS WATER REFILLING STATION',
'RIGHT MOVES INC.');
--and b.address_id in( '01','02')
;
--      -- 'NESTOR & SONIA MEAT RETAILER',
select *
from IFSAPP.CUSTOMER_CREDIT_INFO_CUST;

select *
from CUSTOMER_info_tab;
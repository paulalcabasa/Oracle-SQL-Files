--wala pang OR ng january at febuary,
--Collection pa lang ang mayroon

select rcta.customer_trx_id,
         rcta.trx_number,
         rcta.comments,
         rcta.trx_date,
         apsa.gl_date,
         rctta.name transaction_type,
         hp.party_name,
         hca.account_number,
         hca.account_name,
         site_uses.location,
         rcta.complete_flag,
         rcta.sold_to_customer_id,
         rcta.sold_to_site_use_id,
         rcta.bill_to_customer_id,
         rcta.bill_to_site_use_id,
         rcta.ship_to_customer_id,
         rcta.ship_to_site_use_id,
         (select sum(extended_amount)
from ra_customer_trx_lines_all
where customer_trx_id = rcta.customer_trx_id)
from ra_customer_trx_all rcta,
        RA_CUST_TRX_TYPES_ALL rctta,
        hz_cust_accounts_all hca,
        hz_parties hp,
        hz_cust_site_uses_all site_uses,
        ar_payment_schedules_all apsa
      
where 1 = 1
          AND rcta.cust_trx_type_id = rctta.cust_trx_type_id
          AND rcta.bill_to_customer_id = hca.cust_account_id
          AND hp.party_id = hca.party_id
          AND site_uses.site_use_id = rcta.bill_to_site_use_id
          AND apsa.trx_number = rcta.trx_number
          AND RCTA.TRX_NUMBER NOT IN (SELECT distinct --RCTLG.AMOUNT,
     --  AC.CUSTOMER_NUMBER,
    --   AC.CUSTOMER_NAME,
       RCX.TRX_NUMBER     
 --      to_char(rcx.trx_date) invoice_date,
    --    to_char(apsa.gl_date) gl_date,
  --     gjh.JE_HEADER_ID,
--       gjh.doc_sequence_value
  FROM ra_customer_trx_all rcx,
       ar_customers ac,
       ra_cust_trx_line_gl_dist_all rctlg,
       xla.xla_ae_headers xah,
       xla.xla_ae_lines xal,
       xla_distribution_links xdl,
       gl_code_combinations gcc,
       xla.xla_transaction_entities xte,
       gl_import_references gir,
       gl_je_headers gjh,
       gl_je_lines gjl,
       ar_payment_schedules_all apsa
 WHERE rcx.bill_to_customer_id = ac.customer_id(+)
 and apsa.trx_number = rcx.trx_number
   AND rcx.customer_trx_id = rctlg.customer_trx_id
   AND xah.ae_header_id = xal.ae_header_id(+)
   AND gcc.code_combination_id(+) = xal.code_combination_id
   AND rctlg.code_combination_id = xal.code_combination_id
   AND xdl.ae_header_id = xah.ae_header_id
   AND xdl.ae_line_num = xal.ae_line_num
   AND xdl.source_distribution_id_num_1 = rctlg.cust_trx_line_gl_dist_id
   AND xte.source_id_int_1 = rcx.customer_trx_id
   AND xte.entity_code = 'TRANSACTIONS'
   AND rctlg.account_class = 'REV'
   AND xte.entity_id = xah.entity_id
   and xal.gl_sl_link_id = gir.gl_sl_link_id
   and gir.je_header_id = gjl.je_header_id
   and gir.je_line_num = gjl.je_line_num
   AND GIR.JE_HEADER_ID = GJH.JE_HEADER_ID
   AND GJL.JE_HEADER_ID = GJH.JE_HEADER_ID)
   --       AND rctta.name = 'Invoice-Parts'
order by rcta.trx_number;

select trx_number
from ar_payment_schedules_all;


/***** AR QUERY FOR MS. GRACE ****/
select rcta.trx_number,
           to_char(rcta.trx_date) invoice_date,
           to_char(apsa.gl_date) gl_date,
           to_char(rcta.creation_date) creation_date,
           rcta.attribute3 cs_no,
           rcta.comments ifs_invoice_no,
           (select sum(extended_amount) from ra_customer_trx_lines_All 
           where customer_trx_id = rcta.customer_trx_id) amount,
           rctta.name
          
from ra_customer_trx_all rcta,
         ar_payment_schedules_all apsa,
         ra_cust_trx_types_all rctta
where 1 = 1
        and rcta.trx_number = apsa.trx_number
        and rctta.CUST_TRX_TYPE_ID = rcta.CUST_TRX_TYPE_ID
        and rcta.CUST_TRX_TYPE_ID = apsa.CUST_TRX_TYPE_Id
 --       and rcta.trx_date BETWEEN '01-JUN-2017' AND '20-JUN-2017'
        and to_date(rcta.creation_date) >= '18-MAY-2017';
;AND RCTA.TRX_NUMBER IN ('40200012322',
'40200012323',
'40200012324',
'40200012325',
'40200012326',
'40200012327',
'40200012328',
'40200012330',
'40200012329',
'40200012331',
'40200012333',
'40200012332',
'40200012334',
'40200012335');
     --   and rcta.trx_number = '1048'
--        and           (select sum(extended_amount) from ra_customer_trx_lines_All 
--           where customer_trx_id = rcta.customer_trx_id) = '17419.03'
order by rcta.customer_trx_id;



select *
from ra_cust_trx_types_all;

select *
from ra_customer_trx_all
where trx_number like '402%'
and trx_date between '01-JUN-2017' AND '30-JUN-2017';

select *
from ra_customer_trx_all
where comments like '980240279%';


select *
from ra_customer_trx_all
where interfacE_header_attribute1 = '3010005586';

select *
from hr_all_organization_units;

select *
from mtl_parameters;



select customer_trx_id,trx_number,interface_header_attribute1,(select count(customer_trx_id) from ra_customer_trx_lines_all
                                                                                            where customer_trx_id  = rcta.customer_trx_id) line_count
from ra_customer_trx_all rcta
where interface_header_attribute1 IN (select interface_header_attribute1
from ra_customer_trx_all rcta
where trx_number like '403%'
and trx_date between '01-APR-2017' AND '30-APR-2017'
having count(trx_number) = 1
group by rcta.interface_header_attribute1);

select *
from ra_customer_trx_lines_all
where customer_trx_id = 21463;


select *
from ra_customer_trx_all rcta
where (select sum(extended_amount) 
            from ra_customer_trx_lines
            where customer_trx_id = rcta.customer_trx_id) = '2327.48';
           
            
/*AR Query for Ms. Mel*/

select rcta.trx_number,
         ooha.order_number,
         ord_type.ORD_TYPE_NAME,
         ord_type.ORD_TYPE_DESC
         
from ra_customer_trx_all rcta,
        oe_order_headers_all ooha,
        XXIPC_ORDER_TYPES ord_type
where 1 = 1
          and to_char(rcta.interface_header_attribute1) = to_char(ooha.order_number)
          and ord_type.transaction_type_id = ooha.order_type_id
          and rcta.trx_number = '40200002239';
          
          SELECT *
          FROM ALL_TAB_COLUMNS
          WHERE TABLE_NAME LIKE 'XXIPC%';
          
SELECT rcta.trx_number,
            rcta.comments,
            cust.account_name,
            cust.account_number,
            cust.party_name,
            cust.party_site_name
FROM RA_CUSTOMER_TRX_ALL rcta,
          XXIPC_CUSTOMER_NAMES_V cust
WHERE 1 = 1
            and cust.site_use_id = rcta.bill_to_site_use_id
            and rcta.trx_number IN('40200013077',
'40200013078',
'40200013079',
'40200013080',
'40200013124',
'40200013127',
'40200013128',
'40200013129',
'40200013143',
'40200013152',
'40200013153',
'40200013154',
'40200013155',
'40200013156',
'40200013157',
'40200013158',
'40200013159',
'40200013160',
'40200013161',
'40200013162',
'40200013163',
'40200013164',
'40200013165',
'40200013166',
'40200013167',
'40200013168',
'40200013169',
'40200013170',
'40200013171',
'40200013172',
'40200013173',
'40200013174',
'40200013175',
'40200013176',
'40200013177',
'40200013178',
'40200013179',
'40200013180',
'40200013181',
'40200013182',
'40200013183',
'40200013184',
'40200013185',
'40200013186',
'40200013187',
'40200013188',
'40200013189',
'40200013190',
'40200013191',
'40200013235',
'40200013243',
'40200013244',
'40200013247',
'40200013248',
'40200013250',
'40200013251',
'40200013273',
'40200013274',
'40200013275',
'40200013276',
'40200013277',
'40200013278',
'40200013279',
'40200013280',
'40200013281',
'40200013282',
'40200013283',
'40200013284',
'40200013285',
'40200013286',
'40200013287',
'40200013288',
'40200013289',
'40200013290',
'40200013291',
'40200013292',
'40200013293',
'40200013294',
'40200013295',
'40200013296',
'40200013297',
'40200013298',
'40200013299',
'40200013300',
'40200013301',
'40200013302',
'40200013303',
'40200013304',
'40200013305',
'40200013306',
'40200013307',
'40200013309');


select *
from ra_cust_trx_types_all;

select rcta.trx_number invoice_number,
         to_char(rcta.trx_date) invoice_date,
         to_char(apsa.gl_date) gl_date,
         rctta.name,
         rctta.description,
         to_char(rcta.creation_date) creation_date
from ra_customer_trx_all rcta,
        ar_payment_schedules_all apsa,
        ra_cust_trx_types_all rctta
where 1 = 1
          and rcta.customer_trx_id = apsa.customer_trx_id
          and rctta.cust_trx_type_id = rcta.cust_trx_type_id
          and rcta.trx_number like '402%'
          and rcta.trx_date <> apsa.gl_date;
          
          
select rcta.trx_number oracle_invoice_no,
         rcta.comments ifs_invoice_no,
         rcta.attribute1 ifs_other_reference
from ra_customer_trx_all rcta
where rcta.trx_date between '01-FEB-2017' AND '28-FEB-2017'
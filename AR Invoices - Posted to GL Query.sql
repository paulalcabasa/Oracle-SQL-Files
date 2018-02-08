SELECT *
FROM RA_CUSTOMER_TRX_ALL;

select *
from ra_cust_trx_line_gl_dist_all;

select *
from gl_je_lines
where je_;


SELECT distinct --RCTLG.AMOUNT,
     --  AC.CUSTOMER_NUMBER,
    --   AC.CUSTOMER_NAME,
       RCX.TRX_NUMBER     ,
       gjh.doc_sequence_value
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
   and xal.gl_sl_link_id = gir.gl_sl_link_id(+)
   and gir.je_header_id = gjl.je_header_id
   and gir.je_line_num = gjl.je_line_num
   and rcx.trx_number = '5010'
   AND GIR.JE_HEADER_ID = GJH.JE_HEADER_ID
   AND GJL.JE_HEADER_ID = GJH.JE_HEADER_ID

   ;
   
   select *
   from xla_ae_headers;
   
   select *
   from mtl_serial_numbers
   where current_organization_id = 121
   and lot_number = 'DXTLE-50';
   
   select current_organization_id,
            serial_number
   from mtl_serial_numbers
    where  current_organization_id = 121
    and serial_number = 'CS5858';
   and serial_number in ('CQ3479',
'CR4664',
'CR3968',
'CR5145',
'CR5146',
'CR4663',
'CQ3504',
'CQ3506',
'CQ3498',
'CQ3499',
'CQ3505',
'CQ3502',
'CQ3500',
'CQ3503',
'CQ3497',
'CQ3501',
'CR4666',
'CR4669',
'CR3969',
'CR4667',
'CR4668',
'CR4665',
'CR5148',
'CR5147',
'CR5149',
'CR5306',
'CQ3491',
'CQ3494',
'CQ3495',
'CQ3496',
'CQ3493',
'CQ3487',
'CQ3489',
'CQ3488',
'CQ3492',
'CQ3490',
'CR2895',
'CR2896',
'CR4404',
'CR4407',
'CR4402',
'CR2898',
'CR2893',
'CR2900',
'CR4403',
'CR2897',
'CR4405',
'CR2894',
'CR4401',
'CR2899',
'CR4406',
'CQ3483',
'CQ3486',
'CQ3485',
'CQ3484',
'CQ3482',
'CT0874',
'CT0883',
'CT0878',
'CT0871',
'CT0882',
'CT0876',
'CT0884',
'DOA034',
'DOA043',
'DOA041',
'DOA046',
'DOA038',
'DOA033',
'DOA032',
'DOA035',
'DOA036',
'CT0880',
'CT0881',
'DOA044',
'DOA039',
'CT0885',
'CT0873',
'DOA042',
'CT0879',
'CT0877',
'CT0872',
'DOA037',
'DOA040',
'CT0875',
'DOA045',
'CT0887',
'CT0894',
'CT0891',
'CT0897',
'CT0892',
'CT0900',
'CT0895',
'DOA049',
'DOA054',
'DOA058',
'DOA050',
'DOA053',
'DOA055',
'CT0889',
'DOA052',
'CT0890',
'CT0893',
'CT0886',
'DOA059',
'CT0899',
'DOA047',
'CT0888',
'CT0898');
   
   select  b.TRX_NUMBER orig_trx_number, b.customer_trx_id orig_trx_id, b.attribute3 orig_cs_no, a.trx_number cm_trx_number, a.customer_trx_id cm_trx_id, a.attribute3 cm_cs_no
from ra_customer_trx_all a,
ra_customer_trx_all b
where a.previous_customer_trx_id = b.customer_trx_id;


   CREATE TABLE IPC_DEALERS (
        ID INT,
        DEALER_CODE VARCHAR2(10),
        MOTHER_DEALER_CODE VARCHAR2(10)
   );
   
   SELECT *
   FROM IPC_DEALERS;
   
   
   
   
   select *
   from ar_cash_receipts_all
   where status = 'UNID'
   AND AMOUNT <> 0;
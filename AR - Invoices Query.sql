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

select rcta.trx_number,
           to_char(rcta.trx_date) invoice_date,
           to_char(apsa.gl_date) gl_date
from ra_customer_trx_all rcta,
         ar_payment_schedules_all apsa
where 1 = 1
        and rcta.trx_number = apsa.trx_number
        and rcta.trx_number IN ('40200009608',
'40200009609',
'40200009610',
'40200009612',
'40200009630',
'40200009631',
'40200009632',
'40200009633',
'40200009634',
'40200009635',
'40200009636',
'40200009637',
'40200009638',
'40200009639',
'40200009640',
'40200009641',
'40200009642',
'40200009644',
'40200009646',
'40200009647',
'40200009648',
'40200009649',
'40200009650',
'40200009651',
'40200009652',
'40200009691',
'40200009692',
'40200009693',
'40200009694',
'40200009695',
'40200009696',
'40200009697',
'40200009698',
'40200009699',
'40200009700',
'40200009701',
'40200009702',
'40200009703',
'40200009704',
'40200009705',
'40200009706',
'40200009707',
'40200009708',
'40200009709',
'40200009710',
'40200009711',
'40200009712',
'40200009713',
'40200009714',
'40200009715',
'40200009716',
'40200009717',
'40200009718',
'40200009719',
'40200009720',
'40200009721',
'40200009722',
'40200009723',
'40200009724',
'40200009725',
'40200009726',
'40200009727',
'40200009728',
'40200009729',
'40200009730',
'40200009731',
'40200009732',
'40200009733',
'40200009734',
'40200009735',
'40200009736',
'40200009737',
'40200009738',
'40200009739',
'40200009740',
'40200009741',
'40200009742',
'40200009743',
'40200009744',
'40200009745',
'40200009746',
'40200009747',
'40200009748',
'40200009749',
'40200009751',
'40200009752',
'40200009753',
'40200009754',
'40200009755',
'40200009756',
'40200009757',
'40200009763',
'40200009764',
'40200009765',
'40200009766',
'40200009767',
'40200009768',
'40200009769',
'40200009770',
'40200009771',
'40200009772',
'40200009773',
'40200009774',
'40200009775',
'40200009776',
'40200009777',
'40200009778',
'40200009779',
'40200009780',
'40200009781',
'40200009782',
'40200009783',
'40200009784',
'40200009785',
'40200009786',
'40200009787',
'40200009788',
'40200009789',
'40200009790',
'40200009791',
'40200009792',
'40200009793',
'40200009794',
'40200009795',
'40200009796',
'40200009797',
'40200009798',
'40200009799',
'40200009800',
'40200009801',
'40200009802',
'40200009803',
'40200009804',
'40200009805',
'40200009806',
'40200009886',
'40200009887',
'40200009888',
'40200009889',
'40200009890',
'40200009901',
'40200009902',
'40200009903',
'40200009904',
'40200009905',
'40200009906',
'40200009907',
'40200009908',
'40200009909',
'40200009910',
'40200009911',
'40200009912',
'40200009913',
'40200009914',
'40200009915',
'40200009916',
'40200009917',
'40200009918',
'40200009919',
'40200009920',
'40200009921',
'40200009922',
'40200009923',
'40200010058',
'40200010059',
'40200010060',
'40200010061',
'40200010062',
'40200009618',
'40200009619',
'40200009653',
'40200009760',
'40200009761',
'40200009807',
'40200009808',
'40200009809',
'40200009810',
'40200009811',
'40200009812',
'40200009813',
'40200009814',
'40200009815',
'40200009816',
'40200009817',
'40200009818',
'40200009819',
'40200009820',
'40200009821',
'40200009822',
'40200009823',
'40200009824',
'40200009827',
'40200009828',
'40200009829',
'40200009830',
'40200009831',
'40200009832',
'40200009833',
'40200009834',
'40200009835',
'40200009836',
'40200009837',
'40200009838',
'40200009839',
'40200009840',
'40200009841',
'40200010128',
'40200010129',
'40200010130',
'40200010131',
'40200010132',
'40200010133',
'40200010134',
'40200010135',
'40200010136',
'40200010137',
'40200010138',
'40200010139',
'40200010140',
'40200010141',
'40200010142',
'40200010143',
'40200010144',
'40200010145',
'40200010146',
'40200010147',
'40200010148',
'40200010149',
'40200010150',
'40200010151',
'40200010152',
'40200010153',
'40200010154',
'40200010155',
'40200010156',
'40200010157',
'40200010158',
'40200010159',
'40200010160',
'40200010161',
'40200010162',
'40200010163',
'40200010164',
'40200010165',
'40200010166',
'40200010167',
'40200010168',
'40200010169',
'40200010170',
'40200010171',
'40200010172',
'40200010173',
'40200010174',
'40200010175',
'40200010176',
'40200010177',
'40200010178',
'40200010179',
'40200010180',
'40200010181',
'40200010182',
'40200010183',
'40200010184',
'40200010185',
'40200010186',
'40200010187',
'40200010188',
'40200010189',
'40200010190',
'40200010191',
'40200010192',
'40200010193',
'40200010194',
'40200010195',
'40200010196',
'40200010197',
'40200010198',
'40200010199',
'40200010200',
'40200010201',
'40200010202',
'40200010203',
'40200010204',
'40200010205',
'40200010206',
'40200010207',
'40200010208',
'40200010209',
'40200010210',
'40200010211',
'40200010212',
'40200010213',
'40200009842',
'40200009843',
'40200009844',
'40200009845',
'40200009846',
'40200009847',
'40200009891',
'40200009892',
'40200009893',
'40200009894',
'40200009895',
'40200009896',
'40200009897',
'40200009898',
'40200009899',
'40200009900',
'40200009925',
'40200009926',
'40200009927',
'40200009928',
'40200009929',
'40200009930',
'40200009931',
'40200009932',
'40200009933',
'40200009958',
'40200009959',
'40200009960',
'40200009961',
'40200009962',
'40200009963',
'40200009964',
'40200009965',
'40200009966',
'40200009967',
'40200009968',
'40200009969',
'40200009970',
'40200009971',
'40200009972',
'40200009973',
'40200009974',
'40200009975',
'40200009976',
'40200009977',
'40200009978',
'40200009979',
'40200009980',
'40200009981',
'40200009982',
'40200009983',
'40200009984',
'40200009985',
'40200009986',
'40200009987',
'40200009988',
'40200009989',
'40200009990',
'40200009991',
'40200009992',
'40200009993',
'40200009994',
'40200009995',
'40200009996',
'40200009997',
'40200009998',
'40200009999',
'40200010000',
'40200010001',
'40200010002',
'40200010003',
'40200010004',
'40200010005',
'40200010006',
'40200010007',
'40200010008',
'40200010009',
'40200010010',
'40200010011',
'40200010012',
'40200010013',
'40200010014',
'40200010015',
'40200010016',
'40200010017',
'40200010018',
'40200010019',
'40200010020',
'40200010021',
'40200010022',
'40200010023',
'40200010024',
'40200010025',
'40200010026',
'40200010027',
'40200010028',
'40200010029',
'40200010030',
'40200010031',
'40200010032',
'40200010033',
'40200010034',
'40200010035',
'40200010036',
'40200010037',
'40200010038',
'40200010039',
'40200010040',
'40200010041',
'40200010042',
'40200010043',
'40200010044',
'40200010045',
'40200010046',
'40200010047',
'40200010048',
'40200010049',
'40200010050',
'40200010051',
'40200010052',
'40200010063',
'40200010064',
'40200010065',
'40200010066',
'40200010067',
'40200010068',
'40200010069',
'40200010070',
'40200010071',
'40200010072',
'40200010073',
'40200010074',
'40200010075',
'40200010076',
'40200010077',
'40200010078',
'40200010079',
'40200010080',
'40200010081',
'40200010082',
'40200010083',
'40200010084',
'40200010085',
'40200010086',
'40200010087',
'40200010088',
'40200010089',
'40200010090',
'40200010091',
'40200010092',
'40200010093',
'40200010094',
'40200010095',
'40200010096',
'40200010097',
'40200010098',
'40200010099',
'40200010100',
'40200010101',
'40200010102',
'40200010103',
'40200010104',
'40200010105',
'40200010106',
'40200010107',
'40200010108',
'40200010109',
'40200010110',
'40200010111',
'40200010112',
'40200010113',
'40200010114',
'40200010115',
'40200010116',
'40200010117',
'40200010118',
'40200010119',
'40200010120',
'40200010121',
'40200010122',
'40200010123',
'40200010124',
'40200010125',
'40200010126',
'40200010127',
'40200010214',
'40200010215',
'40200010216',
'40200010217',
'40200010218',
'40200010219',
'40200010220',
'40200010221',
'40200010222',
'40200010223',
'40200010224',
'40200010225',
'40200010226',
'40200010227',
'40200010228',
'40200010229',
'40200010230',
'40200010231',
'40200010232',
'40200010233',
'40200010234',
'40200010235',
'40200010236',
'40200010237',
'40200010238',
'40200010239',
'40200010240',
'40200010241',
'40200010242',
'40200010243',
'40200010244',
'40200010245',
'40200010246',
'40200010247',
'40200010248',
'40200010249',
'40200010250',
'40200010251',
'40200010252',
'40200010253',
'40200010254',
'40200010255',
'40200010256',
'40200010257',
'40200010269',
'40200010270',
'40200010271',
'40200010272',
'40200010273',
'40200010274',
'40200010275',
'40200010276',
'40200010277',
'40200010278',
'40200010279',
'40200010280',
'40200010281',
'40200010282',
'40200010283');

    
SELECT RCTLG.AMOUNT,
      AC.CUSTOMER_NUMBER,
      AC.CUSTOMER_NAME,
       RCX.TRX_NUMBER     
       to_char(rcx.trx_date) invoice_date,
        to_char(apsa.gl_date) gl_date,
       gjh.JE_HEADER_ID,
       gjh.doc_sequence_value
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


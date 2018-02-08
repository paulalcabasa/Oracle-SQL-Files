select rcta.attribute3 cs_no,
            msn.attribute1 part_no,
            msn.attribute2 description,
            msn.attribute15 color,
            rcta.trx_number invoice_no,
            TO_CHAR(rcta.trx_date) invoice_date,
            INTERFACE_HEADER_ATTRIBUTE1,
            rctal.sales_order_line,
            line_type
       
from ra_customer_trx_all rcta,
        ra_cust_trx_types_all rctta,
        mtl_serial_numbers msn,
        ra_customer_trx_lines_all rctal
where 1 = 1
          and rcta.trx_number like '403%'
          and rctal.customer_trx_id = rcta.customer_trx_id
          and rcta.trx_number not in (select orig_trx_number from IPC_AR_INVOICES_WITH_CM)
     --     and rctta.name = 'Invoice-Vehicle'
          and rctta.cust_trx_type_id  = rcta.cust_trx_type_id
          and msn.serial_number(+) = rcta.attribute3 
          and line_type = 'LINE'
   --      and rcta.attribute3 = 'CO6774'
          ;

select current_organization_id, 
         msib.segment1, 
         msib.description, 
         current_subinventory_code, 
         cs_no, 
         serial_number
from vehicle_master@ifs_oracle.isuzu.local ifs_vms,
     mtl_serial_numbers msn,
     mtl_system_items msib
where ifs_vms.cs_no = msn.serial_number(+)
and msn.inventory_item_id = msib.inventory_item_id(+)
and current_organization_id = msib.organization_id(+)
and act_prod_n_end is not null
and invoice_no is null
;


CR3471



select    substr(rcta.comments,1,9) ifs_reference,
            rcta.attribute1,
            rcta.attribute2,
            rcta.trx_number invoice_no,
            TO_CHAR(rcta.trx_date) invoice_date,
            rcta.attribute3 cs_no,
            rctta.name
from ra_customer_trx_all rcta,
        ra_cust_trx_types_all rctta
where 1 = 1
          and rcta.trx_number not in (select orig_trx_number from IPC_AR_INVOICES_WITH_CM)
          and rctta.cust_trx_type_id  = rcta.cust_trx_type_id;
     --     and rctta.name = 'Invoice-Vehicle'
     --     and rcta.trx_number like '403%';
     --    and rcta.comments = '980243288';
   --      and rcta.attribute3 = 'CO6774'
   
   
   select COMMENTS,ATTRIBUTE1,TRX_NUMBER
   from ra_customer_trx_all
   where TRX_NUMBER IN('2010005788',
'9737948',
'9737949',
'9737950',
'9737951',
'9737952',
'9737915',
'9737916',
'2010005771',
'2010005772',
'2010005782',
'2010005768',
'9737881',
'1296',
'2025',
'980239490',
'980239488',
'980239486',
'980239485',
'980239496',
'980239495',
'980239493',
'980239492',
'980239483',
'980239481',
'980239480',
'980239471',
'980239469',
'980239467',
'9737869',
'980243667',
'2010005754',
'9737870',
'9737871',
'9737872',
'9737873',
'9737917',
'980239465',
'980239477',
'980239475',
'980239473',
'980239472',
'980239981',
'980239980',
'9737882',
'980240081',
'9737883',
'9737884',
'9737885',
'9737845',
'2010005745',
'2010005753',
'980243741',
'2010005773',
'9737919',
'9737886',
'9737887',
'9737888',
'9737874',
'9737875',
'980243516',
'2010005755',
'2010005756',
'9737846',
'980239449',
'980239503',
'980239502',
'980239500',
'980239498',
'9737858',
'9737859',
'9737889',
'9737890',
'9737891',
'9737876',
'980239653',
'980239652',
'980239455',
'980239454',
'980239450',
'980239452',
'980239573',
'9737909',
'2010005770',
'9737920',
'980243780',
'9737921',
'9737922',
'9737923',
'9737860',
'9737861',
'9737862',
'9737863',
'9737864',
'9737865',
'2010005763',
'9737892',
'9737893',
'980239572',
'980239570',
'980239568',
'980239463',
'980239461',
'980239459',
'980239457',
'2010005767',
'9737877',
'9737847',
'9737848',
'9737849',
'9737850',
'9737851',
'980239971',
'980239970',
'9737895',
'1297',
'2005',
'9737924',
'9737925',
'9737926',
'9737927',
'9737928',
'9737929',
'2010005774',
'2010005775',
'2010005764',
'2010005769',
'9737878',
'9737879',
'9737852',
'9737853',
'9737854',
'2004',
'9737896',
'9737897',
'9737898',
'9737899',
'9737900',
'2010005776',
'2010005777',
'2010005778',
'2010005779',
'2010005780',
'2010005781',
'9737930',
'9737866',
'2010005765',
'2021',
'9737867',
'9737868',
'9737894',
'9737880',
'980242762',
'9737855',
'2010005783',
'2031',
'9737943',
'2010005789',
'2010005766',
'9737856',
'2010005757',
'2010005758',
'2010005759',
'2010005760',
'2010005761',
'2010005762',
'9737901',
'9737902',
'9737937',
'980243005',
'2023',
'2024',
'9737903',
'9737904',
'9737905',
'980239395',
'9737931',
'9737932',
'9737938',
'9737944',
'980239418',
'9737945',
'980239444',
'980239443',
'980239442',
'980239441',
'980243780',
'9737921',
'980239415',
'980239417',
'980239412',
'980239410',
'980239414',
'980239440',
'980239438',
'980239436',
'980239435',
'9737946',
'2010005793',
'2010005794',
'980242763',
'980242761',
'9737906',
'980239398',
'980239397',
'9737907',
'9737908',
'9737933',
'9737934',
'9737939',
'2010005790',
'1974',
'1971',
'1970',
'1968',
'1965',
'1964',
'1963',
'1962',
'1932',
'1931',
'1930',
'1926',
'1925',
'1873',
'9737947',
'9737910',
'9737911',
'9737912',
'980239789',
'9737913',
'9737935',
'9737941',
'2010005784',
'2010005785',
'2010005786',
'2010005787',
'2010005792',
'9737914',
'9737936',
'9738113',
'9738114',
'9738115',
'9738116',
'9738052',
'9738062',
'9738063',
'9738064',
'9738103',
'980234264',
'980234263',
'980234262',
'980234261',
'980234260',
'980234259',
'980234258',
'980234257',
'980234256',
'980234255',
'980234254',
'980234253',
'980234252',
'980234251',
'980234250',
'980234249',
'980234248',
'980234247',
'980234246',
'980234245',
'980234244',
'980234243',
'980234242',
'980234241',
'980234240',
'9738117',
'9738118',
'9738119',
'2010005907',
'2010005881',
'2010005908',
'2010005909',
'2010005910',
'2010005911',
'2010005849',
'2010005850',
'2010005851',
'2010005852',
'2010005853',
'2010005854',
'2010005855',
'2010005856',
'2010005857',
'2010005858',
'9738065',
'2010005861',
'1287',
'1288',
'1300',
'9738104',
'9738105',
'9738106',
'1277',
'1276',
'1969',
'1890',
'9738121',
'9738122',
'9738123',
'9738066',
'2010005862',
'980236582',
'980234825',
'9738107',
'2010005887',
'2010005916',
'2010005917',
'9738143',
'2010005821',
'2010005822',
'2010005823',
'2010005824',
'2010005825',
'2010005827',
'2010005828',
'2010005836',
'9737996',
'9737997',
'9737998',
'2010005837',
'9738068',
'9738069',
'2010005863',
'2010005864',
'9738071',
'9737986',
'9737987',
'2010005830',
'2010005831',
'2010005832',
'1271',
'2010005888',
'2010005889',
'2010005890',
'2010005891',
'2010005892',
'2010005893',
'2010005894',
'2010005895',
'2010005896',
'2010005897',
'2010005902',
'2010005903',
'2010005904',
'2010005905',
'9738144',
'9738145',
'1302',
'980240300',
'980240299',
'980240298',
'980240297',
'980240296',
'980240295',
'980240294',
'980240293',
'9737967',
'2034',
'9738000',
'9738001',
'9738072',
'9738073',
'1272',
'980239759',
'980239758',
'980239757',
'9737988',
'9737989',
'9737990',
'9737991',
'2010005847',
'2010005848',
'980234239',
'980234238',
'2010005613',
'2010005612',
'2010005545',
'2010005544',
'2010005532',
'2010005531',
'9737953',
'9737954',
'9737955',
'9737956',
'9737957',
'9738146',
'9737968',
'980239426',
'980239424',
'980239423',
'980239421',
'980239448',
'980239447',
'980239446',
'980239445',
'980239432',
'980239431',
'980239429',
'980239427',
'9738074',
'9738075',
'9738076',
'9737992',
'9738055',
'980239770',
'980239921',
'980234237',
'980234236',
'980234235',
'980234234',
'980234233',
'980234231',
'980234230',
'980234229',
'980234129',
'980234128',
'980234127',
'980234123',
'980234122',
'980234121',
'980234120',
'980234119',
'980234118',
'980234115',
'980234113',
'980234112',
'980234107',
'980234105',
'980234104',
'980234102',
'980234100',
'980234099',
'980234097',
'980234096',
'980234094',
'980234092',
'980234091',
'980234089',
'980234087',
'980234086',
'980234085',
'980234083',
'9737958',
'9737959',
'9737960',
'1306',
'980242402',
'980242192',
'980242191',
'980242190',
'9738022',
'9738023',
'9738024',
'2036',
'2010005865',
'9738077',
'9738078',
'9738079',
'9738080',
'9738081',
'9738082',
'9738083',
'9737993',
'9737994',
'2010005833',
'2010005834',
'2010005835',
'9738086',
'2010005871',
'2040',
'9738087',
'2010004941',
'2010004940',
'2010004880',
'2010004879',
'2010004098',
'2010004006',
'2010003857',
'2010003792',
'980234081',
'980234079',
'980234077',
'980234076',
'980234073',
'980234071',
'980234069',
'9738125',
'1237',
'9737961',
'9737962',
'9737963',
'9737964',
'9738147',
'980240230',
'980240231',
'980240229',
'9738025',
'2010005838',
'2019',
'2016',
'9737969',
'9737970',
'9737971',
'9737972',
'9737973',
'2010005571',
'2010005502',
'9737974',
'9737975',
'9738002',
'9738003',
'9738004',
'9738005',
'9738006',
'9738007',
'9738084',
'9738085',
'2010005866',
'2010005867',
'2010005868',
'2010005869',
'2010005870',
'2010003790',
'2010003788',
'2010005651',
'2010005638',
'2010005636',
'2010005634',
'2010005632',
'2010005630',
'2010005594',
'2010005529',
'2010005528',
'2010005527',
'2010005526',
'2010005525',
'2010005524',
'2010005523',
'2010005522',
'2010005521',
'2010005520',
'2010005511',
'2010005508',
'2010005164',
'2010005163',
'2010005162',
'2010005161',
'2010005160',
'9737965',
'9737966',
'980244268',
'2010005791',
'2010005795',
'9738148',
'9738149',
'9738026',
'9738027',
'9738028',
'9738029',
'9738030',
'9738031',
'9738032',
'9738033',
'9738034',
'9737976',
'9737977',
'9737978',
'9737979',
'9737980',
'9737981',
'9737982',
'9737983',
'9738008',
'9738009',
'9738010',
'9738011',
'9738094',
'9738095',
'2010005872',
'2041',
'9738127',
'9738128',
'2010005914',
'2010005796',
'2010005797',
'2010005798',
'2010005799',
'2010005800',
'2010005801',
'2010005802',
'2010005803',
'2010005804',
'2010005805',
'9738150',
'9738151',
'9738035',
'9738036',
'9738037',
'9738038',
'9738039',
'9738040',
'9738041',
'9737984',
'2010005829',
'9738012',
'980239938',
'980239937',
'980239936',
'9738013',
'9738014',
'9738015',
'9738096',
'9738097',
'980240232',
'980240233',
'9738088',
'9738089',
'9738090',
'980240125',
'9738130',
'980240059',
'980240058',
'9738131',
'9738132',
'9738133',
'9738134',
'2010005806',
'2010005807',
'2010005808',
'2010005809',
'2010005810',
'2010005811',
'2010005812',
'2010005813',
'2010005814',
'9738152',
'9738153',
'9737985',
'9738016',
'9738017',
'9738098',
'2010005882',
'9738091',
'9738092',
'9738135',
'9738136',
'9738137',
'9738138',
'9738139',
'9738140',
'2010005816',
'2010005817',
'2010005818',
'2010005819',
'2010005820',
'2010005906',
'9738154',
'9738042',
'9738043',
'9738044',
'9738045',
'9738046',
'2010005839',
'2010005840',
'9738018',
'9738099',
'2010005915',
'2010005815',
'1307',
'9738110',
'2010005841',
'2010005842',
'9738019',
'9738093',
'2010005873',
'2010005874',
'2010005875',
'2010005876',
'2010005877',
'2010005878',
'2010005879',
'1977',
'1976',
'2010005880',
'9738141',
'9738142',
'9738111',
'9738112',
'980239750',
'980239749',
'980239748',
'2010005843',
'2010005844',
'2010005845',
'9738020',
'9738021',
'9738058',
'9738059',
'2010005859',
'2037',
'2010005860',
'2010',
'9738100',
'9738101',
'2010005883',
'2010005884',
'2010005885',
'2010005886',
'2010005898',
'2010005899',
'2010005900',
'2010005901',
'2010005846',
'9738061',
'2017',
'9738102');
   
   select COMMENTS,ATTRIBUTE1,TRX_NUMBER
   from ra_customer_trx_all
   where COMMENTS IN('2010005788',
'9737948',
'9737949',
'9737950',
'9737951',
'9737952',
'9737915',
'9737916',
'2010005771',
'2010005772',
'2010005782',
'2010005768',
'9737881',
'1296',
'2025',
'980239490',
'980239488',
'980239486',
'980239485',
'980239496',
'980239495',
'980239493',
'980239492',
'980239483',
'980239481',
'980239480',
'980239471',
'980239469',
'980239467',
'9737869',
'980243667',
'2010005754',
'9737870',
'9737871',
'9737872',
'9737873',
'9737917',
'980239465',
'980239477',
'980239475',
'980239473',
'980239472',
'980239981',
'980239980',
'9737882',
'980240081',
'9737883',
'9737884',
'9737885',
'9737845',
'2010005745',
'2010005753',
'980243741',
'2010005773',
'9737919',
'9737886',
'9737887',
'9737888',
'9737874',
'9737875',
'980243516',
'2010005755',
'2010005756',
'9737846',
'980239449',
'980239503',
'980239502',
'980239500',
'980239498',
'9737858',
'9737859',
'9737889',
'9737890',
'9737891',
'9737876',
'980239653',
'980239652',
'980239455',
'980239454',
'980239450',
'980239452',
'980239573',
'9737909',
'2010005770',
'9737920',
'980243780',
'9737921',
'9737922',
'9737923',
'9737860',
'9737861',
'9737862',
'9737863',
'9737864',
'9737865',
'2010005763',
'9737892',
'9737893',
'980239572',
'980239570',
'980239568',
'980239463',
'980239461',
'980239459',
'980239457',
'2010005767',
'9737877',
'9737847',
'9737848',
'9737849',
'9737850',
'9737851',
'980239971',
'980239970',
'9737895',
'1297',
'2005',
'9737924',
'9737925',
'9737926',
'9737927',
'9737928',
'9737929',
'2010005774',
'2010005775',
'2010005764',
'2010005769',
'9737878',
'9737879',
'9737852',
'9737853',
'9737854',
'2004',
'9737896',
'9737897',
'9737898',
'9737899',
'9737900',
'2010005776',
'2010005777',
'2010005778',
'2010005779',
'2010005780',
'2010005781',
'9737930',
'9737866',
'2010005765',
'2021',
'9737867',
'9737868',
'9737894',
'9737880',
'980242762',
'9737855',
'2010005783',
'2031',
'9737943',
'2010005789',
'2010005766',
'9737856',
'2010005757',
'2010005758',
'2010005759',
'2010005760',
'2010005761',
'2010005762',
'9737901',
'9737902',
'9737937',
'980243005',
'2023',
'2024',
'9737903',
'9737904',
'9737905',
'980239395',
'9737931',
'9737932',
'9737938',
'9737944',
'980239418',
'9737945',
'980239444',
'980239443',
'980239442',
'980239441',
'980243780',
'9737921',
'980239415',
'980239417',
'980239412',
'980239410',
'980239414',
'980239440',
'980239438',
'980239436',
'980239435',
'9737946',
'2010005793',
'2010005794',
'980242763',
'980242761',
'9737906',
'980239398',
'980239397',
'9737907',
'9737908',
'9737933',
'9737934',
'9737939',
'2010005790',
'1974',
'1971',
'1970',
'1968',
'1965',
'1964',
'1963',
'1962',
'1932',
'1931',
'1930',
'1926',
'1925',
'1873',
'9737947',
'9737910',
'9737911',
'9737912',
'980239789',
'9737913',
'9737935',
'9737941',
'2010005784',
'2010005785',
'2010005786',
'2010005787',
'2010005792',
'9737914',
'9737936',
'9738113',
'9738114',
'9738115',
'9738116',
'9738052',
'9738062',
'9738063',
'9738064',
'9738103',
'980234264',
'980234263',
'980234262',
'980234261',
'980234260',
'980234259',
'980234258',
'980234257',
'980234256',
'980234255',
'980234254',
'980234253',
'980234252',
'980234251',
'980234250',
'980234249',
'980234248',
'980234247',
'980234246',
'980234245',
'980234244',
'980234243',
'980234242',
'980234241',
'980234240',
'9738117',
'9738118',
'9738119',
'2010005907',
'2010005881',
'2010005908',
'2010005909',
'2010005910',
'2010005911',
'2010005849',
'2010005850',
'2010005851',
'2010005852',
'2010005853',
'2010005854',
'2010005855',
'2010005856',
'2010005857',
'2010005858',
'9738065',
'2010005861',
'1287',
'1288',
'1300',
'9738104',
'9738105',
'9738106',
'1277',
'1276',
'1969',
'1890',
'9738121',
'9738122',
'9738123',
'9738066',
'2010005862',
'980236582',
'980234825',
'9738107',
'2010005887',
'2010005916',
'2010005917',
'9738143',
'2010005821',
'2010005822',
'2010005823',
'2010005824',
'2010005825',
'2010005827',
'2010005828',
'2010005836',
'9737996',
'9737997',
'9737998',
'2010005837',
'9738068',
'9738069',
'2010005863',
'2010005864',
'9738071',
'9737986',
'9737987',
'2010005830',
'2010005831',
'2010005832',
'1271',
'2010005888',
'2010005889',
'2010005890',
'2010005891',
'2010005892',
'2010005893',
'2010005894',
'2010005895',
'2010005896',
'2010005897',
'2010005902',
'2010005903',
'2010005904',
'2010005905',
'9738144',
'9738145',
'1302',
'980240300',
'980240299',
'980240298',
'980240297',
'980240296',
'980240295',
'980240294',
'980240293',
'9737967',
'2034',
'9738000',
'9738001',
'9738072',
'9738073',
'1272',
'980239759',
'980239758',
'980239757',
'9737988',
'9737989',
'9737990',
'9737991',
'2010005847',
'2010005848',
'980234239',
'980234238',
'2010005613',
'2010005612',
'2010005545',
'2010005544',
'2010005532',
'2010005531',
'9737953',
'9737954',
'9737955',
'9737956',
'9737957',
'9738146',
'9737968',
'980239426',
'980239424',
'980239423',
'980239421',
'980239448',
'980239447',
'980239446',
'980239445',
'980239432',
'980239431',
'980239429',
'980239427',
'9738074',
'9738075',
'9738076',
'9737992',
'9738055',
'980239770',
'980239921',
'980234237',
'980234236',
'980234235',
'980234234',
'980234233',
'980234231',
'980234230',
'980234229',
'980234129',
'980234128',
'980234127',
'980234123',
'980234122',
'980234121',
'980234120',
'980234119',
'980234118',
'980234115',
'980234113',
'980234112',
'980234107',
'980234105',
'980234104',
'980234102',
'980234100',
'980234099',
'980234097',
'980234096',
'980234094',
'980234092',
'980234091',
'980234089',
'980234087',
'980234086',
'980234085',
'980234083',
'9737958',
'9737959',
'9737960',
'1306',
'980242402',
'980242192',
'980242191',
'980242190',
'9738022',
'9738023',
'9738024',
'2036',
'2010005865',
'9738077',
'9738078',
'9738079',
'9738080',
'9738081',
'9738082',
'9738083',
'9737993',
'9737994',
'2010005833',
'2010005834',
'2010005835',
'9738086',
'2010005871',
'2040',
'9738087',
'2010004941',
'2010004940',
'2010004880',
'2010004879',
'2010004098',
'2010004006',
'2010003857',
'2010003792',
'980234081',
'980234079',
'980234077',
'980234076',
'980234073',
'980234071',
'980234069',
'9738125',
'1237',
'9737961',
'9737962',
'9737963',
'9737964',
'9738147',
'980240230',
'980240231',
'980240229',
'9738025',
'2010005838',
'2019',
'2016',
'9737969',
'9737970',
'9737971',
'9737972',
'9737973',
'2010005571',
'2010005502',
'9737974',
'9737975',
'9738002',
'9738003',
'9738004',
'9738005',
'9738006',
'9738007',
'9738084',
'9738085',
'2010005866',
'2010005867',
'2010005868',
'2010005869',
'2010005870',
'2010003790',
'2010003788',
'2010005651',
'2010005638',
'2010005636',
'2010005634',
'2010005632',
'2010005630',
'2010005594',
'2010005529',
'2010005528',
'2010005527',
'2010005526',
'2010005525',
'2010005524',
'2010005523',
'2010005522',
'2010005521',
'2010005520',
'2010005511',
'2010005508',
'2010005164',
'2010005163',
'2010005162',
'2010005161',
'2010005160',
'9737965',
'9737966',
'980244268',
'2010005791',
'2010005795',
'9738148',
'9738149',
'9738026',
'9738027',
'9738028',
'9738029',
'9738030',
'9738031',
'9738032',
'9738033',
'9738034',
'9737976',
'9737977',
'9737978',
'9737979',
'9737980',
'9737981',
'9737982',
'9737983',
'9738008',
'9738009',
'9738010',
'9738011',
'9738094',
'9738095',
'2010005872',
'2041',
'9738127',
'9738128',
'2010005914',
'2010005796',
'2010005797',
'2010005798',
'2010005799',
'2010005800',
'2010005801',
'2010005802',
'2010005803',
'2010005804',
'2010005805',
'9738150',
'9738151',
'9738035',
'9738036',
'9738037',
'9738038',
'9738039',
'9738040',
'9738041',
'9737984',
'2010005829',
'9738012',
'980239938',
'980239937',
'980239936',
'9738013',
'9738014',
'9738015',
'9738096',
'9738097',
'980240232',
'980240233',
'9738088',
'9738089',
'9738090',
'980240125',
'9738130',
'980240059',
'980240058',
'9738131',
'9738132',
'9738133',
'9738134',
'2010005806',
'2010005807',
'2010005808',
'2010005809',
'2010005810',
'2010005811',
'2010005812',
'2010005813',
'2010005814',
'9738152',
'9738153',
'9737985',
'9738016',
'9738017',
'9738098',
'2010005882',
'9738091',
'9738092',
'9738135',
'9738136',
'9738137',
'9738138',
'9738139',
'9738140',
'2010005816',
'2010005817',
'2010005818',
'2010005819',
'2010005820',
'2010005906',
'9738154',
'9738042',
'9738043',
'9738044',
'9738045',
'9738046',
'2010005839',
'2010005840',
'9738018',
'9738099',
'2010005915',
'2010005815',
'1307',
'9738110',
'2010005841',
'2010005842',
'9738019',
'9738093',
'2010005873',
'2010005874',
'2010005875',
'2010005876',
'2010005877',
'2010005878',
'2010005879',
'1977',
'1976',
'2010005880',
'9738141',
'9738142',
'9738111',
'9738112',
'980239750',
'980239749',
'980239748',
'2010005843',
'2010005844',
'2010005845',
'9738020',
'9738021',
'9738058',
'9738059',
'2010005859',
'2037',
'2010005860',
'2010',
'9738100',
'9738101',
'2010005883',
'2010005884',
'2010005885',
'2010005886',
'2010005898',
'2010005899',
'2010005900',
'2010005901',
'2010005846',
'9738061',
'2017',
'9738102');
   
   select COMMENTS,ATTRIBUTE1,TRX_NUMBER
   from ra_customer_trx_all
   where ATTRIBUTE1 IN ('2010005788',
'9737948',
'9737949',
'9737950',
'9737951',
'9737952',
'9737915',
'9737916',
'2010005771',
'2010005772',
'2010005782',
'2010005768',
'9737881',
'1296',
'2025',
'980239490',
'980239488',
'980239486',
'980239485',
'980239496',
'980239495',
'980239493',
'980239492',
'980239483',
'980239481',
'980239480',
'980239471',
'980239469',
'980239467',
'9737869',
'980243667',
'2010005754',
'9737870',
'9737871',
'9737872',
'9737873',
'9737917',
'980239465',
'980239477',
'980239475',
'980239473',
'980239472',
'980239981',
'980239980',
'9737882',
'980240081',
'9737883',
'9737884',
'9737885',
'9737845',
'2010005745',
'2010005753',
'980243741',
'2010005773',
'9737919',
'9737886',
'9737887',
'9737888',
'9737874',
'9737875',
'980243516',
'2010005755',
'2010005756',
'9737846',
'980239449',
'980239503',
'980239502',
'980239500',
'980239498',
'9737858',
'9737859',
'9737889',
'9737890',
'9737891',
'9737876',
'980239653',
'980239652',
'980239455',
'980239454',
'980239450',
'980239452',
'980239573',
'9737909',
'2010005770',
'9737920',
'980243780',
'9737921',
'9737922',
'9737923',
'9737860',
'9737861',
'9737862',
'9737863',
'9737864',
'9737865',
'2010005763',
'9737892',
'9737893',
'980239572',
'980239570',
'980239568',
'980239463',
'980239461',
'980239459',
'980239457',
'2010005767',
'9737877',
'9737847',
'9737848',
'9737849',
'9737850',
'9737851',
'980239971',
'980239970',
'9737895',
'1297',
'2005',
'9737924',
'9737925',
'9737926',
'9737927',
'9737928',
'9737929',
'2010005774',
'2010005775',
'2010005764',
'2010005769',
'9737878',
'9737879',
'9737852',
'9737853',
'9737854',
'2004',
'9737896',
'9737897',
'9737898',
'9737899',
'9737900',
'2010005776',
'2010005777',
'2010005778',
'2010005779',
'2010005780',
'2010005781',
'9737930',
'9737866',
'2010005765',
'2021',
'9737867',
'9737868',
'9737894',
'9737880',
'980242762',
'9737855',
'2010005783',
'2031',
'9737943',
'2010005789',
'2010005766',
'9737856',
'2010005757',
'2010005758',
'2010005759',
'2010005760',
'2010005761',
'2010005762',
'9737901',
'9737902',
'9737937',
'980243005',
'2023',
'2024',
'9737903',
'9737904',
'9737905',
'980239395',
'9737931',
'9737932',
'9737938',
'9737944',
'980239418',
'9737945',
'980239444',
'980239443',
'980239442',
'980239441',
'980243780',
'9737921',
'980239415',
'980239417',
'980239412',
'980239410',
'980239414',
'980239440',
'980239438',
'980239436',
'980239435',
'9737946',
'2010005793',
'2010005794',
'980242763',
'980242761',
'9737906',
'980239398',
'980239397',
'9737907',
'9737908',
'9737933',
'9737934',
'9737939',
'2010005790',
'1974',
'1971',
'1970',
'1968',
'1965',
'1964',
'1963',
'1962',
'1932',
'1931',
'1930',
'1926',
'1925',
'1873',
'9737947',
'9737910',
'9737911',
'9737912',
'980239789',
'9737913',
'9737935',
'9737941',
'2010005784',
'2010005785',
'2010005786',
'2010005787',
'2010005792',
'9737914',
'9737936',
'9738113',
'9738114',
'9738115',
'9738116',
'9738052',
'9738062',
'9738063',
'9738064',
'9738103',
'980234264',
'980234263',
'980234262',
'980234261',
'980234260',
'980234259',
'980234258',
'980234257',
'980234256',
'980234255',
'980234254',
'980234253',
'980234252',
'980234251',
'980234250',
'980234249',
'980234248',
'980234247',
'980234246',
'980234245',
'980234244',
'980234243',
'980234242',
'980234241',
'980234240',
'9738117',
'9738118',
'9738119',
'2010005907',
'2010005881',
'2010005908',
'2010005909',
'2010005910',
'2010005911',
'2010005849',
'2010005850',
'2010005851',
'2010005852',
'2010005853',
'2010005854',
'2010005855',
'2010005856',
'2010005857',
'2010005858',
'9738065',
'2010005861',
'1287',
'1288',
'1300',
'9738104',
'9738105',
'9738106',
'1277',
'1276',
'1969',
'1890',
'9738121',
'9738122',
'9738123',
'9738066',
'2010005862',
'980236582',
'980234825',
'9738107',
'2010005887',
'2010005916',
'2010005917',
'9738143',
'2010005821',
'2010005822',
'2010005823',
'2010005824',
'2010005825',
'2010005827',
'2010005828',
'2010005836',
'9737996',
'9737997',
'9737998',
'2010005837',
'9738068',
'9738069',
'2010005863',
'2010005864',
'9738071',
'9737986',
'9737987',
'2010005830',
'2010005831',
'2010005832',
'1271',
'2010005888',
'2010005889',
'2010005890',
'2010005891',
'2010005892',
'2010005893',
'2010005894',
'2010005895',
'2010005896',
'2010005897',
'2010005902',
'2010005903',
'2010005904',
'2010005905',
'9738144',
'9738145',
'1302',
'980240300',
'980240299',
'980240298',
'980240297',
'980240296',
'980240295',
'980240294',
'980240293',
'9737967',
'2034',
'9738000',
'9738001',
'9738072',
'9738073',
'1272',
'980239759',
'980239758',
'980239757',
'9737988',
'9737989',
'9737990',
'9737991',
'2010005847',
'2010005848',
'980234239',
'980234238',
'2010005613',
'2010005612',
'2010005545',
'2010005544',
'2010005532',
'2010005531',
'9737953',
'9737954',
'9737955',
'9737956',
'9737957',
'9738146',
'9737968',
'980239426',
'980239424',
'980239423',
'980239421',
'980239448',
'980239447',
'980239446',
'980239445',
'980239432',
'980239431',
'980239429',
'980239427',
'9738074',
'9738075',
'9738076',
'9737992',
'9738055',
'980239770',
'980239921',
'980234237',
'980234236',
'980234235',
'980234234',
'980234233',
'980234231',
'980234230',
'980234229',
'980234129',
'980234128',
'980234127',
'980234123',
'980234122',
'980234121',
'980234120',
'980234119',
'980234118',
'980234115',
'980234113',
'980234112',
'980234107',
'980234105',
'980234104',
'980234102',
'980234100',
'980234099',
'980234097',
'980234096',
'980234094',
'980234092',
'980234091',
'980234089',
'980234087',
'980234086',
'980234085',
'980234083',
'9737958',
'9737959',
'9737960',
'1306',
'980242402',
'980242192',
'980242191',
'980242190',
'9738022',
'9738023',
'9738024',
'2036',
'2010005865',
'9738077',
'9738078',
'9738079',
'9738080',
'9738081',
'9738082',
'9738083',
'9737993',
'9737994',
'2010005833',
'2010005834',
'2010005835',
'9738086',
'2010005871',
'2040',
'9738087',
'2010004941',
'2010004940',
'2010004880',
'2010004879',
'2010004098',
'2010004006',
'2010003857',
'2010003792',
'980234081',
'980234079',
'980234077',
'980234076',
'980234073',
'980234071',
'980234069',
'9738125',
'1237',
'9737961',
'9737962',
'9737963',
'9737964',
'9738147',
'980240230',
'980240231',
'980240229',
'9738025',
'2010005838',
'2019',
'2016',
'9737969',
'9737970',
'9737971',
'9737972',
'9737973',
'2010005571',
'2010005502',
'9737974',
'9737975',
'9738002',
'9738003',
'9738004',
'9738005',
'9738006',
'9738007',
'9738084',
'9738085',
'2010005866',
'2010005867',
'2010005868',
'2010005869',
'2010005870',
'2010003790',
'2010003788',
'2010005651',
'2010005638',
'2010005636',
'2010005634',
'2010005632',
'2010005630',
'2010005594',
'2010005529',
'2010005528',
'2010005527',
'2010005526',
'2010005525',
'2010005524',
'2010005523',
'2010005522',
'2010005521',
'2010005520',
'2010005511',
'2010005508',
'2010005164',
'2010005163',
'2010005162',
'2010005161',
'2010005160',
'9737965',
'9737966',
'980244268',
'2010005791',
'2010005795',
'9738148',
'9738149',
'9738026',
'9738027',
'9738028',
'9738029',
'9738030',
'9738031',
'9738032',
'9738033',
'9738034',
'9737976',
'9737977',
'9737978',
'9737979',
'9737980',
'9737981',
'9737982',
'9737983',
'9738008',
'9738009',
'9738010',
'9738011',
'9738094',
'9738095',
'2010005872',
'2041',
'9738127',
'9738128',
'2010005914',
'2010005796',
'2010005797',
'2010005798',
'2010005799',
'2010005800',
'2010005801',
'2010005802',
'2010005803',
'2010005804',
'2010005805',
'9738150',
'9738151',
'9738035',
'9738036',
'9738037',
'9738038',
'9738039',
'9738040',
'9738041',
'9737984',
'2010005829',
'9738012',
'980239938',
'980239937',
'980239936',
'9738013',
'9738014',
'9738015',
'9738096',
'9738097',
'980240232',
'980240233',
'9738088',
'9738089',
'9738090',
'980240125',
'9738130',
'980240059',
'980240058',
'9738131',
'9738132',
'9738133',
'9738134',
'2010005806',
'2010005807',
'2010005808',
'2010005809',
'2010005810',
'2010005811',
'2010005812',
'2010005813',
'2010005814',
'9738152',
'9738153',
'9737985',
'9738016',
'9738017',
'9738098',
'2010005882',
'9738091',
'9738092',
'9738135',
'9738136',
'9738137',
'9738138',
'9738139',
'9738140',
'2010005816',
'2010005817',
'2010005818',
'2010005819',
'2010005820',
'2010005906',
'9738154',
'9738042',
'9738043',
'9738044',
'9738045',
'9738046',
'2010005839',
'2010005840',
'9738018',
'9738099',
'2010005915',
'2010005815',
'1307',
'9738110',
'2010005841',
'2010005842',
'9738019',
'9738093',
'2010005873',
'2010005874',
'2010005875',
'2010005876',
'2010005877',
'2010005878',
'2010005879',
'1977',
'1976',
'2010005880',
'9738141',
'9738142',
'9738111',
'9738112',
'980239750',
'980239749',
'980239748',
'2010005843',
'2010005844',
'2010005845',
'9738020',
'9738021',
'9738058',
'9738059',
'2010005859',
'2037',
'2010005860',
'2010',
'9738100',
'9738101',
'2010005883',
'2010005884',
'2010005885',
'2010005886',
'2010005898',
'2010005899',
'2010005900',
'2010005901',
'2010005846',
'9738061',
'2017',
'9738102');
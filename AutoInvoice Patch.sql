select *
from ra_customer_trx_all
where interface_header_attribute1 = '3010010850';
        
select request_id
from ra_interface_lines_all
where interface_line_attribute1 = '3010010850';
        
update ra_interface_lines_all
set request_id = NULL
where interface_line_attribute1 IN('3010004429',
'3010006608',
'3010005075',
'3010001668',
'3010002585',
'3010002594',
'3010002592',
'3010009102',
'3010001449',
'3010001450',
'3010006608',
'3010009410',
'3010005303',
'3010006606',
'3010006607',
'3010010023',
'3010015322',
'3010015330');
           
COMMIT;

SELECT *
FROM RA_CUSTOMER_TRX_ALL
WHERE INTERFACE_HEADER_ATTRIBUTE1 = '3010010850';
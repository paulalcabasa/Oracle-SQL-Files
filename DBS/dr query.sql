SELECT pl.picklist_no,
       pl.sales_order_no,
       pl.sales_order_type,
       pl.customer_name,
       pl.account_name,
       pl.customer_id,
       pll.line_no,
       pll.part_no,
       pll.part_description,
       pll.requested_quantity,
       apll.actual_quantity,
       dr.shipped_quantity,
       dr.dr_number
FROM (SELECT * FROM picklist_headers_tab WHERE picklist_source_id = 1 AND picklist_status = 1) pl
     INNER JOIN picklist_lines_tab pll
	ON pl.id = pll.picklist_header_id
     LEFT JOIN (SELECT * FROM picklist_headers_tab WHERE picklist_source_id = 2 AND picklist_status = 1) apl
	ON apl.picklist_no = pl.picklist_no
	AND apl.sales_order_no = pl.sales_order_no
     LEFT JOIN picklist_lines_tab apll
	ON apll.picklist_header_id = apl.id
	AND apll.part_no = pll.part_no
	AND apll.line_no = pll.line_no
     LEFT JOIN  delivery_receipt_tab dr
	ON pl.sales_order_no = dr.so_number
	AND pl.picklist_no = dr.picklist_number
	AND pll.line_no = dr.line_no
WHERE 1 = 1
GROUP BY 
      pll.line_no, pll.part_no,pl.picklist_no,pl.sales_order_no,dr.id;

SELECT *
FROM picklist_lines_tab
WHERE picklist_header_id = 7042;

SELECT *
FROM picklist_headers_tab
WHERE picklist_no = '585544';

select *
from delivery_receipt_tab
where picklist_number = '2058462';

select *
from employee_masterfile_tab
where employee_no = '';


select *
from overtime_request_employees
where request_id = 12033
and employee_no in ('963261',
'000326',
'000352',
'160727',
'000911',
'170806',
'170345',
'170465',
'000408',
'000361',
'000106',
'000106',
'001004',
'001207',
'170805',
'000388',
'963084',
'973551',
'000349',
'000319',
'963455',
'170716',
'151020',
'170925',
'963154',
'990815',
'963447',
'001003',
'963083',
'000902',
'000306',
'000392',
'151219',
'171004',
'963056',
'151028',
'963393',
'000912',
'170347',
'170718',
'170902',
'151024',
'963194',
'000406',
'000123');
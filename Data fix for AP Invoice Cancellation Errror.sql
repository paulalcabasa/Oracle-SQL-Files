select *
from ap_invoices_all
where invoice_id = 1115844;

select quantity_invoiced,unit_price
from ap_invoice_lines_all
where invoice_id = 1115844
and line_number = 2;

update ap_invoice_lines_all
set unit_price = null
where invoice_id = 1115844
and line_number = 2;


update ap_invoice_lines_all
set quantity_invoiced = null
where invoice_id = 1115844
and line_number = 2;
commit;


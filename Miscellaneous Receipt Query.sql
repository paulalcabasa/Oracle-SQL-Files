select *
from ra_interface_lines_all
where interface_line_attribute1 = '3010005012';


select 
        rctal.line_number,
     
    msib.segment1,
         msib.description,
         SUM(rctal.unit_selling_price),
         rctal.quantity_invoiced
    
from ra_customer_trx_lines_all rctal,
        mtl_system_items_b msib,
        ra_customer_trx_all rcta
where rctal.customer_trx_id = 382668
         and msib.inventory_item_id = rctal.inventory_item_id
         and rcta.customer_trX_id = rctal.customer_trx_id
         and rctal.interface_line_attribute10 = msib.organization_id
         and line_type = 'LINE'
group by 
         msib.segment1,
         msib.description,
         rctal.quantity_invoiced;

         select *
         from ra_customer_trx_all;
         
         select *
         from ra_customer_trx_lines_all;
         
         select *
         from hr_all_organization_units;
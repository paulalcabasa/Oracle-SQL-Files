select 
--ra_dist.*,
ooha.order_type_id,
rctal.CUSTOMER_TRX_LINE_ID,
rctal.CUSTOMER_TRX_ID,
ra_dist.account_class,
rcta.trx_number,
         rcta.trx_date,
         cust_bill_to.customer_number,
         cust_bill_to.party_name bill_to_customer,
         cust_bill_to.account_name bill_to_account_name,
         cust_bill_to.bill_to_address1,
         cust_ship_to.party_name bill_to_customer,
         cust_ship_to.account_name bill_to_account_name,
         cust_ship_to.bill_to_address1,
            rctal.line_number,
            rctal.sales_order,
            rctal.sales_order_line,
            rctal.inventory_item_id,
            msib.segment1 part_no,
         rctal.description,
              rctal.unit_standard_price,
            rctal.unit_selling_price,
         ra_dist.amount,
             rctal.quantity_invoiced,
         ra_dist.code_combination_id,
         gcc.segment6,
         gcc.concatenated_segments,
         rcta.DOC_SEQUENCE_VALUE,
         ra_dist.gl_date,
         ra_dist.org_id,
         org.NAME,
         rcta.interface_header_attribute1,
         ord_type.ord_type_name ORDER_TYPE,
          ord_type.ord_type_desc ORDER_TYPE_DESCRIPTION,
            cust_bill_to.*
from ra_cust_trx_line_gl_dist_all ra_dist,
     ra_customer_trx_all rcta,
     ra_customer_trx_lines_all rctal,
    gl_code_combinations_kfv gcc,
    hr_all_organization_units org,
    XXIPC_CUSTOMER_DETAIL_V cust_bill_to,
    XXIPC_CUSTOMER_DETAIL_V cust_ship_to,
    mtl_system_items_b msib,
    oe_order_headers_all ooha,
  XXORDER_TYPES ord_type
where 1 = 1
          AND ra_dist.customer_trx_id = rcta.customer_trx_id
          AND ra_dist.customer_trx_line_id = rctal.customer_trx_line_id(+)
          AND gcc.code_combination_id = ra_dist.code_combination_id
          AND org.organization_id(+) = rctal.warehouse_id
          AND cust_bill_to.cust_account_id =  rcta.BILL_TO_CUSTOMER_ID
          AND cust_bill_to.site_use_id = rcta.BILL_TO_SITE_USE_ID
          AND cust_ship_to.cust_account_id =  rcta.SHIP_TO_CUSTOMER_ID
          AND cust_ship_to.site_use_id = rcta.SHIP_TO_SITE_USE_ID
          AND rctal.inventory_item_id = msib.inventory_item_id(+)
          AND rctal.interface_line_attribute10 = msib.organization_id(+)
          AND ooha.order_number = rcta.interface_header_attribute1(+)
          AND ord_type.transaction_type_id = ooha.order_type_id(+)
          AND rcta.trx_number like '402%'
and rcta.trx_date between '01-APR-2017' AND '30-APR-2017';
-- and rcta.trx_number like '40200001584W';

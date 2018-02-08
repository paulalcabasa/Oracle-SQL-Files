select rcta.trx_number,
         rcta.trx_date,
         cust_bill_to.customer_number,
         cust_bill_to.party_name bill_to_customer,
         cust_bill_to.account_name bill_to_account_name,
         cust_bill_to.bill_to_address1,
         cust_ship_to.party_name bill_to_customer,
         cust_ship_to.account_name bill_to_account_name,
         cust_ship_to.bill_to_address1,
         rctal.description,
         ra_dist.amount,
         ra_dist.code_combination_id,
         gcc.segment6,
         gcc.concatenated_segments,
         rcta.DOC_SEQUENCE_VALUE,
         ra_dist.gl_date,
         ra_dist.org_id,
         org.NAME,
         rcta.interface_header_attribute1
from ra_cust_trx_line_gl_dist_all ra_dist,
        ra_customer_trx_all rcta,
        ra_customer_trx_lines_all rctal,
        gl_code_combinations_kfv gcc,
        hr_all_organization_units org,
        XXIPC_CUSTOMER_DETAIL_V cust_bill_to,
        XXIPC_CUSTOMER_DETAIL_V cust_ship_to
where 1 = 1
          AND ra_dist.customer_trx_id = rcta.customer_trx_id
          AND ra_dist.customer_trx_line_id = rctal.customer_trx_line_id(+)
          AND gcc.code_combination_id = ra_dist.code_combination_id
          AND org.organization_id = ra_dist.org_id
          AND cust_bill_to.cust_account_id =  rcta.BILL_TO_CUSTOMER_ID
          AND cust_bill_to.site_use_id = rcta.BILL_TO_SITE_USE_ID
          AND cust_ship_to.cust_account_id =  rcta.SHIP_TO_CUSTOMER_ID
          AND cust_ship_to.site_use_id = rcta.SHIP_TO_SITE_USE_ID
          AND rcta.trx_number = '40200000492';
 

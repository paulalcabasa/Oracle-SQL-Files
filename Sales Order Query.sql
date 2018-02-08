select ooha.order_number,
         sold_to_customer.party_name SOLD_TO_CUSTOMER_NAME,
         sold_to_customer.account_name SOLD_TO_ACCOUNT_NAME,
         sold_to_customer.account_number SOLD_TO_ACCOUNT_NUMBER,
         order_types.ord_type_name,
         order_types.ord_type_desc,
         ooha.cust_po_number,
         ooha.ordered_date
from oe_order_headers_all ooha,
       (SELECT hp.party_id,
                    hca.cust_account_id,
                    (hp.address1 || ' ' || hp.address2 || ' ' || hp.address3 || ' ' || hp.city || ' ' || hp.country) address,
                    hca.account_number,
                    hp.party_name,
                    hca.account_name
        FROM hz_parties hp,
                 hz_cust_accounts hca
        WHERE hp.party_id = hca.party_id) sold_to_customer,
        (SELECT ou.name ou,
                    ot1.transaction_type_id,
                    ot1.name ord_type_name,
                    ot1.description ord_type_desc,
                    rt.cust_trx_type_id,
                    rt.name trx_type_name,
                    rt.description trx_type_desc,
                    rt.TYPE trx_type,
                    ot2.start_date_active ord_type_active,
                    ot2.end_date_active ord_type_end
        FROM oe_transaction_types_all ot2,
                  oe_transaction_types_tl ot1,
                  ra_cust_trx_types_all rt,
                  hr_operating_units ou
        WHERE ot1.transaction_type_id = ot2.transaction_type_id
               AND ot2.transaction_type_code = 'ORDER'
               AND ot2.cust_trx_type_id = rt.cust_trx_type_id
               AND ot2.org_id = ou.organization_id
               AND ot2.end_date_active IS NULL) order_types
WHERE 1 = 1
            AND sold_to_customer.cust_account_id = ooha.sold_to_org_id
            AND order_types.transaction_type_id  = ooha.order_type_id;

SELECT ooha.order_number,
            oola.line_number,
            oola.ordered_item,
            msib.description,
            oola.ORDERED_QUANTITY,
            oola.ORDER_QUANTITY_UOM,
            msib.attribute14 ifs_part_number,
            oola.UNIT_SELLING_PRICE,
            oola.tax_value
            
FROM OE_ORDER_LINES_ALL oola,
          oe_order_headers_all ooha,
          mtl_system_items_b msib
WHERE oola.header_id = ooha.header_id
            AND msib.inventory_item_id = oola.inventory_item_id
ORDER BY ooha.order_number,
                oola.line_number;


 
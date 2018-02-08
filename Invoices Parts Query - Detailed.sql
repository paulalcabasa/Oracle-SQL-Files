
SELECT rctta.name trans_type,
            hcsua.location customer_site,
            hp.party_name customer_name,
            hcaa.account_name,
            hcaa.account_number,
            rcta.trx_date invoice_date,
            rcta.trx_number invoice_number,
            rcta.interface_header_attribute1 so_number,
            oola.attribute10 dr_num,
            ooha.cust_po_number po_num,
            msib.segment1,
            msib.description,
            rctla.quantity_invoiced,
            sum (
                case
                    when rctla.interface_line_attribute11 = 0
                    then rctla.unit_selling_price
                else 0
                end
            ) gross,
            case
                when sum (decode (rctla.interface_line_attribute11,'0', 0,rctla.unit_selling_price)) > 0
                then 0
            else
                sum (decode (rctla.interface_line_attribute11,'0', 0,rctla.unit_selling_price))
           end discount
     
            
FROM -- INVOICE
            ra_customer_trx_all rcta
            INNER JOIN ra_customer_trx_lines_all rctla
                ON rctla.customer_trx_id = rcta.customer_trx_id
            INNER JOIN ra_cust_trx_types_all rctta
                ON rctta.cust_trx_type_id = rcta.cust_trx_type_id
            -- SALES ORDER
            INNER JOIN oe_order_lines_all oola
                ON oola.line_id = rctla.interface_line_attribute6
            INNER JOIN oe_order_headers_all ooha
                ON ooha.header_id = oola.header_id
            INNER JOIN xxipc_order_types ord_types
                ON ord_types.transaction_type_id = ooha.order_type_id
            -- ITEM
            INNER JOIN mtl_system_items_b msib
                ON msib.inventory_item_id =  rctla.inventory_item_id
                AND msib.organization_id = rctla.interface_line_attribute10
               
            -- CUSTOMER DATA
            INNER JOIN hz_cust_accounts_all hcaa
                ON hcaa.cust_account_id = rcta.bill_to_customer_id
            INNER JOIN hz_cust_site_uses_all hcsua
                ON hcsua.site_use_id = rcta.bill_to_site_use_id
                AND hcsua.status = 'A'
                AND hcsua.site_use_code = 'BILL_TO'
            INNER JOIN hz_parties hp
                ON hp.party_id = hcaa.party_id
            INNER JOIN hz_cust_acct_sites_all hcasa
                ON hcsua.cust_acct_site_id = hcasa.cust_acct_site_id
            INNER JOIN hz_party_sites hps
                ON hps.party_site_id = hcasa.party_site_id
            INNER JOIN hz_locations hl
                ON hl.location_id = hps.location_id
            -- TERMS
            LEFT JOIN ra_terms_tl rtt
                ON rtt.term_id = rcta.term_id
       
WHERE 1 = 1 -- filter
           
and rcta.trx_number = '40200011765'
and msib.segment1 = '8970119000'
and rcta.trx_number like '402%'

group by 
rctta.name ,
            hcsua.location ,
            hp.party_name ,
            hcaa.account_name,
            hcaa.account_number,
            rcta.trx_date ,
            rcta.trx_number ,
            rcta.interface_header_attribute1 ,
            oola.attribute10 ,
            ooha.cust_po_number ,
            msib.segment1,
            msib.description,
            rctla.quantity_invoiced
      
        -- 40200007019 - cm   
;


select *
from dbs_picklist_interface
where request_number IN(1021909,
1021907,
1022154,
1022267,
1022271,
1022337,
1022344,
1022182,
1022236,
1022234)
ORDER BY request_number ASC;

SELECT *
FROM dbs_picklist_interface
where request_number = 1022154;

/*
  AND mtrh.request_number IN (select distinct mtrh.request_number
            from MTL_RESERVATIONS_ALL_V mr
            ,OE_ORDER_HEADERS_ALL ooh
            ,OE_ORDER_LINES_ALL ool
            ,MTL_TXN_REQUEST_LINES_V mtrl
            ,MTL_TXN_REQUEST_HEADERS_V mtrh
            where ooh.header_id=ool.header_id
            and demand_source_line_id=ool.line_id
            and mr.DEMAND_SOURCE_LINE_ID is not null
            and mtrh.header_id=mtrl.header_id
            and mtrl.txn_source_line_id=mr.DEMAND_SOURCE_LINE_ID)
            */
         
SELECT mtrh.picklist_id,
                      mtrh.header_id,
                      picklist_details.ord_type_name sales_order_type,
                      picklist_details.sales_order_no,
                      mtrh.request_number picklist_no,
                      picklist_details.sales_order_date sales_order_date,
                      NULL customer_contact_person,
                      shipping_data.ship_to_address customer_delivery_address,
                      ship_to_customer.account_number ship_to_customer_number,
                      ship_to_customer.account_name,
                      sold_to_customer.party_name customer_name,
                      sold_to_customer.account_number customer_id,
                      picklist_details.order_header_id,
                      picklist_details.remarks,
                      picklist_details.additional_remarks,
                      mtrh.header_status,
                      txn_header_status.meaning,
                      picklist_details.ord_type_name,
                      picklist_details.trx_type_name,
                      picklist_details.ship_to_org_id,
                      picklist_details.cust_po_number,
                      user_details.created_by_id,
                      user_details.created_by_name,
                      user_details.created_by_email,
                      picklist_details.ship_from_org_id,
                      picklist_details.currency_code
                FROM dbs_picklist_interface mtrh,
                     mtl_txn_request_headers mtrh2,
                     (SELECT FU.USER_ID CREATED_BY_ID,
                                    (PPF.FIRST_NAME || ' ' || PPF.LAST_NAME) created_by_name,
                                    FU.EMAIL_ADDRESS created_by_email
                        FROM FND_USER FU LEFT JOIN PER_PEOPLE_F PPF
                            ON FU.EMPLOYEE_ID = PPF.PERSON_ID
                            AND FU.PERSON_PARTY_ID = PPF.PARTY_ID
                       ) user_details,
                     (SELECT hp.party_id,
                              hca.cust_account_id,
                              (hp.address1 || ' ' || hp.address2 || ' ' || hp.address3 || ' ' || hp.city || ' ' || hp.country) address,
                              hca.account_number,
                              hp.party_name
                     FROM hz_parties hp,
                             hz_cust_accounts hca
                     WHERE hp.party_id = hca.party_id) sold_to_customer,
                     (SELECT hp.party_id,
                              hca.cust_account_id,
                              (hp.address1 || ' ' || hp.address2 || ' ' || hp.address3 || ' ' || hp.city || ' ' || hp.country) address,
                              hca.account_number,
                              hp.party_name,
                              hca.account_name
                     FROM hz_parties hp,
                             hz_cust_accounts hca
                     WHERE hp.party_id = hca.party_id) ship_to_customer,
                     (SELECT DISTINCT wdd.source_header_number sales_order_no,
                             wdd.source_header_id order_header_id,
                             wdd.currency_code,
                             ooha.ordered_date sales_order_date,
                             ooha.attribute1 remarks,
                             ooha.attribute2 additional_remarks,
                             mtrl.header_id,
                             ooha.sold_to_org_id,
                             ooha.ship_to_org_id,
                             ooha.ship_from_org_id,
                             order_types.ord_type_name,
                             order_types.trx_type_name,
                             ooha.cust_po_number
                       FROM wsh_delivery_details wdd,
                               mtl_txn_request_lines mtrl,
                               oe_order_headers_all ooha,
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
                       WHERE wdd.move_order_line_id = mtrl.line_id
                                 AND wdd.source_header_id = ooha.header_id
                                 AND order_types.transaction_type_id  = ooha.order_type_id
           
                      ) picklist_details,
                      (SELECT lookup_code,
                                 lookup_type,
                                 meaning,
                                 description,
                                 enabled_flag
                      FROM mfg_lookups
                      WHERE lookup_type = 'MTL_TXN_REQUEST_STATUS' 
                      AND enabled_flag = 'Y') txn_header_status,
                     (SELECT ooh.order_number
                     , hp_bill.party_name
                     , hl_ship.address1 || ' ' ||
                       hl_ship.address2 || ' ' || 
                       hl_ship.address3 || ' ' || 
                       hl_ship.address4 || ' ' ||
                       hl_ship.city || ' ' || 
                       hl_ship.state || ' ' ||
                       hl_ship.postal_code ship_to_address
                     , hl_bill.address1 || ' ' ||
                       hl_bill.address2 || ' ' || 
                       hl_bill.address3 || ' ' || 
                       hl_bill.address4 || ' ' ||
                       hl_bill.city || ' ' || 
                       hl_bill.state || ' ' ||
                       hl_bill.postal_code bill_to_address
                     , ooh.transactional_curr_code currency_code
                     , mp.organization_code
                     , ooh.fob_point_code
                     , ooh.freight_terms_code
                     , ooh.cust_po_number
                FROM   oe_order_headers_all ooh
                     , hz_cust_site_uses_all hcs_ship
                     , hz_cust_acct_sites_all hca_ship
                     , hz_party_sites hps_ship
                     , hz_parties hp_ship
                     , hz_locations hl_ship
                     , hz_cust_site_uses_all hcs_bill
                     , hz_cust_acct_sites_all hca_bill
                     , hz_party_sites hps_bill
                     , hz_parties hp_bill
                     , hz_locations hl_bill
                     , mtl_parameters mp
                WHERE  1 = 1
                AND    ooh.ship_to_org_id = hcs_ship.site_use_id
                AND    hcs_ship.cust_acct_site_id = hca_ship.cust_acct_site_id
                AND    hca_ship.party_site_id = hps_ship.party_site_id
                AND    hps_ship.party_id = hp_ship.party_id
                AND    hps_ship.location_id = hl_ship.location_id
                AND    ooh.invoice_to_org_id = hcs_bill.site_use_id
                AND    hcs_bill.cust_acct_site_id = hca_bill.cust_acct_site_id
                AND    hca_bill.party_site_id = hps_bill.party_site_id
                AND    hps_bill.party_id = hp_bill.party_id
                AND    hps_bill.location_id = hl_bill.location_id
                AND    mp.organization_id(+) = ooh.ship_from_org_id) shipping_data
        WHERE picklist_details.header_id = mtrh.header_id
           AND sold_to_customer.cust_account_id = picklist_details.sold_to_org_id
           AND ship_to_customer.cust_account_id = picklist_details.sold_to_org_id
           AND txn_header_status.lookup_code = mtrh.header_status
           AND shipping_data.order_number = picklist_details.sales_order_no
           AND mtrh.header_status = 7
           AND picklist_details.trx_type_name LIKE ('%Invoice-Parts%')
           AND picklist_details.ord_type_name <> 'PRT.LUB'
           AND mtrh2.request_number = mtrh.request_number
           AND user_details.created_by_id = mtrh2.created_by
           AND mtrh.is_interface_picked IS NULL
           and picklist_details.ship_from_org_id = 102
           and picklist_details.sales_order_no NOT IN ('3010000004',
                                                        '3010001083',
                                                        '3010001238',
                                                        '3010000010',
                                                        '3010001086',
                                                        '3010001085',
                                                        '3010000009',
                                                        '3010001087',
                                                        '3010001239',
                                                        '3010001076',
                                                        '3010001075',
                                                        '3010001080',
                                                        '3010001077',
                                                        '3010001079',
                                                        '3010001082',
                                                        '3010000006',
                                                        '3010000007',
                                                        '3010000012',
                                                        '3010001241',
                                                        '3010000001',
                                                        '3010000002',
                                                        '3010000003',
                                                        '3010001074',
                                                        '3010000005',
                                                        '3010001236',
                                                        '3010001088',
                                                        '3010001240',
                                                        '3010001081',
                                                        '3010001078',
                                                        '3010000008',
                                                        '3010001084',
                                                        '3010000011',
                                                        '3010000258',
                                                        '3010000257',
                                                        '3010000254',
                                                        '3010000252',
                                                        '3010000251',
                                                        '3010000242',
                                                        '3010000241',
                                                        '3010000239',
                                                        '3010000235',
                                                        '3010000231',
                                                        '3010000214',
                                                        '3010000213',
                                                        '3010000208',
                                                        '3010000203',
                                                        '3010000021',
                                                        '3010000019',
                                                        '3010000017',
                                                        '3010000013');
                                                        
                                                        select max(cash_receipt_id)
                                                        from ar_cash_receipts_all;
                                                        
                                                        -- 63315
                                                        select *
                                                        from ar_cash_receipts_all
                                                        where cash_receipt_id = 25001;
                                                        
                                                        select max(receipt_number)
                                                        from ar_cash_receipts_all;
           
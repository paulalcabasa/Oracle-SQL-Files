SELECT 
                            picklist_details.sales_order_no,
                            mtrh.request_number picklist_no,
                            sold_to_customer.account_number customer_id,
                            picklist_details.cust_po_number,
                            sold_to_customer.party_name customer_name,
                            shipping_data.ship_to_address customer_delivery_address,
                            ship_to_customer.account_number ship_to_customer_number,
                            
                            picklist_details.ord_type_name sales_order_type,
                            (select name from qp_list_headers_all where list_header_id = picklist_details.price_list_id) price_list,
                            picklist_details.sales_order_date sales_order_date,
                            picklist_details.remarks,
                            picklist_details.additional_remarks
                            
--                     mtrh.picklist_id,
--                      mtrh.header_id,
--                     (contact_details.contact_first_name || ' ' || contact_details.contact_middle_name  || ' ' || contact_details.contact_last_name) customer_contact_person,
--                     picklist_details.order_header_id,
--                     mtrh.header_status,
--                      txn_header_status.meaning,
--                      picklist_details.ord_type_name,
--                      picklist_details.trx_type_name,
--                      picklist_details.ship_to_org_id,
--                     picklist_details.price_list_id
                     
                FROM dbs_picklist_interface mtrh,
                     (select hp.party_id,
                              hca.cust_account_id,
                              (hp.address1 || ' ' || hp.address2 || ' ' || hp.address3 || ' ' || hp.city || ' ' || hp.country) address,
                              hca.account_number,
                              hp.party_name
                     from hz_parties hp,
                             hz_cust_accounts hca
                     where hp.party_id = hca.party_id) sold_to_customer,
                     (select hp.party_id,
                              hca.cust_account_id,
                              (hp.address1 || ' ' || hp.address2 || ' ' || hp.address3 || ' ' || hp.city || ' ' || hp.country) address,
                              hca.account_number,
                              hp.party_name
                     from hz_parties hp,
                             hz_cust_accounts hca
                     where hp.party_id = hca.party_id) ship_to_customer,
                     (select distinct wdd.source_header_number sales_order_no,
                             wdd.source_header_id order_header_id,
                             ooha.ordered_date sales_order_date,
                             ooha.attribute1 remarks,
                             ooha.attribute2 additional_remarks,
                             mtrl.header_id,
                             ooha.sold_to_org_id,
                             ooha.ship_to_org_id,
                             order_types.ord_type_name,
                             order_types.trx_type_name,
                             ooha.cust_po_number,
                             ooha.price_list_id
                       from wsh_delivery_details wdd,
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
                       where wdd.move_order_line_id = mtrl.line_id
                                 and wdd.source_header_id = ooha.header_id
                                 and order_types.transaction_type_id  = ooha.order_type_id
                      ) picklist_details,
                     (SELECT d.cust_account_id, 
                                d.account_number,
                                d.party_id, 
                                e.orig_system_reference, 
                                b.site_use_id,
                                c.name group_name,
                                i.overall_credit_limit,
                                a.party_number,
                                a.party_name,
                                a.jgzz_fiscal_code tin,
                                k.cust_acct_site_id,
                                a.address1 || ' ' || a.address2 || ' ' || a.country address,
                                substr(a2.person_first_name, 1, 40)       contact_first_name,
                                substr(a2.person_middle_name, 1, 40)  contact_middle_name,
                                substr(a2.person_last_name, 1, 50)        contact_last_name
                      FROM   hz_parties a,
                                hz_parties a2,
                                hz_customer_profiles b,
                                hz_cust_profile_classes c,
                                hz_cust_accounts d,
                                hz_cust_acct_sites_all e,
                                hz_party_sites f,
                                hz_cust_site_uses_all g,
                                hr_all_organization_units h,
                                hz_cust_profile_amts i,
                                hz_relationships j,
                                hz_cust_account_roles k
                      WHERE  a.party_id = b.party_id
                                AND b.profile_class_id = c.profile_class_id
                                AND a.party_id = d.party_id
                                AND d.cust_account_id = e.cust_account_id
                                AND a.party_id = f.party_id
                                AND f.party_site_id = e.party_site_id
                                AND d.cust_account_id = b.cust_account_id
                                AND d.cust_account_id = e.cust_account_id
                                AND e.cust_acct_site_id = g.cust_acct_site_id
                                AND d.cust_account_id = b.cust_account_id
                                AND g.site_use_id = b.site_use_id
                                AND e.org_id = h.organization_id
                                AND b.cust_account_id = i.cust_account_id(+)
                                AND b.site_use_id = i.site_use_id(+)
                                and  d.party_id  =  j.object_id
                                and k.party_id = j.party_id
                                and k.cust_acct_site_id = e.cust_acct_site_id
                                and j.subject_id = a2.party_id(+)
                                and k.role_type = 'CONTACT'
                                AND e.status = 'A'
                                AND k.current_role_state = 'A')  contact_details,
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
           AND picklist_details.sold_to_org_id = contact_details.cust_account_id(+)
           AND txn_header_status.lookup_code = mtrh.header_status
           AND shipping_data.order_number = picklist_details.sales_order_no
           AND mtrh.header_status = 7
           AND picklist_details.trx_type_name LIKE ('%Invoice-Parts%')
           AND picklist_details.ord_type_name <> 'PRT.LUB'
    --       AND picklist_details.sales_order_no = '3010000087'
           
                 AND  mtrh.request_number IN (
11006,
11004,
11008,
11010,
11016,
11040,
11042,
11036,
11018,
11034,
11031,
11027,
13010,
13008,
13012,
13016,
16005,
16031,
17003,
17005,
17007,
17019,
17009,
17011,
17013,
17023,
17025,
18003,
19012,
19034,
19050,
19054);
        
             

SELECT *
FROM DBS_PICKLIST_INTERFACE;

select dbs_picklist_interface_seq.currval
from dual;
select *
from mtl_txn_request_headers;

SELECT  
mtrh.request_number picklist_no,
wdd.source_header_number so_order_number,
msi.segment1 part_no,
mtrl.quantity requested_quantity,
wdd.requested_quantity_uom,
oola.unit_selling_price,
oola.line_number so_line_number,
oola.promise_date,
oola.request_date,
oola.schedule_ship_date,
oola.schedule_arrival_date,
oola.attribute1 remarks,
item_categories.segment1,
item_categories.segment2
             -- wnd.delivery_id,
                --        wnd.name delivery_name,
                  --      wnd.initial_pickup_location_id,
                    --    mtrh.request_number mo_number,
                      --  mtrl.line_number mo_line_number,
                      --  mtrl.line_id mo_line_id,
                      --  mtrl.from_subinventory_code,
                      --  mtrl.to_subinventory_code,
                     --   mtrl.lot_number,
                      --  mtrl.serial_number_start,
                      --  mtrl.serial_number_end,
                     --   mtrl.uom_code,
                        
                     --   mtrl.quantity_delivered,
                     --   mtrl.quantity_detailed,
                        
                       
                --        wdd.source_header_id so_header_id,
               --         wdd.source_line_id so_line_id,
              --          wdd.shipping_instructions,
               --         wdd.inventory_item_id,
           
                        
                  --      msi.description item_description,
                   --     msi.revision_qty_control_code ,
                    --    wdd.ship_method_code carrier,
                  --      wdd.shipment_priority_code priority,
                  --      wdd.organization_id,
                   --     wdd.released_status,
                    --    wdd.source_code,
                     --   mtp.organization_code,
                
                FROM mtl_system_items_vl msi,
                     oe_order_lines_all oola,
                     mtl_txn_request_lines mtrl,
                     mtl_txn_request_headers mtrh,
                     wsh_delivery_details wdd,
                     wsh_delivery_assignments wda,
                     wsh_new_deliveries wnd,
                     mtl_system_items_b msib,
                     mtl_parameters mtp,
                     (select mic.inventory_item_id,
                               mc.segment1,
                               mc.segment2,
                               mc.category_id
                      from mtl_item_categories mic,
                              mtl_categories mc
                      where 1=1 
                                and mic.category_id = mc.category_id
                                and organization_id = 87
                                and segment1 = 'PARTS') item_categories
                WHERE 1=1 
                      AND wda.delivery_id = wnd.delivery_id(+)
                      AND wdd.delivery_detail_id = wda.delivery_detail_id
                      AND wdd.move_order_line_id = mtrl.line_id
                      AND mtrl.header_id = mtrh.header_id
                      AND wdd.inventory_item_id = msi.inventory_item_id(+)
                      AND wdd.organization_id = msi.organization_id(+)
                      AND wdd.source_line_id = oola.line_id
                      AND wdd.source_header_id = oola.header_id 
                      AND msib.inventory_item_id = wdd.inventory_item_id
                      AND msib.organization_id = mtp.organization_id
                      AND item_categories.inventory_item_id(+) = wdd.inventory_item_id
                      AND msib.organization_id = 87 
                 
        AND  mtrh.request_number IN (
11006,
11004,
11008,
11010,
11016,
11040,
11042,
11036,
11018,
11034,
11031,
11027,
13010,
13008,
13012,
13016,
16005,
16031,
17003,
17005,
17007,
17019,
17009,
17011,
17013,
17023,
17025,
18003,
19012,
19034,
19050,
19054);
        
             
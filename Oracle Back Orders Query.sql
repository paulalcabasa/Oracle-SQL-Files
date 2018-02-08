select wsh.source_header_number,
         wsh.source_line_number,
         msib.segment1 part_no,
         wsh.item_description part_description,
         wsh.src_requested_quantity,
         wsh.src_requested_quantity_uom,
         wsh.CANCELLED_QUANTITY,
         wsh.DELIVERED_QUANTITY,
         wsh.SHIPPED_QUANTITY,
         wsh. REQUESTED_QUANTITY,
         wsh.RELEASED_STATUS_NAME,
         wsh.RELEASED_STATUS, 
         wsh.DELIVERY_ID,
         wsh.DELIVERY_LINE_ID,
         wsh.DELIVERY_DETAIL_ID,
         hca.account_name,
         hp.party_name,
         org.name,
         msib.organization_id,
         wsh.creation_date,
         wsh.delivery_id
from  WSH_DELIVERABLES_V wsh,
        hz_cust_accounts_all hca,
        hz_parties hp,
        mtl_system_items_b msib,
        hr_all_organization_units org
where 1 = 1
         AND hca.cust_account_id =   wsh.CUSTOMER_ID
         AND hp.party_id = hca.party_id
         AND msib.inventory_item_id =  wsh.inventory_item_id
         AND msib.organization_id = org.organization_id
         AND msib.organization_id = 102
       --  AND msib.segment1 = '8981941190'
         AND upper(released_status_name) like upper('%Back%');
         
         SELECT *
         FROM WSH_DELIVERABLES_V;
 
select *
from hr_all_organization_units;
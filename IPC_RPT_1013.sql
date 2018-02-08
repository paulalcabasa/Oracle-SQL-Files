select  ra_head.customer_trx_id,
	   			hp.party_name,
				substr(ra_head.comments, 1, 9) old_invoice,
				substr(ra_head.comments, 13) fleet_account,
	   			case
	   	   			when hcaa.account_name in ('IPC Teammembers', 'IPC Teammembes') then null
		   			else hcaa.account_name
	   			end account_name,
	   			case
	   	   			when hcaa.account_name not in ('IPC Teammembers', 'IPC Teammembes')  then null
		   			else hcaa.account_name
	   			end employee,
	   			ra_head.trx_number,
				hcaa.account_number,
	   			CASE
	   	   			WHEN HL.ADDRESS1 LIKE 'DEALERS%' THEN HL.ADDRESS2||' '||HL.ADDRESS3
           			ELSE HL.ADDRESS1||' '||HL.ADDRESS2||' '||HL.ADDRESS3||''||HL.CITY
       			END ADDRESS,
	   			hcsua.TAX_REFERENCE,
	   			ra_head.bill_to_customer_id,
	   			ra_head.attribute1,
	   			ra_head.bill_to_site_use_id,
	   			ra_head.ship_to_customer_id,
	   			ra_head.SHIP_TO_SITE_USE_ID,
	   			ra_line.inventory_item_id,
	   			to_char(ra_head.trx_date, 'Monthdd, yyyy') trx_date,
				rtt.name,
				ra_head.attribute8 CSR,
				ra_head.attribute10 CSR_OR,
	   			ra_line.quantity_invoiced,
	   			ra_line.unit_selling_price,
	   			ra_line.extended_amount,
                (select sum(extended_amount) 
                from ra_customer_trx_lines_all
                where customer_trx_id = ra_head.customer_trx_id
                and line_type = 'LINE') amt,
	   			ra_line.tax_recoverable,
	   			ra_head.interface_header_attribute1 SO_NUM,
				ra_head.purchase_order PO_NUM,
	   			ra_line.interface_line_attribute3 dr_num,
	   			ra_line.description model,
	   			msn.lot_number lot_no,
	   			msn.ATTRIBUTE2 serial_no,
	   			msn.attribute3 engine_no,
	   			msn.attribute15 body_color,
	   			itm.ATTRIBUTE17 fuel,
	   			msn.attribute6 key_no,
	   			msn.attribute10 tire_brand,
	   			msn.attribute8 battery,
	   			msn.serial_number cs_no,
				ra_head.attribute4,
	   			itm.attribute21 year_model
from RA_Customer_Trx_All ra_head,
	 RA_Customer_Trx_Lines_All ra_line,
	 MTL_SYSTEM_ITEMS itm,
	 mtl_serial_numbers msn,
	 hz_cust_accounts_all hcaa,
	 hz_cust_acct_sites_all hcasa,
	 hz_party_sites hps,
	 hz_parties hp,
	 hz_locations hl,
	 hz_cust_site_uses_all hcsua,
	 ra_terms_tl rtt,
	 (SELECT mtt.transaction_id,
      		 mtt.trx_source_line_id,
      		 mtt.inventory_item_id,
      		 mtt.organization_id,
      		 mut.serial_number,
      		 mtlv.lot_number
      FROM (SELECT *
            FROM MTL_UNIT_TRANSACTIONS_ALL_V
        	WHERE TRANSACTION_SOURCE_TYPE_ID = 2) MUT,
           (SELECT *
            FROM MTL_TRANSACTION_LOT_VAL_V
        	WHERE transaction_source_type_id = 2 AND STATUS_ID = 1) MTLV,
           (SELECT *
            FROM mtl_material_transactions
        	WHERE TRANSACTION_SOURCE_TYPE_ID = 2
              	  AND TRANSACTION_TYPE_ID = 33) mtt
      WHERE 1 = 1
      		--and MUT.serial_number = '104-21' and MUT.organization_id = 89 and MUT.inventory_item_id = 18795
      		AND mut.transaction_id = mtlv.serial_transaction_id
      		AND mtlv.transaction_id = mtt.transaction_id
      		AND mtlv.transaction_source_type_id = mtt.transaction_source_type_id
      		AND mtlv.transaction_source_id = mtt.transaction_source_id
      		AND mut.transaction_source_id = mtlv.transaction_source_id) MTT1
where ra_head.customer_trx_id = ra_line.customer_trx_id
	  and ra_head.org_id = ra_line.org_id
	  and itm.inventory_item_id = ra_line.inventory_item_id
	  and itm.organization_id = ra_line.warehouse_id
	  and ra_line.line_type = 'LINE'
	  and ra_head.complete_flag = 'Y'
	  and mtt1.trx_source_line_id = ra_line.interface_line_attribute6
	  AND msn.serial_number = mtt1.serial_number
	  AND msn.inventory_item_id = mtt1.inventory_item_id
	  and ra_line.interface_line_attribute11 = 0
	  AND ra_head.sold_to_customer_id = hcaa.cust_account_id
   	  and hcaa.cust_account_id = hcasa.cust_account_id
   	  AND hcasa.cust_acct_site_id = hcsua.cust_acct_site_id
   	  AND hps.location_id = hl.location_id
   	  AND hps.party_site_id = hcasa.party_site_id
   	  and hcaa.party_id = hp.party_id
   	  and ra_head.bill_to_site_use_id = hcsua.SITE_USE_ID
   	  and ra_head.term_id = rtt.term_id
	  and ra_head.org_id = :org_id
	  and ra_head.trx_number between :INV1 and :INV2
order by ra_head.trx_number asc;



select *
from ra_customer_trx_lines_all;
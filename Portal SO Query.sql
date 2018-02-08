
SELECT pl.id pl_id,
					   pl.sales_order_no so_number,
					   pl.picklist_no picklist_number,
					   pl.sales_order_type,
					   pl.sales_order_date,
					   pl.customer_po_number,
					   pl.account_name,
					   pl.date_created picklist_date,
					   pl.created_by_name,
					   pl.customer_delivery_address address,
					   pl.customer_name,
					   dr.dr_number,
					   dr.new_dr_number dr_reference,
					   pll.line_no,
					   dr.shipped_quantity dr_qty,
					   pll.requested_quantity picklist_qty,
					   apll.actual_quantity actual_picklist_qty,
					   pll.unit_of_measure uom,
					   pll.part_description description,
					   pll.part_no part_number,
					   dr.tax_reference,
					   apl.id pick_confirmed_reference,
					   apl.date_created pick_confirmed_date,
					   dr.ship_confirmed_date,
					   dr.ship_confirmed_date delivery_receipt_date,
					   pll.unit_price,
					   CASE WHEN pll.tax > 0 THEN pll.unit_price * .12 ELSE 0 END tax,
					   pll.list_price,
					   dr.trx_number invoice_number,
					   dr.trx_date invoice_date,
					   dr.dispatch_date
				FROM  picklist_headers_tab pl
				LEFT JOIN picklist_lines_tab pll
				   ON pll.picklist_header_id = pl.id
				LEFT JOIN picklist_headers_tab apl
					ON apl.sales_order_no = pl.sales_order_no
					AND apl.picklist_no = pl.picklist_no
					AND apl.picklist_source_id = 2
				LEFT JOIN picklist_lines_tab apll
					ON apll.picklist_header_id = apl.id
					AND apll.line_no = pll.line_no
				LEFT JOIN (SELECT a.so_number,
									   a.picklist_number,
									   a.dr_number,
									   a.ship_confirmed_date,
									   CONCAT('312',LPAD(b.id, 8, '0')) new_dr_number,
									   a.po_number,
									   a.line_no,
									   a.tax_reference,
									   a.shipped_quantity,
									   b.trx_number,
									   b.trx_date,
									   b.dispatch_date
									FROM delivery_receipt_tab a
									LEFT JOIN ship_confirm b
										ON a.picklist_number = b.picklist_no
										AND a.so_number = b.sales_order_no
										AND a.dr_number = b.dr_number
									WHERE a.is_ship_confirmed IS NOT NULL) dr
					ON pl.sales_order_no = dr.so_number
					AND pl.picklist_no = dr.picklist_number
					AND pll.line_no = dr.line_no
				WHERE 1 = 1
				 AND pl.date_created BETWEEN '2017-01-01' AND '2017-08-04'
				AND pl.picklist_source_id = 1;
				
				
				SELECT *
				FROM picklist_headers_tab
				WHERE picklist_no = '1776035';
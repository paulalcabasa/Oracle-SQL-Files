SELECT -- ph.id,
   ph.sales_order_no,
   ph.picklist_no,
   DATE_FORMAT(ph.sales_order_date,'%m/%d/%Y') sales_order_date	,
 --  IFNULL(ph.customer_po_number, s.customer_po_number) customer_po_number,
   ph.customer_name,
   ph.account_name,
   DATE_FORMAT(ph.date_created,'%m/%d/%Y') picklist_date,
   ot.description,
 --  ph.created_by_name,
   plt.line_no,
   plt.part_no,
   plt.part_description,
   plt.requested_quantity
   -- plt.actual_quantity
  -- ap.pick_confirmed_date dbs_picklist_date,
  -- ap.ap_id,
 --  s.dr_number dr_number,
 --  s.new_dr_number dr_reference,
 --  s.ship_confirmed_date ship_confirmed_date,
 --  s.ship_confirmed_date dr_date,
 --  s.dispatch_date,
 --  ph.picklist_status,
 --  s.delivery_date,
--   s.trx_number
FROM picklist_headers_tab ph
 LEFT JOIN (SELECT a.so_number,
				   a.picklist_number,
				   a.dr_number,
				   a.ship_confirmed_date,
				   CONCAT('312',LPAD(b.id, 8, '0')) new_dr_number,
				   a.po_number customer_po_number,
				   b.dispatch_date,
				    b.delivery_date,
				   b.trx_number
				FROM delivery_receipt_tab a
				LEFT JOIN ship_confirm b
					ON a.picklist_number = b.picklist_no
					AND a.so_number = b.sales_order_no
					AND a.dr_number = b.dr_number
				WHERE a.is_ship_confirmed IS NOT NULL
				GROUP BY a.dr_number, a.picklist_number) s
		ON ph.picklist_no = s.picklist_number
 LEFT JOIN (SELECT id ap_id,
					date_created pick_confirmed_date,
					picklist_no,
					sales_order_no
				FROM picklist_headers_tab
				WHERE picklist_source_id = 2
					AND picklist_status = 1) ap
		ON ph.picklist_no = ap.picklist_no
		AND ph.sales_order_no = ap.sales_order_no
LEFT JOIN picklist_lines_tab plt 
	ON plt.picklist_header_id = ph.id
LEFT JOIN order_types ot
	ON ot.sales_order_type = ph.sales_order_type
WHERE 1 = 1 
	AND ph.picklist_source_id = 1 
	AND ap.pick_confirmed_date IS NULL
	AND s.dr_number IS NULL
	AND ph.picklist_status = 1
	ORDER BY ph.sales_order_no,
		 ph.picklist_no,
		 plt.line_no
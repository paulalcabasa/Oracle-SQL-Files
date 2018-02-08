SELECT DISTINCT 
	a_head.id asn_reference,
	a_head.supplier_name,
	a_head.dr_no remarks,
	a_head.invoice_no,
	gr.gr_head_id,
	a_lines.id line_id,
	a_lines.case_no,
	a_lines.po_no,
	a_lines.part_no,
	a_lines.description,
	gr.locator,
	gr.location_type,
	a_lines.quantity asn_qty,
	IFNULL(gr.quantity, 0) gr_qty,
	(a_lines.quantity - IFNULL(gr.quantity, 0)) difference,
	gr.date_created gr_receive_date,
	CASE a_head.supplier_type WHEN 1 THEN 'Local' ELSE 'Foreign' END supplier_type,
	CASE
		WHEN IFNULL(gr.quantity, 0) = 0 THEN 'No GR'
		WHEN a_lines.quantity > IFNULL(gr.quantity, 0) THEN 'PARTIAL'
		WHEN IFNULL(gr.quantity, 0) > a_lines.quantity THEN 'EXCESS'
	ELSE 'GOOD'
	END STATUS
FROM asn_lines_tab a_lines LEFT JOIN (SELECT r_item.location_id,
					     r_cases.case_no,
					     r_item.part_number,
					     r_loc.quantity,
					     r_loc.locator,
					     r_loc.location_type,
					     r_head.asn_header_id,
					     r_head.date_created,
					     r_head.id gr_head_id,
					     r_loc.asn_line_id
				 FROM receipt_line_items_location_tab r_loc LEFT JOIN receipt_line_items_tab r_item
					ON r_loc.receipt_line_item_id = r_item.id
				     LEFT JOIN receipt_lines_tab r_cases
					ON r_cases.id = r_item.receipt_line_id 
				     LEFT JOIN receipt_headers_tab r_head
					ON r_head.id = r_cases.receipt_header_id
				 WHERE 1 = 1) gr
	ON gr.asn_header_id = a_lines.header_id
	AND gr.part_number = a_lines.part_no
	AND a_lines.id = gr.asn_line_id
	AND gr.case_no = a_lines.case_no
LEFT JOIN asn_headers_tab a_head 
	ON a_head.id = a_lines.header_id;

				 
SELECT a_head.supplier_name,
       a_head.dr_no remarks,
       a_head.invoice_no,
       a_lines.part_no,
       a_lines.quantity asn_quantity
FROM asn_headers_tab a_head
	LEFT JOIN asn_lines_tab a_lines
		ON a_head.id = a_lines.header_id
WHERE a_head.supplier_name = 'ISUZU PHILIPPINES CORPORATION';


SELECT *
FROM asn_headers_tab
WHERE id = 185;

SELECT *
FROM asn_lines_tab
WHERE header_id = 185;

SELECT *
FROM receipt_headers_tab
WHERE asn_header_id = 185;

SELECT *
FROM receipt_lines_tab rlt 
	LEFT JOIN receipt_line_items_tab rlit
		ON rlit.receipt_line_id = rlt.id
	LEFT JOIN receipt_line_items_location_tab rlilt
		ON rlilt.receipt_line_item_id = rlit.id
WHERE receipt_header_id = 407
AND rlilt.part_number = '9650009310';
WHERE receipt;
WHERE receipt_id =
      AND id = 7689;
      
      SELECT *
      FROM receipt_line_items_location_tab;

SELECT *
FROM asn_headers_tab
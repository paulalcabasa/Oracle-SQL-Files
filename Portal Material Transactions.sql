SELECT ipc_picklist.sales_order_no,
       DATE_FORMAT(ipc_picklist.sales_order_date,'%m/%d/%Y %h:%i:%p') sales_order_date,
       ipc_picklist.picklist_no,
       DATE_FORMAT(ipc_picklist.date_created,'%m/%d/%Y %h:%i:%p') picklist_date,
       ipc_picklist.line_no,
       ipc_picklist.part_no,
       ipc_picklist.part_description,
       ipc_picklist.requested_quantity,
       dbs_picklist.actual_quantity picked_quantity,
       drt.shipped_quantity,
       DATE_FORMAT(drt.shipment_date,'%m/%d/%Y %h:%i:%p') shipment_date
FROM (SELECT pht.picklist_no,
	     pht.sales_order_no, 
	     pht.sales_order_date, 
	     pht.picklist_status,
	     plt.*
      FROM picklist_lines_tab plt LEFT JOIN picklist_headers_tab pht
      ON pht.id = plt.picklist_header_id
	WHERE pht.picklist_source_id = 1) ipc_picklist
     LEFT JOIN
      (SELECT pht.picklist_no,plt.*
      FROM picklist_lines_tab plt LEFT JOIN picklist_headers_tab pht
      ON pht.id = plt.picklist_header_id
	WHERE pht.picklist_source_id = 2) dbs_picklist
	ON ipc_picklist.part_no = dbs_picklist.part_no
	AND ipc_picklist.line_no = dbs_picklist.line_no
	AND ipc_picklist.picklist_no = dbs_picklist.picklist_no
     LEFT JOIN delivery_receipt_tab drt
	ON drt.picklist_number = ipc_picklist.picklist_no
	AND drt.part_number = ipc_picklist.part_no
WHERE ipc_picklist.part_no = '8975625670L'
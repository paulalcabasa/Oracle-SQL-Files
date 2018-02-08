/** Trip ticket master sql **/

SELECT tt.id trip_ticket,
       tt.jo_no job_order,
       nt.trip_type,
       tt.driver_no,
       sys_vehicle_monitoring.GetDriverName(tt.driver_no) driver_name,
       ts.status trip_status,
       CONCAT("IPCCU",LPAD(units.id,5,"0")) vehicle_id,
       units.cs_no,
       units.plate_no,
       CONCAT(DATE_FORMAT(tt.ob_date_from,'%m/%d/%Y'),' - ',DATE_FORMAT(tt.ob_date_to,'%m/%d/%Y')) "ob_date(m/d/y)",
       tt.purpose,
       tt.destination,
       CONCAT(pit.last_name,", ",pit.first_name," ",pit.middle_name) requested_by_name,
       CONVERT(emt.employee_no,CHAR) request_by_employee_no,
       DATE_FORMAT(tt.date_requested,'%m/%d/%Y') date_requested,
       CONCAT(pit2.last_name,", ",pit2.first_name," ",pit2.middle_name) prepared_by,
       (SELECT GROUP_CONCAT(passenger_name)
       FROM trip_ticket_passenger
       WHERE trip_ticket_no = tt.id
       GROUP BY trip_ticket_no) passengers
FROM sys_vehicle_monitoring.trip_ticket tt LEFT JOIN sys_vehicle_monitoring.nature_of_trip nt
		ON tt.nature_of_trip_id = nt.id
	LEFT JOIN ipc_central.personal_information_tab pit
		ON pit.employee_id = tt.requestor
	LEFT JOIN ipc_central.personal_information_tab pit2
		ON pit2.employee_id = tt.create_user
	LEFT JOIN ipc_central.employee_masterfile_tab emt
		ON emt.id = pit.employee_id
	LEFT JOIN sys_vehicle_monitoring.trip_status ts
		ON ts.id = tt.trip_status_id
	LEFT JOIN sys_insurance_and_registration.iar_company_car_units units
		ON units.id = tt.vehicle_id
	LEFT JOIN sys_insurance_and_registration.iar_vehicle_master v_mas
		ON v_mas.cs_no = units.cs_no
WHERE 1 = 1
      AND ts.id <> 3
      AND DATE(tt.date_requested) BETWEEN '2017-01-01' AND '2017-03-31'
;

/* vehicle master query */
SELECT CONCAT("IPCCU",LPAD(units.id,5,"0")) vehicle_id,
       units.cs_no,
       units.plate_no,
       class.classification,
       v_mas.model,
       v_mas.body_color,
       units.assignee,
       units.department,
       units.section,
       units.employee_no driver_no,
       CONCAT(pit.last_name,', ',pit.first_name,' ',pit.middle_name) driver_name,
       (SELECT COUNT(id)
       FROM trip_ticket
       WHERE vehicle_id = units.id
	    AND DATE(date_requested) BETWEEN '2017-01-01' AND '2017-03-31'
	    AND trip_status_id <> 3) trip_ticket_count
FROM sys_insurance_and_registration.iar_company_car_units units LEFT JOIN sys_insurance_and_registration.iar_company_car_classification class
	ON units.classification = class.id
     LEFT JOIN sys_insurance_and_registration.iar_vehicle_master v_mas
	ON v_mas.cs_no = units.cs_no
     LEFT JOIN ipc_central.employee_masterfile_tab emt
	ON emt.employee_no = units.employee_no
     LEFT JOIN ipc_central.personal_information_tab pit
	ON pit.employee_id = emt.id;
	
/*** Time logs query ****/
SELECT tl.id log_id,
       tl.trip_ticket_no,
       lt.type,
       CONCAT("IPCCU",LPAD(tl.vehicle_id,5,"0")) vehicle_id,
       units.plate_no,
       units.cs_no,
       tl.driver_no,
       tl.driver_name,
       tl.km_reading,
       tl.fuel_status_id,
       fs.status fuel_status,
       DATE_FORMAT(tl.log_time,'%b %d, %Y %h:%i %p'),
       tl.remarks,
       (SELECT GROUP_CONCAT(passenger_name)
       FROM sys_vehicle_monitoring.time_log_passenger
       WHERE time_log_id = tl.id
       GROUP BY time_log_id) passengers,
       CONCAT(pit.last_name,", ",pit.first_name," ",pit.middle_name) logged_by
FROM sys_vehicle_monitoring.time_log tl
	LEFT JOIN sys_vehicle_monitoring.log_type lt
		ON lt.id = tl.log_type_id
	LEFT JOIN sys_insurance_and_registration.iar_company_car_units units
		ON units.id = tl.vehicle_id
	LEFT JOIN sys_insurance_and_registration.iar_vehicle_master v_mas
		ON v_mas.cs_no = units.cs_no
	LEFT JOIN sys_vehicle_monitoring.fuel_status fs
		ON fs.id = tl.fuel_status_id
	LEFT JOIN ipc_central.personal_information_tab pit
		ON pit.employee_id = tl.create_user
WHERE DATE(tl.log_time) BETWEEN '2017-01-01' AND '2017-03-31';

SELECT *
FROM time_log
WHERE trip_ticket_no = 880;

SELECT *
FROM trip_ticket
WHERE id = 880;

SELECT *
FROM picklist_headers_tab
WHERE sales_order_no = '3010026383';

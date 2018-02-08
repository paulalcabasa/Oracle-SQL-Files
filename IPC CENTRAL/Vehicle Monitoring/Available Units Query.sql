SELECT vehicle_list.*,
       tl.driver_name,
       lc.classification log_classification,
       lt.type,
       tl.log_time last_time_in,
       tl.trip_ticket_no,
       ts.status
FROM (
     SELECT    
	car_units.cs_no,
	car_units.plate_no,
	car_units.assignee,
	car_units.department,
	car_units.section,
	st.name STATUS,
	(SELECT tl.id
		FROM sys_vehicle_monitoring.time_log tl
		WHERE tl.vehicle_id = car_units.id	
	ORDER BY tl.id DESC
	LIMIT 1
	) last_log_id
     FROM sys_insurance_and_registration.iar_company_car_units car_units
	INNER JOIN sys_insurance_and_registration.iar_vehicle_master vehicle
		ON car_units.cs_no = vehicle.cs_no
	LEFT JOIN sys_insurance_and_registration.iar_company_car_classification class
		ON class.id = car_units.classification
	LEFT JOIN sys_insurance_and_registration.status st
		ON st.id = car_units.status
      WHERE 1 = 1
            AND st.name IN ('Pending','Active')
     ) vehicle_list 
     INNER JOIN sys_vehicle_monitoring.time_log tl
	ON tl.id = vehicle_list.last_log_id
     INNER JOIN sys_vehicle_monitoring.log_classification lc
	ON lc.id = tl.log_classification_id
     INNER JOIN sys_vehicle_monitoring.log_type lt
	ON lt.id = tl.log_type_id
     LEFT JOIN sys_vehicle_monitoring.trip_ticket tt
	ON tt.id = tl.trip_ticket_no
     LEFT JOIN sys_vehicle_monitoring.trip_status ts
	ON ts.id = tt.trip_status_id
WHERE 1 = 1
      AND LOWER(lt.type) = 'in'
ORDER BY tl.log_time DESC;
	


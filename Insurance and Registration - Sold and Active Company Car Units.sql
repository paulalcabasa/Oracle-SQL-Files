SELECT vehicle.cs_no,
       units.assignee,
       DATE_FORMAT(vehicle.invoice_date,'%M %d, %Y') invoice_date,
       units.plate_no,
       class.classification
FROM iar_company_car_units units LEFT JOIN iar_vehicle_master vehicle
	ON units.cs_no = vehicle.cs_no
     LEFT JOIN iar_company_car_classification class 
	ON class.id = units.classification
WHERE units.status IN (3)
ORDER BY units.assignee ASC;
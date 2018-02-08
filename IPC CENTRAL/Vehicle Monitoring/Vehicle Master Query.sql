SELECT car_units.cs_no,
       car_units.plate_no,
       class.classification,
       car_units.assignee,
       car_units.department,
       car_units.section,
       st.name STATUS
FROM iar_company_car_units car_units
     INNER JOIN iar_vehicle_master vehicle
	ON car_units.cs_no = vehicle.cs_no
     INNER JOIN iar_company_car_classification class
	ON class.id = car_units.classification
     INNER JOIN STATUS st
	ON st.id = car_units.status;
SELECT -- pit.id person_id,
       -- emt.id employee_id,
       emt.employee_no,
       CONCAT(pit.last_name,', ',pit.first_name,' ',pit.middle_name) employee_name,
     --  pit.shuttle_code,
       stl.area,
       st.status employment_status
     --  stl.shuttle
       
FROM ipc_central.personal_information_tab pit 
     INNER JOIN ipc_central.employee_masterfile_tab emt
	ON pit.employee_id = emt.id
     INNER JOIN ipc_central.shuttle_tab stl
	ON stl.shuttle_code = pit.shuttle_code
     INNER JOIN ipc_central.status_tab st
	ON st.id = emt.status_id
WHERE 1 = 1
	AND emt.status_id IN (1,2,3,4,10)
	AND pit.shuttle_code NOT IN ('0003')

ORDER BY stl.shuttle ASC,
         pit.last_name ASC,
         pit.first_name ASC;
	
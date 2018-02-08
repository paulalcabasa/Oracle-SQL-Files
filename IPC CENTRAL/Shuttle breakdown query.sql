SELECT pit.id person_id,
       emt.id employee_id,
       emt.employee_no,
       pit.shuttle_code,
       stl.area,
       stl.shuttle,
       CONCAT(pit.last_name,', ',pit.first_name,' ',pit.middle_name) employee_name
FROM ipc_central.personal_information_tab pit 
     INNER JOIN ipc_central.employee_masterfile_tab emt
	ON pit.employee_id = emt.id
     INNER JOIN ipc_central.shuttle_tab stl
	ON stl.shuttle_code = pit.shuttle_code
     LEFT JOIN (SELECT employee_no FROM sys_overtime_request.overtime_request_employees WHERE DATE(ot_time) = '2017-09-21') ot
	ON ot.employee_no = emt.employee_no
WHERE 1 = 1
	AND emt.status_id IN (1,2,3,4,10)
	AND pit.shuttle_code NOT IN ('0003')
	AND ot.employee_no IS NULL
ORDER BY stl.shuttle ASC,
         pit.last_name ASC,
         pit.first_name ASC;
	
select *
from ap_suppliers;

select person_id,
         employee_number,
         title,
         first_name,
         middle_names,
         last_name,
         full_name,
         sex,
         effective_start_date,
         effective_end_date,
         attribute1 TIN, 
         attribute2 DIVISION,
         attribute3 DEPARTMENT,
         attribute4 SECTION
from per_people_f
ORDER BY FULL_NAME ASC;
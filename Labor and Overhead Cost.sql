/*
Labor and Overhead Cost Report 
This query will identify the labor and overhead cost for the model/lot number for the month based on parameter specified
Date: August 23, 2017 -mzc
Note: if there are new labor code (resource code), kindly add to the parameter of resource code
*/
select *
from (select
        job_order,
        part_number,
        part_description,
        lot_number,
        job_start_quantity,
        job_completed_quantity,
        account_code,
        nvl(difference,0) as difference
      from 
        ipc.ipc_wip_resources_v
      where 
        account_code in ('38900','38801','38800')   --labor, overhead1, overhead2
        and resource_code in ('LBR BS3','LBR BS1','LBR-BS2','LBR-BS3','LBR-TR-CHA','LBR-CBU CH','LABOR NYK','LBR-F-CHA','LBR-CBU TR','CBU','MuX/TF-CBU','CH truck') --to add if there are new resourcea
        and to_date (wip_transaction_date) between to_date (:p_start_date,'DD-MON-YYYY') and to_date(:p_end_date,'DD-MON-YYYY')
     )trans
pivot  
    (sum(difference) as total for (account_code) in  ('38900','38801','38800')) --labor, overhead1, overhead2
    order by 
        part_number,
        lot_number,
        job_order asc;
    
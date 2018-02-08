select distinct
e.responsibility_id,
  a.user_concurrent_program_name,
  a.description,
  request_group_name,
  e.responsibility_name
from
  fnd_concurrent_programs_tl a,
  fnd_request_groups b,
  fnd_request_group_units c,
  fnd_responsibility d,
  fnd_responsibility_tl e
where
  a.concurrent_program_id = c.request_unit_id(+)
and b.request_group_id = c.request_group_id
and b.request_group_id = d.request_group_id
and d.responsibility_id = e.responsibility_id(+)
and a.application_id = b.application_id(+)
and b.application_id = c.application_id
and d.application_id = e.application_id(+)
AND a.user_concurrent_program_name LIKE '%IPC%Vehicle%Invoiced%';
 --and e.responsibility_name like 'IPC%Receivables%Super%'
--and a.concurrent_program_id = :p_conc_program_id;
;
select *
from fnd_responsibility;

select distinct USER_CONCURRENT_PROGRAM_NAME
from fnd_concurrent_programs_tl
where USER_CONCURRENT_PROGRAM_NAME like 'IPC%';

SELECT MAX(CONCURRENT_PROGRAM_NAME)
FROM fnd_concurrent_programs_vl
where 1 = 1    
            AND CONCURRENT_PROGRAM_NAME LIKE 'IPC_RPT%' 
             AND CONCURRENT_PROGRAM_NAME NOT IN('IPC_RPT_MOD_CHK');

SELECT *
FROM IPC_CONCURRENT_PROGRAMS;
select *
from ra_customer_trx_all
where trx_number like '511%103';

select *
from fnd_responsibility_tl
where responsibility_name like 'IPC%Receivables%';

select *
from fnd_

-- 50732


select *
fro

select *
from fnd_request_groups;

select *
from fnd_request_group_units;

select *
from fnd_responsibility_tl;

select *
from fnd_responsibility;

select *
from fnd_concurrent_programs_tl
where  user_concurrent_program_name LIKE 'Inventory Value Report - by Subinventory';

select trx_number,
         attribute3
from ra_customer_trx_all
where attribute3 = 'CR4300';

select *
from all_tab_columns
where table_name like '%XXIPC_DBS_ONHAND%';

select *
from XXIPC_DBS_ONHAND;

SELECT *
FROM IPC_IPS_ONHAND;

SELECT *
FROM mtl_onhand_quantities_detail
WHERE ORGANIZATION_ID = 87;


 SELECT oo.organization_name AS "Organization Name",
            moqd.organization_id AS "Org ID",
            moqd.subinventory_code AS "Subinventory",
            moqd.inventory_item_id AS "Item Id",
            msib.segment1 AS "Oracle Part Number",
            msib.attribute14 AS "IFS Part Number",
            msib.description AS "Part Description",
            NVL (SUM (moqd.primary_transaction_quantity), 0)
               AS "On Hand Quantity"
       FROM mtl_system_items_b msib
            LEFT JOIN mtl_onhand_quantities_detail moqd
               ON moqd.inventory_item_id = msib.inventory_item_id
                  AND moqd.organization_id = msib.organization_id
            LEFT JOIN mtl_secondary_inventories_fk_v msiv
               ON msiv.organization_id = moqd.organization_id
                  AND moqd.subinventory_code = msiv.secondary_inventory_name
            LEFT JOIN org_organization_definitions oo
               ON msib.organization_id = oo.organization_id
      WHERE     1 = 1
          --  AND MSIB.organization_id = 87
           -- AND moqd.subinventory_code = 'IPS'
            and msib.segment1 = '1156032675'
   GROUP BY oo.organization_name,
            moqd.organization_id,
            moqd.subinventory_code,
            msiv.description,
            moqd.inventory_item_id,
            msib.segment1,
            msib.attribute14,
            msib.description;


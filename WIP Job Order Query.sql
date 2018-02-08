SELECT B.WIP_ENTITY_NAME JO_NUM,
                B.PRIMARY_ITEM_ID ASSEMBLY_ITEM_ID,
                A.ATTRIBUTE1 LOT_NUMBER
FROM WIP_DISCRETE_JOBS A,
                                WIP_ENTITIES B
        WHERE A.WIP_ENTITY_ID = B.WIP_ENTITY_ID;


SELECT we.wip_entity_name job_order_no,
            msib.segment1 part_no,
            msib.attribute9 sales_model,
            msib.attribute8 color,
            wdj.attribute1 lot_number,
            org.name organization,
            wdj.start_quantity,
            wdj.quantity_completed,
            wdj.date_released,
            wdj.date_completed,
            mfl.meaning jo_status
FROM wip_discrete_jobs wdj 
           LEFT JOIN  wip_entities we
                ON wdj.wip_entity_id = we.wip_entity_id
                AND wdj.organization_id = we.organization_id
           LEFT JOIN hr_all_organization_units org
                ON org.organization_id = wdj.organization_id
           LEFT JOIN mtl_system_items_b msib
                ON msib.inventory_item_id = we.primary_item_id
                AND msib.organization_id = wdj.organization_id 
           LEFT JOIN mfg_lookups mfl
                ON (wdj.status_type) =  (mfl.lookup_code)  and lookup_type = 'WIP_JOB_STATUS'
WHERE wdj.date_released BETWEEN '01-JAN-2017' AND '30-SEP-2017';

select *
from wip_discrete_jobs;

    select*
    from mfg_lookups;
    
    select status_type
    from wip_discrete_jobs;
            SELECT B.WIP_ENTITY_NAME JO_NUM,
                B.PRIMARY_ITEM_ID ASSEMBLY_ITEM_ID,
                A.ATTRIBUTE1 LOT_NUMBER,
                c.meaning JO_STATUS
FROM WIP_DISCRETE_JOBS A,
                                WIP_ENTITIES B,
                                mfg_lookups c
        WHERE A.WIP_ENTITY_ID = B.WIP_ENTITY_ID
                    and   a.STATUS_TYPE =  c.LOOKUP_CODE 
                    and c.lookup_type = 'WIP_JOB_STATUS';

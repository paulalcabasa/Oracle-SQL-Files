select *
from MTL_SYSTEM_ITEMS_FVL;

select msib.inventory_item_id,
         msib.segment1 part_no,
         msib.description part_description,
         msib.planner_code,
         org.name organization
from mtl_system_items_b msib,
        hr_all_organization_units org
where org.organization_id = msib.organization_id;

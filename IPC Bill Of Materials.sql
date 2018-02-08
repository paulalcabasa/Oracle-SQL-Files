/* Formatted on 19/9/2017 10:44:28 AM (QP5 v5.163.1008.3004) */
CREATE OR REPLACE VIEW IPC_VSS_LOV AS SELECT 
--        B.SERIAL_NUMBER,
--       A.SEGMENT1,
--       A.DESCRIPTION,
--       B.CURRENT_SUBINVENTORY_CODE
        distinct segment1,
        B.CURRENT_ORGANIZATION_ID
  FROM MTL_SYSTEM_ITEMS_B A, MTL_SERIAL_NUMBERS B
 WHERE     A.INVENTORY_ITEM_ID = B.INVENTORY_ITEM_ID
       AND A.ORGANIZATION_ID = B.CURRENT_ORGANIZATION_ID
--       AND C_ATTRIBUTE30 IS NULL
--       AND a.segment1 = '170TBR-IPCDXTLE-O.GRAY'
       AND B.CURRENT_SUBINVENTORY_CODE IN ('STG', 'VSS')
--       AND CURRENT_STATUS = 3;
;
select distinct current_organization_id
from IPC_VSS_LOV;



select *
from mtl_system_items_b
where organization_id = 88
        and segment1 = '170TBR-IPCDXTLE-O.GRAY'
;
select organization_id,
           name
from hr_all_organization_units
where organization_id IN (141,121,88);

SELECT organization_code,
             organization_id
FROM mtl_parameters
WHER;

                       

/*IPC Bill of Materials
   Parameter: :p_fg_model = VSS model
                       :p_org = Org Name (limit to IVP, NYK, IVS)
                       */


select distinct
                   fg_model,
                   assembly_parent_part_number,
                   parent_description,
                   parent_category_family,
                   parent_category_class,
                   parent_item_type,
                   child_item,
                   item_category_class as child_category_class,
                   item_category_family as child_category_family,
                   item_type as child_item_type,
                   component_quantity,
                   cost
from 
                 (select 
                                                 b.*,
             (case when item_category_family = 'WIP'
                   then 0
                   else child_item_cost
              end) cost,
                                                (case when parent_item_type = 'Subassembly Non Chassis'
                        and parent_category_family = 'LOCAL'
                   then 'OSP'
                   else 'Regular'
              end) type_item
       from
                                   (select
                                                                  :p_fg_model as fg_model,
                                                                  bom.oracle_part_number as assembly_parent_part_number,
                  bom.description as parent_description,
                  bom.item_category_family as parent_category_family,
                  bom.item_category_class as parent_category_class,
                  bom.item_type AS parent_item_type,
                                                                  lpad ('', 2 * (level - 1),'') ||
                                                                                   (select 
                                                                                                                   msi.segment1
                        from 
                                                                                                                 mtl_system_items msi
                        where
                                                                                                                msi.inventory_item_id = bic.component_item_id
                             and msi.organization_id = :p_org
                                                                                   ) as child_item,
                  iica.item_category_class,
                  iica.item_category_family, 
                                                                  iica.item_type,
                  (select
                                                                                                 msi.item_type
                   from 
                                                                                                mtl_system_items msi
                   where 
                                                                                                 msi.inventory_item_id = bic.component_item_id
                         and msi.organization_id = :p_org
                                                                   ) as child_item_type,
                   (select 
                                                                                                   iic.item_cost
                    from 
                                                                                                 mtl_system_items msi,
                         ipc_item_cost iic
                    where 
                                                                                                  msi.inventory_item_id = bic.component_item_id
                          and msi.inventory_item_id = iic.inventory_item_id
                          and msi.organization_id = iic.organization_id
                          and iic.cost_type = 'FIFO'
                          and msi.organization_id = :p_org
                                                                    ) as child_item_cost,
                                                                                bic.component_quantity
            from 
                bom_inventory_components bic,
                ipc_item_cost_account iica,
                (select 
                    a.bill_sequence_id,
                    (case when upper( b.item_type) = 'PHANTOM' THEN 
                    (SELECT ASSEMBLY_NO FROM IPC.IPC_BOM_DETAILS AA WHERE AA.BOM_COMPONENT_ID = a.assembly_item_id AND  AA.FG_MODEL_NO LIKE :p_fg_model)
        ELSE b.ORACLE_PART_NUMBER END) ORACLE_PART_NUMBER,
        a.assembly_item_id ,
    --    b.ORACLE_PART_NUMBER,
--        b.description,
         (case when upper( b.item_type) = 'PHANTOM' THEN 
                    (SELECT ASSEMBLY_DESCRIPTION FROM IPC.IPC_BOM_DETAILS AA WHERE AA.BOM_COMPONENT_ID = a.assembly_item_id AND  AA.FG_MODEL_NO LIKE :p_fg_model)
        ELSE   b.description END) DESCRIPTION, 
                 --   a.assembly_item_id,
               --     b.oracle_part_number,
              --      b.description,
                    b.item_category_family,
                    b.item_category_class,
                    b.item_type
                 from 
                    bom_bill_of_materials a,
                    ipc_item_cost_account b
                 where
                    a.organization_id = :p_org
                    and a.organization_id = b.organization_id
                    and a.assembly_item_id = b.inventory_item_id
                ) bom
        where 
            bic.component_item_id = iica.inventory_item_id
            and bic.pk2_value = iica.organization_id
            and bic.disable_date is null
            and bom.bill_sequence_id = bic.bill_sequence_id
            and iica.item_type <> 'Phantom'
start with
    bom.oracle_part_number like :p_fg_model --'170TBR-IPCDXTLE-O.GRAY'
connect by prior 
    bic.component_item_id = bom.assembly_item_id
order by 
    level, 
    bom.assembly_item_id
            ) b
     ) c
where 
    c.type_item <> 'OSP'
order by
    c.assembly_parent_part_number ASC;

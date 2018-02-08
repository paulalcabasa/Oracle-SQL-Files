select  --  msib.inventory_item_id,
        --    msib.organization_id,
            org.name organization,
            msib.segment1 part_no,
            msib.description,
            gcc1.concatenated_segments "Sales Account",
            gcc2.concatenated_segments "Cost of Sales Account",
            gcc3.concatenated_segments "Expense Account",
            msib_subinv.secondary_inventory,
            msib_subinv.sub_description,
            mtl_cat.category_set_name "Category Set Name",
            mtl_cat.control_level_disp "Control Level",
            mtl_cat.category_concat_segs "Category"
       --     msib.inventory_item_flag,
      --      msif.INVENTORY_ITEM_STATUS_CODE "Item Status"
from mtl_system_items_b msib,
        hr_all_organization_units org,
        MTL_SYSTEM_ITEMS_FVL msif,
        gl_code_combinations_kfv gcc1,
        gl_code_combinations_kfv gcc2,
        gl_code_combinations_kfv gcc3,
        MTL_ITEM_SUB_INVENTORIES_ALL_V msib_subinv,
        MTL_ITEM_CATEGORIES_V mtl_cat
where 1 = 1
           and org.organization_id = msib.organization_id
           and msib.inventory_item_id = msif.inventory_item_id
           and msib.organization_id = msif.organization_id
           and gcc1.code_combination_id = msif.sales_account
           and gcc2.code_combination_id = msif.cost_of_sales_account
           and gcc3.code_combination_id = msif.expense_account
           and msib_subinv.inventory_item_id(+) = msib.inventory_item_id
           and msib_subinv.organization_id(+) = msib.organization_id
           and mtl_cat.inventory_item_id = msib.inventory_item_id
           and mtl_cat.organization_id = msib.organization_id
   and mtl_cat.category_concat_segs = 'DFLT.DFLT'
           and msib.organization_id <> 86
           and msif.inventory_item_flag = 'Y'
    --        and msib.segment1 = '000120'
           and mtl_cat.control_level_disp = 'Org'
--         and msib.segment1 = '170TBR-IPCBD2LE-V.RED'
         and msif.INVENTORY_ITEM_STATUS_CODE = 'Active';
--         ==  and msib.organization_id = 102;
;


-- PARTS

select  --  msib.inventory_item_id,
        --    msib.organization_id,
            org.name organization,
            msib.segment1 part_no,
            msib.description,
            gcc1.concatenated_segments "Sales Account",
            gcc2.concatenated_segments "Cost of Sales Account",
            gcc3.concatenated_segments "Expense Account",
            msib_subinv.secondary_inventory,
            msib_subinv.sub_description,
            mtl_cat.category_set_name "Category Set Name",
            mtl_cat.control_level_disp "Control Level",
            mtl_cat.category_concat_segs "Category"
from mtl_system_items_b msib,
        hr_all_organization_units org,
        MTL_SYSTEM_ITEMS_FVL msif,
        gl_code_combinations_kfv gcc1,
        gl_code_combinations_kfv gcc2,
        gl_code_combinations_kfv gcc3,
        MTL_ITEM_SUB_INVENTORIES_ALL_V msib_subinv,
        MTL_ITEM_CATEGORIES_V mtl_cat
where 1 = 1
           and org.organization_id = msib.organization_id
           and msib.inventory_item_id = msif.inventory_item_id
           and msib.organization_id = msif.organization_id
           and gcc1.code_combination_id = msif.sales_account
           and gcc2.code_combination_id = msif.cost_of_sales_account
           and gcc3.code_combination_id = msif.expense_account
           and msib_subinv.inventory_item_id(+) = msib.inventory_item_id
           and msib_subinv.organization_id(+) = msib.organization_id
           and mtl_cat.inventory_item_id = msib.inventory_item_id
           and mtl_cat.organization_id = msib.organization_id
           and msif.INVENTORY_ITEM_STATUS_CODE = 'Active'
    --       and msib.organization_id <> 86
           and msif.inventory_item_flag = 'Y'
           and mtl_cat.control_level_disp = 'Org'
           and msib.organization_id IN(87,106,103)
          and mtl_cat.category_concat_segs LIKE 'PARTS%'
          and msib_subinv.secondary_inventory NOT IN ( 'STG','RECON')
            --        and msib.segment1 = '000120'
           
            --         and msib.segment1 = '170TBR-IPCBD2LE-V.RED'
         ;

;


select  --  msib.inventory_item_id,
        --    msib.organization_id,
            org.name organization,
            msib.segment1 part_no,
            msib.description,
            gcc1.concatenated_segments "Sales Account",
            gcc2.concatenated_segments "Cost of Sales Account",
            gcc3.concatenated_segments "Expense Account",
            msib_subinv.secondary_inventory,
            msib_subinv.sub_description,
            mtl_cat.category_set_name "Category Set Name",
            mtl_cat.control_level_disp "Control Level",
            mtl_cat.category_concat_segs "Category"
from mtl_system_items_b msib,
        hr_all_organization_units org,
        MTL_SYSTEM_ITEMS_FVL msif,
        gl_code_combinations_kfv gcc1,
        gl_code_combinations_kfv gcc2,
        gl_code_combinations_kfv gcc3,
        MTL_ITEM_SUB_INVENTORIES_ALL_V msib_subinv,
        MTL_ITEM_CATEGORIES_V mtl_cat
where 1 = 1
           and org.organization_id = msib.organization_id
           and msib.inventory_item_id = msif.inventory_item_id
           and msib.organization_id = msif.organization_id
           and gcc1.code_combination_id = msif.sales_account
           and gcc2.code_combination_id = msif.cost_of_sales_account
           and gcc3.code_combination_id = msif.expense_account
           and msib_subinv.inventory_item_id(+) = msib.inventory_item_id
           and msib_subinv.organization_id(+) = msib.organization_id
           and mtl_cat.inventory_item_id = msib.inventory_item_id
           and mtl_cat.organization_id = msib.organization_id
           and msif.INVENTORY_ITEM_STATUS_CODE = 'Active'
    --       and msib.organization_id <> 86
           and msif.inventory_item_flag = 'Y'
           and mtl_cat.control_level_disp = 'Org'
           and msib.organization_id IN(104,107)
          and mtl_cat.category_concat_segs LIKE 'VSS%'
     --     and msib_subinv.secondary_inventory NOT IN ( 'STG','RECON')
            --        and msib.segment1 = '000120'
           
              and msib.segment1 = '020NHR55EL-TILT'
         ;

;



DBS 102
IPS  87
RIO 106
NAC 103
NYK 104
IVS 107
SELECT *
FROM HR_ALL_ORGANIZation_units;

select *
from zx_taxes_b
where tax LIKE 'V2(S)%';
select *
from zx_taxes_b ;

select *
from gl_code_combinations
where code_combination_id = 204334;

select *
from zx_rates_vl;

select *
from zx_party_tax_profile;

 SELECT hou.organization_id,
       hou.NAME,
       (select concatenated_segments from gl_code_combinations_kfv where code_combination_id = tax_account_ccid) tax_account,
       zxr.tax,
       zxr.tax_status_code,
       zxr.tax_regime_code,
       zxr.tax_rate_code,
       zxr.tax_jurisdiction_code,
       zxr.rate_type_code,
       zxr.percentage_rate,
       zxr.tax_rate_id,
       zxr.effective_from,
       zxr.effective_to,
       zxr.active_flag
  FROM zx_rates_vl        zxr,
       zx_accounts        b,
       hr_operating_units hou
 WHERE b.internal_organization_id = hou.organization_id
   AND b.tax_account_entity_code = 'RATES'
   AND b.tax_account_entity_id = zxr.tax_rate_id
   AND zxr.active_flag = 'Y'
   and  zxr.tax_rate_code LIKE 'V2%'
   AND SYSDATE BETWEEN zxr.effective_from AND nvl(zxr.effective_to, SYSDATE);

SELECT DISTINCT CATEGORY_CONCAT_SEGS
FROM MTL_ITEM_CATEGORIES_V;
-- fg inventory item
select * from apps.zx_rates_b;

select *
from MTL_SYSTEM_FVL;
select *
from MTL_ITEM_SUB_INVENTORIES_ALL_V 
where inventory_item_id = 105398;
a
select distinct category_concat_segs
from MTL_ITEM_CATEGORIES_V;
select *
from hr_all_organization_units;

select *
from mtl_item_categories m_cat,
        mtl_category_sets_b m_cat_set
where 1 = 1
          and m_cat.category_set_id = m_cat_set.category_set_id 
    
          and m_cat.inventory_item_id = 105398
          and m_cat.organization_id = 102;

select *
from mtl_category_sets_b;

select *
from mtl_categories;
select *
from mtl_item_categories;

select *
from MTL_ITEM_CATEGORIES_V
where inventory_item_id = 105398
and organization_id = 102;
          -- IVS
          -- Sales
          -- Cost Account
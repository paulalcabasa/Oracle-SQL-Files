select  msib.segment1 part_no,
            msib.description,
            cidv.subinventory_code,
            mmt.transaction_quantity,
            mmt.transaction_uom,
            mmt.primary_quantity,
            msib.primary_uom_code,
            mtst.transaction_source_type_name source_type,
            mmt.transaction_source_id,
            cidv.transaction_type_name,
            cidv.transaction_date,
            cidv.line_type_name,
            gcc.concatenated_segments account_no,
            cidv.base_transaction_value transaction_value,
            cidv.unit_cost,
            (cidv.unit_cost * cidv.PRIMARY_QUANTITY) value
from mtl_material_transactions mmt,
         mtl_system_items_b msib,
         cst_inv_distribution_v cidv,
         mtl_txn_source_types mtst,
         gl_code_combinations_kfv gcc
where 1 = 1
            and mmt.inventory_item_id = msib.inventory_item_id
            and msib.organization_id = mmt.organization_id
            and mtst.transaction_source_type_id =  mmt.transaction_source_type_id
            and cidv.transaction_id = mmt.transaction_id
            and gcc.code_combination_id = cidv.reference_account
            and msib.segment1 = '12001009'
            and mmt.transaction_date >= to_date('2017/06/30 22:00:00','yyyy/mm/dd hh24:mi:ss');


select *
from CST_INV_DISTRIBUTION_V
where transaction_id = 4539592;

select *
from mtl_txn_source_types;






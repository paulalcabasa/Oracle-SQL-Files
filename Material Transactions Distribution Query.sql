--Material Transaction Distribution 
select
        cid.organization_id
      , cid.organization_code 
      , hro.NAME 
      , TRUNC (mmt.transaction_date) AS transaction_date
      , mmt.transaction_id
      , mck.segment1 AS item_category_family
      , mck.segment2 AS item_category_class
      , msi.item_type
      , flv.meaning AS item_type_description
      , mty.transaction_type_name
      , mmt.transaction_type_id
      , msi.segment1 AS item
      , msi.description
      , mmt.transaction_quantity
      , mmt.transaction_uom
      , mmt.transaction_source_name
      , cid.unit_cost
      , NVL (mmt.actual_cost, 0) AS actual_cost
      , gcc.concatenated_segments AS account_code_combination
      , gcc.segment6 as account_code
      , cid.line_type_name
      , cid.base_transaction_value
      ,
         CASE
            WHEN cid.base_transaction_value > 0
               THEN cid.base_transaction_value
         END debit_amount,
         CASE
            WHEN cid.base_transaction_value < 0
               THEN cid.base_transaction_value
         END credit_amount
         
FROM 
       mtl_material_transactions mmt
     , mtl_system_items_b msi
     , hr_all_organization_units hro
     , mtl_transaction_types mty
     , cst_inv_distribution_v cid
     , gl_code_combinations_kfv gcc
     , fnd_lookup_values_vl flv
     , mtl_item_categories mtc
     , mtl_categories_kfv mck

where

         msi.inventory_item_id = mtc.inventory_item_id
     AND mmt.organization_id = mtc.organization_id
     AND mtc.category_id = mck.category_id
     AND CID.ORGANIZATION_ID = :P_ORG_ID
     AND mmt.inventory_item_id = msi.inventory_item_id
     AND mmt.organization_id = msi.organization_id
     AND mmt.organization_id = hro.organization_id
     AND mmt.transaction_type_id = mty.transaction_type_id
     AND mmt.transaction_id = cid.transaction_id
     AND mmt.organization_id = cid.organization_id
     AND cid.reference_account = gcc.code_combination_id
     AND flv.lookup_type = 'ITEM_TYPE'
     AND msi.item_type = flv.lookup_code
     AND mck.structure_id = '50388'
     AND TO_DATE (MMT.TRANSACTION_DATE) BETWEEN TO_DATE(:P_FROM_DATE, 'yyyy/mm/dd hh24:mi:ss') AND TO_DATE(:P_TO_DATE, 'yyyy/mm/dd hh24:mi:ss')
ORDER BY mmt.transaction_id;


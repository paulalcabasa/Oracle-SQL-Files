SELECT mmt.CREATION_DATE,
           mmt.transaction_date AS transaction_date,
           mmt.transaction_id,
           we.wip_entity_name job_id,
           msib.segment1 part_no,
           msib.description part_description,
           mck.segment1 AS item_type,                  --item_category_family,
           mtt.transaction_type_name transaction_type,
           xdl.source_distribution_type source_distribution,
           xal.accounting_class_code,
           xah.gl_transfer_date,
           gcc.segment6,
           TO_NUMBER (xal.entered_dr) entered_debit,
           TO_NUMBER (xal.entered_cr) entered_credit,
           xdl.ae_header_id,
           xdl.ae_line_num,
           mmt.organization_id,
           org.name organization_name
FROM xla_distribution_links xdl,
           xla_ae_headers xah,
           xla_ae_lines xal,
           gl_code_combinations gcc,
           wip_transaction_accounts wta,
           wip_entities we,
           hr_all_organization_units org,
           /*** ITEM ***/
           mtl_system_items_b msib,
           mtl_item_categories mtc,
           mtl_categories_kfv mck,
           fnd_lookup_values_vl flv,
           /*** MATERIAL TRANSACTIONS ***/
           mtl_material_transactions mmt,
           mtl_transaction_types mtt
     WHERE     1 = 1
           AND xal.ae_header_id = xdl.ae_header_id
           AND xal.ae_line_num = xdl.ae_line_num
           AND xal.ae_header_id = xah.ae_header_id
           AND xdl.source_distribution_type = 'WIP_TRANSACTION_ACCOUNTS'
           AND xal.code_combination_id = gcc.code_combination_id
           AND xdl.source_distribution_id_num_1 = wta.wip_sub_ledger_id
           AND we.wip_entity_id = wta.wip_entity_id
           AND org.organization_id = we.organization_id
           AND msib.inventory_item_id = we.primary_item_id
           AND msib.organization_id = we.organization_id
           /*** item ****/
           AND msib.inventory_item_id = mtc.inventory_item_id
           AND mtc.CATEGORY_ID = mck.CATEGORY_ID
           AND mtc.organization_id = msib.organization_id
           AND MSIb.ITEM_TYPE = FLV.LOOKUP_CODE
           AND FLV.LOOKUP_TYPE = 'ITEM_TYPE'
           AND MCK.STRUCTURE_ID = '50388'
           /**** material transactions ***/
           AND we.wip_entity_id = mmt.transaction_source_id
           AND mmt.transaction_source_id = wta.wip_entity_id
           AND mmt.inventory_item_id = we.primary_item_id
           AND mmt.organization_id = we.organization_id
           AND mtt.transaction_type_id = mmt.transaction_type_id
           AND wta.organization_id = mmt.organization_id
           AND wta.wip_entity_id = we.wip_entity_id
         AND msib.segment1 = '150TBR54FWL-IPCAC1-PS2S.WHI';
   --        AND msib.segment1 = 'EXR51F-A.WHI';
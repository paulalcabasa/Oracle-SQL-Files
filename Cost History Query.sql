CREATE OR REPLACE VIEW XXIPC_MTL_TXN_V AS SELECT mmt.CREATION_DATE,
            mmt.transaction_date AS transaction_date,
            mmt.transaction_id, 
            null job_id,
            msib.segment1 part_no,
            msib.description part_description,
            mck.segment1 as item_type, --item_category_family,
            mty.transaction_type_name transaction_type,
            xdl.source_distribution_type source_distribution,
            xal.accounting_class_code,
            xah.gl_transfer_date,
            gcc.segment6,
            to_number(xal.entered_dr) entered_debit,
            to_number(xal.entered_cr) entered_credit,
            xdl.ae_header_id, 
            xdl.ae_line_num,
            mmt.organization_id,
            org.name organization_name
          
FROM    xla_distribution_links xdl,
            xla_ae_headers       xah,
            xla_ae_lines         xal,
            gl_code_combinations gcc,
            mtl_transaction_accounts mta,
            mtl_system_items_b msib,
            mtl_material_transactions mmt,
            MTL_ITEM_CATEGORIES  mtc,
            mtl_categories_kfv mck,
            FND_LOOKUP_VALUES_VL flv,
            MTL_TRANSACTION_TYPES MTY,
            hr_all_organization_units org
WHERE     1 = 1
                and mmt.inventory_item_id = msib.inventory_item_id 
                and mmt.organization_id = msib.organization_id  
                and xal.code_combination_id = gcc.code_combination_id
                and xah.ae_header_id = xal.ae_header_id
                and xal.ae_header_id = xdl.ae_header_id
                and xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id
                and mmt.transaction_id = mta.transaction_id
                and xal.ae_line_num = xdl.ae_line_num
                /* new joins */
                and msib.inventory_item_id = mtc.inventory_item_id 
                and MMT.ORGANIZATION_ID = mtc.ORGANIZATION_ID
                and MMT.TRANSACTION_TYPE_ID = MTY.TRANSACTION_TYPE_ID
                and org.organization_id = MMT.organization_id
                and mtc.CATEGORY_ID =mck.CATEGORY_ID  
                and  MSIb.ITEM_TYPE = FLV.LOOKUP_CODE  
                and  FLV.LOOKUP_TYPE = 'ITEM_TYPE'
                and  MCK.STRUCTURE_ID = '50388'
                and xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS';
                
CREATE OR REPLACE VIEW XXIPC_WIP_TXN_V AS (SELECT    mmt.CREATION_DATE,
                mmt.transaction_date AS transaction_date,
                mmt.transaction_id, 
                we.wip_entity_name job_id,
                msib.segment1 part_no,
                msib.description part_description,
                mck.segment1 as item_type, --item_category_family,
                mtt.transaction_type_name transaction_type,
                xdl.source_distribution_type source_distribution,
                xal.accounting_class_code,
                xah.gl_transfer_date,
                gcc.segment6,
                to_number(xal.entered_dr) entered_debit,
                to_number(xal.entered_cr) entered_credit,
                xdl.ae_header_id, 
                xdl.ae_line_num,
                mmt.organization_id,
                org.name organization_name
            
from xla_distribution_links xdl,
        xla_ae_headers       xah,
        xla_ae_lines         xal,
        gl_code_combinations gcc,
        wip_transaction_accounts wta,
        wip_entities we,
        hr_all_organization_units org,
        /*** ITEM ***/
        mtl_system_items_b msib,
        mtl_item_categories  mtc,
        mtl_categories_kfv mck,
        fnd_lookup_values_vl flv,
        /*** MATERIAL TRANSACTIONS ***/
       mtl_material_transactions mmt,
       mtl_transaction_types mtt
WHERE 1 = 1
        and xal.ae_header_id = xdl.ae_header_id
        and xal.ae_line_num = xdl.ae_line_num
        and xal.ae_header_id = xah.ae_header_id  
        and xdl.source_distribution_type = 'WIP_TRANSACTION_ACCOUNTS'
        and xal.code_combination_id = gcc.code_combination_id
        and xdl.source_distribution_id_num_1 = wta.wip_sub_ledger_id
        and we.wip_entity_id = wta.wip_entity_id
        and org.organization_id = we.organization_id
        and msib.inventory_item_id = we.primary_item_id
        and msib.organization_id = we.organization_id
        /*** item ****/
        and msib.inventory_item_id = mtc.inventory_item_id
        and mtc.CATEGORY_ID =mck.CATEGORY_ID
        and mtc.organization_id = msib.organization_id
        and  MSIb.ITEM_TYPE = FLV.LOOKUP_CODE  
        and  FLV.LOOKUP_TYPE = 'ITEM_TYPE'
        and  MCK.STRUCTURE_ID = '50388'
        /**** material transactions ***/
        and we.wip_entity_id = mmt.transaction_source_id 
        and mmt.transaction_source_id = wta.wip_entity_id
        and mmt.inventory_item_id = we.primary_item_id
        and mmt.organization_id = we.organization_id
        and mtt.transaction_type_id = mmt.transaction_type_id   
        and wta.organization_id = mmt.organization_id
        and wta.wip_entity_id = we.wip_entity_id
     ) ;
                                                    
     
     
SELECT CREATION_DATE,
            TRANSACTION_DATE,
            TRANSACTION_ID,
            JOB_ID,
            PART_NO,
            PART_DESCRIPTION,
            ITEM_TYPE,
            TRANSACTION_TYPE,
            SOURCE_DISTRIBUTION,
            ACCOUNTING_CLASS_CODE,
            GL_TRANSFER_DATE,
            SEGMENT6,
            ENTERED_DEBIT,
            ENTERED_CREDIT,
            ORGANIZATION_ID
FROM XXIPC_MTL_TXN_V
WHERE 1 = 1

            and part_no = NVL(:p_part_no,part_no)
            and item_type = NVL(:p_item_category,item_type)
            and organization_id = :p_org_id
            and TRUNC(creation_date) BETWEEN TO_DATE(nvl(:p_creation_date_from,creation_date), 'yyyy/mm/dd hh24:mi:ss')
                                                       and TO_DATE (nvl(:p_creation_date_to,TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS')), 'yyyy/mm/dd hh24:mi:ss')             
            and TRUNC(transaction_date) BETWEEN TO_DATE (nvl(:p_trans_date_from,transaction_date), 'yyyy/mm/dd hh24:mi:ss') 
                                                           and TO_DATE (nvl(:p_trans_date_to,TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS')), 'yyyy/mm/dd hh24:mi:ss')                                       
UNION ALL
SELECT CREATION_DATE,
            TRANSACTION_DATE,
            TRANSACTION_ID,
            JOB_ID,
            PART_NO,
            PART_DESCRIPTION,
            ITEM_TYPE,
            TRANSACTION_TYPE,
            SOURCE_DISTRIBUTION,
            ACCOUNTING_CLASS_CODE,
            GL_TRANSFER_DATE,
            SEGMENT6,
            ENTERED_DEBIT,
            ENTERED_CREDIT,
            ORGANIZATION_ID
FROM XXIPC_WIP_TXN_V   
WHERE 1 = 1
            and part_no = NVL(:p_part_no,part_no)
            and item_type = NVL(:p_item_category,item_type)
            and organization_id = :p_org_id
            and TRUNC(creation_date) BETWEEN TO_DATE(nvl(:p_creation_date_from,creation_date), 'yyyy/mm/dd hh24:mi:ss')
                                                       and TO_DATE (nvl(:p_creation_date_to,TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS')), 'yyyy/mm/dd hh24:mi:ss')             
            and TRUNC(transaction_date) BETWEEN TO_DATE (nvl(:p_trans_date_from,transaction_date), 'yyyy/mm/dd hh24:mi:ss') 
                                                           and TO_DATE (nvl(:p_trans_date_to,TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS')), 'yyyy/mm/dd hh24:mi:ss');
                                                           
                                                           






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
     --    AND msib.segment1 = '150TBR54FWL-IPCAC1-PS2S.WHI';
           AND msib.segment1 = 'EXR51F-A.WHI';
           -- 20044
           -- 18224
           select *
           from wip_transaction_accounts;
           
           select *
           from wip_entities
           where wip_entity_name = '18224';
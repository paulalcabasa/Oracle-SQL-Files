/*******    RECEIVING INSPECTION *******/ 
SELECT    
               msib.segment1,
               msib.description,
               po_lines.vendor_product_num lot_number,
               mck.segment1 as item_category_family,
               mck.segment2 as item_category_class,
               msib.item_type,
               mmt.transaction_quantity,
               mty.transaction_type_name,
               mmt.transaction_date AS transaction_date,
               xah.accounting_date,
               /** REFERENCES **/
               mmt.transaction_id, 
               mmt.organization_id,
               org.name organization,
               mmt.transaction_source_id receiving_transaction_id,
               po_head.segment1 po_number,
               po_lines.line_num
FROM  xla_distribution_links xdl,
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
            hr_all_organization_units org,
            rcv_transactions rcvt,
            po_lines_all po_lines,
            po_headers_all po_head
WHERE     1 = 1
                and mmt.inventory_item_id = msib.inventory_item_id 
                and mmt.organization_id = msib.organization_id  
                and xal.code_combination_id = gcc.code_combination_id
                and xah.ae_header_id = xal.ae_header_id
                and xal.ae_header_id = xdl.ae_header_id
                and xal.ae_line_num = xdl.ae_line_num
                /* new joins */
                and msib.inventory_item_id = mtc.inventory_item_id 
                and MMT.ORGANIZATION_ID = mtc.ORGANIZATION_ID
                and mmt.organization_id = msib.organization_id  
                and MMT.TRANSACTION_TYPE_ID = MTY.TRANSACTION_TYPE_ID
                and org.organization_id = MMT.organization_id
                and mtc.CATEGORY_ID =mck.CATEGORY_ID  
                and  MSIb.ITEM_TYPE = FLV.LOOKUP_CODE  
                and  FLV.LOOKUP_TYPE = 'ITEM_TYPE'
                and  MCK.STRUCTURE_ID = '50388'
                and xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
                and xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id
                and mmt.transaction_id = mta.transaction_id
         --       and xah.accounting_date BETWEEN :P_Start_Date AND :P_End_Date
                and  mmt.organization_id in ('88') --rio nac dbs ips
                and msib.item_type = 'CKD'
                and xal.accounting_class_code IN ('RECEIVING_INSPECTION')
                /***** PURCHASE ORDER *****/
                and mmt.rcv_transaction_id = rcvt.transaction_id
                and po_lines.po_line_id = rcvt.po_line_id
                and po_lines.po_header_id = po_head.po_header_id
ORDER BY xdl.ae_header_id, xdl.ae_line_num ASC;



-- PO rECEIPT (TRANSACTION _SOURCE_ID = PO_HEADER_ID)
-- WIP ISSUE (WIP_ENTITY_ID = WIP_DISCRETE_JOBS)

SELECT *
FROM  XXIPC_RCV_INSP_ACCTG_V;



/******* WIP  VALUATION *******/


SELECT    
               msib.segment1,
               msib.description,
               wdj.attribute1 lot_no,
               mck.segment1 as item_category_family,
               mck.segment2 as item_category_class,
               msib.item_type,
               mmt.transaction_quantity,
               mty.transaction_type_name,
               mmt.transaction_date AS transaction_date,
               xah.accounting_date,
               /** REFERENCES **/
               mmt.transaction_id, 
               mmt.organization_id,
               org.name organization,
               mmt.transaction_source_id wip_entity_id,
               we.wip_entity_name job_no
FROM  xla_distribution_links xdl,
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
            hr_all_organization_units org,
            wip_entities we,
            WIP_DISCRETE_JOBS wdj
WHERE     1 = 1
                and mmt.inventory_item_id = msib.inventory_item_id 
                and mmt.organization_id = msib.organization_id  
                and xal.code_combination_id = gcc.code_combination_id
                and xah.ae_header_id = xal.ae_header_id
                and xal.ae_header_id = xdl.ae_header_id
                and xal.ae_line_num = xdl.ae_line_num
                /* new joins */
                and msib.inventory_item_id = mtc.inventory_item_id 
                and MMT.ORGANIZATION_ID = mtc.ORGANIZATION_ID
                and mmt.organization_id = msib.organization_id  
                and MMT.TRANSACTION_TYPE_ID = MTY.TRANSACTION_TYPE_ID
                and org.organization_id = MMT.organization_id
                and mtc.CATEGORY_ID =mck.CATEGORY_ID  
                and  MSIb.ITEM_TYPE = FLV.LOOKUP_CODE  
                and  FLV.LOOKUP_TYPE = 'ITEM_TYPE'
                and  MCK.STRUCTURE_ID = '50388'
                and xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
                and xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id
                and mmt.transaction_id = mta.transaction_id
           
         --       and xah.accounting_date BETWEEN :P_Start_Date AND :P_End_Date
                and  mmt.organization_id in ('88') --rio nac dbs ips
                and msib.item_type = 'CKD'
                and xal.accounting_class_code IN ('WIP_VALUATION')
                /***** WIP *****/
                and mmt.transaction_source_id = we.wip_entity_id
                and wdj.wip_entity_id = we.wip_entity_id
                and wdj.status_type IN (3,4)
;

SELECT *
FROM XXIPC_WIP_VAL_ACCTG_V;

SELECT *
FROM XXIPC_RCV_INSP_ACCTG_V;
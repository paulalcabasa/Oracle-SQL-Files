select transaction_source_id
from mtl_material_transactions
where transaction_id = 2609424;

select *
from wip_entities
where wip_entity_id = 75008;
-- my new query

select *
from wip_transactions;

SELECT distinct
xah.application_id,
        org.name organization,
        mmt.transaction_cost,
        mmt.transaction_date,
         mmt.transaction_quantity,
         wdj.lot_number,
        mmt.transaction_id,
        mmt.transaction_source_id,
        we.wip_entity_id,
        we.wip_entity_name job_order_no,
        msib.segment1 assembly_no,
        msib.description,
        mck.segment1 as item_category_family,
        mck.segment2 as item_category_class,
        msib.item_type,
        flv.meaning  item_type_description,
        mtt.transaction_type_name,
        xdl.source_distribution_type,
        xdl.source_distribution_id_num_1,
        xah.ae_header_id,
        xal.ae_line_num,
        
        xal.accounting_class_code,
        xdl.accounting_line_code,
        xdl.line_definition_code,
        xdl.event_class_code,
        xdl.event_type_code,
        xdl.rounding_class_code,
        xah.accounting_date,
        to_char(xah.creation_date) creation_date,
        xah.je_category_name,
        to_char(gjh.doc_sequence_value) gl_voucher_no,
        gjl.je_line_num,
        xah.gl_transfer_status_code,
        to_char(xah.gl_transfer_date) gl_transfer_date,
        xah.period_name,
        to_char(glcc.segment6) account_no,
        xal.entered_dr xla_entered_dr,
        xal.entered_cr xla_entered_cr,
        xal.accounted_dr xla_accounted_dr,
        xal.accounted_cr xla_accounted_cr

FROM   
        xla.xla_ae_headers xah 
        INNER JOIN xla.xla_ae_lines xal
            ON  xah.ae_header_id = xal.ae_header_id 
            AND xal.application_id = xah.application_id
        INNER JOIN apps.gl_code_combinations glcc
            ON xal.code_combination_id = glcc.code_combination_id
        INNER  JOIN xla.xla_transaction_entities xte
            ON xah.entity_id = xte.entity_id
            AND xte.application_id = xal.application_id
       INNER JOIN xla_distribution_links xdl
            ON xah.ae_header_id = xdl.ae_header_id
            AND xdl.event_id = xah.event_id
        AND xdl.ae_line_num = xal.ae_line_num
            AND xdl.application_id = xah.application_id
        INNER JOIN wip_transaction_accounts wta
            ON xdl.source_distribution_id_num_1 = wta.wip_sub_ledger_id
        INNER JOIN mtl_material_transactions mmt
            ON mmt.transaction_source_id = wta.wip_entity_id
        INNER JOIN  wip_entities we
            ON  we.wip_entity_id = wta.wip_entity_id
            
            and we.organization_id = mmt.organization_id
            and mmt.inventory_item_id = we.primary_item_id
        INNER JOIN wip_discrete_jobs wdj
            ON wdj.wip_entity_id = we.wip_entity_id
            
        -- item
        INNER JOIN mtl_system_items_b msib
            ON mmt.inventory_item_id = msib.inventory_item_id
            AND mmt.organization_id = msib.organization_id
            
        INNER JOIN mtl_item_categories  mtc
            ON msib.inventory_item_id = mtc.inventory_item_id 
            AND msib.organization_id = mtc.organization_id 
        INNER JOIN mtl_categories_kfv mck 
            ON mtc.category_id =mck.category_id          
        INNER JOIN fnd_lookup_values flv
            ON  msib.item_type = flv.lookup_code  
        INNER JOIN hr_all_organization_units org
            ON org.organization_id = msib.organization_id    
        INNER JOIN mtl_transaction_types mtt
            ON mtt.transaction_type_id = mmt.transaction_type_id
            
        LEFT JOIN apps.gl_import_references gir
            ON gir.gl_sl_link_id = xal.gl_sl_link_id
            AND gir.gl_sl_link_table = xal.gl_sl_link_table
        LEFT JOIN apps.gl_je_lines gjl
            ON gjl.je_header_id = gir.je_header_id
            AND gjl.je_line_num = gir.je_line_num
        LEFT JOIN apps.gl_je_headers gjh         
            ON gjh.je_header_id = gjl.je_header_id
              
WHERE 1 = 1
            AND  mck.structure_id = '50388'
            AND  flv.lookup_type = 'ITEM_TYPE'
            AND xdl.source_distribution_type = 'WIP_TRANSACTION_ACCOUNTS'
            AND we.wip_entity_name = '302019'
            AND glcc.segment6 = '05800'
--            -- FILTERS
--            AND to_date(xah.creation_date) BETWEEN NVL(to_date(:p_creation_date_start,'yyyy/mm/dd hh24:mi:ss') ,to_date(xah.creation_date))
--                                                                          AND NVL(to_date(:p_creation_date_end,'yyyy/mm/dd hh24:mi:ss'),to_date(xah.creation_date)) -- creation date
         --   AND to_date(xah.accounting_date) BETWEEN NVL(to_date(:p_acctg_date_start,'yyyy/mm/dd hh24:mi:ss'),to_date(xah.accounting_date)) 
           --                                                               AND NVL(to_date(:p_acctg_date_end,'yyyy/mm/dd hh24:mi:ss'),to_date(xah.accounting_date)) -- gl date
--            AND glcc.segment6 BETWEEN NVL(:p_account_from,glcc.segment6) AND NVL(:p_account_to,glcc.segment6) -- account
--            AND mck.segment1 = NVL(:p_item_category,mck.segment1) -- item category
--            AND msib.segment1 = NVL(:p_part_no,msib.segment1) -- part no
--            AND msib.organization_id = NVL(:p_organization_id,msib.organization_id) -- organization
--            AND mmt.transaction_id LIKE '1117145'
            
        --    AND xah.accounting_date BETWEEN '01-JUL-2017' AND '01-JUL-2017'
    --  AND mmt.transaction_id = 2609424
     -- and mtt.transaction_type_name = 'WIP Completion'
       --      AND mmt.organization_id = 102
group by        
mmt.transaction_cost,
xah.application_id,
                mtt.transaction_type_name,
                mmt.transaction_date,
                mmt.transaction_id,
                we.wip_entity_id,
                we.wip_entity_name,
                xdl.source_distribution_type,
                xdl.source_distribution_id_num_1,
                xah.ae_header_id,
                xal.ae_line_num,
                xah.creation_date,
                org.name,
                xah.period_name,
                xal.accounting_class_code  ,
                xdl.accounting_line_code,
                xdl.line_definition_code,
                xdl.event_class_code,
                xdl.event_type_code,
                xdl.rounding_class_code,
                xah.accounting_date ,
                msib.segment1 ,
                msib.description,
                mck.segment1,
                mck.segment2,
                msib.item_type,
                flv.meaning ,
                xah.JE_CATEGORY_NAME,
                gjh.doc_sequence_value,
                gjl.je_line_num,
                glcc.segment6,
                xah.accounting_date,
                xah.gl_transfer_status_code,
                xah.gl_transfer_date,
                xal.entered_dr ,
                xal.entered_cr ,
                xal.accounted_dr ,
                xal.accounted_cr ,
                mmt.transaction_source_id,
                mmt.transaction_quantity,
                wdj.lot_number
;

-- old query reference
select   distinct org.name,
            mmt.transaction_id,
            mmt.transaction_source_id,
            we.wip_entity_id,
            we.wip_entity_name job_order_no,
            msib.segment1 assembly_no,
            msib.description,
            mck.segment1 as item_category_family,
            mck.segment2 as item_category_class,
            msib.item_type,
            flv.meaning  item_type_description,
            mtt.transaction_type_name,
            xdl.application_id    ,
            xdl.source_distribution_type  ,
            xdl.source_distribution_id_num_1 ,
            xdl.ae_header_id         ,
            xdl.ae_line_num         ,
            xal.accounting_class_code     ,
            xdl.accounting_line_code ,
            xdl.line_definition_code,
            xdl.event_class_code     ,
            xdl.event_type_code      ,
            xdl.rounding_class_code    ,
            xah.accounting_date           ,
            xah.gl_transfer_status_code  ,
            xah.gl_transfer_date  ,
            xah.je_category_name       ,
            xah.accounting_entry_type_code ,
            xah.doc_sequence_value     ,
            gcc.segment1             ,
            gcc.segment2             ,
            gcc.segment3                  ,
            gcc.segment4           ,
            gcc.segment5             ,
            gcc.segment6              ,
            gcc.segment7                 ,
            gcc.segment8           ,
            gcc.segment9              ,
            xah.description                ,
            xal.description           ,
            xal.displayed_line_number     ,
            xah.period_name             ,
            xal.entered_dr               ,
            xal.entered_cr              ,
            xal.accounted_dr            ,
            xal.accounted_cr             ,
            xdl.unrounded_entered_dr      ,
            xdl.unrounded_entered_cr     ,
            xdl.unrounded_accounted_dr  ,
            xdl.unrounded_accounted_cr   ,
            xal.currency_code           ,
            xal.currency_conversion_date,
            xal.currency_conversion_rate   ,
            xah.product_rule_code        

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
    --    and we.wip_entity_name = '43070'
    and gcc.segment6 = '38800'
    and mmt.transaction_id  = 2609424;
        and xah.accounting_date BETWEEN :P_Start_Date AND :P_End_Date

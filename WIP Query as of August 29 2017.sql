SELECT 
        org.name organization,
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
        INNER JOIN  wip_entities we
            ON  we.wip_entity_id = wta.wip_entity_id
        INNER JOIN mtl_material_transactions mmt
            ON mmt.transaction_source_id = wta.wip_entity_id
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
            AND we.wip_entity_name = '205024'
            -- FILTERS
            --AND to_date(xah.creation_date) BETWEEN NVL(to_date(:p_creation_date_start,'yyyy/mm/dd hh24:mi:ss') ,to_date(xah.creation_date))
             --                                                             AND NVL(to_date(:p_creation_date_end,'yyyy/mm/dd hh24:mi:ss'),to_date(xah.creation_date)) -- creation date
          --  AND to_date(xah.accounting_Wdate) BETWEEN NVL(to_date(:p_acctg_date_start,'yyyy/mm/dd hh24:mi:ss'),to_date(xah.accounting_date)) 
             --                                                             AND NVL(to_date(:p_acctg_date_end,'yyyy/mm/dd hh24:mi:ss'),to_date(xah.accounting_date)) -- gl date
            --AND glcc.segment6 BETWEEN NVL(:p_account_from,glcc.segment6) AND NVL(:p_account_to,glcc.segment6) -- account
            --AND mck.segment1 = NVL(:p_item_category,mck.segment1) -- item category
            --AND msib.segment1 = NVL(:p_part_no,msib.segment1) -- part no
            --AND msib.organization_id = NVL(:p_organization_id,msib.organization_id) -- organization
--            AND mmt.transaction_id LIKE '1117145'
            
       --  AND xah.accounting_date BETWEEN '01-AUG-2017' AND '15-AUG-2017'
     --      AND mmt.transaction_id = 868778
       --      AND mmt.organization_id = 102
group by        
                mtt.transaction_type_name,
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
                mmt.transaction_source_id;
                
                

select *
from wip_transactions
where transaction_id = 4886218;

select *
from mtl_material_transactions
where --transaction_id = 4886218;
transaction_source_id = 227025;                
                
select transaction_id
from wip_move_transactions;         

select distinct move_transaction_id
from mtl_material_transactions
where move_transaction_id = 2165985;

select *
from wip_entities;

SELECT 
        org.name organization,
        mmt.transaction_id,
        mmt.transaction_source_id,
        we.wip_entity_id,
        we.wip_entity_name job_order_no,
        msib.segment1 assembly_no,
       mmt.transaction_quantity,
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
--        INNER  JOIN xla.xla_transaction_entities xte
--            ON xah.entity_id = xte.entity_id
--            AND xte.application_id = xal.application_id
       INNER JOIN xla_distribution_links xdl
            ON xah.ae_header_id = xdl.ae_header_id
            AND xdl.event_id = xah.event_id
            AND xdl.ae_line_num = xal.ae_line_num
            AND xdl.application_id = xah.application_id
        INNER JOIN wip_transaction_accounts wta
            ON xdl.source_distribution_id_num_1 = wta.wip_sub_ledger_id
            AND xdl.source_distribution_type = 'WIP_TRANSACTION_ACCOUNTS'   
        INNER JOIN  wip_entities we
            ON  we.wip_entity_id = wta.wip_entity_id
        INNER JOIN wip_transactions wt
            ON wt.wip_entity_id = we.wip_entity_id
            AND wt.organization_id = we.organization_id
        -- ITEM
        INNER JOIN mtl_material_transactions mmt
            ON mmt.transaction_source_id = wt.wip_entity_id
        INNER JOIN mtl_system_items_b msib
            ON mmt.inventory_item_id = msib.inventory_item_id
            AND mmt.organization_id = msib.organization_id
       -- ITEM CATEGORY
        INNER JOIN mtl_item_categories  mtc
            ON msib.inventory_item_id = mtc.inventory_item_id 
            AND msib.organization_id = mtc.organization_id 
        INNER JOIN mtl_categories_kfv mck 
            ON mtc.category_id =mck.category_id          
            AND  mck.structure_id = '50388'
        INNER JOIN fnd_lookup_values flv
            ON  msib.item_type = flv.lookup_code  
            AND  flv.lookup_type = 'ITEM_TYPE'
        -- ITEM ORGANIZATION
        INNER JOIN hr_all_organization_units org
            ON org.organization_id = msib.organization_id    
        -- TRANSACTION TYPE NAME
        INNER JOIN mtl_transaction_types mtt
            ON mtt.transaction_type_id = mmt.transaction_type_id

  --     INNER JOIN 
        LEFT JOIN apps.gl_import_references gir
            ON gir.gl_sl_link_id = xal.gl_sl_link_id
            AND gir.gl_sl_link_table = xal.gl_sl_link_table
        LEFT JOIN apps.gl_je_lines gjl
            ON gjl.je_header_id = gir.je_header_id
            AND gjl.je_line_num = gir.je_line_num
        LEFT JOIN apps.gl_je_headers gjh         
            ON gjh.je_header_id = gjl.je_header_id
              
WHERE 1 = 1
          --  AND  mck.structure_id = '50388'
        --    AND  flv.lookup_type = 'ITEM_TYPE'
            
            AND we.wip_entity_name = '205024'
            -- FILTERS
            --AND to_date(xah.creation_date) BETWEEN NVL(to_date(:p_creation_date_start,'yyyy/mm/dd hh24:mi:ss') ,to_date(xah.creation_date))
             --                                                             AND NVL(to_date(:p_creation_date_end,'yyyy/mm/dd hh24:mi:ss'),to_date(xah.creation_date)) -- creation date
          --  AND to_date(xah.accounting_Wdate) BETWEEN NVL(to_date(:p_acctg_date_start,'yyyy/mm/dd hh24:mi:ss'),to_date(xah.accounting_date)) 
             --                                                             AND NVL(to_date(:p_acctg_date_end,'yyyy/mm/dd hh24:mi:ss'),to_date(xah.accounting_date)) -- gl date
            --AND glcc.segment6 BETWEEN NVL(:p_account_from,glcc.segment6) AND NVL(:p_account_to,glcc.segment6) -- account
            --AND mck.segment1 = NVL(:p_item_category,mck.segment1) -- item category
            --AND msib.segment1 = NVL(:p_part_no,msib.segment1) -- part no
            --AND msib.organization_id = NVL(:p_organization_id,msib.organization_id) -- organization
--            AND mmt.transaction_id LIKE '1117145'
            
 --     AND xah.accounting_date BETWEEN '01-AUG-2017' AND '15-AUG-2017'
     --      AND mmt.transaction_id = 868778
       --      AND mmt.organization_id = 102
group by        
                   mmt.transaction_quantity,
                 mtt.transaction_type_name,
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
                mmt.transaction_source_id;
                
SELECT *
FROM MTL_MATERIAL_TRANSACTIONS;

SELECT *
FROM HR_ALL_ORGANIZATIO
select *
from wip_entities we
where 1 = 1
           and we.wip_entity_name = '205024';

select *
from mtl_material_transactions
where transaction_source_id = 227025;

select *
from wip_transaction_accounts
where wip_entity_id = 227025;

select *
from xla_distribution_links
where source_distribution_id_num_1 IN (463494,
463495,
446638,
446639,
446642,
446643)
and source_distribution_type = 'WIP_TRANSACTION_ACCOUNTS';

/*
463494
463495
446638
446639
446642
446643
*/

select rcta.trx_number,
           to_char(rcta.trx_date) invoice_date
from ra_customer_trx_all rcta
where complete_flag = 'N';

select *
from po_headers_all pha LEFT JOIN ap_invoice_lines_all aila
            ON pha.po_header_id = aila.po_header_id
          LEFT JOIN ap_invoices_all aia
                ON aia.invoice_id = aila.invoice_id
 where aia.invoice_id IS NOT NULL;
        
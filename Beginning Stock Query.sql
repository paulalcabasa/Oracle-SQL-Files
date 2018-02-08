SELECT to_char(creation_date)
from po_headers_all
where segment1 = '20100003956';

select *
from mtl_material_transactions;

select 
            msib.inventory_item_id,
            msib.segment1 part_no,
            nvl(msib.attribute9,msib.segment1) sales_model,
            msib.attribute8 color,
            sum(mmt.transaction_quantity) beg_stock,
            0 tagged,
            0 buyoff,
            0 invoiced
from mtl_material_transactions mmt 
        INNER JOIN mtl_transaction_types mtt
            ON mtt.transaction_type_id = mmt.transaction_type_id
        INNER JOIN mtl_system_items_b msib
            ON msib.inventory_item_id = mmt.inventory_item_id
            AND msib.organization_id = mmt.organization_id
where 1 = 1
            and mmt.organization_id = 121
            and mmt.SUBINVENTORY_code = 'VSS'
            AND MSIB.SEGMENT1 = 'CYZ51Q-A.WHI'
            and UPPER(msib.inventory_item_status_code) = 'ACTIVE'
--            and trunc(mmt.transaction_date) <= :p_as_of
group by 
           msib.inventory_item_id,
            msib.segment1,
            msib.attribute9,
            msib.segment1,
            msib.attribute8;
  
            
            select *
            from mtl_serial_numbers;
            
            select *
            from MTL_SERIAL_NUMBERS
            WHERE CURRENT_ORGANIZATION_ID = 121;
            
            SELECT *
            FROM MTL_UNIT_tRANSACTIONS
            WHERE SERIAL_NUMBER = 'CP5371';
            
            select mmt.transaction_id, mtln.lot_number, mut.serial_number,
            mtt.transaction_type_name,mmt.transaction_quantity,mmt.transaction_date from mtl_material_transactions mmt,
                           MTL_TRANSACTION_LOT_NUMBERS mtln,
                           mtl_unit_transactions mut,
                           mtl_transaction_types mtt
where mmt.transaction_id(+) = mtln.transaction_id
              and mut.transaction_id(+) = mtln.serial_transaction_id
              and mtt.transaction_type_id = mmt.transaction_type_id
              and mut.SERIAL_NUMBER = 'D0D110';
               and mmt.transaction_id=998286;


select *
from all_tab_columns
where table_name like '%vehicle%master%';


SELECT msn.serial_number           cs_number,
                         msi.inventory_item_id       item_id,
                         msi.segment1                item_model,
                         mp.organization_code,
                         msn.current_subinventory_code subinventory_code,
                         msn.lot_number,
                         msn.attribute5              buyoff_date,
                         ippd.cs_number              for_repair,     -- not null => for repair
                         ipvs.cs_number              for_transfer  -- not null => for transfer
                    FROM mtl_system_items_b msi
                         LEFT JOIN mtl_serial_numbers msn
                            ON msi.inventory_item_id = msn.inventory_item_id
                            AND msi.organization_id = msn.current_organization_id
                         LEFT JOIN mtl_parameters mp
                            ON msi.organization_id = mp.organization_id
                         LEFT JOIN ipc_pdi_problem_details ippd
                            ON msn.serial_number = ippd.cs_number
                         LEFT JOIN ipc_pdi_vehicle_status ipvs
                            ON msn.serial_number = ipvs.cs_number
                   WHERE     1 = 1
                         AND mp.organization_code IN ('IVP', 'NYK', 'PSI')
                         AND msi.item_type = 'FG'
                         AND msn.current_status = 3
                         and c_attribute30 IS NULL
                ORDER BY msn.serial_number DESC;
/* Formatted on 5/9/2017 2:55:31 PM (QP5 v5.163.1008.3004) */
SELECT mmt.transaction_id,
            mmt.transaction_date ,
            mck.segment1 item_category,
            msib.segment1 part_no,
            mty.transaction_type_name,
            mtln.lot_number,
            we.wip_entity_name job_order,
            ((sum(NVL (xal.accounted_dr, 0)) - sum(NVL (xal.accounted_cr, 0))) / mmt.transaction_quantity) unit_cost,
            mut.serial_number ,
            msn.attribute2  vin,
            msn.attribute3  engine,
            to_char(msn.attribute5) buyoff_date
--              mmt.rcv_transaction_id,
--       sum((NVL (xal.accounted_dr, 0))) AS "Accounted Debit",
   --    sum((NVL (xal.accounted_cr, 0))) AS "Accounted Credit",
      
          --       msib.description,
--       msib.item_type,
--       mmt.last_update_date,
      
  --  gjh.doc_sequence_value, mmt.organization_id, org.NAME,
  -- mmt.inventory_item_id,
  -- we.wip_entity_name AS "Job Order",
  -- we.attribute1 AS "Lot Number",
  -- mtst.transaction_source_type_name,
  -- mtst.description AS "Source Type", mmt.transaction_source_name,
  -- rcv.receipt_num, rcv.po_number, flv.meaning item_type_description,
  --  mmt.transaction_source_id,
  -- xdl.source_distribution_type AS "Source Distribution Type",
  -- xal.accounting_class_code AS "Accounting Class Code",
  --  xdl.accounting_line_code AS "Accounting Line Code",
  ---  xdl.line_definition_code AS "Line Definition COde",
  --  xdl.event_class_code AS "Event Class Code",
  --  xdl.event_type_code AS "Event Type Code",
  --  xdl.rounding_class_code AS "Rounding Class Code",
  --  xah.accounting_date AS accnt_date,
  -- xah.gl_transfer_status_code AS "GL Transfer Status Code",
  --  xah.gl_transfer_date AS "GL Transfer Date",
  --  xah.je_category_name AS "JE Category Name",
  -- xah.accounting_entry_type_code AS "Accounting Entry Type Code",
  -- xah.doc_sequence_value AS "Document Sequence Value",
  -- gcc.segment1 AS "Company", gcc.segment2 AS "Cost Center",
  -- gcc.segment3 AS "ID", gcc.segment4 AS "Budget Account",
  -- gcc.segment5 AS "Budget Cost Center",
  -- gcc.segment6 AS "Account",
  -- gcc.segment7 AS "Model", gcc.segment8 AS "Projects",
  -- gcc.segment9 AS "Future", xah.description AS "Description",
  -- xah.period_name AS "Period Name",
  -- (NVL (xal.entered_dr, 0)) AS "Entered Debit",
  -- (NVL (xal.entered_cr, 0)) AS "Entered Credit",
  -- xah.product_rule_code AS "Product Rule Code", mmt.creation_date,

  FROM xla_distribution_links xdl
       INNER JOIN xla_ae_lines xal
          ON xal.ae_header_id = xdl.ae_header_id
             AND xal.ae_line_num = xdl.ae_line_num
       INNER JOIN xla_ae_headers xah
          ON xah.ae_header_id = xal.ae_header_id
       INNER JOIN gl_code_combinations gcc
          ON xal.code_combination_id = gcc.code_combination_id
       INNER JOIN mtl_transaction_accounts mta
          ON xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id
       INNER JOIN mtl_material_transactions mmt
          ON mmt.transaction_id = mta.transaction_id
       INNER JOIN mtl_system_items_b msib
          ON mmt.inventory_item_id = msib.inventory_item_id
             AND mmt.organization_id = msib.organization_id
       INNER JOIN mtl_item_categories mtc
          ON msib.inventory_item_id = mtc.inventory_item_id
             AND mmt.organization_id = mtc.organization_id
       INNER JOIN mtl_categories_kfv mck
          ON mtc.category_id = mck.category_id
       INNER JOIN fnd_lookup_values_vl flv
          ON msib.item_type = flv.lookup_code
       INNER JOIN mtl_transaction_types mty
          ON mmt.transaction_type_id = mty.transaction_type_id
       INNER JOIN hr_all_organization_units org
          ON mmt.organization_id = org.organization_id
       INNER JOIN mtl_txn_source_types mtst
          ON mmt.transaction_source_type_id = mtst.transaction_source_type_id
        LEFT JOIN mtl_transaction_lot_numbers mtln
            ON mtln.transaction_id = mmt.transaction_id
        LEFT JOIN mtl_unit_transactions mut 
            ON mut.transaction_id = mtln.serial_transaction_id
        LEFT JOIN wip_discrete_jobs_v we
            ON mmt.transaction_source_id = we.wip_entity_id
        LEFT JOIN MTL_SERIAL_NUMBERS msn
            ON msn.serial_number = mut.serial_number
         
       --         LEFT JOIN
       --         (SELECT rt.transaction_id, rsh.receipt_num, pha.segment1 po_number
       --            FROM rcv_transactions rt LEFT JOIN rcv_shipment_headers rsh
       --                 ON rt.shipment_header_id = rsh.shipment_header_id
       --                 LEFT JOIN po_headers_all pha
       --                 ON rt.po_header_id = pha.po_header_id
       --                 ) rcv ON mmt.rcv_transaction_id = rcv.transaction_id
       LEFT JOIN apps.gl_import_references gir
          ON gir.gl_sl_link_id = xal.gl_sl_link_id
             AND gir.gl_sl_link_table = xal.gl_sl_link_table
       LEFT JOIN apps.gl_je_lines gjl
          ON gjl.je_header_id = gir.je_header_id
             AND gjl.je_line_num = gir.je_line_num
       LEFT JOIN apps.gl_je_headers gjh
          ON gjh.je_header_id = gjl.je_header_id
 WHERE     1 = 1
       AND xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
       AND mck.structure_id = '50388'
       AND flv.lookup_type = 'ITEM_TYPE'
       --AND mmt.organization_id = msib.organization_id
  --     AND TO_DATE (xah.accounting_date) BETWEEN '01-AUG-2017'
    --                                         AND '31-AUG-2017'
       AND (NVL (xal.accounted_dr, 0)) - (NVL (xal.accounted_cr, 0)) != 0
       AND mty.transaction_type_name LIKE '%WIP%'
       AND gcc.segment6 = '65100'
       AND mck.segment1 = 'VSS'
       AND TO_DATE(msn.attribute5,'YYYY/MM/DD HH24:MI:SS') BETWEEN
               TO_DATE(:p_buyoff_date_start, 'YYYY/MM/DD HH24:MI:SS') AND  
               TO_DATE(:p_buyoff_date_end, 'YYYY/MM/DD HH24:MI:SS') +1 
    --   AND mmt.transaction_id = '5216190'
GROUP BY   mmt.transaction_id,
                    mmt.transaction_date,
                    mck.segment1,
                    msib.segment1,
                    mmt.transaction_quantity,
                    mtln.lot_number,
                    mty.transaction_type_name,
                    we.wip_entity_name,
                    mut.serial_number,
                    msn.attribute2,
                    msn.attribute3,
                    msn.attribute5;
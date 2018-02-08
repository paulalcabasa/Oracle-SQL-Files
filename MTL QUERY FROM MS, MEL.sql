/* Formatted on 28/7/2017 1:53:05 PM (QP5 v5.163.1008.3004) */
  SELECT mmt.organization_id,
         org.name,
         mmt.transaction_id,
         mmt.inventory_item_id,
         msib.segment1 AS "Part Number",
         msib.description,
         mck.segment1 AS item_category_family,
         mck.segment2 AS item_category_class,
         msib.item_type,
         mmt.transaction_quantity,
         mmt.rcv_transaction_id,
         mty.transaction_type_name,
         we.wip_entity_name AS "Job Order",
         we.attribute1 AS "Lot Number",
         mtst.transaction_source_type_name,
         mtst.description AS "Source Type",
         mmt.transaction_SOURCE_NAME,
         rcv.receipt_num,
         rcv.po_number,
         flv.meaning item_type_description,
         mty.transaction_type_name,
         mmt.transaction_source_id,
         xdl.source_distribution_type AS "Source Distribution Type",
         xal.accounting_class_code AS "Accounting Class Code",
         xdl.accounting_line_code AS "Accounting Line Code",
         xdl.line_definition_code AS "Line Definition COde",
         xdl.event_class_code AS "Event Class Code",
         xdl.event_type_code AS "Event Type Code",
         xdl.rounding_class_code AS "Rounding Class Code",
         xah.accounting_date AS "Accounting Date",
         xah.gl_transfer_status_code AS "GL Transfer Status Code",
         xah.gl_transfer_date AS "GL Transfer Date",
         xah.je_category_name AS "JE Category Name",
         xah.accounting_entry_type_code AS "Accounting Entry Type Code",
         xah.doc_sequence_value AS "Document Sequence Value",
         gcc.segment6 AS "Account",
         xal.description AS "Line Description",
         xah.period_name AS "Period Name",
         NVL (xal.entered_dr, 0) AS "Entered Debit",
         NVL (xal.entered_cr, 0) AS "Entered Credit",
         NVL (xal.accounted_dr, 0) AS "Accounted Debit",
         NVL (xal.accounted_cr, 0) AS "Accounted Credit",
         NVL (xal.accounted_dr, 0) - NVL (xal.accounted_cr, 0) AS "Difference",
         xah.product_rule_code AS "Product Rule Code",
         mmt.CREATION_DATE,
         mmt.LAST_UPDATE_DATE,
         mmt.transaction_date AS transaction_date
    FROM xla_distribution_links xdl,
         xla_ae_headers xah,
         xla_ae_lines xal,
         gl_code_combinations gcc,
         mtl_transaction_accounts mta,
         mtl_system_items_b msib,
         mtl_material_transactions mmt,
         mtl_item_categories mtc,
         mtl_categories_kfv mck,
         fnd_lookup_values_vl flv,
         mtl_transaction_types mty,
         hr_all_organization_units org,
         mtl_txn_source_types mtst,
         wip_discrete_jobs_v we,
         (SELECT rt.transaction_id, rsh.receipt_num, pha.segment1 po_number
            FROM rcv_transactions rt,
                 rcv_shipment_headers rsh,
                 po_headers_all pha
           WHERE rt.shipment_header_id = rsh.shipment_header_id
                 AND rt.po_header_id = pha.po_header_id(+)) rcv
   WHERE     mmt.TRANSACTION_SOURCE_TYPE_ID = mtst.TRANSACTION_SOURCE_TYPE_ID
         AND mmt.inventory_item_id = msib.inventory_item_id
         AND mmt.organization_id = msib.organization_id
         AND mmt.TRANSACTION_SOURCE_ID = we.wip_entity_id(+)
         AND mmt.rcv_transaction_id = rcv.transaction_id(+)
         AND xal.code_combination_id = gcc.code_combination_id
         AND xah.ae_header_id = xal.ae_header_id
         AND xal.ae_header_id = xdl.ae_header_id
         AND xal.ae_line_num = xdl.ae_line_num
         /* new joins */
         AND msib.inventory_item_id = mtc.inventory_item_id
         AND MMT.ORGANIZATION_ID = mtc.ORGANIZATION_ID
         AND mmt.organization_id = msib.organization_id
         AND MMT.TRANSACTION_TYPE_ID = MTY.TRANSACTION_TYPE_ID
         AND mtc.CATEGORY_ID = mck.CATEGORY_ID
         AND MSIb.ITEM_TYPE = FLV.LOOKUP_CODE
         AND mmt.organization_id = org.organization_id
         AND mmt.transaction_id = mta.transaction_id
         AND xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id
         AND FLV.LOOKUP_TYPE = 'ITEM_TYPE'
         AND MCK.STRUCTURE_ID = '50388'
         AND xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
         AND to_date(xah.creation_date) BETWEEN NVL(to_date(:p_creation_date_start,'yyyy/mm/dd hh24:mi:ss') ,to_date(xah.creation_date))
                                                                       AND NVL(to_date(:p_creation_date_end,'yyyy/mm/dd hh24:mi:ss'),to_date(xah.creation_date)) -- creation date
         AND to_date(xah.accounting_date) BETWEEN NVL(to_date(:p_acctg_date_start,'yyyy/mm/dd hh24:mi:ss'),to_date(xah.accounting_date)) 
                                                                           AND NVL(to_date(:p_acctg_date_end,'yyyy/mm/dd hh24:mi:ss'),to_date(xah.accounting_date)) -- gl date
         AND gcc.segment6 BETWEEN NVL(:p_account_from,gcc.segment6) AND NVL(:p_account_to,gcc.segment6) -- account
         AND mck.segment1 = NVL(:p_item_category,mck.segment1) -- item category
         AND msib.segment1 = NVL(:p_part_no,msib.segment1) -- part no
         AND msib.organization_id = NVL(:p_organization_id,msib.organization_id) -- organization
ORDER BY xdl.ae_header_id, xdl.ae_line_num ASC;
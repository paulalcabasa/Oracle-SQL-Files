SELECT   gjh.doc_sequence_value, mmt.organization_id, org.NAME,
         mmt.transaction_id, mmt.inventory_item_id,
         msib.segment1 AS "Part Number", msib.description,
         mck.segment1 AS item_category_family,
         mck.segment2 AS item_category_class, msib.item_type,
         mmt.transaction_quantity, mmt.rcv_transaction_id,
         mty.transaction_type_name, we.wip_entity_name AS "Job Order",
         we.attribute1 AS "Lot Number", mtst.transaction_source_type_name,
         mtst.description AS "Source Type", mmt.transaction_source_name,
         rcv.receipt_num, rcv.po_number, flv.meaning item_type_description,
         mty.transaction_type_name, mmt.transaction_source_id,
         xdl.source_distribution_type AS "Source Distribution Type",
         xal.accounting_class_code AS "Accounting Class Code",
         xdl.accounting_line_code AS "Accounting Line Code",
         xdl.line_definition_code AS "Line Definition COde",
         xdl.event_class_code AS "Event Class Code",
         xdl.event_type_code AS "Event Type Code",
         xdl.rounding_class_code AS "Rounding Class Code",
         xah.accounting_date AS accnt_date,
         xah.gl_transfer_status_code AS "GL Transfer Status Code",
         xah.gl_transfer_date AS "GL Transfer Date",
         xah.je_category_name AS "JE Category Name",
         xah.accounting_entry_type_code AS "Accounting Entry Type Code",
         xah.doc_sequence_value AS "Document Sequence Value",
         gcc.segment1 AS "Company", gcc.segment2 AS "Cost Center",
         gcc.segment3 AS "ID", gcc.segment4 AS "Budget Account",
         gcc.segment5 AS "Budget Cost Center", gcc.segment6 AS "Account",
        gcc.segment7 AS "Model", gcc.segment8 AS "Projects",
         gcc.segment9 AS "Future", xah.description AS "Description",
         xah.period_name AS "Period Name",
         SUM (NVL (xal.entered_dr, 0)) AS "Entered Debit",
         SUM (NVL (xal.entered_cr, 0)) AS "Entered Credit",
         SUM (NVL (xal.accounted_dr, 0)) AS "Accounted Debit",
         SUM (NVL (xal.accounted_cr, 0)) AS "Accounted Credit",
           SUM (NVL (xal.accounted_dr, 0))
         - SUM (NVL (xal.accounted_cr, 0)) AS diff_accnt,
         xah.product_rule_code AS "Product Rule Code", mmt.creation_date,
         mmt.last_update_date, mmt.transaction_date AS transaction_date
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
             AND rt.po_header_id = pha.po_header_id(+)) rcv,
         apps.gl_import_references gir,
         apps.gl_je_lines gjl,
         apps.gl_je_headers gjh
   WHERE mmt.transaction_source_type_id = mtst.transaction_source_type_id
     AND mmt.inventory_item_id = msib.inventory_item_id
     AND mmt.organization_id = msib.organization_id
     AND mmt.transaction_source_id = we.wip_entity_id(+)
     AND mmt.rcv_transaction_id = rcv.transaction_id(+)
     AND xal.code_combination_id = gcc.code_combination_id
     AND xah.ae_header_id = xal.ae_header_id
     AND xal.ae_header_id = xdl.ae_header_id
     AND xal.ae_line_num = xdl.ae_line_num
     /* new joins */
     AND msib.inventory_item_id = mtc.inventory_item_id
     AND mmt.organization_id = mtc.organization_id
     AND mmt.organization_id = msib.organization_id
     AND mmt.transaction_type_id = mty.transaction_type_id
     AND mtc.category_id = mck.category_id
     AND msib.item_type = flv.lookup_code
     AND mmt.organization_id = org.organization_id
     AND flv.lookup_type = 'ITEM_TYPE'
     AND mck.structure_id = '50388'
     AND xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
     AND mmt.transaction_id = mta.transaction_id
     AND xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id
     AND gir.gl_sl_link_id = xal.gl_sl_link_id
     AND gir.gl_sl_link_table = xal.gl_sl_link_table
     AND gjl.je_header_id = gir.je_header_id
     AND gjl.je_line_num = gir.je_line_num
     AND gjh.je_header_id = gjl.je_header_id
     --Filter
      AND TO_DATE(xah.accounting_date) BETWEEN '16-AUG-2017' AND '31-AUG-2017'
      --AND gcc.segment6 BETWEEN '05100' AND '05197'
GROUP BY mmt.organization_id,
         org.NAME,
         mmt.transaction_id,
         mmt.inventory_item_id,
         msib.segment1,
         msib.description,
         mck.segment1,
         mck.segment2,
         msib.item_type,
         mmt.transaction_quantity,
         mmt.rcv_transaction_id,
         mty.transaction_type_name,
         we.wip_entity_name,
         we.attribute1,
         mtst.transaction_source_type_name,
         mtst.description,
         mmt.transaction_source_name,
         rcv.receipt_num,
         rcv.po_number,
         flv.meaning,
         mty.transaction_type_name,
         mmt.transaction_source_id,
         xdl.application_id,
         xdl.source_distribution_type,
         xdl.source_distribution_id_num_1,
         xdl.ae_header_id,
         xdl.ae_line_num,
         xal.accounting_class_code,
         xdl.accounting_line_code,
         xdl.line_definition_code,
         xdl.event_class_code,
         xdl.event_type_code,
         xdl.rounding_class_code,
         xah.accounting_date,
         xah.gl_transfer_status_code,
         xah.gl_transfer_date,
         xah.je_category_name,
         xah.accounting_entry_type_code,
         xah.doc_sequence_value,
         gcc.segment1,
         gcc.segment2,
         gcc.segment3,
         gcc.segment4,
         gcc.segment5,
         gcc.segment6,
         gcc.segment7,
         gcc.segment8,
         gcc.segment9,
         xah.description,
         xal.description,
         xal.displayed_line_number,
         xah.period_name,
         xal.currency_code,
         xal.currency_conversion_date,
         xal.currency_conversion_rate,
         xah.product_rule_code,
         mmt.creation_date,
         mmt.last_update_date,
         mmt.transaction_date,
         gjh.doc_sequence_value
            HAVING SUM (NVL (xal.accounted_dr, 0))
         - SUM (NVL (xal.accounted_cr, 0)) > 0
            
            
;

select receipt_number
from ar_cash_receipts_all
where status = 'REV';
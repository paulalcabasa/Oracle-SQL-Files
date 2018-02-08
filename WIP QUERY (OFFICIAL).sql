SELECT 
    mmt.CREATION_DATE,
    mmt.LAST_UPDATE_DATE,
    TRUNC (mmt.transaction_date) AS transaction_date,
        mmt.transaction_id, 
        mmt.organization_id,
        mmt.inventory_item_id,
        mck.segment1 as item_category_family,
        mck.segment2 as item_category_class,
        msib.item_type,
        flv.meaning  item_type_description,
        mty.transaction_type_name,
        msib.segment1,
        xdl.application_id             AS "Application ID",
         xdl.source_distribution_type   AS "Source Distribution Type",
         xdl.source_distribution_id_num_1 AS "Source Distribution Id Num",
         xdl.ae_header_id               AS "AE Header ID",
         xdl.ae_line_num                AS "AE Line Num",
         xal.accounting_class_code      AS "Accounting Class Code",
         xdl.accounting_line_code       AS "Accounting Line Code",
         xdl.line_definition_code       AS "Line Definition COde",
         xdl.event_class_code           AS "Event Class Code",
         xdl.event_type_code            AS "Event Type Code",
         xdl.rounding_class_code        AS "Rounding Class Code",
         xah.accounting_date            AS "Accounting Date",
         xah.gl_transfer_status_code    AS "GL Transfer Status Code",
         xah.gl_transfer_date           AS "GL Transfer Date",
         xah.je_category_name           AS "JE Category Name",
         xah.accounting_entry_type_code AS "Accounting Entry Type Code",
         xah.doc_sequence_value         AS "Document Sequence Value",
         gcc.segment1                   AS "Company",
         gcc.segment2                   AS "Cost Center",
         gcc.segment3                   AS "ID",
         gcc.segment4                   AS "Budget Account",
         gcc.segment5                   AS "Budget Cost Center",
         gcc.segment6                   AS "Account",
         gcc.segment7                   AS "Model",
         gcc.segment8                   AS "Projects",
         gcc.segment9                   AS "Future",
         xah.description                AS "Description",
         xal.description                AS "Line Description",
         xal.displayed_line_number      AS "Line Number",
         xah.period_name                AS "Period Name",
         xal.entered_dr                 AS "Entered Debit",
         xal.entered_cr                 AS "Entered Credit",
         xal.accounted_dr               AS "Accounted Debit",
         xal.accounted_cr               AS "Accounted Credit",
         xdl.unrounded_entered_dr       AS "Unrounded Entered Debit",
         xdl.unrounded_entered_cr       AS "Unrounded Entered Credit",
         xdl.unrounded_accounted_dr     AS "Unrounded Accounted Debit",
         xdl.unrounded_accounted_cr     AS "Unrounded Accounted Credit",
         xal.currency_code              AS "Currency Code",
         xal.currency_conversion_date   AS "Currency Conversion Date",
         xal.currency_conversion_rate   AS "Currency Conversion Rate",
         xah.product_rule_code          AS "Product Rule Code"
    FROM xla_distribution_links xdl,
                xla_ae_headers       xah,
                xla_ae_lines         xal,
                gl_code_combinations gcc,
                wip_transaction_accounts mta,
                mtl_system_items_b msib,
                mtl_material_transactions mmt,
                MTL_ITEM_CATEGORIES  mtc,
                mtl_categories_kfv mck,
                FND_LOOKUP_VALUES_VL flv,
                MTL_TRANSACTION_TYPES MTY,
                wip_entities we
   WHERE     
        mmt.inventory_item_id = msib.inventory_item_id and
        mmt.organization_id = msib.organization_id and 
        xal.code_combination_id = gcc.code_combination_id
         AND xah.ae_header_id = xal.ae_header_id
         AND xal.ae_header_id = xdl.ae_header_id
         AND xal.ae_line_num = xdl.ae_line_num
         /* new joins */
        and msib.inventory_item_id = mtc.inventory_item_id 
        and MMT.ORGANIZATION_ID = mtc.ORGANIZATION_ID
        and mmt.organization_id = msib.organization_id  
        and MMT.TRANSACTION_TYPE_ID = MTY.TRANSACTION_TYPE_ID
        and mtc.CATEGORY_ID =mck.CATEGORY_ID  
        and  MSIb.ITEM_TYPE = FLV.LOOKUP_CODE  
        --and msib.segment1 = 'EXR51F-A.WHI'
        and  FLV.LOOKUP_TYPE = 'ITEM_TYPE'
        and  MCK.STRUCTURE_ID = '50388'
        
        and we.wip_entity_id = mta.wip_entity_id
         -- and xah.doc_sequence_value = '40300000724 '
         -- and gcc.segment6 = '01200'
        --AND xdl.source_distribution_type = "RCV_RECEIVING_SUB_LEDGER"
     --    AND xah.accounting_date BETWEEN :P_Start_Date AND :P_End_Date
         --   AND xdl.event_class_code = 'SALES_ORDER'
--and xdl.application_id   not in ('200','140','222')
and xdl.source_distribution_type = 'WIP_TRANSACTION_ACCOUNTS'
and mmt.transaction_id = mta.transaction_id
and we.wip_entity_name IN ('302019')
 -- and mmt.transaction_id = 117145
--and xdl.ae_header_id   in ('9586301','9614129','9614823')
--and gcc.segment6   in('67100')
--and xdl.line_definition_code    = 'IPC_SALES_ORDER'
--and xdl.accounting_line_code  = 'INVENTORY_VALUATION'
--And xal.entered_dr  = 226510
--and  xah.gl_transfer_status_code = 'N'
--and xdl.rounding_class_code ='COST_OF_GOODS_SOLD'
-- and  mmt.organization_id in ('88') --rio nac dbs ips
-- and  gcc.segment6 in ('65600')
and xdl.source_distribution_id_num_1 = mta.wip_sub_ledger_id
--and xal.entered_dr  = 278.3
--and msib.segment1 = '8971793590'
;


select *
from wip_transaction_accounts;

select *
from wip_entities;

--and xah.accounting_date = '13-JAN-2017' 
--and xal.accounting_class_code like 'INTERORG%'
--AND xdl.ae_header_id  = '10294671'
ORDER BY xdl.ae_header_id, xdl.ae_line_num ASC;



select 
        aia.doc_sequence_value,
        aia.invoice_id,
       aila.line_number, 
       aila.attribute1 Sup_ID, 
        case when AILA.ATTRIBUTE1 is null then null
                else
                    case when AILA.ATTRIBUTE2 is null then
                          aps.vendor_name
                         else
                          AILA.ATTRIBUTE2
                    end
        end  DFF_SUP_NAME,
        case when AILA.ATTRIBUTE1 is null then null
        else
            case when AILA.ATTRIBUTE3 is null then
                   aps.vat_registration_num
                 --assa.vat_registration_num
                 else AILA.ATTRIBUTE3
            end 
        end DFF_TIN,
        case when AILA.ATTRIBUTE1 is null then
        null
        else
            case when AILA.ATTRIBUTE4 is null then
                   ASSA.ADDRESS_LINE1 || ' ' || ASSA.ADDRESS_LINE2
                 else AILA.ATTRIBUTE4
            end 
        END    DFF_ADDRESS,
       case when aila.tax_classification_code in ('V2(S)','V2(OCG)','V2(IMP)') THEN 
               round((aila.amount)/ 1.12, 2)
               else aila.amount
       end amount,
       aila.tax_classification_code vat_code,
       case when aila.tax_classification_code in ('V2(S)','V2(OCG)','V2(IMP)') THEN 
               round(((aila.amount)/ 1.12)* 0.12, 2)
               when aila.tax_classification_code IN ('V0(VE)') THEN 0
               ELSE round(aila.amount * 0.12, 2)
       end vat_amount,
       awt.name invoice_witholding_tax_group,
       case when aila.tax_classification_code in ('V2(S)','V2(OCG)','V2(IMP)') THEN 
               round(((aila.amount)/ 1.12)* (awtra.tax_rate / 100), 2)
               else
            round(aila.amount * (awtra.tax_rate / 100), 2)
       end w_amount
from ap_invoice_lines_all aila,
     ap_invoices_all aia,
     ap_awt_groups awt,
     ap_suppliers aps,
     ap_supplier_sites_all assa,
     ap_awt_tax_rates_all awtra
where aila.invoice_id = aia.invoice_id
and awt.group_id(+) = aila.awt_group_id
and aps.segment1(+) = aila.attribute1
and aps.vendor_id = assa.vendor_id(+)
and awt.name = awtra.tax_name
-- and aila.attribute1 is not null
and aia.doc_sequence_value = :DOC_SEQUENCE_VALUE;

select  aila.attribute1,
            aila.attribute2,
            aila.attribute3,
            aila.attribute4,
            aila.attribute5
from ap_invoices_all aia 
        INNER JOIN ap_invoice_lines_all aila
            ON aila.invoice_id = aia.invoice_id
where 1 = 1
           and aia.doc_sequence_value = 20033927
group by
            aila.attribute1,
            aila.attribute2,
            aila.attribute3,
            aila.attribute4,
            aila.attribute5
  
         ;         
           -- 20033927
           -- 20033793
           -- 8081
           -- 3080
           
           select *
           from IPC_AR_INVOICES_WITH_CM;
           
           select cust_trx_type_id,
                     name,
                     description
           from ra_cust_trx_types_all;
           select comments,
                     attribute1,
                     attribute2,
                     attribute3,
                     trx_number
           from ra_customer_trx_all
           WHERE trx_number not in (select orig_trx_number from IPC_AR_INVOICES_WITH_CM);
           where comments = '980247651';
           
           
           select *
           from ar_cash_receipts_all
           where receipt_number like '%60050%';
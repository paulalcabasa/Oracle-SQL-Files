select aia.invoice_id,
         aia.source,
         aia.INVOICE_TYPE_LOOKUP_CODE,
         AIA.DOC_CATEGORY_CODE,
          aia.doc_sequence_value,
         aia.invoice_num,
         aia.invoice_amount header_amount,
         sum(aila.amount) line_amount,
         aila.awt_group_id,
         aila.tax_classification_code,
         (select CONCATENATED_SEGMENTS from gl_code_combinations_kfv where CODE_COMBINATION_ID = aia.ACCTS_PAY_CODE_COMBINATION_ID) liability_account,
         (select CONCATENATED_SEGMENTS from gl_code_combinations_kfv where CODE_COMBINATION_ID = aila.DEFAULT_DIST_CCID) line_dist_acct,
         aia.vendor_id,
         sp.vendor_name,
         sp.segment1 supplier_no,
         aia.creation_date
from ap_invoices_all aia,
        ap_invoice_lines_all aila,
        ap_suppliers sp
where 1 = 1
        AND aia.invoice_id =  aila.invoice_id
        AND sp.vendor_id = aia.vendor_id
   
        -- TRADE
  --    AND  (select CONCATENATED_SEGMENTS from gl_code_combinations_kfv where CODE_COMBINATION_ID = aia.ACCTS_PAY_CODE_COMBINATION_ID) = '01.-.-.-.-.83300.-.-.-'
        -- NON-TRADE
  --   AND  (select CONCATENATED_SEGMENTS from gl_code_combinations_kfv where CODE_COMBINATION_ID = aia.ACCTS_PAY_CODE_COMBINATION_ID) = '01.-.-.-.-.83300.-.-.-'
        -- TRADE
    --AND (select CONCATENATED_SEGMENTS from gl_code_combinations_kfv where CODE_COMBINATION_ID = aia.DEFAULT_DIST_CCID) = '01.-.-.-.-.82000.-.-.-' 
       --  NON-TRADE
 --   AND (select CONCATENATED_SEGMENTS from gl_code_combinations_kfv where CODE_COMBINATION_ID = DEFAULT_DIST_CCID) = '01.-.-.-.-.82001.-.-.-' 
 --  AND AIA.DOC_CATEGORY_CODE = 'AP_BEG'
GROUP BY aia.invoice_id,
               aia.doc_sequence_value,
               aia.invoice_num,
               aia.invoice_amount,
               aia.ACCTS_PAY_CODE_COMBINATION_ID,
               aila.DEFAULT_DIST_CCID,
               aila.awt_group_id,
               aila.tax_classification_code,
               aia.vendor_id,
               sp.vendor_name,
               sp.segment1,
                      aia.creation_date,
                      aia.source,
                           aia.INVOICE_TYPE_LOOKUP_CODE,
                            AIA.DOC_CATEGORY_CODE
ORDER BY aia.doc_sequence_value desc;
  
select distinct INVOICE_TYPE_LOOKUP_CODE
from ap_invoices_all;


select inventory_item_id,segment1
from mtl_system_items_b
where segment1 = '8979990130';
select *
from mtl_reservations
where inventory_item_id = 125181;

select *
from dbs_picklist_interface
where request_number = '479518';


-- 98015

select *
from po_headers;


where packing_slip = 'B1709029';

select *
from ap_invoices_all
where invoice_num = 'SI P506-16-1';
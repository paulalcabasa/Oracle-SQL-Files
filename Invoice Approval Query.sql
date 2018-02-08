
select aia.invoice_id,
         aia.invoice_date,
         aia.invoice_num,
         aia.doc_sequence_value,
         aia.WFAPPROVAL_STATUS
from ap_invoices_all aia
where 1 = 1
          AND aia.WFAPPROVAL_STATUS = 'REQUIRED'
        --  AND aia.WFAPPROVAL_STATUS = 'MANUALLY APPROVED'
          ;
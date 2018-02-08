SELECT aps.segment1 supplier_id,
             aca.vendor_name supplier_name,
             cpb.payment_document_name,
             aca.check_number,
             aca.amount check_amount,
             aca.check_date,
             aca.status_lookup_code status,
             to_char(aca.creation_date,'DD/MM/YYYY') creation_date,
             fu.description created_by
FROM ap_checks_all aca 
           LEFT JOIN ap_suppliers aps
                ON aps.vendor_id = aca.vendor_id
           INNER JOIN ce_payment_documents cpb
                ON cpb.payment_document_id = aca.payment_document_id
           INNER JOIN fnd_user fu
                ON fu.user_id = aca.created_by
WHERE TO_DATE(aca.check_date) between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss');
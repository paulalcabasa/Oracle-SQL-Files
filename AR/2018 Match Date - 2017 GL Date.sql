SELECT acra.receipt_number,
            acra.doc_sequence_value,
            to_char(acra.receipt_date,'DD-MON-YYYY') receipt_date,
            to_char(araa.apply_date,'DD-MON-YYYY') apply_date,
            to_char(araa.gl_date,'DD-MON-YYYY') gl_date,
            to_char(araa.creation_date,'DD-MON-YYYY') matched_date,
            rcta.trx_number,
            araa.amount_applied
FROM ar_receivable_applications_all araa
            INNER JOIN ar_cash_receipts_all acra
                ON acra.cash_receipt_id = araa.cash_receipt_id
                AND araa.display = 'Y'
            INNER JOIN ra_customer_trx_all rcta
                ON rcta.customer_trx_id = araa.applied_customer_trx_id
WHERE trunc(araa.gl_date) >= '01-JAN-2018'
       -- AND RECEIPT_DATE BETWEEN '01-SEP-2017' AND '30-SEP-2017'
--and acra.doc_sequence_value like '701%1904'
           ; and GL_DATE < '01-JAN-2018';
           
           select receipt_number,
                     doc_sequence_value,s
                     receipt_date
           from ar_cash_receipts_all
           where receipt_date = '04-SEP-2017';
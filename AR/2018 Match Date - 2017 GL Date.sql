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
WHERE trunc(araa.creation_date) >= '01-JAN-2018'
            and GL_DATE < '01-JAN-2018';
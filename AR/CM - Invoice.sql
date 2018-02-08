SELECT rcta.trx_number CM_INVOICE,
            rcta_app.trx_number orig_invoice
FROM AR_RECEIVABLE_APPLICATIONS_ALL ar_app
           LEFT JOIN ra_customer_trx_all rcta 
                ON rcta.customer_trx_id = ar_app.customer_trx_id -- CM
           LEFT JOIN ra_customer_trx_all rcta_app
                ON rcta_app.customer_trx_id = ar_app.applied_customer_trx_id -- INVOICE         
where applied_customer_Trx_id = 930771
and application_type = 'CM'
;
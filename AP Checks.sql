SELECT DBS_DR_SEQ.NEXTVAL LINE_ID,
                    WDD.SOURCE_LINE_NUMBER LINE_NO,
                    MSIB.SEGMENT1 PART_NUMBER,
                    NVL(WDD.CUST_PO_NUMBER,'') PURCHASE_ORDER_NUMBER,
                    WDD.SHIPPED_QUANTITY QUANTITY,
                    WDD.REQUESTED_QUANTITY_UOM UOM,
                    MSIB.DESCRIPTION PART_DESCRIPTION,
                    '' REMARKS,
                    WDA.DELIVERY_ID DELIVERY_RECEIPT_NUMBER,
                    WDD.SOURCE_HEADER_NUMBER SALES_ORDER_NUMBER,
                    MTRH.REQUEST_NUMBER PICKLIST_NUMBER,
                    WND.ULTIMATE_DROPOFF_DATE SHIPMENT_DATE,
                    HP.PARTY_NAME,
                    TRIM (HL.ADDRESS1 || ' ' || HL.ADDRESS2 || ' ' || HL.ADDRESS3) ADDRESS,
                    HCSUA.TAX_REFERENCE,
                    WND.INITIAL_PICKUP_DATE SHIP_CONFIRMED_DATE,
                    WDD.DATE_REQUESTED SALES_ORDER_DATE,
                    FU.USER_ID CREATED_BY_ID,
                    (PPF.FIRST_NAME || ' ' || PPF.LAST_NAME) CREATED_BY,
                    RT.NAME PAYMENT_TERM,
                    WDD.UNIT_PRICE,
                    WND.ORGANIZATION_ID
                    FROM WSH_DELIVERY_DETAILS WDD
                    LEFT JOIN MTL_SYSTEM_ITEMS_B MSIB                           -----------
                      ON MSIB.INVENTORY_ITEM_ID = WDD.INVENTORY_ITEM_ID
                         AND MSIB.ORGANIZATION_ID = WDD.ORGANIZATION_ID
                    LEFT JOIN WSH_DELIVERY_ASSIGNMENTS WDA                  ---------------
                      ON WDA.DELIVERY_DETAIL_ID = WDD.DELIVERY_DETAIL_ID
                    LEFT JOIN WSH_NEW_DELIVERIES WND                           ------------
                      ON WND.DELIVERY_ID = WDA.DELIVERY_ID
                    LEFT JOIN HZ_PARTY_SITES HPS                               ------------
                      ON WND.ULTIMATE_DROPOFF_LOCATION_ID = HPS.LOCATION_ID
                    LEFT JOIN HZ_LOCATIONS HL                                   -----------
                      ON HPS.LOCATION_ID = HL.LOCATION_ID
                    LEFT JOIN HZ_PARTIES HP                                    ------------
                      ON HPS.PARTY_ID = HP.PARTY_ID
                    LEFT JOIN HZ_CUSTOMER_PROFILES HCP                     ----------------
                      ON HP.PARTY_ID = HCP.PARTY_ID
                    LEFT JOIN HZ_CUST_PROFILE_CLASSES HCPC                      -----------
                      ON HCP.PROFILE_CLASS_ID = HCPC.PROFILE_CLASS_ID
                    LEFT JOIN HZ_CUST_ACCOUNTS HCA                        -----------------
                      ON HCP.PARTY_ID = HCA.PARTY_ID
                         AND WDD.CUSTOMER_ID = HCA.CUST_ACCOUNT_ID
                    LEFT JOIN HZ_CUST_ACCT_SITES_ALL HCASA                     ------------
                      ON HCA.CUST_ACCOUNT_ID = HCASA.CUST_ACCOUNT_ID
                         AND HPS.PARTY_SITE_ID = HCASA.PARTY_SITE_ID
                    LEFT JOIN HZ_CUST_SITE_USES_ALL HCSUA                      ------------
                      ON HCP.SITE_USE_ID = HCSUA.SITE_USE_ID
                         AND HCASA.CUST_ACCT_SITE_ID = HCSUA.CUST_ACCT_SITE_ID
                    LEFT JOIN MTL_TXN_REQUEST_LINES MTRL                         ----------
                      ON WDD.MOVE_ORDER_LINE_ID = MTRL.LINE_ID
                    LEFT JOIN MTL_TXN_REQUEST_HEADERS MTRH                 ----------------
                      ON MTRH.HEADER_ID = MTRL.HEADER_ID
                    LEFT JOIN FND_USER FU
                      ON WDD.CREATED_BY = FU.USER_ID
                    LEFT JOIN PER_PEOPLE_F PPF
                      ON FU.EMPLOYEE_ID = PPF.PERSON_ID
                         AND FU.PERSON_PARTY_ID = PPF.PARTY_ID
                    LEFT JOIN RA_TERMS RT
                          ON HCSUA.payment_term_id = rt.term_id
                    WHERE     1 = 1
                    AND WDD.RELEASED_STATUS = 'C'
                --    AND WDA.DELIVERY_ID NOT IN (SELECT DR_NUMBER FROM DBS_DELIVERY_RECEIPT_INTERFACE)
                    AND HCPC.PROFILE_CLASS_ID IN (1042, 1044, 1046, 1047, 1049, 1050,1048)
                    AND WDD.SOURCE_HEADER_TYPE_NAME LIKE 'PRT.%'
                    AND WDD.SOURCE_HEADER_TYPE_NAME  <> 'PRT.LUB'
                    AND HCSUA.SITE_USE_ID <> 0
                    AND WDD.SOURCE_HEADER_NUMBER = '3010003187'
                    AND WDD.SOURCE_HEADER_NUMBER NOT IN ('3010000004',
                                                        '3010001083',
                                                        '3010001238',
                                                        '3010000010',
                                                        '3010001086',
                                                        '3010001085',
                                                        '3010000009',
                                                        '3010001087',
                                                        '3010001239',
                                                        '3010001076',
                                                        '3010001075',
                                                        '3010001080',
                                                        '3010001077',
                                                        '3010001079',
                                                        '3010001082',
                                                        '3010000006',
                                                        '3010000007',
                                                        '3010000012',
                                                        '3010001241',
                                                        '3010000001',
                                                        '3010000002',
                                                        '3010000003',
                                                        '3010001074',
                                                        '3010000005',
                                                        '3010001236',
                                                        '3010001088',
                                                        '3010001240',
                                                        '3010001081',
                                                        '3010001078',
                                                        '3010000008',
                                                        '3010001084',
                                                        '3010000011');
                                                        
                                                        SELECT *
                                                        from  ra_customer_trx_all
                                                        where interface_header_attribute1 = '3010003187';
                                                        
                                                        
                                                        
select receipt_number,
amount,
payment_customer,
receipt_date
from ar_cash_receipts_all;
                                                    
select    upper(apa.vendor_name) vendor_name,
            apa.vendor_id,
            apa.check_id,
            apa.status_lookup_code,
            apa.check_number,
            apa.amount,
            apa.doc_sequence_value,
            to_char(apa.check_date,'DD-MON-YYYY') check_date,
            apa.org_id,
            apa.CE_BANK_ACCT_USE_ID,
            ap_sla.bank_branch_name
from ap_checks_all apa,
        AP_SLA_PAYMENTS_TRANSACTION_V ap_sla
where 1=1
        AND apa.org_id = 82 
--
       AND apa.check_number between :p_checknumfrom and :p_checknumto 
       AND ap_sla.check_id = apa.check_id 
     --   AND check_id in (select check_id from AP_SLA_PAYMENTS_TRANSACTION_V where bank_branch_name = :p_branch) 
    --    AND CE_BANK_ACCT_USE_ID = :P_BANKACCTNUM
order by check_number;
COMMIT;

select *
from XXIPC_AP_CHECKS;


select  upper(apa.vendor_name) vendor_name,
            apa.vendor_id,
            apa.check_id,
            apa.status_lookup_code,
            apa.check_number,
            apa.amount,
            apa.doc_sequence_value,
            to_char(apa.check_date,'DD-MON-YYYY') check_date,
            apa.org_id,
            apa.CE_BANK_ACCT_USE_ID,
            ap_sla.bank_branch_name
from ap_checks_all apa,
        AP_SLA_PAYMENTS_TRANSACTION_V ap_sla
where 1=1
        AND apa.org_id = 82 
       AND ap_sla.check_id = apa.check_id 
order by check_number;

select *
from AP_SLA_PAYMENTS_TRANSACTION_V;

select *
from ap_checks_all;

select *
from ap_invoices_all;

select *
from ap_invoice_payments_all;

select invoices.invoice_id,
         invoices.invoice_num,
         
         payments.amount,
         checks.amount,
         checks.check_number,
         checks.check_date,
         checks.bank_account_name
from ap_invoices_all invoices,  
        ap_invoice_payments_all payments,
        ap_checks_all checks
where 1 = 1
          and invoices.invoice_id = payments.invoice_id(+)
          and payments.check_id = checks.check_id(+)
          and invoices.doc_sequence_value = '100001467';
       
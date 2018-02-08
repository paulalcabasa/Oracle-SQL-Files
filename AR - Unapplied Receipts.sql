SELECT distinct 
       --  acra.cash_receipt_id,
         REC_METHOD.NAME RECEIPT_METHOD,
         ACRA.RECEIPT_NUMBER,
         ACRA.CURRENCY_CODE,
         ACRA.AMOUNT,
       --  ACRA.TYPE,
       --  ACRHA.STATUS STATE,
         ACRA.RECEIPT_DATE,
         ACRA.ATTRIBUTE1 DFF_CUSTOMER_BANK,
         ACRA.ATTRIBUTE2 DFF_CHECK_NUMBER,
         ACRA.ATTRIBUTE3 DFF_CHECK_DATE,
         ACRHA.GL_DATE,
         APSA.DUE_DATE,
         ARAA.GL_DATE REC_GL_DATE,
         ARAA.APPLY_DATE,
         ACRHA.ACCTD_AMOUNT FUNCTIONAL_AMOUNT,
         ACRA.DOC_SEQUENCE_VALUE,
         ACRA.DEPOSIT_DATE,
         PARTY.PARTY_NAME,
         CUST.ACCOUNT_NUMBER,
         CUST.ACCOUNT_NAME,
         SITE_USES.LOCATION,
         BB.BANK_NAME,
         BB.BANK_BRANCH_NAME,
         CBA.BANK_ACCOUNT_NAME,
         CBA.BANK_ACCOUNT_NUM,
      --   APSA.GL_DATE PAYMENT_GL_DATE,
         RCTA.TRX_NUMBER,
        ARAA.AMOUNT_APPLIED
    --    ARAA.GL_DATE APPLIED_PAYMENT_GL_DATE
FROM AR_CASH_RECEIPTS_ALL ACRA,
        AR_CASH_RECEIPT_HISTORY_ALL ACRHA,
        AR_PAYMENT_SCHEDULES_ALL APSA,
        AR_RECEIPT_METHODS REC_METHOD,
        AR_RECEIPT_CLASSES ARC,
        HZ_CUST_ACCOUNTS CUST,
        HZ_PARTIES PARTY,
        HZ_CUST_SITE_USES_ALL SITE_USES,
        CE_BANK_ACCT_USES_ALL REMIT_BANK,
        CE_BANK_ACCOUNTS CBA,
        CE_BANK_BRANCHES_V BB,
        AR_RECEIVABLE_APPLICATIONS_ALL ARAA,
        RA_CUSTOMER_TRX_ALL RCTA
WHERE ACRA.CASH_RECEIPT_ID = ACRHA.CASH_RECEIPT_ID
          AND APSA.CASH_RECEIPT_ID = ACRA.CASH_RECEIPT_ID
          AND ACRA.RECEIPT_METHOD_ID = REC_METHOD.RECEIPT_METHOD_ID
          AND ARC.RECEIPT_CLASS_ID = REC_METHOD.RECEIPT_CLASS_ID
          AND SITE_USES.SITE_USE_ID(+) = ACRA.CUSTOMER_SITE_USE_ID
          AND ACRA.PAY_FROM_CUSTOMER = CUST.CUST_ACCOUNT_ID(+)
          AND CUST.PARTY_ID = PARTY.PARTY_ID(+)
          AND REMIT_BANK.BANK_ACCT_USE_ID = ACRA.REMIT_BANK_ACCT_USE_ID
          AND CBA.BANK_ACCOUNT_ID(+) = REMIT_BANK.BANK_ACCOUNT_ID
          AND BB.BRANCH_PARTY_ID = CBA.BANK_BRANCH_ID
          AND ARAA.CASH_RECEIPT_ID = ACRA.CASH_RECEIPT_ID
          AND RCTA.CUSTOMER_TRX_ID = ARAA.APPLIED_CUSTOMER_TRX_ID
          AND ARAA.DISPLAY = 'Y'
        --  AND RCTA.TRX_NUMBER = '40300000001'
      --    AND ACRA.RECEIPT_DATE BETWEEN TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
       --   AND ACRA.RECEIPT_NUMBER = '59464';
;

SELECT *
FROM RA_CUSTOMER_TRX_ALL
WHERE COMMENTS LIKE '%980243388%';



select TRX_NUMBER, COMMENTS
from ra_customer_trx_all
where trx_date between '01-FEB-2017' AND '28-FEB-2017'; 

SELECT  
       --  acra.cash_receipt_id,
    --     REC_METHOD.NAME RECEIPT_METHOD,
         ACRA.RECEIPT_NUMBER,
     --    ACRA.CURRENCY_CODE,
         ACRA.AMOUNT,
       --  ACRA.TYPE,
       --  ACRHA.STATUS STATE,
         ACRA.RECEIPT_DATE,
      --   ACRA.ATTRIBUTE1 DFF_CUSTOMER_BANK,
     --    ACRA.ATTRIBUTE2 DFF_CHECK_NUMBER,
     --    ACRA.ATTRIBUTE3 DFF_CHECK_DATE,
  --       ACRHA.GL_DATE,
   --      APSA.DUE_DATE,
      --   ARAA.GL_DATE REC_GL_DATE,
      --   ARAA.APPLY_DATE,
     --   ACRHA.ACCTD_AMOUNT FUNCTIONAL_AMOUNT,
      --   ACRA.DOC_SEQUENCE_VALUE,
     --    ACRA.DEPOSIT_DATE,
   --      PARTY.PARTY_NAME,
    --     CUST.ACCOUNT_NUMBER,
    --     CUST.ACCOUNT_NAME,
    --     SITE_USES.LOCATION,
    --     BB.BANK_NAME,
    --     BB.BANK_BRANCH_NAME,
   --      CBA.BANK_ACCOUNT_NAME,
   --      CBA.BANK_ACCOUNT_NUM,
      --   APSA.GL_DATE PAYMENT_GL_DATE,
      --   RCTA.TRX_NUMBER,
        SUM(ARAA.AMOUNT_APPLIED) AMOUNT_APPLIED,
         ACRA.AMOUNT - SUM(ARAA.AMOUNT_APPLIED) UNAPPLIED_AMOUNT
    --    ARAA.GL_DATE APPLIED_PAYMENT_GL_DATE
FROM AR_CASH_RECEIPTS_ALL ACRA,
        AR_CASH_RECEIPT_HISTORY_ALL ACRHA,
        AR_PAYMENT_SCHEDULES_ALL APSA,
        AR_RECEIPT_METHODS REC_METHOD,
        AR_RECEIPT_CLASSES ARC,
        HZ_CUST_ACCOUNTS CUST,
        HZ_PARTIES PARTY,
        HZ_CUST_SITE_USES_ALL SITE_USES,
        CE_BANK_ACCT_USES_ALL REMIT_BANK,
        CE_BANK_ACCOUNTS CBA,
        CE_BANK_BRANCHES_V BB,
        AR_RECEIVABLE_APPLICATIONS_ALL ARAA,
        RA_CUSTOMER_TRX_ALL RCTA
WHERE ACRA.CASH_RECEIPT_ID = ACRHA.CASH_RECEIPT_ID
          AND APSA.CASH_RECEIPT_ID = ACRA.CASH_RECEIPT_ID
          AND ACRA.RECEIPT_METHOD_ID = REC_METHOD.RECEIPT_METHOD_ID
          AND ARC.RECEIPT_CLASS_ID = REC_METHOD.RECEIPT_CLASS_ID
          AND SITE_USES.SITE_USE_ID(+) = ACRA.CUSTOMER_SITE_USE_ID
          AND ACRA.PAY_FROM_CUSTOMER = CUST.CUST_ACCOUNT_ID(+)
          AND CUST.PARTY_ID = PARTY.PARTY_ID(+)
          AND REMIT_BANK.BANK_ACCT_USE_ID = ACRA.REMIT_BANK_ACCT_USE_ID
          AND CBA.BANK_ACCOUNT_ID(+) = REMIT_BANK.BANK_ACCOUNT_ID
          AND BB.BRANCH_PARTY_ID = CBA.BANK_BRANCH_ID
          AND ARAA.CASH_RECEIPT_ID = ACRA.CASH_RECEIPT_ID
          AND RCTA.CUSTOMER_TRX_ID = ARAA.APPLIED_CUSTOMER_TRX_ID
          AND ARAA.DISPLAY = 'Y'
         
        --  AND RCTA.TRX_NUMBER = '40300000001'
       AND ACRA.RECEIPT_DATE BETWEEN TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
       --   AND ACRA.RECEIPT_NUMBER = '59464';
GROUP BY       ACRA.RECEIPT_NUMBER,

         ACRA.AMOUNT,
    
         ACRA.RECEIPT_DATE
     HAVING ACRA.AMOUNT <>  SUM(ARAA.AMOUNT_APPLIED)
;

select *
from ra_customer_trx_all
where comments = '980243525';
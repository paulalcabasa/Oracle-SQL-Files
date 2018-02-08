SELECT  
          GCC.SEGMENT6 ACCOUNT_NO,
          gl_flexfields_pkg.get_description_sql (
                       gcc.chart_of_accounts_id,--- chart of account id
                        6,----- Position of segment
                        gcc.segment6 --- Segment value
                    ) account_name,
          gl_flexfields_pkg.get_description_sql (
                       gcc.chart_of_accounts_id,--- chart of account id
                        2,----- Position of segment
                        gcc.segment2 --- Segment value
                    ) cost_center,
         RCTAL.TAX_CLASSIFICATION_CODE,
         gl_flexfields_pkg.get_description_sql (
                   gcc.chart_of_accounts_id,--- chart of account id
                    7,----- Position of segment
                    gcc.segment7 --- Segment value
                ) model,
       --  acra.cash_receipt_id,
         null lot,
         gl_flexfields_pkg.get_description_sql (
                   gcc.chart_of_accounts_id,--- chart of account id
                    4,----- Position of segment
                    gcc.segment4 --- Segment value
                ) budget_account,
         gl_flexfields_pkg.get_description_sql (
                   gcc.chart_of_accounts_id,--- chart of account id
                    5,----- Position of segment
                    gcc.segment5 --- Segment value
                ) budget_cost_center,
         CASE WHEN rctal.customer_trx_line_id IS NULL THEN ra_dist.amount END credit,
         CASE WHEN rctal.customer_trx_line_id IS NOT NULL THEN ra_dist.amount END debit,
         rctal.description
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
        RA_CUSTOMER_TRX_ALL RCTA,
        ra_cust_trx_line_gl_dist_all RA_DIST,
        gl_code_combinations_kfv gcc,
        ra_customer_trx_lines_all rctal
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
          AND RA_DIST.CUSTOMER_TRX_ID = RCTA.CUSTOMER_TRX_ID
          AND GCC.CODE_COMBINATION_ID = RA_DIST.CODE_COMBINATION_ID
        --  AND rctal.customer_trx_id = rcta.customer_trx_id
     and ra_dist.customer_trx_line_id = rctal.customer_trx_line_id(+)
    --      AND REC_METHOD.NAME <> 'COLLECTION RECEIPT'
       --   AND RCTA.TRX_NUMBER in ('40300004683')
      --    AND ACRA.RECEIPT_DATE BETWEEN TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
     --     AND ACRA.RECEIPT_NUMBER = '5013812';
         AND ACRA.DOC_SEQUENCE_VALUE =  '70100003977'
   --      AND RCTA.TRX_NUMBER = '40300000916'
 --     AND ra_dist.amount < 0;
;



select *
from ra_cust_trx_line_gl_dist_all
we;

select *
from ra_customer_trx_lines_all;

SELECT DISTINCT AIA.ORG_ID,gl.code_combination_id,
              HAOU.NAME ORGANIZATION_NAME,
              GJL.JE_LINE_NUM,
              GJH.JE_SOURCE,
              fdsc.name  BOOK_TYPE,       
              TO_CHAR(GJH.DEFAULT_EFFECTIVE_DATE, 'mm/dd/yyyy') POSTED_DATE,       
              GL.SEGMENT6 ACCOUNT_NO, 
              DECODE(GL.SEGMENT6,NULL,NULL, B.DESCRIPTION) ACCOUNT_NAME, 
              GL.SEGMENT2 COST_CENTER,
              DECODE(GL.SEGMENT3, NULL, A.DESCRIPTION, PV1.SEGMENT1||' '||PV1.VENDOR_NAME) EMPLOYEE_NAME,
              DECODE(GL.SEGMENT3, NULL, A.DESCRIPTION, PV.SEGMENT1 ||' '||PV.VENDOR_NAME) SUPPLIER_NAME,
              GL.SEGMENT7 MODEL, 
              NULL AS LOT,
              GL.SEGMENT4 BUDGET_ACC,
              GL.SEGMENT5 BUDGET_CC, 
              nvl(GJL.accounted_dr,gjl.entered_dr) ENTERED_DR, 
              nvl(GJL.accounted_cr,gjl.entered_cr) ENTERED_CR,
              GJH.DOC_SEQUENCE_VALUE VOUCHER_NO, 
              TO_NUMBER(GJL.SUBLEDGER_DOC_SEQUENCE_VALUE) SUBLEDGER_DOC_SEQUENCE_VALUE,      
              AIA.INVOICE_NUM,                         
              GJL.DESCRIPTION VOUCHER_TEXT,
              GJH.STATUS,
              :P_REPORT_NAME P_REPORT_NAME    
FROM GL_JE_HEADERS         GJH
    ,GL_JE_LINES           GJL
    ,GL_CODE_COMBINATIONS  GL
    ,AP_INVOICES_ALL    AIA
    ,PO_VENDORS     PV
    ,PO_VENDORS     PV1
    ,FND_DOC_SEQUENCE_CATEGORIES fdsc
    ,HR_ALL_ORGANIZATION_UNITS HAOU
    ,(SELECT FLEX_VALUE, DESCRIPTION 
        FROM FND_FLEX_VALUES_VL) A 
    ,(SELECT FLEX_VALUE, DESCRIPTION                     
        FROM FND_FLEX_VALUES_VL) B
WHERE GJH.JE_HEADER_ID     = GJL.JE_HEADER_ID 
AND GL.CODE_COMBINATION_ID = GJL.CODE_COMBINATION_ID
and gjh.je_category = fdsc.code
AND GJL.SUBLEDGER_DOC_SEQUENCE_VALUE = AIA.DOC_SEQUENCE_VALUE(+)
AND AIA.VENDOR_ID                     = PV1.VENDOR_ID(+)
AND GL.SEGMENT3                       = PV.SEGMENT1(+)
AND AIA.ORG_ID                            = HAOU.ORGANIZATION_ID(+)
AND GL.SEGMENT3            = A.FLEX_VALUE 
AND GL.SEGMENT6            = B.FLEX_VALUE       
-- AND GJH.DOC_SEQUENCE_VALUE BETWEEN :P_VOUCHER_NO1 AND :P_VOUCHER_NO2
--AND GJH.DOC_SEQUENCE_VALUE = NVL(:P_VOUCHER_NO, GJH.DOC_SEQUENCE_VALUE)
--AND GJH.JE_CATEGORY           = NVL(:P_BOOK_TYPE, GJH.JE_CATEGORY)
--AND GJL.SUBLEDGER_DOC_SEQUENCE_VALUE = :P_APV_NO
--AND GJL.SUBLEDGER_DOC_SEQUENCE_VALUE BETWEEN :P_APV_NO AND :P_APV_NO2
ORDER BY TO_NUMBER(GJL.SUBLEDGER_DOC_SEQUENCE_VALUE),  GJH.DOC_SEQUENCE_VALUE,GJL.JE_LINE_NUM;

SELECT *
FROM GL_JE_HEADERS;

SELECT DISTINCT SUBLEDGER_DOC_SEQUENCE_VALUE
FROM GL_JE_LINES;
--WHERE SUBLEDGER_DOC_SEQUENCE_VALUE =  70100003977; 
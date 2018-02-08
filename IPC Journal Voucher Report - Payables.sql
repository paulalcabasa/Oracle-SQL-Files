SELECT DISTINCT AIA.ORG_ID,gl.code_combination_id,
              HAOU.NAME ORGANIZATION_NAME,
              GJL.JE_LINE_NUM,
              GJH.JE_SOURCE,
              fdsc.name  BOOK_TYPE,       
              TO_CHAR(GJH.DEFAULT_EFFECTIVE_DATE, 'mm/dd/yyyy') POSTED_DATE,       
              GL.SEGMENT6 ACCOUNT_NO, 
--              DECODE(GL.SEGMENT6,NULL,NULL, B.DESCRIPTION) ACCOUNT_NAME, 
   gl_flexfields_pkg.get_description_sql (
                        chart_of_accounts_id,--- chart of account id
                        6,----- Position of segment
                        GL.segment6 --- Segment value
                    ) account_name,
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
--    ,(SELECT FLEX_VALUE, DESCRIPTION                     
--        FROM FND_FLEX_VALUES_VL) B
WHERE GJH.JE_HEADER_ID     = GJL.JE_HEADER_ID 
AND GL.CODE_COMBINATION_ID = GJL.CODE_COMBINATION_ID
and gjh.je_category = fdsc.code
AND GJL.SUBLEDGER_DOC_SEQUENCE_VALUE = AIA.DOC_SEQUENCE_VALUE(+)
AND AIA.VENDOR_ID                     = PV1.VENDOR_ID(+)
AND GL.SEGMENT3                       = PV.SEGMENT1(+)
AND AIA.ORG_ID                            = HAOU.ORGANIZATION_ID(+)
AND GL.SEGMENT3            = A.FLEX_VALUE 
--AND GL.SEGMENT6            = B.FLEX_VALUE       
AND GJH.DOC_SEQUENCE_VALUE BETWEEN :P_VOUCHER_NO1 AND :P_VOUCHER_NO2
--AND GJH.DOC_SEQUENCE_VALUE = NVL(:P_VOUCHER_NO, GJH.DOC_SEQUENCE_VALUE)
AND GJH.JE_CATEGORY           = NVL(:P_BOOK_TYPE, GJH.JE_CATEGORY)
--AND GJL.SUBLEDGER_DOC_SEQUENCE_VALUE = :P_APV_NO
--AND GJL.SUBLEDGER_DOC_SEQUENCE_VALUE BETWEEN :P_APV_NO AND :P_APV_NO2
ORDER BY TO_NUMBER(GJL.SUBLEDGER_DOC_SEQUENCE_VALUE),  GJH.DOC_SEQUENCE_VALUE,GJL.JE_LINE_NUM;

-- 80001692

select gjl.attribute10
from gl_je_headers gjh
        INNER JOIN gl_je_lines gjl
            ON gjh.je_header_id = gjl.je_header_id
where 1 = 1
           AND gjh.doc_sequence_value = '80001692';
           
           
SELECT    
         -- ACCOUNTING ENTRIES
           gjc.user_je_category_name book_type,
           to_char(gjh.default_effective_date, 'mm/dd/yyyy') voucher_date,
           gjh.doc_sequence_value jv_no,  
            to_char(gcc.segment6) account_no,
            DECODE(gcc.segment6,'-',
                              gcc.segment6,
                              gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,6,segment6)) account_name,
            gcc.segment2 cost_center,
            '-' employee,
            gcc.segment7 model, 
            '-' lot,
            gcc.segment4 budget_acc,
            gcc.segment5 budget_cc, 
            gjl.entered_dr,
            gjl.entered_cr,
            gjl.description,
            CASE 
                WHEN gcc.segment6 IN ('83300','83301','83303','83304','83314','82000') THEN 1
                WHEN gcc.segment6 IN ('67000','67100','67101','67102','67103','67104','67105') THEN 2
                 WHEN gcc.segment6 IN ('83302') THEN 2
                ELSE 3
            END priority
FROM   
        gl_je_headers gjh 
        INNER JOIN gl_je_lines gjl
            ON  gjh.je_header_id = gjl.je_header_id 
        INNER JOIN apps.gl_code_combinations gcc
            ON gjl.code_combination_id = gcc.code_combination_id
        INNER JOIN gl_je_categories_tl gjc
            ON gjc.je_category_name = gjh.je_category
WHERE 1 = 1
          and gjh.doc_sequence_value between :p_start_voucher and :p_end_voucher;
            
SELECT gjl.je_line_num,
            CASE
                WHEN gjl.attribute1 IS NOT NULL THEN gjl.attribute1
                WHEN gjl.attribute10 IS NOT NULL THEN gjl.attribute10
                ELSE NULL
            END code,
           CASE 
                WHEN gjl.attribute2 IS NOT NULL THEN gjl.attribute2
                WHEN aps.vendor_name IS NOT NULL THEN aps.vendor_name
                WHEN ppf.full_name IS NOT NULL THEN ppf.full_name
           END description,
            NVL(gjl.entered_dr,0) - NVL(gjl.entered_cr,0) amount         
FROM gl_je_headers gjh 
         INNER JOIN gl_je_lines gjl
            ON gjh.je_header_id = gjl.je_header_id
         LEFT JOIN per_people_f ppf
            ON ppf.employee_number = gjl.attribute10
         LEFT JOIN ap_suppliers aps
            ON aps.segment1 = gjl.attribute1
WHERE gjh.doc_sequence_value = '80001692'
ORDER BY gjl.je_line_num; 
 
select *
from per_people_f perf;
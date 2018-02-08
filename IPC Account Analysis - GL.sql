/* IPC Account Analysis - GL 
    22 (No concatenation)
    Purchase Invoices ( , )
*/

/****************************** Purchase Invoices New performance issues *************************************/
select   distinct  a.je_header_id
            ,b.je_line_num
            ,a.je_category
            ,a.je_source
            ,a.period_name
            ,a.name
            --,a.currency
            ,a.status
            --,a.created
            --,a.default_effectivity_date
            ,a.posted_date
            ,REGEXP_SUBSTR (a.description, '[^,]+', 1, 1) "Invoice Status"
            ,REGEXP_SUBSTR (a.description, '[^,]+', 1, 2) "Invoice Number"
            ,REGEXP_SUBSTR (a.description, '[^,]+', 1, 3) "Invoice Date"
            ,REGEXP_SUBSTR (a.description, '[^,]+', 1, 4) "Doc Sequence Category"
            ,REGEXP_SUBSTR (a.description, '[^,]+', 1, 5) "Doc Sequence Name"
            ,REPLACE(REGEXP_SUBSTR (a.description, '[^,]+', 1, 6),'Invoice Voucher Number:','') "Voucher Number"
            ,REGEXP_SUBSTR (a.description, '[^,]+', 1, 7) || REGEXP_SUBSTR (a.description, '[^,]+', 1, 8) "Invoice Description"  
            ,a.description xl_description
            ,a.running_total_accounted_dr
            ,a.running_total_accounted_cr
            ,b.code_combination_id
            ,gcc.segment1 as "Company"
            ,gcc.segment2 as "Cost Center"
            ,gcc.segment3 as "ID" 
            ,gcc.segment4 as "Budget Account"
            ,gcc.segment5 as "Budget Cost Center"
            ,gcc.segment6 as "Account"
            ,gcc.segment7 as "Model"
            ,gcc.segment8 as "Projects"
            ,gcc.segment9 as "Future"
            ,b.entered_dr
            ,b.entered_cr
            ,b.accounted_dr
            ,b.accounted_cr
            ,a.description gl_description
            ,b.description line_description
            ,ppf.full_name transacted_by
from gl_je_headers a,
         gl_je_lines b,
         gl_code_combinations gcc,
         fnd_user fu,
         per_people_f ppf,
         xla_ae_headers xah,
         xla_ae_lines xal,
         gl_import_references gir
where 1 = 1
       /* TABLE LINKS */
        and a.je_header_id = b.je_header_id 
        and  b.code_combination_id = gcc.code_combination_id
        and gir.je_header_id = a.je_header_id
        and gir.gl_sl_link_id = xal.gl_sl_link_id
--        and xah.ae_header_id IN (select distinct ae_header_id
--                                                from XLA_AE_LINES
--                                                where gl_sl_link_id IN (select gl_sl_link_id 
--                                                                                    from gl_import_references
--                                                                                    where je_header_id = a.je_header_id))
        and xah.ae_header_id = xal.ae_header_id
        and xah.application_id = xal.application_id 
        and xal.ae_line_num = b.je_line_num
        -- WHO COLUMN
          and a.created_by = fu.user_id (+)
          and ppf.employee_number(+) = fu.user_name
        
        /* FILTERS */
        and a.period_name = :P_PERIOD
        and a.je_category = 'Purchase Invoices'
  --      and a.je_header_id = 393004
        and gcc.segment6 between NVL(:P_ACCOUNT_CODE_FROM,gcc.segment6) AND NVL(:P_ACCOUNT_CODE_TO,gcc.segment6) ;


/************************************************** Purchase Invoices Orig ****************************************/

select    a.je_header_id
            ,b.je_line_num
            ,a.je_category
            ,a.je_source
            ,a.period_name
            ,a.name
            --,a.currency
            ,a.status
            --,a.created
            --,a.default_effectivity_date
            ,a.posted_date
            ,REGEXP_SUBSTR (a.description, '[^,]+', 1, 1) "Invoice Status"
            ,REGEXP_SUBSTR (a.description, '[^,]+', 1, 2) "Invoice Number"
            ,REGEXP_SUBSTR (a.description, '[^,]+', 1, 3) "Invoice Date"
            ,REGEXP_SUBSTR (a.description, '[^,]+', 1, 4) "Doc Sequence Category"
            ,REGEXP_SUBSTR (a.description, '[^,]+', 1, 5) "Doc Sequence Name"
            ,REPLACE(REGEXP_SUBSTR (a.description, '[^,]+', 1, 6),'Invoice Voucher Number:','') "Voucher Number"
            ,REGEXP_SUBSTR (a.description, '[^,]+', 1, 7) || REGEXP_SUBSTR (a.description, '[^,]+', 1, 8) "Invoice Description"  
            ,a.description xl_description
            ,a.running_total_accounted_dr
            ,a.running_total_accounted_cr
            ,b.code_combination_id
            ,gcc.segment1 as "Company"
            ,gcc.segment2 as "Cost Center"
            ,gcc.segment3 as "ID" 
            ,gcc.segment4 as "Budget Account"
            ,gcc.segment5 as "Budget Cost Center"
            ,gcc.segment6 as "Account"
            ,gcc.segment7 as "Model"
            ,gcc.segment8 as "Projects"
            ,gcc.segment9 as "Future"
            ,b.entered_dr
            ,b.entered_cr
            ,b.accounted_dr
            ,b.accounted_cr
            ,a.description gl_description
            ,b.description line_description
            ,ppf.full_name transacted_by
from gl_je_headers a,
         gl_je_lines b,
         gl_code_combinations gcc,
         fnd_user fu,
         per_people_f ppf,
         xla_ae_headers xah,
         xla_ae_lines xal
where 1 = 1
       /* TABLE LINKS */
        and a.je_header_id = b.je_header_id 
        and  b.code_combination_id = gcc.code_combination_id
        and xah.ae_header_id IN (select distinct ae_header_id
                                                from XLA_AE_LINES
                                                where gl_sl_link_id IN (select gl_sl_link_id 
                                                                                    from gl_import_references
                                                                                    where je_header_id = a.je_header_id))
        and xah.ae_header_id = xal.ae_header_id
        and xah.application_id = xal.application_id 
        and xal.ae_line_num = b.je_line_num
        -- WHO COLUMN
          and a.created_by = fu.user_id (+)
          and ppf.employee_number(+) = fu.user_name
        
        /* FILTERS */
        and a.period_name = :P_PERIOD
        and a.je_category = 'Purchase Invoices'
   --     and a.je_header_id = 393004
        and gcc.segment6 between NVL(:P_ACCOUNT_CODE_FROM,gcc.segment6) AND NVL(:P_ACCOUNT_CODE_TO,gcc.segment6) ;

select value from v$parameter where name = 'db_block_size';
select bytes/1024/1024 as mb_size,
       maxbytes/1024/1024 as maxsize_set,
       x.*
from   dba_data_files x;
/************************************************** Purchase Invoices ***********************************************/

select *
from GL_IMPORT_REFERENCES
where je_header_id = 393004;

select distinct ae_header_id
from XLA_AE_LINES
where gl_sl_link_id IN (select gl_sl_link_id 
                                    from gl_import_references
                                    where je_header_id = 393004);

select *
from XLA_AE_HEADERS
where ae_header_id = 9356670;

select *
from XLA_TRANSACTION_ENTITIES
where entity_id > 1875500
order by entity_id ASC;

select *
from XLA_TRANSACTION_ENTITIES
where source_id_int_1 = 687841;

select *
from ap_invoices_all
where doc_sequence_value = '20022698';

select    a.je_header_id
            ,b.je_line_num
            ,a.je_category
            ,a.je_source
            ,a.period_name
            ,a.name
            --,a.currency
            ,a.status
            --,a.created
            --,a.default_effectivity_date
            ,a.posted_date
            ,REGEXP_SUBSTR (xah.description, '[^,]+', 1, 1) "Invoice Status"
            ,REGEXP_SUBSTR (xah.description, '[^,]+', 1, 2) "Invoice Number"
            ,REGEXP_SUBSTR (xah.description, '[^,]+', 1, 3) "Invoice Date"
            ,REGEXP_SUBSTR (xah.description, '[^,]+', 1, 4) "Doc Sequence Category"
            ,REGEXP_SUBSTR (xah.description, '[^,]+', 1, 5) "Doc Sequence Name"
            ,REPLACE(REGEXP_SUBSTR (xah.description, '[^,]+', 1, 6),'Invoice Voucher Number:','') "Voucher Number"
            ,REGEXP_SUBSTR (xah.description, '[^,]+', 1, 7) || REGEXP_SUBSTR (xah.description, '[^,]+', 1, 8) "Invoice Description"  
            ,xah.description xl_description
            ,a.running_total_accounted_dr
            ,a.running_total_accounted_cr
            ,b.code_combination_id
            ,gcc.segment1 as "Company"
            ,gcc.segment2 as "Cost Center"
            ,gcc.segment3 as "ID" 
            ,gcc.segment4 as "Budget Account"
            ,gcc.segment5 as "Budget Cost Center"
            ,gcc.segment6 as "Account"
            ,gcc.segment7 as "Model"
            ,gcc.segment8 as "Projects"
            ,gcc.segment9 as "Future"
            ,b.entered_dr
            ,b.entered_cr
            ,b.accounted_dr
            ,b.accounted_cr
            ,a.description gl_description
            ,b.description line_description,
            ppf.full_name transacted_by
from gl_je_headers a,
         gl_je_lines b,
         gl_code_combinations gcc,
         fnd_user fu,
         per_people_f ppf,
         xla_ae_headers xah,
         xla_ae_lines xal
where 1 = 1
       /* TABLE LINKS */
        and a.je_header_id = b.je_header_id 
        and  b.code_combination_id = gcc.code_combination_id
        and xah.ae_header_id IN (select distinct ae_header_id
                                                from XLA_AE_LINES
                                                where gl_sl_link_id IN (select gl_sl_link_id 
                                                                                    from gl_import_references
                                                                                    where je_header_id = a.je_header_id))
        and xah.ae_header_id = xal.ae_header_id
        and xah.application_id = xal.application_id 
        and xal.ae_line_num = b.je_line_num
        -- WHO COLUMN
        and fu.user_id = a.created_by
        and ppf.employee_number = fu.user_name
        
        /* FILTERS */
        and a.period_name = :P_PERIOD
        and a.je_category = 'Purchase Invoices'
  --      and a.je_header_id = 393004
        and gcc.segment6 between NVL(:P_ACCOUNT_CODE_FROM,gcc.segment6) AND NVL(:P_ACCOUNT_CODE_TO,gcc.segment6) ;

/********************************************* Beginning Balance *************************************/

select *
from xla_ae_lines;

select *
from GL_JE_CATEGORIES
where je_category_name = '22';

SELECT *
FROM gl_je_headers;

SELECT *
FROM fnd_user;

select *
from per_people_f;


select   a.je_header_id
            ,b.je_line_num
        --    ,a.je_category
            , gl_cat.user_je_category_name je_category
            ,a.je_source
            ,a.period_name
            ,a.name
            --,a.currency
            ,a.status
            --,a.created
            --,a.default_effectivity_date
            ,a.posted_date
            ,a.description
            ,a.running_total_accounted_dr
            ,a.running_total_accounted_cr
            ,b.code_combination_id
            ,gcc.segment1 as "Company"
            ,gcc.segment2 as "Cost Center"
            ,gcc.segment3 as "ID" 
            ,gcc.segment4 as "Budget Account"
            ,gcc.segment5 as "Budget Cost Center"
            ,gcc.segment6 as "Account"
            ,gcc.segment7 as "Model"
            ,gcc.segment8 as "Projects"
            ,gcc.segment9 as "Future"
            ,b.entered_dr
            ,b.entered_cr
            ,b.accounted_dr
            ,b.accounted_cr
            ,b.description
from gl_je_headers a,
     gl_je_lines b,
        gl_code_combinations gcc,
        GL_JE_CATEGORIES gl_cat
where
        a.je_header_id = b.je_header_id 
        and gl_cat.je_category_name = a.je_category
        and  b.code_combination_id = gcc.code_combination_id
        AND a.period_name = :P_PERIOD
        and a.je_category = '22'
        and gcc.segment6 between NVL(:P_ACCOUNT_CODE_FROM,gcc.segment6) AND NVL(:P_ACCOUNT_CODE_TO,gcc.segment6) ;
        
        
        
/********************* SEARCHED QUERY ***********************************/

SELECT distinct 
           aia.INVOICE_ID "Invoice_Id", ---IN R12
           AIA.DOC_SEQUENCE_VALUE,
           aia.INVOICE_NUM ,
           aia.attribute6 "INVOICE_ID",--IN11i
           aia.GL_DATE,
           aia.INVOICE_AMOUNT,
           xal.ACCOUNTED_DR "Accounted DR IN SLA",
           xal.ACCOUNTED_CR "Accounted CR IN SLA",
           gjl.ACCOUNTED_CR "ACCOUNTED_CR IN GL",
           gjl.ACCOUNTED_DR "Accounted DR IN GL",         
           xev.event_type_code,
              gcc.SEGMENT1
           || '.'
           || gcc.SEGMENT2
           || '.'
           || gcc.SEGMENT3
           || '.'
           || gcc.SEGMENT4
           || '.'
           || gcc.SEGMENT5
           || '.'
           || gcc.SEGMENT6
           || '.'
           || gcc.SEGMENT7
              "CODE_COMBINATION",
           aia.GL_DATE,
           xah.PERIOD_NAME,
           aia.VENDOR_ID "Vendor Id",
           aps.VENDOR_NAME "Vendor Name",
           xah.JE_CATEGORY_NAME "JE Category Name",
                      GJH.JE_SOURCE
    FROM   ap_invoices_all aia,
           xla.xla_transaction_entities XTE,
           xla_events xev,
           xla_ae_headers XAH,
           xla_ae_lines XAL,
           GL_IMPORT_REFERENCES gir,
           gl_je_headers gjh,
           gl_je_lines gjl,
           gl_code_combinations gcc,
           ap_suppliers aps
   WHERE       aia.INVOICE_ID = xte.source_id_int_1
           and aia.ACCTS_PAY_CODE_COMBINATION_ID = gcc.code_combination_id
           AND xev.entity_id = xte.entity_id
           AND xah.entity_id = xte.entity_id
           AND xah.event_id = xev.event_id
           AND XAH.ae_header_id = XAL.ae_header_id
              and XAH.je_category_name = 'Purchase Invoices'
           AND GJH.JE_SOURCE = 'Payables'
           AND XAL.GL_SL_LINK_ID = gir.GL_SL_LINK_ID
           and gir.GL_SL_LINK_ID = gjl.GL_SL_LINK_ID
           AND gir.GL_SL_LINK_TABLE = xal.GL_SL_LINK_TABLE
           AND gjl.JE_HEADER_ID = gjh.JE_HEADER_ID
           AND gjl.ledger_id = gjh.ledger_id
           and xah.ledger_id = gjh.ledger_id
           AND gjh.JE_HEADER_ID = gir.JE_HEADER_ID
           and aia.set_of_books_id = gjh.ledger_id
           AND gjl.JE_HEADER_ID = gir.JE_HEADER_ID
           AND gir.JE_LINE_NUM = gjl.JE_LINE_NUM
           AND gcc.CODE_COMBINATION_ID = XAL.CODE_COMBINATION_ID
           AND gcc.CODE_COMBINATION_ID = gjl.CODE_COMBINATION_ID
           AND aia.VENDOR_ID = aps.VENDOR_ID
           AND gjh.PERIOD_NAME BETWEEN NVL (:PERIOD_FROM, gjh.PERIOD_NAME)
           AND  NVL (:PERIOD_TO, gjh.PERIOD_NAME)               
           AND gcc.SEGMENT1 = NVL (:seg1, gcc.SEGMENT1)
           AND gcc.SEGMENT3 = NVL (:seg, gcc.SEGMENT3)
           AND gjh.je_header_id = 393004;
           
           select *
           from gl_je_headers
           where je_header_id = 393004;
           
           -- 83024237
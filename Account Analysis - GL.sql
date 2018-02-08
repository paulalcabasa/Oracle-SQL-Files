select 
a.je_header_id
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
,a.description
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
        gl_code_combinations gcc
where
a.je_header_id = b.je_header_id 
and  b.code_combination_id = gcc.code_combination_id
AND a.period_name = :P_PERIOD
and gcc.segment6 between NVL(:P_ACCOUNT_CODE_FROM,gcc.segment6) AND NVL(:P_ACCOUNT_CODE_TO,gcc.segment6) ;

/****  REV QUERY FOR UNION *****/ 

select a.je_header_id,    b.je_line_num,    a.je_category,    a.je_source  ,    a.period_name,    a.name,    a.status,    a.posted_date,    a.description,    gcc.segment1,    gcc.segment2,    gcc.segment3,    gcc.segment4,    gcc.segment5,    gcc.segment6,    gcc.segment7,    gcc.segment8,    gcc.segment9,    b.description,    b.entered_dr,    b.entered_cr,    b.accounted_dr,    b.accounted_cr
from gl_je_headers a,
     gl_je_lines b,
        gl_code_combinations gcc
where
a.je_header_id = b.je_header_id 
and  b.code_combination_id = gcc.code_combination_id
AND a.period_name = :P_PERIOD
and gcc.segment6 between NVL(:P_ACCOUNT_CODE_FROM,gcc.segment6) AND NVL(:P_ACCOUNT_CODE_TO,gcc.segment6) ;

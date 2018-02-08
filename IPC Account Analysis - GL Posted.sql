select
a.doc_sequence_value voucher_no, 
a.je_header_id
,b.je_line_num
,a.je_category
,a.je_source
,a.period_name
,a2.NEW_DATE
,a.name
--,a.currency
,a.status
--,a.created
,to_char(a.default_effective_date) effective_date
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
(SELECT period_name, JE_HEADER_ID
,CONCAT(REGEXP_REPLACE (TO_CHAR (to_date(DEFAULT_EFFECTIVE_DATE,'DD-MON-RRRR' ) , 'MM'),
                               '[[:space:]]',
                                 ''),
        to_char(to_date(DEFAULT_EFFECTIVE_DATE,'DD-MON-RRRR'),  '-YY' )
       ) NEW_DATE
FROM gl_je_headers) a2
where a.je_header_id = b.je_header_id 
and b.code_combination_id = gcc.code_combination_id
and a.je_header_id = a2.je_header_id(+)
and a.period_name = a2.period_name(+)
-- AND a.period_name = :P_PERIOD
-- AND a2.NEW_DATE between case when :P_PERIOD
and to_date(a2.new_date,'MM-YY') BETWEEN TO_dATE(:P_PERIOD,'MM-YY') AND TO_DATE(:P_PERIOD2,'MM-YY')
and gcc.segment6 between NVL(:P_ACCOUNT_CODE_FROM,gcc.segment6) AND NVL(:P_ACCOUNT_CODE_TO,gcc.segment6);
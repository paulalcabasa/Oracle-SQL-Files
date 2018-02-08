select gjh.doc_sequence_value,
           gjc.user_je_category_name je_category,
           gjh.name journal_name,
           gjh.period_name,
           gjh.currency_code,
           to_char(gjh.date_created) date_created,
           to_char(gjh.default_effective_date) default_effective_date,
           gjh.description,
           gjl.je_line_num,
           gcc.segment6 account_no,
           gjl.entered_dr,
           gjl.entered_cr,
           gjl.accounted_dr,
           gjl.accounted_cr,
           (nvl(gjl.accounted_dr,0) - nvl(gjl.accounted_cr,0)) accounted_total,
           gjl.description line_description
           
from gl_je_headers gjh,
         gl_je_lines gjl,
         gl_je_categories gjc,
         gl_code_combinations_kfv gcc
where 1 = 1
           and gjh.je_header_id = gjl.je_header_id
           and gcc.code_combination_id = gjl.code_combination_id
           and gjc.je_category_name = gjh.je_category
           and gjh.je_source = 'Manual'
           and gjh.status = 'U'
            and to_date(gjh.default_effective_date) between NVL(to_date(:start_date,'YYYY/MM/DD HH24:MI:SS'),to_date(gjh.default_effective_date)) 
            and NVL(to_date(:end_date,'YYYY/MM/DD HH24:MI:SS'),to_date(gjh.default_effective_date))
           
    ;
           
           select *
           from gl_je_categories
           where je_category_name = '306';
           /*
           
           date effective
           sum of debit and credit
           journal categories
           
           parameters is date effective*/